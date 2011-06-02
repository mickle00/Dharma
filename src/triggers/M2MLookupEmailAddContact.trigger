// NEED TO MAKE SURE THAT RATING ON BOTH CONTACT & ACCOUNT ARE NUMBERS
// DEFAULTS LIKE HOT/WARM/COLD COULD THROW OFF TRIGGER...
// TEST THE VALUE USING REGEX (AS ITS GOING TO BE THE STRING VALUE OF A NUMBER) 
// OR TRY/EXCEPT STATEMENTS WITHIN TRIGGER?? IS THERE A BETTER WAY??


// Web Email Lookup Status must be a rich text field in order for this to be displayed correctly

trigger M2MLookupEmailAddContact on Case (before insert) {
    // We're firing before insert on the trigger . Trigger will not fire if record updated or deleted
       
    // Build a set of all emails that are applied. 
    // Trying to bulkify the trigger as much as possible
    Boolean AddNewContact = true;
    string sfdcURL = 'https://cs7.salesforce.com/';
    Set<String> allemails = new Set<String>();
    Integer numofemail = 0;
    Date myDate = Date.Today();
    // I don't really like how the date is displayed here {YYYY}-{MM}-{DD}.... perhaps I could just use the CreatedDate of the Case, to mimic that display?
    String sDate = String.valueOf(myDate);
    
    //loop through the new cases, and if it comes from Web2Case
    //or Email2Case the SuppliedEmail should be populated.
    //if it's null, we do not add it to the list
    
    for (case c : trigger.New) if (c.SuppliedEmail != null) {
    	allemails.add(c.SuppliedEmail);
    	
    }
     
    // Create a set for all of the email addresses currently in SFDC
    // Will use this to build a list of Contacts that need to be Inserted
    Set<String> SFDCEmails = new Set<String>();
    
    // Create a map of Email to Contact ID
    Map <String, Id> emailcid = new Map<String, Id> ();
    
    // Create a map of Email to Account ID, based on the Contacts Account in the AccountContact Junction Table
    Map <String, Id> emailaid = new Map<String, Id> ();
    
    // Create a map of Email to the number of occurences this email appears in the AccountContact table
    Map <String, Integer> emailcount = new Map<String, Integer> ();
    
    //Maps email to the lower priority between Account&Contact
    Map <String, String> CasePriority = new Map<String, String> ();
    
    //Create a map of emails to contacts FROM THE CONTACT TABLE
    //This will be the fallback in the event the contact record doesn't appear in the AccountContact table
    Map <String, Id> noaccountcontact = new Map<String, Id> ();
    
    //Creats a list of Cases where we'll need to go back and add the contact
    List<Case> CasesToCreateContact = new List<Case>();
    
    // Create a list of Contacts that need to be Added
    Contact[] ContactstoAdd = new Contact[]{};
    
    // Create a list of all emails, and the number of occurrences
    List<AggregateResult> emailcountlist =  [SELECT Contact__r.Email, count(id) total FROM Account_Contact__c WHERE contact__r.Email IN : allemails Group By Contact__r.email];
    
    //Loop throug the results and map the email to the number of occurrences
    for (AggregateResult e : emailcountlist)
    {
        String em =  (String) e.get('Email');
        Integer tot = (integer) e.get('total');
        emailcount.put(em, tot);
    }    
    
    // Query the AccountContactTable for contacts with this email address
    for (Account_Contact__c ac :
        [SELECT Id, contact__r.email, account__c, contact__c, contact__r.priority__c, account__r.rating FROM Account_Contact__c WHERE contact__r.Email IN : allemails ORDER BY account__r.rating desc nulls first]) //need to order by desc, because the map will override as it loops through 
        {
            // add the contacts id to the map emailcid with email address as the key
            emailcid.put(ac.contact__r.email, ac.contact__c);
            // add the account id to the map emailaid with email address as the key
            emailaid.put(ac.contact__r.email, ac.account__c);
            // add the priority to the map. Because priority are queried desc, the last item should always be the lowest (1) priority
            // the NULLS FIRST part of the SOQL doesn't appear to be working because the value is transversed via a relationship query, so I'll simply weed out the NULLs...that wasn't very fun to troubleshoot        
            //system.debug('The account rating is ' + ac.account__r.rating);
            if (ac.account__r.rating != NULL) CasePriority.put(ac.contact__r.email, ac.account__r.rating);
            
        }

    // Loops through all contacts adding to the noaccountcontact map
    // This will be the fallback in the even that the contact is not listed
    // in the AccountContact Table. (Think Internal Contacts)                           
    for (Contact ct :
        [SELECT Id, email, Priority__c FROM Contact WHERE Email IN  : allemails ORDER BY Priority__c desc NULLS FIRST]) //need to order by desc, because the map will override as it loops through
                    {   
                        
                        // This is officially code I'm embarrased of. Since Priority is stored in a picklist, these are strings when they are received, and also need to be when they are updated
                        // When comparing them, I want to use integers. However, initiailizing the variables as Integers below using integer.valueof() causes a null point exception ie Integer icpri = integer.valueof(ct.Priority__c) <-- causes a null pointer exception when that field is blank
                        // Therefore, I'm initiallizing them as strings, and then comparing as ints. There has to be a more elegant way to do this...               
                        noaccountcontact.put(ct.email, ct.Id);
                        SFDCEmails.add(ct.email);
                        String cpri = ct.Priority__c; //contact priority
                        String apri = CasePriority.get(ct.email); //account priority from AccountContact table
                        //If the account priority is NULL, anything will be better. The above code to not add null account priorities should have fixed this, but I'm keeping it around as a double check.
                        if (apri == NULL) CasePriority.put(ct.email, ct.Priority__c);
                        
                        // As long as the contact priority isn't NULL, we should compare it to the current Priority based with that email address in the map
                        // If it's less, we replace the value, if not, we keep the map as is
                        // Catching for exceptions here just incase we get a stray non-integer in the Priority field in SFDC
                        else{ 
                            if (cpri != NULL){ 
                                try {
                                    if (integer.valueof(cpri) < integer.valueof(apri)){
                                        CasePriority.put(ct.email, ct.Priority__c);
                                        }
                                } 
                                catch (Exception e){
                                    system.debug('Exception: '+ e);
                                }
                            }
                        }
                    }
                                 
    // for all of the affected cases, add the contactid and account id                  
    for (case c : trigger.New){ 
        // Only do this if SuppliedEmail is populated. Don't want to add a status of "Not Found" if there
        // was no SuppliedEmail to begin with
        if (c.SuppliedEmail != null){
        	if (SFDCEmails.contains(c.SuppliedEmail)){
        		system.debug('WE HAVE A MATCH'); //I should figure out how to do if a Set DOES NOT contain....        		
        	}else{
        		if (AddNewContact == True){
		    		//system.debug('CREATING A NEW CONTACT: ' + c.SuppliedEmail);
		    		String fullname = c.SuppliedName;
		    		String fname = '';
		    		String lname = 'No Name'; //This should always be overwritten, unless no name supplied.                		
		    		if (fullname != NULL) {
		    			List<String> nameparts = fullname.split(' ', 2);
		    			if (nameparts.size() == 1) lname = nameparts[0];
		    			if (nameparts.size() > 1){
		    				fname = nameparts[0];
		    				lname = nameparts[1];
		    			}
		    		}		    		
		    		Contact newc = new Contact(FirstName = fname, LastName = lname, Email = c.SuppliedEmail);		    		
		    		ContactstoAdd.add(newc);
		    		CasesToCreateContact.add(c);
		    		//system.debug(CasesToCreateContact);	
        		} 	
        	} 	
        	        	
            // figure out how many times email address came up
            numofemail = emailcount.get(c.SuppliedEmail);
            // if one, auto link to contact (and the contacts account), and change status to linked
            if (numofemail == 1){
                c.Priority = CasePriority.get(c.suppliedemail);
                // get and assign the contact id based on email
                c.contactid = emailcid.get(c.SuppliedEmail);
                // get and assign the account id based on email & account
                c.accountid = emailaid.get(c.SuppliedEmail);
                // Update the Status to show that one and only one was found.
                c.Web_Email_Lookup_Status__c = 'Only one match found; linked: '+sDate;
                // can't use Case ID or Case Number in the debug since they haven't been created yet. 
                // I wanted to provide some level of visibility, so using subject line
                system.debug(c.Subject + ' successfully linked');
            
            // if more than one, display how many that were found on custom field
            }else if (numofemail > 1){
                // if there is only one item in the trigger, we should have a ton more flexibility without hitting governor limits
                // i tried to bulkify this trigger as much as possible, so even if we do large dataloads it won't break or slowdown
                // 3 SOQL Queries if trigger.new.size() > 1
                // 4 SOQL Queries if trigger.new.size() == 1
                // I suppose I could build a list....and then iterate through this list where c.suppliedemail == list.email
                // but I worry that with a large size, this could hang for a while...as it seems to grow exponential in size
                if (trigger.new.size()==1){
                    //WARNING SOQL QUERY INSIDE OF A LOOP....GETTING AROUND THIS BY ONLY FIRING WHEN TRIGGER.NEW.SIZE()== 1                    
                    // Get the lowest (1) priority from the map, and apply this to the case                 
                    c.Priority = CasePriority.get(c.suppliedemail);
                    system.debug(CasePriority.get(c.suppliedemail));
                    // Change the status to reflect all possibilities
                    c.Web_Email_Lookup_Status__c = numofemail + ' Matching Emails Found on '+ sDate +'; Not Linked' +'<br><br><b><u>Possibilities Include:</u></b><ol>';
                    // Build a list of all the possibilities of this particular email
                    // Since the set allcontacts will only contain 1 email because triger.new.size() == 1
                    List<Account_Contact__c> allcontacts =  [SELECT Id, contact__r.email, account__c, account__r.Name, Contact__r.Name, contact__c, contact__r.priority__c, account__r.rating FROM Account_Contact__c WHERE contact__r.Email IN : allemails];
                    for (Account_Contact__c ct : allcontacts){
                        // THIS PRIORITY IS THE CONTACT PRIORITY. DON'T WANT TO CONFUSE USERS, AS THE ACCOUNT MAY HAVE A LOWER PRIORITY...May want to grab both, and compare, displaying the lower (1)...
                        // really don't like hardcoding the instance URL here....will have to look at getting this a better way
                        string conURL =  sfdcURL+ct.contact__c;
                        string acctURL = sfdcURL+ct.account__c;
                        c.Web_Email_Lookup_Status__c = c.Web_Email_Lookup_Status__c + '<li>'+ '<a href="'+acctURL+'">'+ct.Account__r.Name+'</a>' + ' - ' +'<a href="'+conURL+'">'+ct.Contact__r.Name+'</a>' + ' - Contact Priority: '+ ct.contact__r.priority__c +' - ' + 'Account Priority: '+ ct.account__r.rating + '</li>';
                    }
                    // close the Ordered List tag
                     c.Web_Email_Lookup_Status__c = c.Web_Email_Lookup_Status__c + '</ol>';
                // if the the trigger was fired from a bulk upload, and matched more than 1 email               
                } else {
                // Get the lowest (1) priority from the map, and apply this to the case
                c.Priority = CasePriority.get(c.suppliedemail);
                // Change the status to only reflect how many possibilities 
                c.Web_Email_Lookup_Status__c = numofemail + ' Matching Emails Found on '+ sDate +'; Not Linked';
                //system.debug(c.Subject + ' has multiple matching emails, not linked');
                }
            // if no emails were found in the AccountContact table
            }
            else {                  
                // Look and see if the contact is in the Contact table
                // but not the AccountContact Table
                // This would be for routing Internal VIP contacts to a higher priority
                c.contactid = noaccountcontact.get(c.SuppliedEmail);
                if (c.ContactId == NULL) {                	
					// If there are no matching contacts in either the contact or account contact table, update status to reflect that
					c.Web_Email_Lookup_Status__c = 'No Matching Email Found. Attempted: '+ sDate; // This should really never happen. Will be temporarily assigned this value, but the loop below will add the new contact to this item.
                } else {
                    // If it finds a contact in the contact table, but not the accountcontact table, update status to reflect that
                    c.Web_Email_Lookup_Status__c = 'Matching Contact not linked to an Account Found. Linked: '+ sDate;
                    c.Priority = CasePriority.get(c.suppliedemail);
                }
            }            
        }            
    }
    //Insert All of the New Contacts outside of the loop
    insert ContactstoAdd;
    
    //Create a map to link the new email addresses with their respective contact IDs
    Map <String, Id> createdcontactid = new Map<String, Id> ();
    
    //Loop through all of the new contacts and put their email & id into the map
    for (contact ct : ContactstoAdd){
    	createdcontactid.put(ct.Email, ct.Id);
    }
    
    //loop through all of the cases that need to be updated, and attach the new contact. Also state that a new contact was created.    
    for (case c : CasesToCreateContact){
    	c.ContactId = createdcontactid.get(c.SuppliedEmail);
    	c.Web_Email_Lookup_Status__c = 'Matching Contact Not Found; New Contact Created: '+sDate;  	
    }
    
    //system.debug(ContactstoAdd);
}
public class sitesVFReContracting {
	private static final Integer PAGE_SIZE = 25;
	private static final String GSO_TOKEN = 'GSO_TOKEN';
	private static final String APPROVER_ALIAS = 'gsosfsup@expedia.com'; //etpdmms@expedia.com

	// Wrapper class for account contacts
	public class AccountWrapper {
		private sitesVFReContracting outerClass;
		public Account Acct {get; set;}
		public Id SelectedContactId {get; set;} // contact selected
		
		public AccountWrapper(sitesVFReContracting outerClass, Account acct, Id selectedContactId) {
			this.outerClass = outerClass;
			this.Acct = acct;
			this.SelectedContactId = selectedContactId;
		}
		
		// Returns a list of contacts associated with the account
		public List<SelectOption> Contacts {
			get{
				if(Contacts == null) {
					Contacts = new List<SelectOption>();
					
					Contacts.add(new SelectOption('', 'Select a contact'));
                    
                    for(Account_Contact__c myContact : AccountContactClass.findByAccountId(this.Acct.Id)) {
						String label = myContact.Contact__r.Name;
						// include title if one exists
						if(myContact.Contact__r.Title != null) {
							 label += ' (' + myContact.Contact__r.Title + ')';
						}
						Contacts.add(new SelectOption(myContact.Contact__c, label));
					}
				}
				return Contacts;
			}
			set;
		}

		// Returns the selected contact object
		public Contact SelectedContact{
			get{
				if(this.SelectedContactId != NULL){
					SelectedContact = ContactClass.findById(this.SelectedContactId);
				}
				
				return SelectedContact;
			}
			set;
		}

    	// add or remove accounts to the selected list
	    public void updateSelectedAccounts(){
			if(SelectedContactId != null) {
				// add account to the list
				outerClass.SelectedAccounts.put(Acct.Id, this);
    		}else {
    			// remove account from the list
    			outerClass.SelectedAccounts.remove(Acct.Id);
    		}
	    }
	} //// End AccountWrapper class
	
	// Wrapper class for Commercial Terms
	public class TermWrapper {
		public Term__c Term {get; set;}
		public String SelectedValue {get; set;}
		public Boolean ValidInput {get; set;}
		// indicates if the term is rendered as a select list or textbox
		public Boolean RenderSelectList { get { return this.Term.Term_Values__r.size() > 1; } } 
		public Boolean Required { get { return this.Term.Required__c; } } // indicates if the term is required
		public Boolean DisplayChild { get { return DisplayChildTerm(); } }
		public List<TermWrapper> childTerms {get; set;}
		public String DefaultValue {get; set;}
		
		public TermWrapper(Term__c term) {
			this.Term = term;
			this.ValidInput = true;
			this.SelectedValue = DefaultValue = getDefaultValue();
			this.childTerms = new List<TermWrapper>();
		}

		public List<SelectOption> TermValues{
			get {
				if(TermValues == null) {
					TermValues = new List<SelectOption>();
					// get list of term values
					TermValues.add(new SelectOption('', 'Select One'));
					
					for(Term_Value__c termValue : this.Term.Term_Values__r) {
						TermValues.add(new SelectOption(termValue.Name, termValue.Name));
						if(termValue.Default_Value__c == true) SelectedValue = termValue.Name;
					}
				}
				return TermValues;
			}
			private set;
		}
		
		public PageReference onChangeofTerms() {
			// set child values
			for(TermWrapper childTerm : childTerms) {
				childTerm.SelectedValue = (this.displayChild == false ? null : childTerm.DefaultValue);
			}
			
			return null;
		}
		
		public Boolean IsValid() {
			return RequiredValueSet() && IsNumeric();
		}
		
	    public List<GSOContract_Term__c> CreateContractTerms(GSOContract__c myContract) {
	    	List<GSOContract_Term__c> contractTerms = new List<GSOContract_Term__c>();
	
	    	// create parent terms
    		if(this.SelectedValue != null && this.SelectedValue != '') {
    			GSOContract_Term__c myContractTerm = new GSOContract_Term__c();
    			myContractTerm.GSOContract__c = myContract.Id;
    			myContractTerm.Term__c = this.Term.Id;
    			myContractTerm.Value__c = this.SelectedValue;
    			
    			contractTerms.add(myContractTerm);
    			
    			// if the selected value is outside of the validation range an approval is required
    			if((this.Term.Min_Value__c  != null && Decimal.valueOf(myContractTerm.Value__c) < this.Term.Min_Value__c) ||
    				(this.Term.Max_Value__c  != null && Decimal.valueOf(myContractTerm.Value__c) > this.Term.Max_Value__c)){
    				myContract.Approval_Required__c = true;
    				myContract.Approval_Status__c = 'Pending Approval';
    			}
    		}
    		// set the contract terms
    		if(this.Term.Description__c == 'Length of contract (months)') {
    			myContract.Contract_Term_months__c = Integer.valueOf(this.SelectedValue);
    		}
	    	
			// create child terms
			for(TermWrapper childTerm : childTerms) {
				if(this.DisplayChildTerm() == true) {
					contractTerms.addAll(childTerm.CreateContractTerms(myContract));
				}
			}
			
	    	return contractTerms;
	    }

		////// Private Methods
		
		private Boolean DisplayChildTerm() {
			// determine if the child term is displayed. if the selected value of the parent term equals the 'When to Display'
			// value of the child term the child term is displayed.
			return (this.Term.When_To_Display__c == this.SelectedValue);
		}
		
		private Boolean RequiredValueSet() {
	    	Boolean valueSet = this.ValidInput = true;
	    	
			// if the term is required validate that the value is not null
			if(this.Required && (this.SelectedValue == '' || this.SelectedValue == null)) {
				valueSet = this.ValidInput = false;
			}
			
			// validate child terms
			if(this.DisplayChildTerm() == true) {
				for(TermWrapper childTerm : childTerms) {
					if(childTerm.RequiredValueSet() == false) {
						valueSet = false;
					}
				}
			}
			
			return valueSet;
		}

	    private Boolean IsNumeric() {
	    	Boolean isNumeric = this.ValidInput = true;
	    	
			// for text values attempt to convert to a decimal
			if(this.RenderSelectList == false && (this.SelectedValue != '' && this.SelectedValue != null)){
	    		try{
					Decimal myDecimal = Decimal.valueOf(this.SelectedValue);
	    		}catch (Exception ex){
	    			 isNumeric = this.ValidInput = false;
	    		}
			}
			
			// validate child terms
			if(this.DisplayChildTerm() == true) {
				for(TermWrapper childTerm : childTerms) {
					if(childTerm.IsNumeric() == false) {
						isNumeric = false;
					}
				}
			}
			
			return isNumeric;
	    }

		private String getDefaultValue() {
			for(Term_Value__c termValue : this.Term.Term_Values__r) {
				if(termValue.Default_Value__c == true) {
					return termValue.Name;
				}
			}
			return null;
		}
		
	} //// End TermWrapper class

	// used to search for a single account
	public String ExpediaHotelId {get; set;}
	public Boolean SupplierTrainingByMM {get; set;}
	public Boolean ApprovalRequired {get; set;}
	public String fileName {get;set;}
	transient public Blob fileBody {get; set;}
    public List<Attachment> newAttachments {
    	get {
    		if(newAttachments == null) {
    			newAttachments = new List<Attachment>();
    		}
    		return newAttachments;
    	}
    	set;
	}
	public Boolean OfflineContract {
		get{
			if(OfflineContract == null){OfflineContract = false;}
			return OfflineContract;
		}
		set;
	}
    public Boolean AllowOfflineContract {
    	get {
    		return this.SelectedAccounts.size() == 1;
    	}
    }

    public PSG_User__c PSGUser {
    	get {
    		if(PSGUser == null) {
		        String marketManager = Apexpages.currentPage().getParameters().get('MM');
		        PSGUser = PSGUserClass.findByEmail(marketManager);
    		}
    		return PSGUser;
    	}
    	set; 
	}

	// list of all accounts associated to the market manager
    public List<AccountWrapper> AvailableAccounts {
    	get{
    		if(AvailableAccounts == null) {
		    	AvailableAccounts = getAvailableAccounts();
    		}
	    	return AvailableAccounts;
    	}
    	set;
	}
	
    // list of all accounts that have been selected
	public Map<Id, AccountWrapper> SelectedAccounts {
		get {
			if(SelectedAccounts == null) {
				SelectedAccounts = new Map<Id, AccountWrapper>();
			}
			return SelectedAccounts;
		}
		private set;
	}
	
	// list of all available terms
	public List<TermWrapper> AvailableTerms { 
		get {
			if(AvailableTerms == null) {
				AvailableTerms = getListofTerms();
			}
			return AvailableTerms;
		}
		set;
	}
    
    ////// Paging Properties and Methods
	// indicates whether there are more records after the current page set.
	public Boolean hasNext {
		get {
			return ListController.getHasNext();
		}
	}
 
	// indicates whether there are more records before the current page set.
	public Boolean hasPrevious {
		get {
			return ListController.getHasPrevious();
		}
	}
 
	// returns the page number of the current page set
	public Integer pageNumber {
		get {
			return ListController.getPageNumber();
		}
	}
 
	public Integer numberOfPages {
		get {
			numberOfPages = ListController.getResultSize()/PAGE_SIZE;
			if(math.mod(ListController.getResultSize(),PAGE_SIZE) > 0) {
				numberOfPages = numberOfPages + 1;
			}
			return numberOfPages;
		}
		private set;
	}

	// navigates to step 1 of the wizard
	public PageReference goToStep1() {
		return Page.ReContractingStep1;
	}

	// navigates to step 2 of the wizard
	public PageReference goToStep2() {
		if(SelectedAccounts.isEmpty() == true) {
			Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'You must select at least one account.'));
			return null;
		}
		return Page.ReContractingStep2;
	}
	
    // navigates to step 3 of the wizard
	public PageReference goToStep3() {
		// validate the input
		if(ValidateInput() == true) {
			// redirect to next step in the wizard
			return Page.ReContractingStep3;
		}
		return null;
	}

	public PageReference Submit() {
		
		if(OfflineContract == true && newAttachments == null && isVenere() == false) {
			// offline contracts require an attachment
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Warning, 'The Form of payment attachment is required for offline contracts'));
			
		}else{
			// create contracts for each selected account
			if(SubmitHelper('Active') == true) {
				PageReference myPageReference = Page.ReContractingConfirmation;
				myPageReference.setRedirect(true);
				myPageReference.getParameters().put('mm', psgUser.Email__c);
				myPageReference.getParameters().put('ApprovalRequired', string.valueOf(this.ApprovalRequired));
				return myPageReference;
			}
		}		
		return null;	
	}
	
	// returns the first page of records
 	public void first() {
 		ListController.first();
		AvailableAccounts = getAvailableAccounts();
 	}
 
 	// returns the last page of records
 	public void last() {
 		ListController.last();
		AvailableAccounts = getAvailableAccounts();
 	}

	// returns the previous page of records
 	public void previous() {
 		ListController.previous();
		AvailableAccounts = getAvailableAccounts();
 	}
 
 	// returns the next page of records
 	public void next() {
 		ListController.next();
		AvailableAccounts = getAvailableAccounts();
 	}
    ////// End Paging Properties and Methods
 	    
    public PageReference VerifyAuthentication() {
        // User has not been authenticated redirect to the authentication page
        if(PSGUserClass.isAuthenticatedUser(PSGUser) == false || PSGUser.Recontracting_Role__c != 'Market Manager') { 
            return Page.ReContractingAuthentication;
        }

        // User has been authenticated
        return null;
    }
    
    public PageReference Search() {
    	// clear the current list
    	ListController = null;
    	// query for accounts
		AvailableAccounts = getAvailableAccounts();
    	
    	return Apexpages.currentPage();
    }
    
    public PageReference uploadFile(){
    	try{
    		// need to first create the contract before we can add attachments.
    		if(gsoContracts == null){
    			submitHelper('Pending');
    		}
    		
    		// upload files
    		if(gsoContracts != null && gsoContracts.isEmpty() == false) {
				// should only be one offline contract
				Id parentId = gsoContracts.get(0).id;
		    	// add attachment to list
		    	Attachment file = new Attachment(Name=fileName, Body=fileBody, ParentId=parentId);
		    	insert file;
		    	
		    	// get list of attachments
				newAttachments = getAttachments(parentId);
    		}
    	}catch(Exception ex) {
    		Apexpages.addMessages(ex);
    	}finally{
	    	// clear file fields
	    	fileName = null;
	    	fileBody = null;
    	}
    	
    	return Apexpages.currentPage();
    }
    
    public PageReference removeFile() {
    	try{
	    	Id attachmentId = (Id)Apexpages.currentPage().getParameters().get('attachmentId');
	    	AttachmentClass.deleteAttachment(attachmentId);
	    	
	    	// get list of attachments
			Id parentId = gsoContracts.get(0).id;
			newAttachments = getAttachments(parentId);
			
    	}catch(Exception ex){
    		Apexpages.addMessages(ex);
    	}finally{
			// need to remove the querystring parameter
			Apexpages.currentPage().getParameters().remove('attachmentId');
    	}
    	return Apexpages.currentPage();
    }
    
    public Boolean getDisplayAttachmentsButton(){
    	return this.OfflineContract && this.AllowOfflineContract;
    }
    
    //// Private Methods
    private List<GSOContract__c> gsoContracts;
    
    private ApexPages.StandardSetController ListController {
        get {
        	// used to get paged results
            if(ListController == null && PSGUser != null) {
            	// build query
            	List<Account> accounts = BuildQuery();
            	
                ListController = new ApexPages.StandardSetController(accounts);
				ListController.setPageSize(PAGE_SIZE);
            }
            
            // if the list controller is still null 
            if(ListController == null) ListController = new ApexPages.StandardSetController(new List<Account>());
            return ListController;
        }
        private set;
    }
    
    private List<Account> BuildQuery() {
    	// need to separate the queries because the combined query was significantly slower
    	// get list of accounts based on market manager field
    	List<Account> accounts = AccountClass.findByMMorEID(PSGUser.Name, ExpediaHotelId);
    	// get list of accounts based on psg user role
		  List<Account> psgAccounts = [Select Id  
                                     From Account 
                                    Where Id In (Select Account__c 
                                                   From PSG_User_Role__c 
                                                  Where PSG_User__r.Name = : psgUser.Name)
                                      AND Id Not In : accounts
                                      AND Expedia_Hotel_Id__c != null
                                      AND ETP_Eligible__c = true];
    	// combine list
    	accounts.addAll(psgAccounts);
    	
    	// requery to sort the list
    	String query = 'Select Name, Id, Expedia_Hotel_Id__c, Region__r.Name ' +
									'From Account ' +
									'Where Id In : accounts';
		    	
		// exclude accounts with contracts
		List<Account> accountsWithContracts = getAccountsWithContracts();
		
    	if(accountsWithContracts != null) {
	    	query += ' and Id Not In : accountsWithContracts';
    	}

    	// search by expedia hotel id
    	if(ExpediaHotelId != null && ExpediaHotelId != '') {
    		query += ' and Expedia_Hotel_Id__c = \'' + String.escapeSingleQuotes(ExpediaHotelId) + '\'';
    	}
    	accounts = database.query(query);
    	
    	return accounts;
    }
    
    private List<Account> getAccountsWithContracts() {
		List<Account> accounts = [Select Id From Account 
									Where Id In (Select Account__c From GSOContract__c 
										Where (Approval_Required__c = false 
										OR (Approval_Required__c = true AND Approval_Status__c != 'Rejected'))
										AND (Status__c = 'Active' OR Status__c = 'Completed' OR Status__c = 'Pending') 
										)];
																
		return accounts;

    }
	
	// get list of available accounts
    private List<AccountWrapper> getAvailableAccounts() {
    	List<AccountWrapper> accounts = new List<AccountWrapper>();
    	
    	// call ListController to get paged results
        for(Account myAccount : (List<Account>) ListController.getRecords()) {
        	// check to see if the account is already included in the selected accounts.
        	// if it's already been selected set the selected contact id
        	AccountWrapper selAcct = SelectedAccounts.get(myAccount.Id);
        	Id selectedContact = (selAcct == null ? null : selAcct.SelectedContactId);
        	
    		accounts.add(new AccountWrapper(this, myAccount, selectedContact));
        }

    	return accounts;
    }
    
    private List<TermWrapper> getListofTerms() {
    	// used to map the parent term wrapper to the child term
    	Map<Id, TermWrapper> tempTerms = new Map<Id, TermWrapper>();
    	// since we can't sort the values in a map we need to use a list.
    	List<TermWrapper> terms = new List<TermWrapper>();
    	
    	// get date range for current year. ex.: 1/1/2011 - 12/31/2011
    	Date beginDate = Date.newInstance(1, 1, system.today().year());
    	Date endDate = Date.newInstance(12, 31, system.today().year());
    	
    	// get terms for the current year
    	for(Term__c term : TermClass.findByDate(beginDate, endDate)) {
	   		
	   		if(term.Parent_Term__c == null) {
	   			// create parent term
		   		TermWrapper myTerm = new TermWrapper(term);
		   		tempTerms.put(term.Id, myTerm);
		   		terms.add(myTerm);
	   		}else {
	   			// get parent term
		   		TermWrapper parentTerm;
	   			parentTerm = tempTerms.get(term.Parent_Term__c);

	   			// create child term
		   		TermWrapper childTerm = new TermWrapper(term);
		   		// add child term to the parent term
		   		parentTerm.childTerms.add(childTerm);
	   		}
	   }
    	
    	return terms;
    }
    
    private Boolean ValidateInput() {
    	Boolean validInput = true;
    	
    	for(TermWrapper myTerm : AvailableTerms) {
			// if the term is required, validate that the value is not null
    		if(myTerm.IsValid() == false) {
    			validInput = false;
    		}
    	}
    	return validInput;
    }
    
    private Boolean SubmitHelper(String status) {
    	Boolean success = true;
    	
    	// set a save point in case we need to rollback on error
    	Savepoint sp = Database.setSavepoint();
    	
    	try {
    		if(gsoContracts != null){
    			// update status of contracts
    			updateContracts(status);
    		}else if(NoActiveSubmissions()){
	    		// create a contract submission record
				GSO_Contract_Submission__c submission = CreateSubmission();
	    		
		    	// create contracts for each selected account
		    	gsoContracts = CreateContracts(submission, status);
				
				// create contract terms
		    	List<GSOContract_Term__c> contractTerms = CreateContractTerms(gsoContracts);
    		}else {
    			// there are active submissions for the selected accounts
    		}
	    	
    	}catch(Exception ex) {
    		// rollback the transactions
    		Database.rollback(sp);
    		Apexpages.addMessages(ex);
    		success = false;
    	}finally {
	    	// set the list controller to null so that the available accounts list is refreshed if the user starts the wizard
	    	// again
	    	ListController = null;
    	}
    	
    	return success;
    }
    
    private List<GSOContract__c> CreateContracts(GSO_Contract_Submission__c submission, String status) {
    	List<GSOContract__c> contracts = new List<GSOContract__c>();
    	
    	// create contracts for each selected account
    	for(AccountWrapper myAccount : SelectedAccounts.values()) {
    		GSOContract__c myContract = new GSOContract__c();
    		myContract.Account__c = myAccount.Acct.Id;
    		myContract.Contact__c = myAccount.SelectedContactId;
    		myContract.Date_Contract_Started__c = Date.Today();
    		myContract.GSO_Contract_Submission__c = submission.Id;
    		myContract.Batch_Size__c = SelectedAccounts.size();
    		myContract.Supplier_Training_by_Market_Manager__c = this.SupplierTrainingByMM;
    		myContract.Offline_Contract__c = this.OfflineContract;
    		myContract.Status__c = status;
    		
    		contracts.add(myContract);
    	}
    	
    	// insert contracts
    	insert contracts;

    	return contracts;
    }
    
    private void updateContracts(String status) {
    	for(GSOContract__c myContract : gsoContracts) {
    		myContract.Status__c = status;
    	}
    	
    	update gsoContracts;
    }
    
    private List<GSOContract_Term__c> CreateContractTerms(List<GSOContract__c> contracts) {
    	List<GSOContract_Term__c> contractTerms = new List<GSOContract_Term__c>();

    	// link contracts to terms
    	for(GSOContract__c myContract : contracts) {
	    	for(TermWrapper myTerm : AvailableTerms) {
	    		contractTerms.addAll(myTerm.CreateContractTerms(myContract));
	    	}
    	}
    	
		// insert contract terms
    	insert contractTerms;

    	// update the contract terms
    	update contracts;
    	
    	ApprovalRequired = contracts.get(0).Approval_Required__c;

    	return contractTerms;
    }
    
    private GSO_Contract_Submission__c CreateSubmission() {
    	GSO_Contract_Submission__c submission = new GSO_Contract_Submission__c();
    	submission.PSG_User__c = PSGUser.Id;
    	submission.Market_Manager_Email__c = PSGUser.Email__c;
    	
    	// set the email alias for the workflow rule to allow an email notification to all approvers
    	submission.Approver_Email__c = getApproverEmail();
    	
    	insert submission;
    	
    	return submission;
    }
    
    private String getApproverEmail(){
    	String approverEmail = APPROVER_ALIAS;
    	 
    	AccountWrapper myAccountWrapper = SelectedAccounts.values().get(0);
    	Id regionId = myAccountWrapper.Acct.Region__c;
    	
    	if(regionId != null){
	    	for(PSG_User_Region__c psgUserRegion : PSGUserRegionClass.findByRegion(regionId)){
	    		approverEmail = psgUserRegion.PSG_User__r.Email__c;
	    	}
    	}
    	
    	return approverEmail;
    }
    
    private List<Attachment> getAttachments(Id parentId) {
    	List<Attachment> attachments = new List<Attachment>();
    	
		for(Attachment myAttachment : AttachmentClass.findByParentId(parentId)) {
			myAttachment.body = null;
			attachments.add(myAttachment);
		}
		
		return attachments;
    }
    
    private Boolean isVenere(){
    	try{
			Account myAccount = SelectedAccounts.values().get(0).Acct;
	    	return myAccount.Venere_Id__c != null;
    	}catch(Exception ex) {
    		return false;
    	}
    }
    
    private Boolean NoActiveSubmissions(){
    	Set<Id> accountIds = new Set<Id>();
    	
    	for(AccountWrapper myAccount : SelectedAccounts.values()) {
    		accountIds.add(myAccount.Acct.Id);
    	}
    	
    	List<GSOContract__c> activeSubmissions = GSOContractClass.findActiveContractsByAccount(accountIds);
    	return activeSubmissions.isEmpty();
    }
}
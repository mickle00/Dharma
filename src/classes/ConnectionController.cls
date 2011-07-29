public class ConnectionController{
   
    public Connection__c myConnection {get; set;}
    public Case myCase {get; set;}
    public Note myNote {get; set;}
    
    public List<Connection__c> accountConnections{get; set;}

    // Query for the full Case, as well as prepopulate the connection with the case & the account linked.
    public ConnectionController(){
        myNote = new Note();
        myCase = [SELECT Id
                         ,AccountId
                         ,Account.Name
                         ,CaseNumber 
                   FROM Case 
                  WHERE Id = :ApexPages.currentPage().getParameters().get('CaseID')];
        myConnection = new Connection__c(Case__c = myCase.Id, Account__c = myCase.AccountId); //are we going to need to check for Account__c == null
        try{
            accountConnections = [SELECT  Id 
                                         ,Connectivity_System__c
                                         ,Connectivity_System__r.Connectivity_Vendor__r.Name
                                         ,Type__c
                                         ,Status__c
                                         ,Platform__c
                                         ,Go_Date__c
                                         ,LastModifiedDate
                                         ,LastModifiedBy.FirstName
                                         ,LastModifiedBy.LastName 
                                   FROM  Connection__c 
                                  WHERE  Account__c = :myCase.AccountId
                               ORDER BY  LastModifiedDate DESC];
        }catch (Exception e) {
            system.debug ('Error: ' + e);
            accountConnections = new List<Connection__c>();
        }
    }
    
    public boolean getRenderRelatedList(){
        return accountConnections.size() > 0;
    }

    // Override the Connection__c default Save method to instead bring you back to the Case you were working on.
    public PageReference Save(){
        try{
            insert myConnection;
            this.insertNote();
            return returnToCase();
        }catch (Exception e){
            return null;
        }           
    }
    
    public PageReference SaveAndNew(){
        try{
            insert myConnection;
            this.insertNote();
        }catch (Exception e){
            return null;
        }
        PageReference caseURL = new PageReference('/apex/NewConnection?CaseID='+myCase.Id);
        caseURL.setRedirect(true); // clear the viewstate
        return caseURL;
    }
  

    public PageReference returnToCase(){
        PageReference caseURL = new PageReference('/'+myCase.Id);
        return caseURL;
    }
    
    private void insertNote(){
        if (myNote.body != null || myNote.title != null){
            if (myNote.title == null) myNote.title = '(NONE)';
            myNote.ParentId = myConnection.Id;
            insert myNote;
        }
    }
}

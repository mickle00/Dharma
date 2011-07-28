public class ConnectionController {

	// Will be passing the CaseId using the queryString
	// Can probably get away with just querying for Case directly, and not using getter/setter
	public id myCaseId{
		get;
		set{
			//myCaseId = Apex.Pages().getParams().get(caseID);
			myCaseId = ApexPages.currentPage().getParameters().get(CaseID);
		}
	}
	
	public Connection__c myConnection;
	public Case myCase;

	// Query for the full Case, as well as prepopulate the connection with the case & the account linked.
	public void ConnectionController(){
		//myCase = [SELECT Id, Account__c, CaseNumber FROM Case WHERE Id = :myCaseId];
		myCase = [SELECT Id, AccountId, CaseNumber FROM Case WHERE Id = :ApexPages.currentPage().getParameters().get(CaseID)];
		myConnection = new Connection__c(Case__c = myCase.Id, Account__c = myCase.AccountId); //are we going to need to check for Account__c == null
	}

	// Override the Connection__c default Save method to instead bring you back to the Case you were working on.
	public PageReference Save(){
		insert myConnection;
		return this.returnToCase(); //not sure if this will work	
	}
	

	public PageReference returnToCase(){
		PageReference caseURL = new PageReference('/'+myCase.Id);
		return caseURL;
	}

	/**
	OVER ENGINEERING??
	**/
	
	// Loop through this list to display all of the connection currently linked to an account.
	// The idea here being they could see what already exists, or perhaps go ahead and edit an existing connection, rather than creating a new one?
	public List<Connection__c> accountConnections = [SELECT Id FROM Connection__c WHERE Account__c = :myCase.Account__c];

}
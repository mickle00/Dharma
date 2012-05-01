public with sharing class VisualforceEmail {

    public Id Case_Id {get; set;}
    public string EmailBody{
    	get { return 'original';}
    	set;
	}
    public GSOContract__c getGSOContract(){
    	Case myCase = [SELECT Id, AccountID FROM Case WHERE Id = :Case_Id];
    	GSOContract__c myContract = [SELECT Id FROM GSOContract__c WHERE Account__c = :myCase.AccountID];
    	return myContract;
    }
    
    //public string getEmailBody(){
    //    return 'this is fomr the controller';
    //}

}
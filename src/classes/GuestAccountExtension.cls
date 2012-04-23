public with sharing class GuestAccountExtension {

    public Guest__c myGuest{get;set;}
    
    public GuestAccountExtension (ApexPages.StandardController stdController) {
           if (!Test.isRunningTest()) stdController.addFields(this.FIELDNAMES);
           this.myGuest = (Guest__c) stdController.getRecord();
    }
    
    private List<String> FIELDNAMES = new List<String>{'Case__r.Account.Name'
                                                       ,'Case__r.Account.Fallback_Notes__c'};
}
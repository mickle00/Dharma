public with sharing class CaseFallbackExtension {
    public Case myCase{get;set;}
    
    public CaseFallbackExtension (ApexPages.StandardController stdController) {
           if (!Test.isRunningTest()) stdController.addFields(this.FIELDNAMES);
           this.myCase = (Case) stdController.getRecord();
    }
    
    private List<String> FIELDNAMES = new List<String>{'Account.Fallback_Notes__c'};
}
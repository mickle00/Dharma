public class CaseTransferController{
	
	public Case myCase {get;set;}
	public Case newCase {get;set;}
	public CaseComment newCaseComment {get;set;}
	public String transferringToCaseTeam {get;set;}
	
	public CaseTransferController(ApexPages.StandardController stdController){       
        this.myCase = (Case)stdController.getRecord();
    }
    
    public PageReference transferCase(){    	
    	PageReference originalCasePage = new ApexPages.StandardController(myCase).View();
        originalCasePage.setRedirect(true);
        return originalCasePage;
    }
    
    public List<selectOption> getCaseTeams() {
        List<selectOption> options = new List<selectOption>();
        
        for (Case_Team__c myCaseTeam : [SELECT Id, Name, Record_Type_Developer_Name__c FROM Case_Team__c WHERE Active__c = true]) { 
            options.add(new selectOption(myCaseTeam.Name, myCaseTeam.Name)); 
        }
        return options;
    }
}
public class CaseTransferController{
	
	public Case myCase {get;set;}
	public string transferReason {get;set;}
	public String transferringToCaseTeam {get;set;}
	
	public CaseTransferController(ApexPages.StandardController stdController){
        //Get fields without needing to query for them
        if (!Test.isRunningTest()) stdController.addFields(this.FIELDNAMES);
        this.myCase = (Case)stdController.getRecord();
    }
    
    public PageReference returnToCase(){    	
    	PageReference originalCasePage = new ApexPages.StandardController(myCase).View();
        originalCasePage.setRedirect(true);
        return originalCasePage;
    }
    
    public PageReference transferCase(){
        this.createTransferredCase(myCase);
    	return this.returnToCase();
    }
    
    public PageReference closeAndTransferCase(){
        this.createTransferredCase(myCase);
        //Why doesn't the standard controller have ClosingView() as a method?
    	PageReference originalCaseClosePage = new PageReference('/' + myCase.Id + '/s?retURL=' + myCase.Id);
    	return originalCaseClosePage;
    }
    
    public List<selectOption> getCaseTeamPicklistOptions() {
        List<selectOption> options = new List<selectOption>();
        
        for (Case_Team__c myCaseTeam : getAllCaseTeams()) { 
            options.add(new selectOption(myCaseTeam.Name, myCaseTeam.Name));
        }
        return options;
    }
    
    public Map<String, Id> getCaseTeamToRecordTypeIdMap(){
    	if (this.caseTeamToRecordTypeIdMap == null){
    		this.caseTeamToRecordTypeIdMap = new Map<String, Id>();
    		Map<String, RecordType> caseRecordTypeMap = Utilities.getRecordTypesMap('Case', true);
    		for (Case_Team__c myCaseTeam : getAllCaseTeams()){
    			this.caseTeamToRecordTypeIdMap.put(myCaseTeam.Name, caseRecordTypeMap.get(myCaseTeam.Record_Type_Developer_Name__c).Id);
    		}
    	}
    	return this.caseTeamToRecordTypeIdMap;
    }
    
    private List<Case_Team__c> getAllCaseTeams(){
    	if (this.allCaseTeams == null){
    		this.allCaseTeams = new List<Case_Team__c>();
    		this.allCaseTeams = [SELECT Id, Name, Record_Type_Developer_Name__c FROM Case_Team__c WHERE Active__c = true];
    	}
    	return this.allCaseTeams;
    }
    
    private void createTransferredCase(Case parentCase){
      String caseDescription = ''; 
      if (parentCase.Description != null) caseDescription = parentCase.Description; 
      Case newCase = new Case (Subject = parentCase.Subject
                            ,ParentId = parentCase.Id
                            ,Description = 'Transferred from Case Number: '+ parentCase.CaseNumber 
                                          +'\n Old Case Id: ' + parentCase.Id 
                                          + '\n Transferred from: ' + myCase.RecordType.Name 
                                          + '\n-----------------------------------------------------------\n\n' 
                                          + caseDescription
                            ,Description_Rich_Text__c = parentCase.Description_Rich_Text__c
                            ,suppliedEmail = parentCase.suppliedEmail
                            ,suppliedName = parentCase.suppliedName
                            ,ContactId = parentCase.ContactId
                            ,AccountId = parentCase.AccountId
                            //,Prevent_Contact_Lookup__c = true
                            ,Status = 'New - Transferred'
                            ,Team__c = transferringToCaseTeam
                            ,RecordTypeId = this.getCaseTeamToRecordTypeIdMap().get(transferringToCaseTeam));
    
      Database.DMLOptions dml = new Database.DMLOptions();
      dml.allowFieldTruncation = true;
      dml.assignmentRuleHeader.useDefaultRule= true;
      newCase.setOptions(dml);
      insert newCase;
      
      if (this.transferReason != null && this.transferReason != ''){
	      CaseComment newCaseComment = new CaseComment();
	      newCaseComment.CommentBody = this.transferReason;
	      newCaseComment.ParentId = newCase.Id;
	      insert newCaseComment;
      }
  }
  
    private Map<String, Id> caseTeamToRecordTypeIdMap;
    private List<Case_Team__c> allCaseTeams;
    private List<String> FIELDNAMES = new List<String>{'Description', 'Description_Rich_Text__c', 'suppliedEmail', 'suppliedName','ContactId','AccountId', 'Status','Team__c', 'RecordTypeId', 'Id'};
}
public class CaseTransferController{
    
    public Case myCase {get;set;}
    public string transferReason {get;set;}
    public String transferringToCaseTeam {get;set;}
    
    public CaseTransferController(ApexPages.StandardController stdController){
        // Get fields without needing to query for them
        // Hack to allow tests to run 
        if (!Test.isRunningTest()) stdController.addFields(this.FIELDNAMES);
        this.myCase = (Case)stdController.getRecord();
    }
    
    public PageReference returnToCase(){
        return new ApexPages.StandardController(myCase).View();
    }                                                           
    
    public PageReference transferCase(){
        this.createTransferredCase(myCase);
        return this.returnToCase();
    }

    public PageReference closeAndTransferCase(){
        this.createTransferredCase(myCase);
        //Why doesn't the standard controller have ClosingView() as a method, similar to View()?
        PageReference originalCaseClosePage = new PageReference('/' + myCase.Id + '/s?retURL=' + myCase.Id);
        return originalCaseClosePage;
    }
    
    public List<selectOption> getCaseTeamPicklistOptions() {
        List<selectOption> options = new List<selectOption>();
        String appendText;
        for (Case_Team__c myCaseTeam : getAllCaseTeams()) {
            appendText = myCaseTeam.Email__c == null ? '' : ' (' + myCaseTeam.Email__c + ')';
            options.add(new selectOption(myCaseTeam.Name, myCaseTeam.Name + appendText));
        }
        return options;
    }
    
    /**
    Move to CaseTeamClass???
    **/
    
    public Map<String, Id> getCaseTeamToRecordTypeIdMap(){
        if (this.caseTeamToRecordTypeIdMap == null){
            this.caseTeamToRecordTypeIdMap = new Map<String, Id>();
            Map<String, RecordType> caseRecordTypeMap = Utilities.getRecordTypesMap('Case', true);
            for (Case_Team__c myCaseTeam : getAllCaseTeams()){
                if (caseRecordTypeMap.containsKey(myCaseTeam.Record_Type_Developer_Name__c)){
                    this.caseTeamToRecordTypeIdMap.put(myCaseTeam.Name, caseRecordTypeMap.get(myCaseTeam.Record_Type_Developer_Name__c).Id);
                }
            }
        }
        return this.caseTeamToRecordTypeIdMap;
    }
    
    public Map<String, Case_Team__c> getCaseTeamMap(){
        if (this.caseTeamMap == null){
            this.caseTeamMap = new Map<String, Case_Team__c>();
            for (Case_Team__c myCaseTeam : this.getAllCaseTeams()){
                this.caseTeamMap.put(myCaseTeam.Name, myCaseTeam);
            }
        }
        return this.caseTeamMap;
    }
    
    private List<Case_Team__c> getAllCaseTeams(){
        if (this.allCaseTeams == null){
            this.allCaseTeams = new List<Case_Team__c>();
            this.allCaseTeams = [SELECT Id, Name, Record_Type_Developer_Name__c, Email__c, Team__c, Language__c FROM Case_Team__c WHERE Active__c = true order by Name ASC];
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
                            ,Prevent_Contact_Lookup__c = true
                            ,Status = 'New - Transferred'
                            ,Language__c = this.getCaseTeamMap().get(transferringToCaseTeam).Language__c
                            ,Team__c = this.getCaseTeamMap().get(transferringToCaseTeam).Team__c
                            ,RecordTypeId = this.getCaseTeamToRecordTypeIdMap().get(transferringToCaseTeam));
    
      Database.DMLOptions dml = new Database.DMLOptions();
      dml.allowFieldTruncation = true;
      dml.assignmentRuleHeader.useDefaultRule= true;
      newCase.setOptions(dml);
      try{
        insert newCase;
        this.createTransferredCaseComment(newCase.Id);
      } catch (Exception exc){
        ExceptionClass.InsertException(exc);
      }
  }

    private void createTransferredCaseComment(Id newCaseId){
        if (this.transferReason == null) this.transferReason = '';
        CaseComment newCaseComment = new CaseComment();
        String commentHeader = 'Parent Case Details at Time of Transfer:'
                                +'\n--- Number of Attachments = ' + this.getParentAttachmentsSize()
                                +'\n--- Number of Comments = ' + this.getParentCaseCommentsSize() + '\n\n';
        newCaseComment.CommentBody = commentHeader + this.transferReason;
        newCaseComment.ParentId = newCaseId;
        insert newCaseComment;
    }
    
    private Integer getParentCaseCommentsSize(){
        if (this.parentCaseComments == null){
            this.parentCaseComments = new List<CaseComment>();
            this.parentCaseComments = [SELECT Id FROM CaseComment WHERE ParentId = :this.myCase.Id];
        }
        return this.parentCaseComments.size();
    }
    
    private Integer getParentAttachmentsSize(){
        if (this.parentAttachments == null){
            this.parentAttachments = new List<Attachment>();
            this.parentAttachments = [SELECT Id FROM Attachment WHERE ParentId = :this.myCase.Id];
        }
        return this.parentAttachments.size();
    }
    
    private List<CaseComment> parentCaseComments;
    private List<Attachment> parentAttachments;
    private Map<String, Id> caseTeamToRecordTypeIdMap;
    private Map<String, Case_Team__c> caseTeamMap;
    private List<Case_Team__c> allCaseTeams;
    private List<String> FIELDNAMES = new List<String>{'Description'
                                                      ,'Description_Rich_Text__c'
                                                      ,'SuppliedEmail'
                                                      ,'SuppliedName'
                                                      ,'ContactId'
                                                      ,'AccountId'
                                                      ,'Status'
                                                      ,'Team__c'
                                                      ,'RecordTypeId'
                                                      ,'Id'};
}
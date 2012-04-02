@isTest
private class CaseTransferController_Test {
	
	static Case testCase;
	static Case_Team__c testCaseTeam;
	
	static CaseTransferController getTestController(){		
		testCase = new Case(Subject = 'TestCase', Status = 'TestStatus', Description = 'Test Description');
		insert testCase;
		PageReference CaseTransferPage = Page.CaseTransfer;
        Test.setCurrentPage(CaseTransferPage);
        ApexPages.currentPage().getParameters().put('Id', testCase.Id);
        ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
        CaseTransferController myController = new CaseTransferController(caseController);
        return myController;
	}
	
	static Case_Team__c getNewCaseTeam(){
		RecordType randomRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = 'Case'AND isActive = true LIMIT 1];
		testCaseTeam = new Case_Team__c (Name = 'TestCaseTeam', Record_Type_Developer_Name__c = randomRecordType.DeveloperName, Email_Service_Address__c = 'fake@nevergoingtohappen.org');
		insert testCaseTeam;
		return testCaseTeam;
	}

    static testMethod void shouldHaveCaseComment() {
        CaseTransferController myController = getTestController();        
        Case_Team__c newCaseTeam = getNewCaseTeam();
        myController.getCaseTeamPicklistOptions();
        List<Case> previousChildCases = [SELECT Id, RecordType.DeveloperName FROM Case WHERE ParentId = :testCase.Id];
                
        myController.transferringToCaseTeam = newCaseTeam.Name;
        myController.transferReason = 'Because this is what I\'m testing';
        myController.transferCase();
        
        List<Case> newChildCases = [SELECT Id, RecordType.DeveloperName FROM Case WHERE ParentID = :testCase.Id];
        system.assertEquals(previousChildCases.size() + 1, newChildCases.size());
        system.assertEquals(newChildCases[0].RecordType.DeveloperName, newCaseTeam.Record_Type_Developer_Name__c);
        
        List<CaseComment> childCaseComments = [SELECT Id FROM CaseComment WHERE ParentID = :newChildCases[0].Id];
        system.assertEquals(1, childCaseComments.size());        
    }
    static testMethod void shouldNotHaveCaseComment() {
        CaseTransferController myController = getTestController();
        Case_Team__c newCaseTeam = getNewCaseTeam();
        List<Case> previousChildCases = [SELECT Id, RecordType.DeveloperName FROM Case WHERE ParentId = :testCase.Id];
        myController.transferringToCaseTeam = newCaseTeam.Name;
        myController.transferCase();
        List<Case> newChildCases = [SELECT Id, RecordType.DeveloperName FROM Case WHERE ParentID = :testCase.Id];
        system.assertEquals(previousChildCases.size() + 1, newChildCases.size());
        system.assertEquals(newChildCases[0].RecordType.DeveloperName, newCaseTeam.Record_Type_Developer_Name__c);
        
        List<CaseComment> childCaseComments = [SELECT Id FROM CaseComment WHERE ParentID = :newChildCases[0].Id];
        system.assertEquals(0, childCaseComments.size());   
    }
    static testMethod void shouldRedirectToStandardClosePage() {
        CaseTransferController myController = getTestController();
        Case_Team__c newCaseTeam = getNewCaseTeam();
        List<Case> previousChildCases = [SELECT Id, RecordType.DeveloperName FROM Case WHERE ParentId = :testCase.Id];
        myController.transferringToCaseTeam = newCaseTeam.Name;
        String nextPage = myController.closeAndTransferCase().getUrl();
        system.assertEquals('/' + testCase.Id + '/s?retURL=' + testCase.Id, nextPage);
        
        List<Case> newChildCases = [SELECT Id, RecordType.DeveloperName FROM Case WHERE ParentID = :testCase.Id];
        system.assertEquals(previousChildCases.size() + 1, newChildCases.size());
        system.assertEquals(newChildCases[0].RecordType.DeveloperName, newCaseTeam.Record_Type_Developer_Name__c);
        
        List<CaseComment> childCaseComments = [SELECT Id FROM CaseComment WHERE ParentID = :newChildCases[0].Id];
        system.assertEquals(0, childCaseComments.size());   
    }
}
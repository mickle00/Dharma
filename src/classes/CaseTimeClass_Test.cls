@isTest
private class CaseTimeClass_Test {

	static testMethod void shouldHaveCaseTime() {
		Case myCase = new Case (Subject = 'TestCase', Status = 'New');
		insert myCase;
		
		Case_Time__c myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);
		system.assertNotEquals(myCaseTime, null);
	}
	static testMethod void shouldNotHaveMultipleCaseTimes(){
		Case myCase = new Case (Subject = 'TestCase', Status = 'New');
		insert myCase;
		
		try{
			Case_Time__c myCaseTime = new Case_Time__c(Case__c = myCase.Id);
			insert myCaseTime;
		} catch (DmlException e){
			system.assert(e.getMessage().contains('DUPLICATE_VALUE'));
		}
		
		List<Case_Time__c> myCaseTimes = [SELECT Id FROM Case_Time__c WHERE Case__c = :myCase.Id];
		system.assertEquals(myCaseTimes.size(), 1);
	}
	
	static testMethod void shouldHaveFirstHandleTime() {
		Case myCase = new Case (Subject = 'TestCase', Status = 'New');
		insert myCase;
        
		myCase.Status = 'In Progress';
		update myCase;
        
		Case_Time__c myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);
		system.assertNotEquals(myCaseTime.First_Handle_Time__c, null);
    }
    
    static testMethod void shouldFailGracefully(){
		Case myCase = new Case (Subject = 'TestCase', Status = 'New');
		insert myCase;
		
		List<Case_Time__c> myCaseTimes = [SELECT Id FROM Case_Time__c WHERE Case__c = :myCase.Id];
		delete myCaseTimes;
		
		myCase.Status = 'In Progress';
		update myCase;
    }
}
@isTest
private class CaseTimeClass_Test {

	static testMethod void shouldHaveCaseTime() {
		Case myCase = new Case (Subject = 'TestCase', Status = 'New');
		insert myCase;
		
		Case_Time__c myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);
		system.assertNotEquals(myCaseTime, null);

	}
	
	static testMethod void shouldNotHaveCaseTime(){
		Case myCase = new Case (Subject = 'TestCase', Status = 'New', PSG_Case_Id__c = '99999');
		insert myCase;
				
		try{
			Case_Time__c myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);
		} catch (QueryException exc){
			system.assert(exc.getMessage().contains('List has no rows for assignment to SObject'));
		}
		
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
	
	static testMethod void shouldRespectFirstHandleTime() {
		Case myCase = new Case (Subject = 'TestCase', Status = 'New');
		insert myCase;
		
		Case_Time__c myCaseTime;
		myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);
		system.assertEquals(myCaseTime.First_Handle_Time__c, null);
        
		string ahtStatus = 'In Progress';
		
		myCase.Status = ahtStatus;
		update myCase;
        
		
		myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);
		
		CaseTimeClass caseTimeObj = new CaseTimeClass();
		if (caseTimeObj.isStatusIncludedInAHT(ahtStatus, false)){
			system.assertNotEquals(myCaseTime.First_Handle_Time__c, null);
		} else {
			system.assertEquals(myCaseTime.First_Handle_Time__c, null);
		}
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
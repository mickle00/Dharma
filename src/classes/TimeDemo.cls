public with sharing class TimeDemo {

	public static Map<String, RecordType> caseTimeRecordTypeMap = Utilities.getRecordTypesMap('Case_Time__c', true);
	
	public static void updateRecordTypes(String developerName){
		
		if (developerName == 'Roadmap') addSLAtoCases();
		
		List<Case_Time__c> allCaseTimes = [SELECT Id, RecordTypeId FROM Case_Time__c];
		for (Case_Time__c myCaseTime : allCaseTimes){
			myCaseTime.RecordTypeId = caseTimeRecordTypeMap.get(developerName).Id;
		}
		update allCaseTimes;
	}
	
	public static void addSLAtoCases(){
		Service_Level_Agreement__c mySLA = [SELECT Id FROM Service_Level_Agreement__c WHERE Time_in_Hours__c = 24];
		List<Case> allCases = [SELECT Id FROM Case WHERE Service_Level_Agreement__c = null];
		
		for (Case myCase : allCases){
			myCase.Service_Level_Agreement__c = mySLA.Id;
		}
		update allCases;
	}
}
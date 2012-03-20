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
	
	public static void createExample(){
		RecordType myRT = [SELECT Id FROM RecordType WHERE sObjectType ='Case' AND DeveloperName = 'Geography'];
		BusinessHours myBusinessHours = [SELECT Id FROM BusinessHours WHERE Name = 'Content'];
		Service_Level_Agreement__c mySLA = [SELECT Id FROM Service_Level_Agreement__c WHERE Name = '24 Hours'];
		//DateTime myDateTime = DateTime.newInstance(2012,3,10,12,30,0);
		DateTime myDateTime = system.now().addHours(-101);
		
		Case myCase = new Case (Subject = 'Test Case'
							   ,Status = 'Closed'
							   ,CreatedDate = myDateTime
							   ,RecordTypeId = myRT.Id
							   ,BusinessHoursId = myBusinessHours.Id
							   ,Service_Level_Agreement__c = mySLA.Id
							   );
		insert myCase;
		
		Case_Time__c myCaseTime = [SELECT Id FROM Case_Time__c WHERE Case__c = :myCase.Id];
		
		List<Time_Log__c> allTimeLogs = [SELECT Id FROM Time_Log__c WHERE Case_Time__r.Case__c = :myCase.Id];
		delete allTimeLogs;
		
		Time_Log__c myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
											   ,In_Effect_From__c = myDateTime
											   ,In_Effect_Until__c = myDateTime.addHours(1)
											   ,Case_Owner__c = 'Geography'
											   ,Case_Owner_Type__c = 'Queue'
											   ,Case_Status__c = 'New'
											   ,New_Case_Status__c = 'New'
											   ,New_Case_Owner__c = 'Michael Stewart'
											   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(1);
		
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(67)
								   ,Case_Owner__c = 'Michael Stewart'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'New'
								   ,New_Case_Status__c = 'In Progress'
								   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(67);
	
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(6)
								   ,Case_Owner__c = 'Michael Stewart'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'In Progress'
								   ,New_Case_Status__c = 'On Hold'
								   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(6);
				
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(18)
								   ,Case_Owner__c = 'Michael Stewart'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'On Hold'
								   ,New_Case_Status__c = 'In Progress'
								   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(18);
		
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(9)
								   ,Case_Owner__c = 'Michael Stewart'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'In Progress'
								   ,New_Case_Status__c = 'Closed'
								   ,While_Closing_Case__c = true
								   );
		insert myTimeLog;	
		
	}
	
	public static void setClosedReply(Id myCaseId){
		Case myCase = new Case(Id = myCaseId);
		myCase.Status = 'Closed - Reply';
		update myCase;
	}
	
	public static void createFakeExample(){
		RecordType myRT = [SELECT Id FROM RecordType WHERE sObjectType ='Case' AND DeveloperName = 'Geography'];
		BusinessHours myBusinessHours = [SELECT Id FROM BusinessHours WHERE Name = 'Content'];
		Service_Level_Agreement__c mySLA = [SELECT Id FROM Service_Level_Agreement__c WHERE Name = '24 Hours'];
		//DateTime myDateTime = DateTime.newInstance(2012,3,10,12,30,0);
		DateTime myDateTime = system.now().addHours(-9);
		
		Case myCase = new Case (Subject = 'Test Case'
							   ,Status = 'Closed'
							   ,CreatedDate = myDateTime
							   ,RecordTypeId = myRT.Id
							   ,BusinessHoursId = myBusinessHours.Id
							   ,Service_Level_Agreement__c = mySLA.Id
							   );
		insert myCase;
		
		Case_Time__c myCaseTime = [SELECT Id FROM Case_Time__c WHERE Case__c = :myCase.Id];
		
		List<Time_Log__c> allTimeLogs = [SELECT Id FROM Time_Log__c WHERE Case_Time__r.Case__c = :myCase.Id];
		delete allTimeLogs;
		
		Time_Log__c myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
											   ,In_Effect_From__c = myDateTime
											   ,In_Effect_Until__c = myDateTime.addHours(1)
											   ,Case_Owner__c = 'Geography'
											   ,Case_Owner_Type__c = 'Queue'
											   ,Case_Status__c = 'New'
											   ,New_Case_Status__c = 'New'
											   ,New_Case_Owner__c = 'Fred Flintstone'
											   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(1);
		
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(3)
								   ,Case_Owner__c = 'Fred Flintstone'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'New'
								   ,New_Case_Status__c = 'In Progress'
								   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(67);
	
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(1)
								   ,Case_Owner__c = 'Fred Flintstone'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'In Progress'
								   ,New_Case_Status__c = 'On Hold'
								   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(6);
				
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(3)
								   ,Case_Owner__c = 'Fred Flintstone'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'On Hold'
								   ,New_Case_Status__c = 'In Progress'
								   );
		insert myTimeLog;
		myDateTime = myDateTime.addHours(18);
		
		myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
								   ,In_Effect_From__c = myDateTime
								   ,In_Effect_Until__c = myDateTime.addHours(1)
								   ,Case_Owner__c = 'Fred Flintstone'
								   ,Case_Owner_Type__c = 'User'
								   ,Case_Status__c = 'In Progress'
								   ,New_Case_Status__c = 'Closed'
								   ,While_Closing_Case__c = true
								   );
		insert myTimeLog;	
		
	}
}
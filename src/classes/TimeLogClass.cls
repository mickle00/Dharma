public with sharing class TimeLogClass {

	// Called from After Update Case Trigger
	public void logCaseTime(List<Case> newCases, Map<Id, Case> oldCaseMap){
        List<Time_Log__c> newCaseLogs = new List<Time_Log__c>();
        
        for (Case myCase : newCases){
            Case myOldCase = oldCaseMap.get(myCase.Id);
            if (myCase.Status != myOldCase.Status || myCase.OwnerId != myOldCase.OwnerId){
                Time_Log__c myTimeLog = new Time_Log__c(Case_Owner__c = myOldCase.OwnerId
                                                       ,Case_Status__c = myOldCase.Status
                                                       ,New_Case_Status__c = myCase.Status
                                                       ,In_Effect_Until__c = myCase.LastModifiedDate
                                                       ,Case_Time__c = myCase.Case_Time__c);
               newCaseLogs.add(myTimeLog);
            }
        }
        insert newCaseLogs;
	}
	
	// Called from Before Insert on Time Log
	public static void beforeNewTimeLogs(List<Time_Log__c> newTimeLogs){
	    CaseTimeClass caseTimeObj = new CaseTimeClass();
        
        for (Time_Log__c myTimeLog : newTimeLogs){
        	myTimeLog.Time_Bucket__c = caseTimeObj.getStatusTimeBucket(myTimeLog.Case_Status__c, myTimeLog.Case_Closed__c);
        	myTimeLog.Included_In_SLA_Time__c = caseTimeObj.isStatusIncludedInSLATime(myTimeLog.Case_Status__c, myTimeLog.Case_Closed__c);            
            myTimeLog.In_Effect_From__c = myTimeLog.Most_Recent_Change__c == null ? myTimeLog.In_Effect_Until__c : myTimeLog.Most_Recent_Change__c;            
            myTimeLog.Business_Time_in_Hours__c = BusinessHours.diff(myTimeLog.Case_Business_Hours_ID__c, myTimeLog.In_Effect_From__c, myTimeLog.In_Effect_Until__c)/3600000.0;
        }
	}
	
	public static Time_Log__c createNewTimeLog(Case_Time__c myCaseTime, Case myCase){
		Time_Log__c myTimeLog = new Time_Log__c();
		//TODO: CREATE TIME LOG
		//TODO: MAKE SURE DEACTIVATED OLDUSERS DOESNT BREAK LOGGING
		
		return myTimeLog;
	}
	
	//TODO: UPDATE METHODS TO USE THIS
	private boolean caseNeedsToLogTime(Case myCase, Case myOldCase){
		if (myCase.Status != myOldCase.Status || myCase.OwnerId != myOldCase.OwnerId){
			return true;
		}
		return false;
	}
}
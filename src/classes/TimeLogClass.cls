public with sharing class TimeLogClass {

	// Called from After Update Case Trigger
	public void logCaseTime(List<Case> newCases, Map<Id, Case> oldCaseMap){
        List<Time_Log__c> newCaseLogs = new List<Time_Log__c>();
        this.getOwnerIdToOwnerNameMap();
        
        for (Case myCase : newCases){
            Case myOldCase = oldCaseMap.get(myCase.Id);
            if (caseNeedsToLogTime(myCase, myOldCase)){
				Time_Log__c myTimeLog = this.createNewTimeLog(myCase, myOldCase);
				newCaseLogs.add(myTimeLog);
            }
        }
        insert newCaseLogs;
	}
	
	// Called from Before Insert on Time Log
	public static void beforeNewTimeLogs(List<Time_Log__c> newTimeLogs){
	    CaseTimeClass caseTimeObj = new CaseTimeClass();
        
        for (Time_Log__c myTimeLog : newTimeLogs){
        	myTimeLog.Time_Bucket__c = caseTimeObj.getStatusTimeBucket(myTimeLog.Case_Status__c, myTimeLog.While_Case_Closed__c);
        	myTimeLog.Included_In_SLA_Time__c = caseTimeObj.isStatusIncludedInSLATime(myTimeLog.Case_Status__c, myTimeLog.While_Case_Closed__c, myTimeLog.While_Closing_Case__c);            
            myTimeLog.In_Effect_From__c = myTimeLog.Most_Recent_Change__c == null ? myTimeLog.In_Effect_Until__c : myTimeLog.Most_Recent_Change__c;            
            myTimeLog.Business_Time_in_Hours__c = BusinessHours.diff(myTimeLog.Case_Business_Hours_ID__c, myTimeLog.In_Effect_From__c, myTimeLog.In_Effect_Until__c)/3600000.0;
        }
	}
	
	public Time_Log__c createNewTimeLog(Case myCase, Case myOldCase){
		Time_Log__c myTimeLog = new Time_Log__c();

		if (myOldCase == null){
			this.setCaseFields(myTimeLog, myCase);
		} else {
			this.setCaseFields(myTimeLog, myOldCase);
		}
		//These fields should always be set from the new values		
		myTimeLog.New_Case_Status__c = myCase.Status;
		myTimeLog.In_Effect_Until__c = myCase.LastModifiedDate;
		myTimeLog.Case_Time__c = myCase.Case_Time__c;
		if (myCase.isClosed) myTimeLog.While_Closing_Case__c = true;
		
		return myTimeLog;
	}
	
	public Map<Id, String> getOwnerIdToOwnerNameMap(){
		if (this.OwnerIdToOwnerNameMap == null){
			this.OwnerIdToOwnerNameMap = new Map<Id, String>();
			this.OwnerIdToOwnerNameMap = Utilities.getOwnerIdToOwnerNameMap('Case');
		}
		return this.OwnerIdToOwnerNameMap;
	}
	
	private void setCaseFields(Time_Log__c myTimeLog, Case myCase){
		myTimeLog.Case_Owner__c = this.getOwnerIdToOwnerNameMap().get(myCase.OwnerId);
		myTimeLog.Case_Status__c = myCase.Status;
		myTimeLog.Case_Owner_Type__c = Utilities.getOwnerType(myCase.OwnerId);
		if (myCase.isClosed) myTimeLog.While_Case_Closed__c = true;
	}		
	private boolean caseNeedsToLogTime(Case myCase, Case myOldCase){
		if (myCase.Status != myOldCase.Status || myCase.OwnerId != myOldCase.OwnerId){
			return true;
		}
		return false;
	}
	
	private Map<Id, String> OwnerIdToOwnerNameMap;	
}
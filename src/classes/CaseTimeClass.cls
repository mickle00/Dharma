public with sharing class CaseTimeClass {

	public static Case_Time__c findByCaseId (Id myCaseId){
		return [SELECT Id
					  ,First_Handle_Time__c 
				 FROM Case_Time__c 
			 	WHERE Case__c = :myCaseId];
	}
	
	// Called from Before Insert on Case
	public void createCaseTimesForNewCases(List<Case> newCases){
        List<Case_Time__c> newCaseTimes = new List<Case_Time__c>();
        for (Integer i=0; i < newCases.size(); i++){
            Case_Time__c myCaseTime = new Case_Time__c();
            newCaseTimes.add(myCaseTime);
        }
        insert newCaseTimes;
        
        for (Case myCase : newCases){
            myCase.Case_Time__c = newCaseTimes.remove(0).Id;        
        }
        // clean up incase there were any failures inserting Cases
        if (!newCaseTimes.isEmpty()) delete newCaseTimes;
	}
	
	// Called from After Insert on Case
	// Link the CaseTime record to the Case. Need the CaseID after Insert
	public void updateCaseTimeAfterInsert(List<Case> newCases){
        List<Case_Time__c> newCaseTimes = new List<Case_Time__c>();
        List<Time_Log__c> newCaseLogs = new List<Time_Log__c>();
        TimeLogClass TimeLogObj = new TimeLogClass();
        for (Case myCase : newCases){
            if (myCase.Case_Time__c != null){
                Case_Time__c myCaseTime = new Case_Time__c(Id=myCase.Case_Time__c);
                myCaseTime.Case__c = myCase.Id;
                newCaseTimes.add(myCaseTime);
                
                //immediately log, incase the case is created in progress or whatever
				Time_Log__c myTimeLog = TimeLogObj.createNewTimeLog(myCase, null);
				newCaseLogs.add(myTimeLog);
            }
        }
        update newCaseTimes;
        insert newCaseLogs;
	}
	
	// Before Insert & Before Update on CaseTime
	public void recalculateCaseTimes(List<Case_Time__c> newCaseTimes){		
		for (Case_Time__c myCaseTime : newCaseTimes){
			//recalculate myCaseTime.Current_Time_Included_in_SLA_Time__c
			if (myCaseTime.Case_Status__c != null && myCaseTime.Case_Closed__c != null){
				myCaseTime.Current_Time_Included_in_SLA_Time__c = this.isStatusIncludedInSLATime(myCaseTime.Case_Status__c, myCaseTime.Case_Closed__c);
			}
			//recalculate myCaseTime.Business_Hours_Earliest_SLA_Due_Date__c
			if (myCaseTime.SLA_in_Hours__c != null){
				Long businessTimeRemainingInSLA = (myCaseTime.SLA_in_Hours__c - myCaseTime.Logged_Business_Hours_Included_in_SLA__c).longValue() * 3600000L;
				DateTime statusChangeTime = myCaseTime.Most_Recent_Change__c;
				if (statusChangeTime == null) statusChangeTime = system.now();
				myCaseTime.Business_Hours_Earliest_SLA_Due_Date__c = BusinessHours.add(myCaseTime.Case_Business_Hours_ID__c,statusChangeTime, businessTimeRemainingInSLA); 
			}
			//recalculate myCaseTime.Logged_Business_Hours_Until_First_Handle__c
			if (myCaseTime.First_Handle_Time__c != null && myCaseTime.Logged_Business_Hours_Until_First_Handle__c == null){
				myCaseTime.Logged_Business_Hours_Until_First_Handle__c = BusinessHours.diff(myCaseTime.Case_Business_Hours_ID__c, myCaseTime.Case_Created_Date__c, myCaseTime.First_Handle_Time__c)/3600000.0;				
			}
			//set the Unique_Key__c
			if (myCaseTime.Case__c != null && myCaseTime.Unique_Key__c == null){
				myCaseTime.Unique_Key__c = myCaseTime.Case__c;
			}
		}
	}
	
	public Map<String, Status_Time_Bucket__c> getStatusToTimeMap(){
		if (statusToTimeMap == null){
			statusToTimeMap = new Map<String, Status_Time_Bucket__c>();
			for (Status_Time_Bucket__c statusTime : Status_Time_Bucket__c.getAll().values()){
            	statusToTimeMap.put(statusTime.Status__c,statusTime);
        	}	
		}
		return statusToTimeMap;
	}
	
	public string getStatusTimeBucket(string caseStatus, boolean caseClosed){
		if (caseClosed) return 'Closed';
		if (getStatusToTimeMap().containsKey(caseStatus)){
			return getStatusToTimeMap().get(caseStatus).Time_Bucket__c;
		}
		return 'Included in SLA';
	}
	
	public boolean isStatusIncludedInSLATime (string caseStatus, boolean caseClosed, boolean closingCase){
		if (closedReplyIncludedInSLA (caseStatus, closingCase)) return true;
		if (caseClosed) return false;
		if (getStatusToTimeMap().containsKey(caseStatus)){
			return getStatusToTimeMap().get(caseStatus).Included_in_SLA_Time__c;
		}
		return true;
	}
	
	public boolean isStatusIncludedInSLATime (string caseStatus, string caseClosed){
		//formula fields cant return boolean. trying to save uneccessary soql here
		if (caseClosed == 'TRUE') return false;
		return this.isStatusIncludedInSLATime(caseStatus, false, false);
	}
	
	private boolean closedReplyIncludedInSLA(string oldCaseStatus, boolean caseStillClosed){
		if (oldCaseStatus == 'Closed - Reply'){
			if (!caseStillClosed) return true;			
		}
		return false; 
	}
	
	private Map<String, Status_Time_Bucket__c> statusToTimeMap;
}
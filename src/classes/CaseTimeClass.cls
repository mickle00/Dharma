public class CaseTimeClass {

    public static Case_Time__c findByCaseId (Id myCaseId){
        return [SELECT Id
                      ,First_Handle_Time__c 
                 FROM Case_Time__c 
                WHERE Case__c = :myCaseId];
    }
    
    // Called from Before Insert on Case
    public void createCaseTimesForNewCases(List<Case> newCases){
        List<Case_Time__c> newCaseTimes = new List<Case_Time__c>();
        List<Case> casesToLogTime = this.casesIncludedInCaseTime(newCases);
        
        for (Integer i=0; i < casesToLogTime.size(); i++){
            Case_Time__c myCaseTime = new Case_Time__c();
            newCaseTimes.add(myCaseTime);
        }
        
        try{
            insert newCaseTimes;    
        } catch (Exception exc){
            ExceptionClass.InsertException(exc);
        }
        
        for (Case myCase : casesToLogTime){
            try{
                myCase.Case_Time__c = newCaseTimes.remove(0).Id;
            }catch (Exception exc){
                ExceptionClass.InsertException(exc);
            }        
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
                
                //immediately log, needed for roll up summary to work
                Time_Log__c myTimeLog = TimeLogObj.createNewTimeLog(myCase, null);
                newCaseLogs.add(myTimeLog);
            }
        }
        try {
            update newCaseTimes;
            insert newCaseLogs;
        } catch (Exception exc){
            ExceptionClass.InsertException(exc);
        }
    }
    
    // Before Insert & Before Update on CaseTime
    public void recalculateCaseTimes(List<Case_Time__c> newCaseTimes){      
        for (Case_Time__c myCaseTime : newCaseTimes){
            //recalculate myCaseTime.Current_Time_Included_in_SLA_Time__c
            if (myCaseTime.Case_Status__c != null && myCaseTime.Case_Closed__c != null){
                myCaseTime.Current_Time_Included_in_SLA_Time__c = this.isStatusIncludedInSLATime(myCaseTime.Case_Status__c, myCaseTime.Case_Closed__c);
            }
            //recalculate myCaseTime.Current_Time_Included_in_AHT__c
            if (myCaseTime.Case_Status__c != null && myCaseTime.Case_Closed__c != null){
                myCaseTime.Current_Time_Included_In_AHT__c = this.isStatusIncludedInAHT(myCaseTime.Case_Status__c, myCaseTime.Case_Closed__c);
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
    
    public boolean isStatusIncludedInAHT(string caseStatus, boolean caseClosed){
        if (caseClosed) return false;
        if (getStatusToTimeMap().containsKey(caseStatus)){
            return getStatusToTimeMap().get(caseStatus).Included_in_AHT__c;
        }
        return false;
    }
    public boolean isStatusIncludedInAHT(string caseStatus, string caseClosed){
        //formula fields cant return boolean. trying to save uneccessary soql here
        if (caseClosed == 'TRUE') return false;
        return this.isStatusIncludedInAHT(caseStatus, false);
    }
    
    // Do not log legacy PSG cases, as the CaseTime will be completely off
    private List<Case> casesIncludedInCaseTime (List<Case> allCases){
        List<Case> myCases = new List<Case>();
        for (Case myCase : allCases){
            if (myCase.PSG_Case_Id__c == null){
                myCases.add(myCase);
            }
        }
        return myCases;
    }
    
    private Map<String, Status_Time_Bucket__c> statusToTimeMap;
}
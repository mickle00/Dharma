trigger CaseTimeTrigger on Case_Time__c (before insert, before update) {
    
    CaseTimeClass CaseTimeObj = new CaseTimeClass();
    
    // Rollup Summary field of new Time Log causes Case Time to be updated
    // Recalculate the Business Hours using the BusinessHours Class
    if (trigger.isBefore && trigger.isInsert){
        CaseTimeObj.recalculateCaseTimes(trigger.New);
    }
    if (trigger.isBefore && trigger.isUpdate){
        CaseTimeObj.recalculateCaseTimes(trigger.New);
    }
}
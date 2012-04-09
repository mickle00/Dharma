trigger TimeLogTrigger on Time_Log__c (before insert) {
    
    if (trigger.isBefore && trigger.isInsert){
    	TimeLogClass.beforeNewTimeLogs(trigger.new);
    }
}
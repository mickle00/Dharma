trigger CaseTimeTrigger on Case (before insert, after insert, after update) {

    CaseTimeClass CaseTimeObj = new CaseTimeClass();
    TimeLogClass TimeLogObj = new TimeLogClass();
    
    if (trigger.isBefore && trigger.isInsert){
		CaseTimeObj.createCaseTimesForNewCases(trigger.New);
    }
    
    if (trigger.isAfter && trigger.isInsert){
		CaseTimeObj.updateCaseTimeAfterInsert(trigger.New);
    }
    
    if (trigger.isAfter && trigger.isUpdate){
		TimeLogObj.logCaseTime(trigger.New, trigger.oldMap);
    }
}
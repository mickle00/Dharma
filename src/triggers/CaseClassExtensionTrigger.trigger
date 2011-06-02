trigger CaseClassExtensionTrigger on Case (after insert, after update, before insert, 
before update) {
	
	CaseClassExtension CaseEx = new CaseClassExtension();
	
	/**
	
	SHOULD ITERATE THROUGH THE LISTS GETTING ONLY TROUBLESHOOTING CASES PRIOR TO SENDING TO CLASS, BUILD NEW LISTS & MAPS, AND THEN PASS
	MAKE IT MORE EFFICIENT BY NOT RUNNING UNNECCESSARY CODE ON UNNECCESSARY RECORDS
	
	**/
	
	if (trigger.isBefore && trigger.isInsert){
		CaseEx.beforeNewTroubleshootingCase(trigger.new);
	}
	
	/**
	if (trigger.isBefore && trigger.isInsert){	
		Id troubleshootingRecordTypeId = [Select Id from RecordType where blah blah blah]
		Id troubleshootingQueueId = [Select Id from Queue blah blah blah]
		Map<Id, Case> troubleshootingCases = new Map<Id, Case>();
		for (Case myCase : trigger.New){
		 if (myCase.RecordTypeId == troubleshootingRecordTypeId || myCase.OwnerId == troubleshootingQueueId){
		   troubleshootingCases.put(myCase.Id, myCase);
		 }
		}
		CaseEx.beforeNewTroubleshootingCase(troubleshootingCases.values());
  }	
	**/	
	
	if (trigger.isAfter && trigger.isInsert){
		CaseEx.afterNewTroubleshootingCase(trigger.new);
	}
	if (trigger.isBefore && trigger.isUpdate){
		CaseEx.beforeUpdateTroubleshootingCase(trigger.newMap, trigger.oldMap);
	}
	if (trigger.isAfter && trigger.isUpdate){
		CaseEx.afterUpdateTroubleshootingCase (trigger.newMap, trigger.oldMap);		
	}

}
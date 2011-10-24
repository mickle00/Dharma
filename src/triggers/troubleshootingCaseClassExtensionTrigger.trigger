trigger troubleshootingCaseClassExtensionTrigger on Case (after insert, after update, before insert, 
before update) {
  
  troubleshootingCaseClassExtension CaseEx = new  troubleshootingCaseClassExtension();
  
  if (trigger.isBefore && trigger.isInsert){
    CaseEx.beforeNewTroubleshootingCase(trigger.new);
  }    
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
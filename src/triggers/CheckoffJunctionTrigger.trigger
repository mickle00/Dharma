trigger CheckoffJunctionTrigger on Checkoff_Junction__c (after update, before insert) {
  CheckoffJunctionClass objCheckoffJunction = new CheckoffJunctionClass();
  
  if (trigger.isBefore && trigger.isInsert){
    objCheckoffJunction.beforeInsertCheckoffJunction(trigger.new);
  }
  if (trigger.isAfter && trigger.isUpdate){
    objCheckoffJunction.afterUpdateCheckoffJunction(trigger.newMap, trigger.oldMap);
  }
}
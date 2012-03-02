trigger ActionItemTrigger on Action_Item__c (before insert) {
	
	ActionItemClass aiObj = new ActionItemClass();
	
	if (trigger.isBefore && trigger.isInsert){
		aiObj.addActionItemsToCase(trigger.New);
	}
}
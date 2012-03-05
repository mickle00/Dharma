@isTest
private class ActionItemClass_Test {

    static testMethod void caseShouldHaveActionItems() {
        Case myCase = new Case (Subject = 'DM Test Case', Number_of_Changes__c = 0);
        insert myCase;
        
        ActionItemClass myAIClass = new ActionItemClass();
        RecordType destinationManagementRT = myAIClass.actionItemRecordTypeMap.get('Destination_Management');
        
        List<Action_Item__c> newActionItems = new List<Action_Item__c>();
        
        Integer actionItemCount = 3;
        
        for (Integer i=0;i<actionItemCount;i++){       
	        Action_Item__c myActionItem = new Action_Item__c(Case__c = myCase.Id
	        												,RecordTypeId = destinationManagementRT.Id
	        												,Name = 'TestActionItem'
	        												,Checklist_Item_ID__c = '999'
	        												,Hotel_Checklist_Status_ID__c ='123456'+i //unique constraint
	        												);
			newActionItems.add(myActionItem);
        }
        myAIClass.addActionItemsToCase(newActionItems);
        
        Case updatedCase = [SELECT Id, Number_Of_Changes__c FROM Case WHERE Id = :myCase.Id];
        system.assertEquals(updatedCase.Number_Of_Changes__c, actionItemCount);
    }
}
trigger GuestTrigger on Guest__c (before insert) {
    GuestClass guestObj = new GuestClass();
    
    if (trigger.isBefore && trigger.isInsert){
    	guestObj.insertFallbacks(trigger.new);
    }

}
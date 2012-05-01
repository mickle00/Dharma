trigger GuestTrigger on Guest__c (before insert, before update) {
    GuestClass guestObj = new GuestClass();
    
    if (trigger.isBefore && trigger.isInsert){
        guestObj.insertFallbacks(trigger.new);
    }
    if (trigger.isBefore && trigger.isUpdate){
    	guestObj.createRelocationsFromFallBacks(trigger.new);
        for (Guest__c myGuest : trigger.new){
            if (myGuest.Status__c == 'Past Arrival'){
                if (myGuest.Hotel_Cancel_Date__c != NULL ||
                    myGuest.Expedia_Cancel_Date__c != NULL){
                    myGuest.Status__c = 'Cancelled';
                }
                if (myGuest.Hotel_Confirmation_Date__c != NULL){
                    myGuest.Status__c = 'Confirmed';
                }
            }
        }
    }

}
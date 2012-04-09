trigger AccountTrigger on Account (before insert, before update) {
	AccountClass objAccount = new AccountClass();
	objAccount.BeforeInsertUpdateAccount(trigger.new);
	
	// create star rating cases for ESR or Venere/EEM accounts
	// Star Ratings is now pushing these cases from an external DB. HP 3/27/2012
	/*if(Trigger.isUpdate) {
		objAccount.NewUnratedProperties(trigger.oldMap, trigger.new);
	}*/
}
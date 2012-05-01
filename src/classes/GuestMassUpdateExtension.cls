public with sharing class GuestMassUpdateExtension {
    
    public Map<Id, Guest__c> openGuests;
    public Map<Id, Guest__c> openGuestsOriginal;
    List<GuestWrapper> myGuestWrappers;
    public Guest__c guestTemplate;
    public boolean allSelected {get;set;}
    
    
    //Extension
    public GuestMassUpdateExtension (ApexPages.StandardSetController controller) {
        this.allSelected = false;
    }
    
    public List<Guest__c> getOpenGuests(){
        if (this.openGuests == null){
            this.openGuests =  new Map<Id, Guest__c> ([SELECT  Id
					                                   ,Name
					                                   ,Expedia_Booking_ID__c
					                                   ,Status__c
					                                   ,Arrival_Date__c 
					                              FROM Guest__c 
					                             WHERE Case__c = :ApexPages.currentPage().getParameters().get('Id')
					                               AND Closed__c = false
					                          ORDER BY Arrival_Date__c ASC]
            );
            this.openGuestsOriginal = this.openGuests.deepClone();
        } return this.openGuests.values();
    }
    
    public PageReference Save(){
    	List<Guest__c> guestsToBeUpdated = new List<Guest__c>();
    	for (GuestWrapper myGuestWrapper : myGuestWrappers){
    		if (myGuestWrapper.myGuest.Status__c != openGuestsOriginal.get(myGuestWrapper.myGuest.Id).Status__c){
    			guestsToBeUpdated.add(myGuestWrapper.myGuest);
    		}
    	}
    	update guestsToBeUpdated;
    	
    	return new ApexPages.StandardController(new Case(Id=ApexPages.currentPage().getParameters().get('Id'))).view();
    }
    
    public void selectAll(){
        if (this.allSelected){
            for (GuestWrapper myGuestWrapper : this.getGuestWrappers()){
                myGuestWrapper.isSelected = true;
            }
        } else {
            for (GuestWrapper myGuestWrapper : this.getGuestWrappers()){
                myGuestWrapper.isSelected = false;
            }
        }
    }
    
    public List<GuestWrapper> getGuestWrappers(){
        if (this.myGuestWrappers == null){
            this.myGuestWrappers = new List<GuestWrapper>();
            for (Guest__c myGuest : this.getOpenGuests()){
                GuestWrapper myGuestWrapper = new GuestWrapper(myGuest);
                myGuestWrappers.add(myGuestWrapper);
            }   
        } return this.myGuestWrappers;
    }
    
    public Guest__c getGuestTemplate(){
        //TODO: Get RecordTypeID via Utilities Method
        if (this.guestTemplate == null){
            this.guestTemplate = new Guest__c(RecordTypeId = '012c000000008AO');
        } return this.guestTemplate;    
    }
    
    public void updateAllGuests(){
        for (GuestWrapper myGuestWrapper : this.myGuestWrappers){
            if (myGuestWrapper.isSelected){
                myGuestWrapper.myGuest.Status__c = this.guestTemplate.Status__c;
            }
        }
    }
    
    public PageReference cancel(){
        return new ApexPages.StandardController(new Case(Id=ApexPages.currentPage().getParameters().get('Id'))).cancel();
    }
    
    public class GuestWrapper{
        public Guest__c myGuest{get;set;}
        public boolean isSelected{get;set;}
        
        public GuestWrapper(Guest__c myGuest){
            this.myGuest = myGuest;
            this.isSelected = false;
        }
        public GuestWrapper(){}
        
    }
}
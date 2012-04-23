public with sharing class GuestMassUpdateExtension {
    
    public List<Guest__c> openGuests;
    List<GuestWrapper> myGuestWrappers;
    public Guest__c guestTemplate;
    public boolean allSelected {get;set;}
    
    public GuestMassUpdateExtension (ApexPages.StandardSetController controller) {
        controller.setPageSize(100);
        this.allSelected = false;
    }
    
    public List<Guest__c> getOpenGuests(){
        if (this.openGuests == null){
            this.openGuests = new List<Guest__c>();
            this.openGuests =  [SELECT  Id
                                   ,Name
                                   ,Expedia_Booking_ID__c
                                   ,Status__c
                                   ,Arrival_Date__c 
                              FROM Guest__c 
                             WHERE Case__c = :ApexPages.currentPage().getParameters().get('Id')
                               AND Closed__c = false
                          ORDER BY Arrival_Date__c ASC];
        } return this.openGuests;
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
        //TODO: Look at StandardSetController.getRecord()
        //TODO: Scope RecordType
        if (this.guestTemplate == null){
            this.guestTemplate = new Guest__c(RecordTypeId = '012c00000008U8L');
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
    }
}
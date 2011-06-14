trigger OutOfOfficeNoticeTrigger on Out_of_Office_Notice__c (after update, before update) {
	
	OutOfOfficeNoticeClass objOOFNotice = new OutOfOfficeNoticeClass(); 
  
  Out_of_Office_Notice__c[] oofNotices = trigger.new;
    
  for(Out_of_Office_Notice__c notice : oofNotices){
    if(trigger.isBefore && notice.End__c > system.today() && notice.Start__c <= System.today()){
      notice.Status__c = 'Inactive';
    }    
  } 
  
  objOOfNotice.setStatus(oofNotices);
}
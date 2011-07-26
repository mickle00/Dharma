public with sharing class OutOfOfficeNoticeClass {
  public void setStatus(Out_of_Office_Notice__c[] oofNotices ){
  	
  	set<Id> oofNoticeUsers = new set<Id>();
  	map<Id,Assignment_Groups__c> UserIdToAssignmentGroup = new map<Id,Assignment_Groups__c>();
  	
    List<Assignment_Groups__c> groupsToUpdate = new List<Assignment_Groups__c>();
  	
  	for(Out_of_Office_Notice__c notice : oofNotices) {
  		oofNoticeUsers.add(notice.User__c);
  	}
  
    Assignment_Groups__c[] groupMembers = [SELECT Id
                                                 ,Active__c
                                                 ,User__c
                                             FROM Assignment_Groups__c
                                             WHERE User__c = :oofNoticeUsers];
                                                
    for(Assignment_Groups__c member : groupMembers) {
      userIdToAssignmentGroup.put(member.User__c,member);
    }
    
    for(Out_of_Office_Notice__c notice : oofNotices) {
    	Assignment_Groups__c thisGroup = userIdToAssignmentGroup.get(notice.User__c);
    	thisGroup.Active__c = notice.Status__c == 'Active' ? 'True' : 'False';
      groupsToUpdate.add(thisGroup);
    }
<<<<<<< HEAD
    List<Database.SaveResult> SR = database.update(groupsToUpdate);
    for (Database.SaveResult err : SR){
    	system.debug(err.getErrors());
    }
    //update groupsToUpdate;
=======
    update groupsToUpdate;
>>>>>>> 5b9b776e3d763a4cb116e0eabb30a1a414befc5e
  }
}
public with sharing class GroupMemberLanguageClass {
	
	public GroupMemberLanguageClass(string groupName){
		this.buildMaps(groupName);
	}
		
    public Map<String, List<User>> getLanguageToUsersMap(){
    	return this.languageToUsersMap;
    }
    
    public Map<Id, List<Language__c>> getUserIdToLanguagesMap(){
    	return this.userIdToLanguagesMap;
    }
    	
	public void buildMaps(string groupName){
		this.languageToUsersMap = new Map<String, List<User>>();
		this.userIdToLanguagesMap = new Map<Id, List<Language__c>>();
		for (Group_Member_Language__c myMemberLanguage : [SELECT Id
		                                                         ,Group_Member__r.User__c
		                                                         ,Group_Member__r.User__r.Id
		                                                         ,Group_Member__r.User__r.Name
		                                                         ,Language__r.Name
	                                                        FROM Group_Member_Language__c 
	                                                        WHERE Group_Member__r.Group_Name__r.Name = :groupName
	                                                          AND Group_Member__r.User_Active__c = 'True']){
            if (this.languageToUsersMap.containsKey(myMemberLanguage.Language__r.Name)){
            	this.languageToUsersMap.get(myMemberLanguage.Language__r.Name).add(myMemberLanguage.Group_Member__r.User__r);
            } else{
            	this.languageToUsersMap.put(myMemberLanguage.Language__r.Name, new List<User>{myMemberLanguage.Group_Member__r.User__r});
            }
            if (this.userIdToLanguagesMap.containsKey(myMemberLanguage.Group_Member__r.User__c)){
            	this.userIdToLanguagesMap.get(myMemberLanguage.Group_Member__r.User__c).add(myMemberLanguage.Language__r);
            } else{
            	this.userIdToLanguagesMap.put(myMemberLanguage.Group_Member__r.User__c, new List<Language__c> {myMemberLanguage.Language__r});
            }
    	}
	}
	private Map<String, List<User>> languageToUsersMap;
    private Map<Id, List<Language__c>> userIdToLanguagesMap;
	
	public class LanguageUserAssignment {
		public User myUser;
		public List<Language__c> userLanguages;
		public Integer numberOfActiveFallbacks;
		
		public LanguageUserAssignment(User myUser, GroupMemberLanguageClass groupMemberLanguageObj){
			this.myUser = myUser;
			this.userLanguages = groupMemberLanguageObj.getUserIdToLanguagesMap().get(myUser.Id);
			this.numberOfActiveFallbacks = 0;
		}
	}
}
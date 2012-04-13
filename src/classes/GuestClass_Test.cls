@isTest
private class GuestClass_Test {
	
	static void setupTestData() {
	   List<Account> testAccounts = new List<Account> {
            new Account(Name = 'A1', PSG_Language__c = 'Spanish', Expedia_Hotel_Id__c = '1')
           ,new Account(Name = 'A2', PSG_Language__c = 'French', Expedia_Hotel_Id__c = '2')
           ,new Account(Name = 'A3', PSG_Language__c = 'German', Expedia_Hotel_Id__c = '3')
           ,new Account(Name = 'A4', PSG_Language__c = 'Tralfamadorian', Expedia_Hotel_Id__c = '4')
	   };
	   insert testAccounts;
	   
	   List<Language__c> testLanguages = new List<Language__c>{
	   	   new Language__c (Name = 'Spanish')
	   	  ,new Language__c (Name = 'English')
	   	  ,new Language__c (Name = 'French')
	   	  ,new Language__c (Name = 'German')
	   };
	   insert testLanguages;
	   
	   List<User> testUsers = new List<User>{
	   	   new User (UserName = 'TestTest')
	   };
	   insert testUsers;
	   
	   Assignment_Group_Name__c myAG = new Assignment_Group_Name__c(Name = 'Fallback');
	   insert myAG;
	   
	   List<Assignment_Groups__c> groupMembers = new List<Assignment_Groups__c>{
	   	   new Assignment_Groups__c (User__c = testUsers[0].Id, Group_Name__c = myAG.Id)
	   };
	   insert groupMembers;
	   
	   List<Group_Member_Language__c> groupMemberLanguages = new List<Group_Member_Language__c>{
	       new Group_Member_Language__c (Language__c = testLanguages[0].Id, Group_Member__c = groupMembers[0].Id)
	      ,new Group_Member_Language__c (Language__c = testLanguages[1].Id, Group_Member__c = groupMembers[0].Id)
	   };
	   insert groupMemberLanguages;
	}

    static testMethod void shouldAttachToExistingCase() {}
    static testMethod void shouldCreateNewCase() {}
    static testMethod void shouldNotAttachToInProgressCase() {}
    static testMethod void shouldAssignToLowerFallbackUser() {}
    static testMethod void shouldNotAssignToInactiveUser() {}
    static testMethod void shouldDefaultToEnglish() {}
    static testMethod void shouldWorkInBulk() {}
}
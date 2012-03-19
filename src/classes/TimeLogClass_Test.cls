@isTest
private class TimeLogClass_Test {

    static testMethod void caseShouldHaveTimeLogs() {
        Case myCase = new Case (Subject = 'TestCase', Status = 'New');
        insert myCase;
        
        myCase.Status = 'In Progress';
        update myCase;
        
        myCase.Status = 'Working';
        update myCase;
        
        List<Time_Log__c> allTimeLogs = [SELECT Id FROM Time_Log__c WHERE Case_Time__r.Case__c = :myCase.Id];
        
        system.assertEquals(allTimeLogs.size(), 3);
    }
    
    static testMethod void shouldNotNeedToLogTime() {
        Case myCase = new Case (Subject = 'TestCase', Status = 'New');
        insert myCase;
        
        myCase.Subject = 'Updating the Subject';
        update myCase;
        
        List<Time_Log__c> allTimeLogs = [SELECT Id FROM Time_Log__c WHERE Case_Time__r.Case__c = :myCase.Id];
        
        system.assertEquals(allTimeLogs.size(), 1);
    }
    
    
    // Apparently Inactive Users can be Owner's & Lookups for Custom Objects.
    // This is not the functionality for Standard Objects
    static testMethod void deactivatedUserShouldWork() {
    	TimeLogClass TimeLogObj = new TimeLogClass(); 
    	User myUser;
    	Case myCase;    	
    	system.runAs(new User(Id=UserInfo.getUserId())){
	    	Profile myProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
	        myUser = new User (Username = randomUUID() + '@fakeExpediaemail.com'
	        					   ,Email = 'test@test.com'
	        					   ,LastName = 'Fake'
	        					   ,Alias ='fake'
	        					   ,ProfileId = myProfile.Id
	        					   ,TimeZoneSidKey = 'America/Los_Angeles'
	        					   ,LanguageLocaleKey = 'en_US'
	        					   ,LocaleSidKey ='en_US'
	        					   ,EmailEncodingKey = 'UTF-8'
	        					   ,IsActive = true);
		   system.debug(myUser.UserName);
	       insert myUser;
    	} system.runAs(myUser){
       		myCase = new Case (Subject = 'TestCase', Status = 'New', OwnerId = myUser.Id);
			insert myCase;
    	} system.runAs(new User(Id=UserInfo.getUserId())){
			myUser.IsActive = false;
			update myUser;
			
			myUser = [SELECT Id, Name, isActive FROM User WHERE Id = :myUser.Id];
			system.assertEquals(myUser.isActive, false);
       
			myCase.Status = 'In Progress';
			update myCase;
			
			Case_Time__c myCaseTime = CaseTimeClass.findByCaseId(myCase.Id);			
			
			// Create a TimeLog with Inactive User
			Time_Log__c myTimeLog = new Time_Log__c(Case_Time__c = myCaseTime.Id
												  ,Case_Owner__c = myUser.Name
												  ,Case_Owner_Type__c = Utilities.getOwnerType(myUser.Id)
												  ,In_Effect_From__c = system.now().addMinutes(-5)
												  ,In_Effect_Until__c = system.now());
			insert myTimeLog;
			
			myTimeLog = [SELECT Case_Owner__c, Case_Owner_Type__c FROM Time_Log__c WHERE Id = :myTimeLog.Id];
			system.assertEquals(myUser.Name, myTimeLog.Case_Owner__c);
			system.assertEquals(myTimeLog.Case_Owner_Type__c, 'User');
    	}
    }
    // Make sure that Queue owned/worked doesn't throw exception
    static testMethod void queueOwnedShouldWork() {
		Group testQueue;  	
    	system.runAs(new User(Id=UserInfo.getUserId())){
    		testQueue = new Group(Type = 'Queue', Name= 'TestTestQueue');
    		insert testQueue;
    		
	    	QueueSobject myQS = new QueueSobject(QueueId = testQueue.Id, sObjectType = 'Case');
    		insert myQS;    		
    	}
    	Case myCase = new Case (OwnerId = testQueue.Id, Subject = 'Test Case');
    	insert myCase;
    	
    	Time_Log__c myTimeLog = [SELECT Case_Owner__c, Case_Owner_Type__c FROM Time_Log__c WHERE Case_Time__r.Case__c = :myCase.Id];
    	system.assertEquals(myTimeLog.Case_Owner__c, testQueue.Name);
    	system.assertEquals(myTimeLog.Case_Owner_Type__c, 'Queue');
    }
    
    // Taken from apex-lang which is set to be GA in Summer 12
    // Want to create a truly unique Username, to Create an Inactive User
    static String kHexChars = '0123456789abcdefABCDEF';
    static String randomUUID(){
        String returnValue = '';
        Integer nextByte = 0;
        for(Integer i = 0; i < 16; i++){
            if(i==4 || i==6 || i==8 || i==10){
                returnValue += '-';
            }
            //generate a "byte"; i.e., number in range [-2^7,2^7-1]
            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if(i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }
	
            if(i==8){
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }
            
            returnValue += charAt(kHexChars,nextByte >> 4);
            returnValue += charAt(kHexChars,nextByte & 15);
        }
        return returnValue;
    }
    
    static String charAt(String str, Integer index) {
        if(str == null){
            return null;
        }
        if(str.length() <= 0){
            return str;    
        }
        if(index < 0 || index >= str.length()){
            return null;    
        }
        return str.substring(index, index+1);
    }
}
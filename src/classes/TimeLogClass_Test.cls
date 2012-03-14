@isTest
private class TimeLogClass_Test {
    
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

    static testMethod void caseShouldHaveTimeLogs() {
        // TO DO: implement unit test
    }
    static testMethod void deactivatedUserShouldWork() {
    	Profile myProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User myUser = new User (Username = randomUUID() + '@fakeemail.com'
        					   ,Email = 'test@test.com'
        					   ,LastName = 'Fake'
        					   ,Alias ='fake'
        					   ,ProfileId = myProfile.Id
        					   ,TimeZoneSidKey = 'America/Los_Angeles'
        					   ,LanguageLocaleKey = 'en_US'
        					   ,LocaleSidKey ='en_US'
        					   ,EmailEncodingKey = 'UTF-8'
        					   ,IsActive = false);
        insert myUser;
    }    
}
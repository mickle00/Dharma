/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class PSGUserRegionClass_Test {

    static testMethod void myUnitTest() {
        
        // create psg user
        PSG_User__c myPSGUser = new PSG_User__c(Name='PSG', Active__c=true, Email__c='psg@expedia.com');
        insert myPSGUser;
        
        // create region
        Region__c myRegion = new Region__c(Name='GSO Region');
        insert myRegion;
        
        // create psg user region
        PSG_User_Region__c myPSGUserRegion = new PSG_User_Region__c(PSG_User__c=myPSGUser.Id, Region__c=myRegion.Id);
        insert myPSGUserRegion;
        
        test.startTest();
        
        for(PSG_User_Region__c psgUserRegions : PSGUserRegionClass.findByRegion(myRegion.Id)) {
        	System.assertEquals(psgUserRegions.PSG_User__c, myPSGUser.Id);
        }
        
        test.stopTest();
    }
}
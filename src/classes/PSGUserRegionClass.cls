public with sharing class PSGUserRegionClass {
	
	public static List<PSG_User_Region__c> findByRegion(Id regionId) {
		String myFields = 'PSG_User__c, PSG_User__r.Email__c, Region__c, Region__r.Name';
		
		// build where clause
    	List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    	conditions.add(new SoqlBuilder.Condition('Region__c', String.valueOf(regionId)));
		
		return findBy(myFields, conditions, null, null);
	}

	/////// Private Methods
    private static List<PSG_User_Region__c> findBy(String myFields, List<SoqlBuilder.Condition> conditions, String conditionLogic, String orderBy) {
		String objectName = PSG_User_Region__c.sObjectType.getDescribe().getName();
		return SoqlBuilder.ExecuteSelectQuery(myFields, objectName, conditions, conditionLogic, orderBy);
    }

}
public with sharing class PSGUserRoleClass {
	
	public static List<PSG_User_Role__c> findByAccount(Id accountId) {
		return [SELECT Id
                  ,Name
                  ,Role__c
                  ,Account__c
                  ,Account__r.Name
                  ,PSG_User__c
                  ,PSG_User__r.Name
                  ,PSG_User__r.Phone__c
                  ,PSG_User__r.Email__c
              FROM PSG_User_Role__c
             WHERE Account__c = :accountId
             ORDER BY Role__c ASC];
	}
	
	public static PSG_User_Role__c findByName(String psgUserRoleName) {
	  return [SELECT Id
                  ,Name
                  ,Role__c
                  ,Account__c
                  ,Account__r.Name
                  ,PSG_User__c
                  ,PSG_User__r.Name
                  ,PSG_User__r.Phone__c
                  ,PSG_User__r.Email__c
              FROM PSG_User_Role__c
             WHERE Name = :psgUserRoleName
             LIMIT 1];	
	}
		
/*	public static List<PSG_User_Role__c> findMarketManagerAccounts(String psgUserName) {
		// build where clause
    	List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    	conditions.add(new SoqlBuilder.Condition('PSG_User__r.Name', psgUserName));
    	conditions.add(new SoqlBuilder.Condition('Role__c', '%Market%', 'like'));
		
		return findBy('*', conditions, null, null);
	}*/
	
	//// Private Methods
    private static List<PSG_User_Role__c> findBy(String myFields, List<SoqlBuilder.Condition> conditions, String conditionLogic, String orderBy) {
		String objectName = PSG_User_Role__c.sObjectType.getDescribe().getName();
		return SoqlBuilder.ExecuteSelectQuery(myFields, objectName, conditions, conditionLogic, orderBy);
    }
}
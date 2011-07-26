trigger CaseTrigger on Case (before insert, after insert, before update, after update) {
 	
  CasePointOfSaleClass objPOS = new CasePointOfSaleClass();
  // Class holding the logic for Transport Troubleshooting Cases
  troubleshootingCaseClassExtension CaseEx = new troubleshootingCaseClassExtension();
  
	List<Case> casesToMatchContactAndAccount = new List<Case>();
	
	if (trigger.isBefore && trigger.isInsert){
		for(Case thisCase : trigger.new) {
			if(thisCase.SuppliedEmail != null && thisCase.SuppliedEmail != '') {
				casesToMatchContactAndAccount.add(thisCase);
			}
		}
		CaseClass objCaseClass = new CaseClass();
		objCaseClass.linkAccountAndContactToCase(casesToMatchContactAndAccount);
		CaseEx.beforeNewTroubleshootingCase(trigger.new);
	}
	
	if (trigger.isAfter && trigger.isInsert){
		objPOS.insertCasePointsOfSaleForNewCases(trigger.new);
		CaseEx.afterNewTroubleshootingCase(trigger.new);
	}
	
	if (trigger.isBefore && trigger.isUpdate){
    CaseEx.beforeUpdateTroubleshootingCase(trigger.newMap, trigger.oldMap);
  }
	
	if(trigger.isAfter && trigger.isUpdate){
    objPOS.syncCasePointsOfSale(trigger.oldMap, trigger.newMap);
    CaseEx.afterUpdateTroubleshootingCase (trigger.newMap, trigger.oldMap);
	}
}
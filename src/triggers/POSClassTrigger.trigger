trigger POSClassTrigger on Case (after insert, after update) {
    CasePointOfSaleClass objPOS = new CasePointOfSaleClass();
    
    if (trigger.isInsert && trigger.isAfter){
        objPOS.insertCasePointsOfSaleForNewCases(trigger.new);
    }   
    
    else if(trigger.isUpdate && trigger.isAfter){
      objPOS.syncCasePointsOfSale(trigger.oldMap, trigger.newMap);
    }
    
    system.debug('END OF TRIGGER');
}
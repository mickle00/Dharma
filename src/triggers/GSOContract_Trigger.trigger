trigger GSOContract_Trigger on GSOContract__c (before update) {
	
  GSOContractClass objContract = new GSOContractClass();
  List<GSOContract__c> contractsToProcess = new List<GSOContract__c>();
  
   if (trigger.isUpdate && trigger.isBefore) {
   	for(GSOContract__c thisContract : trigger.new) {
   	  if(thisContract.Status__c != 'Pending') { // Do not process Pending contracts
   	  	contractsToProcess.add(thisContract);
   	  }	
   	}
    objContract.ORTPostProcessing(contractsToProcess,trigger.oldMap);
    objContract.UpdatePhase(contractsToProcess, trigger.oldMap);
    objContract.CompleteContract(contractsToProcess);
  }
}
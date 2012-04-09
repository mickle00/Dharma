trigger RolloutStepTrigger on Rollout_Step__c (after insert) {
  Map<Id,RecordType> mapIdToRecordType = Utilities.RecordTypeMapIdToRecordType('Rollout_Step__c');
    
    
  if (trigger.isAfter && trigger.isInsert){
    List<Rollout_Step__c> training = new List<Rollout_Step__c>();
    List<Rollout_Step__c> connectivity = new List<Rollout_Step__c>();
        
    for(Rollout_Step__c step : trigger.new) {
      if(mapIdToRecordType.get(step.RecordTypeId).DeveloperName == 'Training') {
        training.add(step);
      }
      else {
        connectivity.add(step);
      }
    }
        
    RolloutStepClass.updateConnection(connectivity);
    RolloutStepClass.UpdateTrainingClass(training);
    
  }  
}
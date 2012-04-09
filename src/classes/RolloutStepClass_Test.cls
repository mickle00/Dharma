@isTest
private class RolloutStepClass_Test {

  static testMethod void myUnitTest() {
    Map<String,RecordType> RecordTypesMap = Utilities.getRecordTypesMap('Rollout_Step__c',true);
    Account myAccount = new Account (Name='AccountTest');
    insert myAccount;
        
		Connectivity_System__c myConnectivitySystem = new Connectivity_System__c (Name = 'TestConnectivitySystem');
		insert myConnectivitySystem;
		
		Connection__c myConnection = new Connection__c (Account__c = myAccount.Id
													   ,Connectivity_System__c = myConnectivitySystem.Id
													   ,Type__c = 'Type'
													   ,Platform__c = 'Platform');
													   
		insert myConnection;
		
		Rollout_Step__c myFirstRolloutStep = new Rollout_Step__c (Connection__c = myConnection.Id
		                                                         ,Rollout_Step__c = 'TestStep1'
		                                                         ,RecordTypeId = RecordTypesMap.get('Connectivity').Id);
		insert myFirstRolloutStep;
		
		List<Rollout_Step__c> myRolloutSteps = RolloutStepClass.getRolloutStepsByConnectionId(myConnection.Id);
		Rollout_Step__c mySecondRolloutStep = new Rollout_Step__c (Connection__c = myConnection.Id
		                                                          ,Rollout_Step__c = 'TestStep2'
		                                                          ,RecordTypeId = RecordTypesMap.get('Connectivity').Id);
		myRolloutSteps.add(mySecondRolloutStep);
		
		RolloutStepClass.insertNewRolloutSteps(myRolloutSteps);		
		system.assertEquals(RolloutStepClass.getRolloutStepsByConnectionId(myConnection.Id).size(), 2);
		mySecondRolloutStep = RolloutStepClass.getRolloutStepById(mySecondRolloutStep.Id);		
    }
    
  static testmethod void testTraining() {
  	Map<String,RecordType> RecordTypesMap = Utilities.getRecordTypesMap('Rollout_Step__c',true);
  	
  	Account myAccount = new Account (Name='AccountTest');
    insert myAccount;
    
    Training_Session__c trainingSession = new Training_Session__c(Initiative__c = 'ETP'
                                                                 ,Date_of_Session__c = System.today());                                     
    insert trainingSession;
    
    Training_Class__c trainingClass = new Training_Class__c(Account__c = myAccount.Id
                                                           ,Training_Session__c = trainingSession.Id);
    insert trainingClass;
    
    Rollout_Step__c rolloutStep = new Rollout_Step__c(Completed_Date__c = DateTime.now()
                                                     ,Training_Class__c = trainingClass.Id
                                                     ,Rollout_Step__c = 'Pending Acceptance I'
                                                     ,RecordTypeId = RecordTypesMap.get('Training').Id);
                                                           
    insert rolloutStep;
    
    trainingClass = [SELECT Id
                           ,Training_Status__c
                           ,Date_of_Last_Status__c
                       FROM Training_Class__c
                      WHERE Id = :trainingClass.Id];
                      
    system.assertEquals(trainingClass.Training_Status__c, rolloutStep.Rollout_Step__c);
    system.assertEquals(trainingClass.Date_of_Last_Status__c, rolloutStep.Completed_Date__c);
  	
  }
}
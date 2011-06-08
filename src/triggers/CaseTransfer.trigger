trigger CaseTransfer on Case (after update) {
  // When Status == Closed - Transferred && Additional Status == (QueueName); 
  // Clone a child case setting record type and queue as the new team
  
  // When Status == Transferred && Additional Status == (QueueName);
  // Case remains open, but transfers a cloned child case to the new team 
  
  // In order for this to work:
  // Additional Status == Queue Name == Record Type Name
  Map<String, Id> queueNameToId = new Map<String, Id>();
  Map<String, Id> queueNameToRecordTypeId = new Map<String, Id>();
  Map<Id, String> RecordTypeIdToName = new Map<Id, String>();
  
  // Loop through all Case record types, building a map from Id to Name, and Name to Id
  for (RecordType myRecordType : 
                                [SELECT Id
                                        ,Name //Using Name instead of DeveloperName because we do not want the underscores, etc
                                  FROM RecordType 
                                  WHERE SobjectType = 'Case']){
  	queueNameToRecordTypeId.put(myRecordType.Name, myRecordType.Id);
  	RecordTypeIdToName.put(myRecordType.Id, myRecordType.Name); 
  }
  
  // Loop through all Queues, building a map of QueueName to Id
  for (Group myQueue : 
                      [SELECT Id
                              ,Name
			                  ,(SELECT  Id
			                           ,SobjectType 
			                      FROM  QueueSobjects 
			                     WHERE SobjectType = 'Case') 
					    FROM Group 
					   WHERE Type = 'Queue']){
    queueNameToId.put(myQueue.Name, myQueue.Id);        
  }
  
  List<Case> casesToInsert = new List<Case>();
  
  // Loop through all of the Cases that have been updated, and apply the logic.
  for (Case myCase : trigger.New){ 
  	String caseDescription = ''; 
  	if (myCase.Description != null) caseDescription = myCase.Description;	
  	//Closed Transferred Logic
    if (myCase.Status == 'Closed - Transferred' && trigger.oldMap.get(myCase.Id).Status != 'Closed - Transferred' && queueNameToRecordTypeId.get(myCase.Additional_Status__c) != NULL){
      Case newCase = new Case (Subject = myCase.Subject
                               ,Description = 'Transferred from Case Number: '+myCase.CaseNumber +'\n Old Case Id: ' + myCase.Id + '\n Transferred from: ' + RecordTypeIdToName.get(myCase.RecordTypeId) + '\n-----------------------------------------------------------\n\n' + caseDescription
			                   ,ParentId = myCase.Id 
			                   ,OwnerId = queueNameToId.get(myCase.Additional_Status__c)
			                   ,RecordTypeId = queueNameToRecordTypeId.get(myCase.Additional_Status__c)
			                   );
      casesToInsert.add(newCase);    
    }
    // Open Transferred Logic
    if (myCase.Status == 'Transferred' && trigger.oldMap.get(myCase.Id).Status != 'Transferred' && queueNameToRecordTypeId.get(myCase.Additional_Status__c) != NULL){
      Case newCase = new Case (Subject = myCase.Subject
                               ,Description = 'Transferred from Case Number: '+myCase.CaseNumber +'\n Old Case Id: ' + myCase.Id + '\n Transferred from: ' + RecordTypeIdToName.get(myCase.RecordTypeId) + '\n-----------------------------------------------------------\n\n' + caseDescription
			                   // Make sure that the Additional Status field is where the Queueteam is captured
			                   ,ParentId = myCase.Id 
			                   ,OwnerId = queueNameToId.get(myCase.Additional_Status__c)
			                   ,RecordTypeId = queueNameToRecordTypeId.get(myCase.Additional_Status__c)
			                   );
      casesToInsert.add(newCase);    
    }     
  }
  // Insert all of the cases outside of the loop. 
  // Makes it so if we mass edit/upload Cases we don't hit any governor limits
  insert casesToInsert;
}
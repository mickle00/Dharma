trigger NancyTrigger on Case (after update) {
  // Adding a comment
  Map<String, Id> queueNameToId = new Map<String, Id>();
  Map<String, Id> queueNameToRecordTypeId = new Map<String, Id>();
  Map<Id, String> RecordTypeIdToName = new Map<Id, String>();
  
  for (RecordType myRecordType : 
                                [SELECT Id
                                        ,Name //Using Name instead of DeveloperName because we do not want the underscores, etc
                                  FROM RecordType 
                                  WHERE SobjectType = 'Case']){
  	queueNameToRecordTypeId.put(myRecordType.Name, myRecordType.Id);
  	RecordTypeIdToName.put(myRecordType.Id, myRecordType.Name); 
  }
  
  List<Case> casesToInsert = new List<Case>();
  for (Group myQueue : 
                      [SELECT Id
                              ,Name
							                ,(SELECT  Id
							                      ,SobjectType 
							                  FROM  QueueSobjects 
							                  WHERE SobjectType = 'Case') 
					               FROM Group 
					              WHERE type = 'Queue']){
    queueNameToId.put(myQueue.Name, myQueue.Id);        
  }
  
  for (Case myCase : trigger.New){
    if (myCase.Status == 'Closed - Transferred' && trigger.oldMap.get(myCase.Id).Status != 'Closed - Transferred' && myCase.Additional_Status__c != NULL){
      Case newCase = new Case (Subject = myCase.Subject
                               ,Description = 'Transferred from Case Number: '+myCase.CaseNumber +'\n Old Case Id: ' + myCase.Id + '\n Transferred from: ' + RecordTypeIdToName.get(myCase.RecordTypeId) + '\n-----------------------------------------------------------\n\n' + myCase.Description
							                 // Make sure that the Additional Status field is where the Queueteam is captured
							                 ,OwnerId = queueNameToId.get(myCase.Additional_Status__c)
							                 ,RecordTypeId = queueNameToRecordTypeId.get(myCase.Additional_Status__c)
							                 );
    casesToInsert.add(newCase);    
    }    
  }
  insert casesToInsert;
}
public with sharing class troubleshootingCaseClassExtension {


// Will add to the Case Class? Should we break it out separately? 

//for Before Insert
public void beforeNewTroubleshootingCase(List<Case> myCases){
  for (Case myCase : myCases){
    if (myCase.RecordTypeId == troubleshootingRecordType){
      myCase.OwnerId = troubleshootingQueueId;
      myCase.Involved__c = getAllInvolvedTeamsPicklistValue();
    } 
  }
}

// for Before Update
public void beforeUpdateTroubleshootingCase(Map<Id, Case> newCaseIDtoCaseMap, Map<Id, Case> oldCaseIDtoCaseMap){
  for (Case myCase : newCaseIDtoCaseMap.values()){
    if (myCase.OwnerId == troubleshootingQueueId) myCase.RecordTypeId = troubleshootingRecordType;
    if (oldCaseIDtoCaseMap.get(myCase.id).RecordTypeId != troubleshootingRecordType && newCaseIDtoCaseMap.get(myCase.id).RecordTypeId == troubleshootingRecordType){
      myCase.Involved__c = getAllInvolvedTeamsPicklistValue();
    }
  }
}

// for After Insert
public void afterNewTroubleshootingCase(List<Case> myCases){
  List<Case_Process_Team__c> newCaseProcessTeamsToInsert = new List<Case_Process_Team__c>();
  for (Case myCase : myCases){
    if (myCase.RecordTypeId == troubleshootingRecordType){
      for (Process_Team__c myProcessTeam : processTeams){
        Case_Process_Team__c caseProcessTeamToAdd = new Case_Process_Team__c(Case__c = myCase.Id, Process_Team__c = myProcessTeam.Id);
        newCaseProcessTeamsToInsert.add(caseProcessTeamToAdd);
      }       
    } 
  }
  insert newCaseProcessTeamsToInsert;
}

// for After Update
public void afterUpdateTroubleshootingCase(Map<Id, Case> newCaseIDtoCaseMap, Map<Id, Case> oldCaseIDtoCaseMap){
  Map<Id, Integer> caseCaseProcessTeamCount = new Map<Id, Integer>();
  List<Case_Process_Team__c> newCaseProcessTeams = new List<Case_Process_Team__c>();
  
  for (AggregateResult ar : 
      [SELECT Case__c
              ,count(id) total 
       FROM Case_Process_Team__c 
       WHERE Case__c IN : newCaseIDtoCaseMap.keyset() 
       GROUP BY Case__c]){
    Id i = (Id) ar.get('Case__c');
    Integer tot = (Integer) ar.get('total');
    caseCaseProcessTeamCount.put(i, tot);
  }
    
  for (Case myCase : newCaseIDtoCaseMap.values()){
      if (!caseCaseProcessTeamCount.containsKey(myCase.Id)){
        if (myCase.RecordTypeId == troubleshootingRecordType){
          for (Process_Team__c myProcessTeam : processTeams){
            Case_Process_Team__c caseProcessTeamToAdd = new Case_Process_Team__c(Case__c = myCase.Id, Process_Team__c = myProcessTeam.Id);
            newCaseProcessTeams.add(caseProcessTeamToAdd);
            caseCaseProcessTeamCount.put(myCase.Id, 1);
          }
        }
      }   
  } 
  insert newCaseProcessTeams;
}
/**

PRIVATE METHODS



TODO

Private to scope down to troubleshooting cases
**/

// Can I reuse some methods in your Utilities Class to get this Queue && Record Type??
private Id troubleshootingRecordType = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName ='Troubleshooting' 
                                        AND sObjectType = 'Case' LIMIT 1].Id;
                                        
private Id troubleshootingQueueId = [SELECT Id
                                            ,Name
                                            ,(SELECT Id
                                                     ,SobjectType 
                                              FROM QueueSobjects 
                                              WHERE SobjectType = 'Case') 
                                      FROM Group 
                                      WHERE Type = 'Queue' 
                                      AND Name = 'Troubleshooting Transport Queue' LIMIT 1].Id;

// List of all of the Checkoff Teams. Currently 11 Teams.
private List<Process_Team__c> processTeams = [SELECT Id 
                                              FROM Process_Team__c];

// build all all possible values of Involved__c into a semicolon seperated string
private String getAllInvolvedTeamsPicklistValue(){
  String involvedTeams = '';
  Schema.DescribeFieldResult fieldResult = Case.Involved__c.getDescribe();
  List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
  for (Schema.PicklistEntry picklistEntry : picklistEntries){
    involvedTeams = involvedTeams + picklistEntry.getValue() + ';';
  }
  return involvedTeams;
}
}
public with sharing class CaseProcessTeamClass {
  
  // for Before Insert. 
  //Simply Make sure that all junctions state that it's not ready to close
  public void beforeInsertCaseProcessTeam(List<Case_Process_Team__c> myCaseProcessTeams){
    for (Case_Process_Team__c myCaseProcessTeam : myCaseProcessTeams){
      // TODO - CHANGE FIELD NAME   
      myCaseProcessTeam.Ready_to_Close__c = 'No';
    }
  }
  
  // for After Update
  // Update the Status to be either Open or Closed
  // Sync the InvolvedTeams Picklist on the Case object, so that views can be configured.
  public void afterUpdateCaseProcessTeam(Map<Id, Case_Process_Team__c> newIdToCaseProcessTeamMap, Map<Id, Case_Process_Team__c> oldIdToCaseProcessTeamMap){
    buildAllMaps(newIdToCaseProcessTeamMap);
    updateCaseStatusAndInvolvedTeams(newIdToCaseProcessTeamMap, oldIdToCaseProcessTeamMap);
  }
  
  /**
  PRIVATE METHODS
  **/
  
  private Map<Id, Case> caseIDtoCase = new Map<Id, Case>();
  private Map<Id, String> CaseProcessTeamIDtoTeamNameMap = new Map<Id, String>();
  private Map<Id, Integer> caseStatusCount = new Map<Id, Integer>();
  private Map<String, Id> queueNametoID = new Map<String, Id>();
  
  private void buildAllMaps(Map<Id, Case_Process_Team__c> newIdToCaseProcessTeamMap){
    Set<Id> CaseIDs = getCaseIDs(newIdToCaseProcessTeamMap.values());
    buildCaseIDtoCaseMap(CaseIDs);
    buildCaseProcessTeamIDtoTeamNameMap(newIdToCaseProcessTeamMap.keySet());
    buildCaseStatusCountMap(CaseIDs);
    buildQueueNameToIdMap();
  }
  
  private Set<Id> getCaseIDs(List<Case_Process_Team__c> myCaseProcessTeams){
    Set<Id>CaseIDs = new Set<Id>();
    for (Case_Process_Team__c myCaseProcessTeam : myCaseProcessTeams){
      CaseIDs.add(myCaseProcessTeam.Case__c);
    }
    return CaseIDs;
  }
  
  private void buildCaseIDtoCaseMap(Set<Id> CaseIDs){
    List<Case> affectedCases = [SELECT Id
                                       ,Involved__c
                                       ,OwnerId
                                       ,Status 
                                FROM Case 
                                WHERE Id IN :CaseIDs];
    for (Case myCase : affectedCases){
      caseIDtoCase.put(myCase.Id, myCase);
    }
  }
  
  private void buildCaseProcessTeamIDtoTeamNameMap(Set<Id> cjIDs){
    for (Case_Process_Team__c myCaseProcessTeam :
																						        [SELECT Id
																						                ,Process_Team__r.Name 
																						         FROM Case_Process_Team__c 
																						         WHERE ID IN : cjIDs]){
      CaseProcessTeamIDtoTeamNameMap.put(myCaseProcessTeam.Id, myCaseProcessTeam.Process_Team__r.Name);   
    }
  }
  
  //Iterate thru Junction, build a set of CaseIDs that are ready to close.
  // One less query
  private void buildCaseStatusCountMap(Set<Id> CaseIDs){  
    for (AggregateResult ar : 
												        [SELECT Case__c
												                ,count(id) total 
												         FROM Case_Process_Team__c 
												         WHERE Case__c IN : CaseIDs 
												         AND Ready_to_Close__c != 'Yes' 
												         Group By Case__c]){
      Id i = (Id) ar.get('Case__c');
      Integer tot = (Integer) ar.get('total');
      CaseStatusCount.put(i, tot);
    }
  }
  //In order for this to work, Queue Name == Case_Checkoff__c.Name == Picklist Value 
  private void buildQueueNameToIdMap(){
    List<Group> myQueues = [SELECT Name
                                   ,(SELECT Id
                                            ,SobjectType 
                                      FROM QueueSobjects 
                                      WHERE SobjectType = 'Case') 
                              FROM Group 
                              WHERE type = 'Queue'];
    for (Group myQueue : myQueues){
      queueNametoID.put(myQueue.Name, myQueue.Id);
    }
  }
  
  private void updateCaseStatusAndInvolvedTeams (Map<Id, Case_Process_Team__c> newIdToCaseProcessTeamMap, Map<Id, Case_Process_Team__c> oldIdToCaseProcessTeamMap){
    Map<Id, Case> casesToUpdateMap = new Map<Id, Case>();
    
    for (Case_Process_Team__c myCaseProcessTeam : newIdToCaseProcessTeamMap.values()){
      Case myCase;
      if (casesToUpdateMap.containsKey(myCaseProcessTeam.Case__c)){
        myCase = casesToUpdateMap.get(myCaseProcessTeam.Case__c);
      }
      else{
        myCase = caseIDtoCase.get(myCaseProcessTeam.Case__c);
      }
      String caseProcessTeamName = CaseProcessTeamIDtoTeamNameMap.get(myCaseProcessTeam.Id);
      if (myCase.Involved__c == null) myCase.Involved__c = '';
      if (!caseStatusCount.containsKey(myCaseProcessTeam.Case__c)){
        if (myCase.OwnerId == queueNametoID.get('Troubleshooting Transport Queue')){
          // do whatever they want to do for when no team accepts ownership
        }
        else{
          myCase.Status = 'Closed';
        }
      }
      //changed to involved
      if (myCaseProcessTeam.Involved__c != 'Owner'){
        if (oldIdToCaseProcessTeamMap.get(myCaseProcessTeam.Id).Involved__c == 'Owner' && myCase.OwnerId == queueNametoID.get(caseProcessTeamName)){
          myCase.OwnerId = queueNametoID.get('Troubleshooting Transport Queue');
        }    
      }
      if (myCaseProcessTeam.Involved__c == 'No'){
        if (caseProcessTeamName != NULL && myCase.Involved__c.contains(caseProcessTeamName)){
          myCase.Involved__c = myCase.Involved__c.replace(caseProcessTeamName, '');        
        }
        // if the Case has one team that says it isn't okay to close, change the status to open...but only if the status is already New or Closed.
        // ie if the status is "Reply: Customer Email" do NOT change the status to open.
        if (caseStatusCount.containsKey(myCaseProcessTeam.Case__c) && (myCase.Status == 'New' || myCase.Status == 'Closed')){
          myCase.Status = 'Open';
        }
      }
      if (myCaseProcessTeam.Involved__c == 'Yes (Not Owner)' || myCaseProcessTeam.Involved__c == 'Unknown' || myCaseProcessTeam.Involved__c == 'Owner'){
        if (caseStatusCount.containsKey(myCaseProcessTeam.Case__c) && (myCase.Status == 'New' || myCase.Status == 'Closed')){
          myCase.Status = 'Open';
        }
        if (caseProcessTeamName != NULL && !myCase.Involved__c.contains(caseProcessTeamName)){
          myCase.Involved__c = myCase.Involved__c + ';' + caseProcessTeamName;
        }
      }
      // Built in logic here incase the owner is transferred to a queue, and then transferred to an individual user, it wont be transferred back to the queue if checkoff junction is updated
      Set<Id> queueIDs = new Set<Id>();
      queueIDs.addAll(queueNametoID.values());
      if (myCaseProcessTeam.Involved__c == 'Owner' && queueIDs.contains(myCase.OwnerId)){
        myCase.OwnerId = queueNametoID.get(caseProcessTeamName);
      }
      casesToUpdateMap.put(myCaseProcessTeam.Case__c, myCase);
    }
    update casesToUpdateMap.values();
  }
}
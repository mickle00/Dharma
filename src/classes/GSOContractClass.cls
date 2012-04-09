public with sharing class GSOContractClass {
  
  public Map<String,RecordType> recordTypesMap = Utilities.getRecordTypesMap('Case', true);
  public Map<String,Id> queueNameToIdMap = Utilities.getQueueNameToIdMap('Case');
  
  public List<GSOContract__c> FindAllById(Set<Id> gsoContractIds) {
    
    List<GSOContract__c> gsoContracts = [SELECT GSOContract__c.Id
                                               ,GSOContract__c.GSO_Contract_Submission__c
                                               ,GSOContract__c.Account__c
                                               ,GSOContract__c.Contact__c
                                               ,GSOContract__c.Date_EPC_Completed__c
                                               ,GSOContract__c.Date_Sent_to_EPC__c
                                               ,GSOContract__c.Date_Abandoned__c
                                               ,GSOContract__c.Cases_Closed__c
                                               ,GSOContract__c.Cases_Needed_for_Closure__c
                                           FROM GSOContract__c
                                          WHERE Id IN :gsoContractIds];
                                          
    return gsoContracts;
  }
    
  
  public void UpdatePhase(List<GSOContract__c> contracts,Map<Id,GSOContract__c> oldMap) {
    
    for(GSOContract__c thisContract : contracts) {
      if((thisContract.Date_EPC_Completed__c != null && oldMap.get(thisContract.Id).Date_EPC_Completed__c == null) ||
         (thisContract.Offline_Contract__c == true)) {
        
        thisContract.Phase__c = 'Conversion';
        thisContract.Sub_Phase__c = null;
      }
        
      if(thisContract.Date_Commercial_Terms_First_Viewed__c != null 
         && oldMap.get(thisContract.Id).Date_Commercial_Terms_First_Viewed__c == null 
         && thisContract.Phase__c == 'Contracting'){
          
        thisContract.Sub_Phase__c = 'Accessed Commercial Terms';
      }
      
      if(thisContract.Date_Payment_Information_First_Viewed__c != null 
         && oldMap.get(thisContract.Id).Date_Payment_Information_First_Viewed__c == null 
         && thisContract.Phase__c == 'Contracting') {
          
        thisContract.Sub_Phase__c = 'Accessed Payment Information';
      }
        
      if(thisContract.Date_Legal_Terms_First_Viewed__c != null 
         && oldMap.get(thisContract.Id).Date_Legal_Terms_First_Viewed__c == null 
         &&thisContract.Phase__c == 'Contracting') {
          
        thisContract.Sub_Phase__c = 'Accessed Legal Terms';
      }
    }
  }
  
  public void CompleteContract(List<GSOContract__c> contracts) {
    
    Set<String> casesToClose = new Set<String>();
    Set<String> casesClosed = new Set<String>();
        
    for(GSOContract__c thisContract : contracts) {
      casesToClose = Utilities.SetFromMultiSelectPicklist(thisContract.Cases_Needed_for_Closure__c);    
      casesClosed = Utilities.SetFromMultiSelectPicklist(thisContract.Cases_Closed__c);
      
      System.debug('Needed for closure=' + thisContract.Cases_Needed_for_Closure__c);
      System.debug('Closed=' + thisContract.Cases_Closed__c);
      System.debug('Needed Set=' + casesToClose);
      System.debug('Closed Set=' + casesClosed);
      //System.debug('Set compare =' + casesClosed.containsAll(casesToClose));
      if(casesToClose != null && casesClosed != null) {
        System.debug('AM I HERE?');
      if(casesClosed.containsAll(casesToClose) == true) {
            System.debug('WHY AM I HERE?');
        thisContract.Status__c = 'Completed';
        thisContract.Date_Contract_Completed__c = datetime.now();
      }
    }
      // set status to abandoned if the date abandoned is not null
      if(thisContract.Date_Abandoned__c != null) {
        thisContract.Status__c = 'Abandoned';
      }
    
  } 
  } 
  
  
  public void ORTPostProcessing(List<GSOContract__c> contracts, Map<Id,GSOContract__c> oldMap) {
    List<Case> casesToInsert = new List<Case>();
    List<Account> accounts = new List<Account>();
    List<Case> newCases = new List<Case>();
    List<GSOContract__c> contractsToProcess = new List<GSOContract__c>(); 
    List<GSOContract__c> EVCContractsToProcess = new List<GSOContract__c>();
    List<GSOContract__c> trainingContracts = new List<GSOContract__c>();
    Set<Id> contractAccountIds = new Set<Id>();
    List<Connection__c> connections = new List<Connection__c>();
    List<GSOContract__c> connectivityContracts = new List<GSOContract__c>();
    Map<Id,GSOContract__c> accountToGSOContractMap = new Map<Id,GSOContract__c>();
    Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
    String teamCasesRequired;    
    for (GSOContract__c thisContract : contracts){
      if (thisContract.Date_EPC_Completed__c != null && oldMap.get(thisContract.Id).Date_EPC_Completed__c == null ||
          thisContract.Offline_Contract__c == true && thisContract.Cases_Needed_For_Closure__c == null) {
        
        contractAccountIds.add(thisContract.Account__c);
        contractsToProcess.add(thisContract);
        accountToGSOContractMap.put(thisContract.Account__c,thisContract);
        
        //if EVC then add to 
        if (thisContract.Setup_on_EVC__c == true) {
          EVCContractsToProcess.add(thisContract);
        }   
        
        //if vendor trained then add
        if (thisContract.Supplier_Training_by_Market_Manager__c == false) {
            trainingContracts.add(thisContract);
        }
      }
    }
    
    if(contractAccountIds.Size() > 0) {
      connections = ConnectionClass.ConnectionsByAccounts(contractAccountIds);
      AccountClass objAccount = new AccountClass();
      accounts = objAccount.FindAllById(contractAccountIds);
      
      for (Account thisAccount : accounts) {
        accountIdToAccountMap.put(thisAccount.Id,thisAccount);  
      }
      
      //for(Connection__c connection : connections) {
        //build out some cases
      //  if(connection.Status__c == 'Connected' && connection.Platform__c == 'EQC') {
      //    connectivityContracts.add(accountToGSOContractMap.get(connection.Account__c));
      //  }
      //}
        }
    
    //if(connectivityContracts.Size() > 0) {
    //  newCases = this.ORTConnectivityCases(connectivityContracts);
    //  for(Case thisCase : newCases) {
    //    casesToInsert.add(thisCase);
    //  } 
    //}
    
    if(contractsToProcess.Size() > 0) {
      //Set up contract loading cases to create
      newCases = this.ORTContractLoadingCases(contractsToProcess, accountIdToAccountMap);
      for(Case thisCase : newCases) {
        casesToInsert.add(thisCase);
      } 
    } 
    
    if(EVCContractsToProcess.Size() > 0) {
      newCases = this.ORTEVCCases(EVCContractsToProcess);
      for(Case thisCase : newCases) {
        casesToInsert.add(thisCase);
      } 
    } 
    
    if(trainingContracts.Size() > 0) {
        newCases = this.ORTTrainingCases(trainingContracts);
        for(Case thisCase : newCases) {
            casesToInsert.add(thisCase);
        }
    }
    
    //for(GSOContract__c thisContract : connectivityContracts) {
    //  teamCasesRequired = Utilities.AddToMultiSelectPicklist(teamCasesRequired, 'Hotel_Systems_Technical_Support');
    //  thisContract.Cases_Needed_for_Closure__c = teamCasesRequired;
    //}
    
    // figure out what cases will be needed to set the contract as complete    
    this.CasesRequiredForClosure(contractsToProcess, 'Contract_Loading');
    this.CasesRequiredForClosure(trainingContracts, 'Training');
    
    insert casesToInsert;
  }
  
  //THIS IS FOR PHASE 1 WHEN CONNECTIVITY IS READY //
  /*
  public list<Case> ORTConnectivityCases(List<GSOContract__c> contracts) {
    
    List<Case> newCases = new List<Case>();
    
    for(GSOContract__c thisContract : contracts) {
      
      Case newCase = new Case();
      
      newCase.Team__c = 'HSTS';
      newCase.RecordTypeId = recordTypesMap.get('Hotel_Systems_Technical_Support').Id;
      
      // ORT is not capturing email address and is capturing name in one field.  Doing a match is not 
      // possible until they capture more data.  PILOT.
      //newCase.ContactId = thisContract.Contact__c;
      
      newCase.Description = 'Hotel has requested to be turned onto EVC\n\n' +
                            'Contract Signer:  ' + thisContract.Contract_Signer__c + '\n' +
                            'Contract Signer Title:  ' + thisContract.Contract_Signer_Title__c + '\n';
      newCase.GSO_Contract__c = thisContract.Id;
      newCase.Language__c = thisContract.Preferred_Language__c; // Bart can get id using Databasedotcom gem  
      newCase.Reason = 'EQC: Connectivity';
      newCase.Subject = 'EQC: Connectivity';
      
      newCases.add(newCase);
    }
    return newCases;
  }
  */
  public List<Case> ORTEVCCases(List<GSOContract__c> contracts) {
    List<Case> newCases = new List<Case>();
    
    for (GSOContract__c thisContract : contracts) {
      Case newCase = new Case();
      
      newCase.Team__c = 'FinOps EVC Support';
      newCase.Origin = 'ORT';
      newCase.AccountId = thisContract.Account__c;
      newCase.RecordTypeId = recordTypesMap.get('Financial_Operations').Id;
      
      // ORT is not capturing email address and is capturing name in one field.  Doing a match is not 
      // possible until they capture more data.  PILOT.
      newCase.ContactId = thisContract.Contact__c;
      
      newCase.No_of_Bookings__c = 0;
      newCase.Language__c = thisContract.Preferred_Language__c; // Bart can get id using Databasedotcom gem  
      newCase.Reason = 'EVC: Add/Remove from EVC';
      newCase.Operational_Unit__c = 'FinOps';
      newCase.Subject = 'EVC: Add hotel to EVC';
      // List of items from narrative 2.0 
      newCase.Description = 'Hotel has requested to be turned onto EVC\n\n' +
                            'Contract Signer:  ' + thisContract.Contract_Signer__c + '\n' +
                            'Contract Signer Title:  ' + thisContract.Contract_Signer_Title__c + '\n\n' +
                            'Payment Currency:  ' + thisContract.Payment_Currency__c;
      newCase.GSO_Contract__c = thisContract.Id;
      newCases.add(newCase);
    }
    return newCases;
  }
  
  public List<Case> ORTTrainingCases(List<GSOContract__c> contracts) {
    List<Case> newCases = new List<Case>();
    
    for (GSOContract__c thisContract : contracts) {
        Case newCase = new Case();
        
        newCase.Language__c = thisContract.Preferred_Language__c;
        newCase.Origin = 'ORT';
      newCase.AccountId = thisContract.Account__c;
      newCase.ContactId = thisContract.Contact__c;
      newCase.RecordTypeId = recordTypesMap.get('Training').Id;
      newCase.OwnerId = queueNameToIdMap.get('ETP Training');
        newCase.GSO_Contract__c = thisContract.Id;
        newCase.Subject = 'ETP: Training';
        newCase.Description = 'ETP: Training';
        
      newCases.add(newCase);
      
    }
    return newCases;
  }
  
  public List<Case> ORTContractLoadingCases(List<GSOContract__c> contracts, Map<Id,Account> accountIdToAccountMap) {
    List<Case> newCases = new List<Case>();
    
    for (GSOContract__c thisContract : contracts) {
        
        Boolean ARIEnabled = accountIdToAccountMap.get(thisContract.Account__c).ARI_Enabled__c;
        
      Case newCase = new Case();
      newCase.Team__c = 'Contract Loading';
      newCase.Origin = 'ORT';
      newCase.AccountId = thisContract.Account__c;
      newCase.RecordTypeId = recordTypesMap.get('Contract_Loading').Id;
      newCase.OwnerId = queueNameToIdMap.get('Contract Loading');
      newCase.Type = 'ETP Conversion';
      newCase.Language__c = thisContract.Preferred_Language__c;
      
      // ORT is not capturing email address and is capturing name in one field.  Doing a match is not 
      // possible until they capture more data.  PILOT.
      newCase.ContactId = thisContract.Contact__c;
      newCase.Language__c = thisContract.Preferred_Language__c; // Bart can get id using Databasedotcom gem  
      newCase.Reason = 'ETP: Create New Rates';
      String offline = thisContract.Offline_Contract__c == True ? ' [Offline Contract]' : '';
      newCase.Subject = 'ETP: Create New Rates' + offline;
      newCase.GSO_Contract__c = thisContract.Id;
      newCase.Description = 'Contract Signer:  ' + thisContract.Contract_Signer__c + '\n' +
                            'Contract Signer Title:  ' + thisContract.Contract_Signer_Title__c + '\n\n';
                              
                            //'Booking Notification Method:  ' + accountIdToAccountMap.get(thisContract.Account__c).Booking_Delivery_Method__c + '\n' +
                            //'ARI Enabled:  ' + ARIEnabled;
                             
      newCases.add(newCase);
      
    }
    return newCases;
  }

  public static List<GSOContract__c> findBySubmissionId(Id submissionId) {
    String myFields = '*, Contact__r.Name, Contact__r.Title, Contact__r.Email, Approved_By__r.Name, Account__r.Name, Account__r.Expedia_Hotel_Id__c';
        
    // build where clause
    List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    conditions.add(new SoqlBuilder.Condition('GSO_Contract_Submission__c', submissionId));
        
    return findBy(myFields, conditions, null, null);
  }

  public static List<GSOContract__c> findActiveContractsByAccount(Set<Id> accountIds) {
    return [Select Id From GSOContract__c Where Account__c IN : accountIds and Status__c = 'Active'];
  }

  public static List<GSOContract__c> getActiveContractsByMM(Id psgUser) {
    String myFields = '*, Account__r.Expedia_Hotel_Id__c, Account__r.Name';

    // build where clause
    List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    conditions.add(new SoqlBuilder.Condition('GSO_Contract_Submission__r.PSG_User__c', psgUser));
    conditions.add(new SoqlBuilder.Condition('Status__c', 'Active'));

    List<GSOContract__c> submissions = findBy(myFields, conditions, null, 'CreatedDate');

    return submissions;
  }
    
  public static GSOContract__c findById(Id contractId) {
    String myFields = '*, Contact__r.Name, Contact__r.Title, Contact__r.Email, Approved_By__r.Name, Account__r.Name, Account__r.Expedia_Hotel_Id__c';
        
    // build where clause
    List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    conditions.add(new SoqlBuilder.Condition('Id', contractId));
        
    // return the first result
    for(GSOContract__c contract : findBy(myFields, conditions, null, null)) {
      return contract;
    }
        
    return null;
  }

  //// Private methdos
    
  private static List<GSOContract__c> findBy(String myFields, List<SoqlBuilder.Condition> conditions, String conditionLogic, String orderBy) {
    return SoqlBuilder.ExecuteSelectQuery(myFields, 'GSOContract__c', conditions, conditionLogic, orderBy);
  }
    
  private void CasesRequiredForClosure(List<GSOContract__c> contracts, String caseType) {
    for(GSOContract__c thisContract : contracts) {
      thisContract.Cases_Needed_for_Closure__c = Utilities.AddToMultiSelectPicklist(thisContract.Cases_Needed_for_Closure__c, caseType);
    }
  }
}
public with sharing class GuestClass {
    // Before Insert on Guest
    public void insertFallbacks(List<Guest__c> myGuests){
        GroupMemberLanguageClass groupMemberObj = new GroupMemberLanguageClass('Fallback');
        Set<String> expediaIDs = this.getRelatedExpediaHotelIDs(myGuests);
        List<Account> relatedAccounts = this.getRelatedAccounts(expediaIDs);
        Map<String, Account> expediaIdAccountMap = this.getExpediaIdToAccountMap(relatedAccounts);
        List<Case> newCases = new List<Case>();
        List<Guest__c> guestsWithoutCase = new List<Guest__c>();
        
        for (Guest__c myGuest : myGuests){
            String guestLanguage;
            List<User> languageUsers = new List<User>();
            if (myGuest.RecordTypeId == this.getGuestRecordTypeMap().get('Fallback').Id 
             && myGuest.Original_Hotel_Expedia_ID__c != null
             && myGuest.Case__c == null){
                if (this.getExpediaIdToCaseMap().containsKey(myGuest.Original_Hotel_Expedia_ID__c)){
                    myGuest.Case__c = this.getExpediaIdToCaseMap().get(myGuest.Original_Hotel_Expedia_ID__c).Id;
                } else{
                    //guestLanguage = expediaIdAccountMap.get(myGuest.Original_Hotel_Expedia_ID__c).PSG_Language__c;
                    //languageUsers = groupMemberObj.getLanguageToUsersMap().get(guestLanguage);
                    if (expediaIDAccountMap.containsKey(myGuest.Original_Hotel_Expedia_ID__c)){
                        Case myCase = this.createFallBackCase(expediaIdAccountMap.get(myGuest.Original_Hotel_Expedia_ID__c).Id
                                                             ,NULL);
                        this.getExpediaIdToCaseMap().put(myGuest.Original_Hotel_Expedia_ID__c, myCase);
                        newCases.add(myCase);
                        guestsWithoutCase.add(myGuest);
                    }
                }
            }
        } insert newCases;
        for (Guest__c myGuest : myGuests){
            String guestLanguage;
            List<User> languageUsers = new List<User>();
            if (myGuest.RecordTypeId == this.getGuestRecordTypeMap().get('Fallback').Id 
             && myGuest.Original_Hotel_Expedia_ID__c != null
             && myGuest.Case__c == null){
                if (this.getExpediaIdToCaseMap().containsKey(myGuest.Original_Hotel_Expedia_ID__c)){
                    myGuest.Case__c = this.getExpediaIdToCaseMap().get(myGuest.Original_Hotel_Expedia_ID__c).Id;
                }
            }
        }
    }
    
    public void createRelocationsFromFallBacks(List<Guest__c> fallBackGuests){
    	List<Guest__c> affectedGuests = new List<Guest__c>();
    	Map<String, Case> expediaIdToNewCaseMap = new Map<String, Case>();
        Map<String, Id> expediaIdToOldCaseMap = new Map<String, Id>();
    	for (Guest__c myGuest : fallbackGuests){
            if (myGuest.RecordTypeId == this.getGuestRecordTypeMap().get('Fallback').Id 
             && myGuest.Status__c == 'Transferred to Relocations'
             && myGuest.Relocated_Fallback_Guest__c == null){
             	affectedGuests.add(myGuest);
             	expediaIdToNewCaseMap.put(myGuest.Original_Hotel_Expedia_ID__c, null);
             	expediaIdToOldCaseMap.put(myGuest.Original_Hotel_Expedia_ID__c, myGuest.Case__c);
             }
    	}
    	expediaIdToNewCaseMap = this.createRelocationCases(expediaIdToNewCaseMap, expediaIdToOldCaseMap);
    	List<Guest__c> newRelocationGuests = new List<Guest__c>();
    	Map<Guest__c, Guest__c> fallBackToRelocationGuestMap = new Map<Guest__c, Guest__c>();
    	for (Guest__c myGuest : affectedGuests){
    		Guest__c relocationGuest = new Guest__c();
    		relocationGuest = myGuest.clone();
    		fallBackToRelocationGuestMap.put(myGuest, relocationGuest);
    		relocationGuest.Unique_Key__c = null;
    		relocationGuest.Closed_By__c = null;
    		relocationGuest.Closed__c = false;
    		relocationGuest.RecordTypeId = this.getGuestRecordTypeMap().get('Client_Services_Relocations').Id;
    		relocationGuest.Case__c = expediaIdToNewCaseMap.get(relocationGuest.Original_Hotel_Expedia_Id__c).Id;
    		relocationGuest.Status__c = 'Transferred from Fallback';
    		newRelocationGuests.add(relocationGuest);   		
    	}
    	insert newRelocationGuests;
    	for (Guest__c myGuest : affectedGuests){
    		myGuest.Relocated_Fallback_Guest__c = fallBackToRelocationGuestMap.get(myGuest).Id;
    	}
    }
    
    public Map<String, Case> createRelocationCases (Map<String, Case> expediaIdToNewCaseMap, Map<String, Id> expediaIdToOldCaseMap){
    	Map<String, Id> expediaIdtoAccountIdMap = new Map<String, Id>();
    	
    	for (Account myAccount : [SELECT Id, Expedia_Hotel_Id__c FROM Account WHERE Expedia_Hotel_Id__c IN : expediaIdToNewCaseMap.keySet()]){
    		expediaIdtoAccountIdMap.put(myAccount.Expedia_Hotel_Id__c, myAccount.Id);
    	}
    	for (String expediaID : expediaIdToNewCaseMap.keySet()){
    		Id parentCaseId = expediaIdToOldCaseMap.get(expediaID);
    		expediaIdToNewCaseMap.put(expediaID, this.createRelocationCase(expediaIdtoAccountIdMap.get(expediaID), parentCaseId));
    	}
    	insert expediaIdToNewCaseMap.values();
    	return expediaIdToNewCaseMap;
    }

    private Case createRelocationCase(Id accountId, Id parentCaseId){
    	RecordType relocationsRecordType = this.getCaseRecordTypeMap().get('Lodging_Operations_HPS');
    	Case myCase = new Case(RecordTypeId = relocationsRecordType.Id
    	                      ,AccountId = accountId
    	                      ,Status = 'New - Transferred'
    	                      ,Origin = 'Fallback'
    	                      ,Subject = 'Relocate Fallback Guest'
    	                      ,ParentId = parentCaseId);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        myCase.setOptions(dmo);
    	return myCase;
    }
    private List<Account> relatedAccounts;
    private Set<String> relatedExpediaHotelIDs;
    private Map<String, RecordType> guestRecordTypeMap;
    private Map<Id, Integer> ownerIdtoNumberOfFallbackMap;
    private Map<String, Account> expediaIdToAccountMap;
    private Map<String, Case> expediaIdToCaseMap;
    private List<Case> relatedCases;
    private Map<String, RecordType> caseRecordTypeMap;
    
    private Case createFallBackCase(Id accountId, List<User> possibleUsers){
        Case myCase = new Case (AccountId = accountId
                                 ,Subject = 'Fallback Case'
                            ,RecordTypeId = this.getCaseRecordTypeMap().get('Lodging_Operations_Fallback').Id
                            //TODO: FIX
                            ,OwnerId = '00Gc0000000EQS1'
                            ,Origin = 'Lodging Booking Master');
        if (possibleUsers != null){
            if (possibleUsers.size() == 1){
               myCase.OwnerId = possibleUsers[0].Id;
            } else{
                //FIGURE OUT WHICH USER TO SELECTASAURUSREX
                //TODO: FIX HARDCODE
                myCase.OwnerId = '00Gc0000000EQS1'; //fallbackQueue
            }
        }
        return myCase;
    }
    
    private Map<String, RecordType> getCaseRecordTypeMap(){
        if (this.caseRecordTypeMap == null){
            this.caseRecordTypeMap = new Map<String, RecordType>();
            this.caseRecordTypeMap = Utilities.getRecordTypesMap('Case', true);
        }
        return this.caseRecordTypeMap;
    }
    
    private List<Case> getRelatedCases(){
        if (this.relatedCases == null){
            this.relatedCases = [SELECT  Id
                                        ,OwnerId
                                        ,Account.Expedia_Hotel_Id__c
                                   FROM  Case
                                  WHERE  RecordTypeId = :this.getCaseRecordTypeMap().get('Lodging_Operations_Fallback').Id
                                    AND  Account.Expedia_Hotel_Id__c IN :this.getRelatedExpediaHotelIDs()];
                                   
        }
        return this.relatedCases;
    }
    
    private Map<String, Case> getExpediaIdToCaseMap(){
        if (this.expediaIdToCaseMap == null){
            this.expediaIdToCaseMap = new Map<String, Case>();
            for (Case myCase : this.getRelatedCases()){
                this.expediaIdToCaseMap.put(myCase.Account.Expedia_Hotel_Id__c, myCase);
            }
        }
        return this.expediaIdToCaseMap;
    }
    
    private Map<Id, Integer> getOwnerIdtoNumberOfFallbackMap(){
        if (this.ownerIdtoNumberOfFallbackMap == null){
            this.ownerIdtoNumberOfFallbackMap = new Map<Id, Integer>();
            for (AggregateResult ar : [SELECT Case__r.OwnerId
                                             ,Count(Id) NumberOfGuests 
                                         FROM Guest__c 
                                        WHERE RecordTypeId = :this.getGuestRecordTypeMap().get('Fallback').Id
                                          AND Status__c != 'Completed'
                                     GROUP BY Case__r.OwnerId]){
                this.ownerIdtoNumberOfFallbackMap.put((Id) ar.get('OwnerId'), (integer) ar.get('NumberOfGuests'));
            }
        }
        return this.ownerIdtoNumberOfFallbackMap;
    }
    
    private Map<String, RecordType> getGuestRecordTypeMap(){
        if (this.guestRecordTypeMap == null){
            this.guestRecordTypeMap = new Map<String, RecordType>();
            this.guestRecordTypeMap = Utilities.getRecordTypesMap('Guest__c', true);
        }
        return this.guestRecordTypeMap;
    }
    
    private List<Account> getRelatedAccounts (Set<String> expediaIDs){
        if (this.relatedAccounts == null){
            this.relatedAccounts = new List<Account>();
            this.relatedAccounts = [SELECT Id
                                           ,Name
                                           ,Expedia_Hotel_Id__c
                                           ,PSG_Language__c
                                      FROM Account
                                     WHERE Expedia_Hotel_Id__c IN :expediaIDs];
        }
        return this.relatedAccounts;
    }
    
    private Map<String, Account> getExpediaIdToAccountMap(List<Account> myAccounts){
        if (this.expediaIdToAccountMap == null){
            this.expediaIdToAccountMap = new Map<String,Account>();
            for (Account myAccount : myAccounts){
                this.expediaIdToAccountMap.put(myAccount.Expedia_Hotel_Id__c, myAccount);
            }
        } return this.expediaIdToAccountMap;
    }
    
    private Set<String> getRelatedExpediaHotelIDs (List<Guest__c> myGuests){
        if (this.relatedExpediaHotelIDs == null){
            this.relatedExpediaHotelIDs = new Set<String>();
            for (Guest__c myGuest : myGuests){
                this.relatedExpediaHotelIDs.add(myGuest.Original_Hotel_Expedia_ID__c);
            }
        }
       return this.relatedExpediaHotelIDs;
    }
    private Set<String> getRelatedExpediaHotelIDs(){
        if (this.relatedExpediaHotelIDs == null){
            return new Set<String>();
        }
        return this.relatedExpediaHotelIDs;
    }
}
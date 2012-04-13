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
					guestLanguage = expediaIdAccountMap.get(myGuest.Original_Hotel_Expedia_ID__c).PSG_Language__c;
					languageUsers = groupMemberObj.getLanguageToUsersMap().get(guestLanguage);
					Case myCase = this.createFallBackCase(expediaIdAccountMap.get(myGuest.Original_Hotel_Expedia_ID__c).Id
					                                     ,languageUsers);
                    this.getExpediaIdToCaseMap().put(myGuest.Original_Hotel_Expedia_ID__c, myCase);
                    newCases.add(myCase);
                    guestsWithoutCase.add(myGuest);
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
	                        ,RecordTypeId = this.getCaseRecordTypeMap().get('Lodging_Operations_Fallback').Id);
        if (possibleUsers != null){
        	if (possibleUsers.size() == 1){
        	   myCase.OwnerId = possibleUsers[0].Id;
        	} else{
        		//FIGURE OUT WHICH USER TO SELECTASAURUSREX
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
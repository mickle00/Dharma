public with sharing class ActionItemClass {
	
	public Map<String, RecordType> actionItemRecordTypeMap = Utilities.getRecordTypesMap('Action_Item__c', true);
	
	public void addActionItemsToCase(List<Action_Item__c> newActionItems){
		List<Action_Item__c> destinationManagementActionItems = getDestinationManagementActionItems(newActionItems, actionItemRecordTypeMap);
		Map<Id, Case> caseMap = this.getActionItemCaseMap(this.getActionItemCaseIDs(destinationManagementActionItems));
		
		for (Action_Item__c myActionItem : destinationManagementActionItems){
			this.addActionItemToCase(myActionItem, caseMap.get(myActionItem.Case__c));
		}
		update caseMap.values();		
	}
	
	private List<Action_Item__c> getDestinationManagementActionItems(List<Action_Item__c> myActionItems, Map<String, RecordType> recordTypeMap){
		RecordType destinationManagementRT = recordTypeMap.get('Destination_Management');
		List<Action_Item__c> destinationManagementActionItems = new List<Action_Item__c>();
		
		for (Action_Item__c myActionItem : myActionItems){
			if (myActionItem.RecordTypeId == destinationManagementRT.Id){
				destinationManagementActionItems.add(myActionItem);
			}
		}
		return destinationManagementActionItems;
	}
	
	private Set<Id> getActionItemCaseIDs (List<Action_Item__c> myActionItems){
		Set<Id> caseIds = new Set<Id>();
		for (Action_Item__c myActionItem : myActionItems){
			if (myActionItem.Case__c != null) caseIds.add(myActionItem.Case__c);
		}
		return caseIds;
	}
	
	private Map<Id, Case> getActionItemCaseMap (Set<Id> caseIds){
		Map<Id,Case> caseMap = new Map<Id, Case>([SELECT Id
														  ,Account.Name
														  ,Account.Expedia_Hotel_Id__c
														  ,Subject
														  ,Description
														  ,Description_Rich_Text__c
														  ,Number_of_Changes__c
												 	  FROM Case
												   	 WHERE Id IN :caseIds]);
	   	 return caseMap;
	}
	
	private void addActionItemToCase (Action_Item__c myActionItem, Case myCase){
		if (myCase.Description == null){
			myCase.Description = buildCaseDescriptionHeader(myActionItem, myCase, false);
			myCase.Description_Rich_Text__c = buildCaseDescriptionHeader(myActionItem, myCase, true);
		}
		myCase.Number_of_Changes__c = myCase.Number_of_Changes__c + 1;
		myCase.Description += buildDescriptionCheckListItem(myActionItem, myCase, false);
		myCase.Description_Rich_Text__c += buildDescriptionCheckListItem(myActionItem, myCase, true);		
	}
	
	private string buildCaseDescriptionHeader(Action_Item__c myActionItem, Case myCase, boolean isHTML){
		string newLine = isHTML ? '<br/>' : '\n';
		string myHeader = 'Expedia ID: ' + myCase.Account.Expedia_Hotel_Id__c +
						   newLine + 'Hotel Name: ' + myCase.Account.Name +
						   newLine + 'Link: http://psgdashboard/hotels/contentchecklist/pages/tab4.aspx?expeid='+myCase.Account.Expedia_Hotel_Id__c +
						   newLine;
   		return myHeader;
	}
	
	private string buildDescriptionCheckListItem(Action_Item__c myActionItem, Case myCase, boolean isHTML){
		string newLine = isHTML ? '<br/>' : '\n';
		string lineSeparator = Utilities.repeatString('-', 100);
		/**		
		Checklist Items Begin

		Checklist Question 1290: Map tab: Are the nearby POIs (points of interest) meaningful and relevant on Expedia? If not, which ones should be removed? (Websites to check: E) (Languages: English)
		
		Locale ID 1290: 1033 English
		
		Live Content 1290: Vejle Town Hall - 0.2 km / 0.1 mi <br />Vejle Art Museum - 0.4 km / 0.3 mi <br />Vejle Windmill - 0.7 km / 0.4 mi <br />Vejle Stadium - 1.5 km / 1 mi <br />Jelling Burial Mounds - 9.1 km / 5.6 mi <br />Kongernes Jelling Exhibition Centre - 9.2 km / 5.7 mi <br />Givskud Zoo - 16.1 km / 10 mi <br />
		<br />The preferred airport for Hotel Australia is Billund (BLL) - 24.6 km / 15.3 mi. <p>Distances are calculated in a straight line from the property's location to the point of interest or airport and may not reflect actual travel distance. <br /><br /> Distances are displayed to the nearest 0.1 mile and kilometre. </p>
		
		MM Suggestion 1290: Legoland Park
		"Koldinghus" Castle Ruin
		Trapholt Art Museum
		Comment 1290:		
		**/
		string returnText = newLine + lineSeparator +
							newLine + 'Checklist Question ' + myActionItem.Checklist_Item_ID__c + ': ' +
							newLine + 'Submitted By: ' + myActionItem.Supplied_Email__c +
							newLine + NewLine + 'Locale ID: ' + myActionItem.Locale_ID__c +
							newLine + newLine + 'Live Content: ' + myActionItem.Live_Content__c +
							newLine + newLine + 'MM Suggestion: ' + myActionItem.Content_Suggestion__c;
		return returnText;
	}

}
public with sharing class Utilities {

	public static Map<String,RecordType> getRecordTypesMap(String objectName){
		
		Map<String,RecordType> mapRecordTypes = new Map<String,RecordType>();
		
		List<RecordType> lstRecordTypes = [Select DeveloperName,Id 
		                                     From RecordType
		                                    Where RecordType.SobjectType = :objectName];
		
		for(RecordType recType : lstRecordTypes){
			mapRecordTypes.put(recType.DeveloperName,recType);
		}
		
		return mapRecordTypes;
		
	}
		
	public static String appendToString(String existing, String appendText) {
		
		return existing == null ? appendText : existing + appendText; 
	}
	
	public static String getCaseThreadId(String caseId) {
    return ' [ ref:' + String.valueOf(Userinfo.getOrganizationId()).substring(0,4) + 
		       String.valueOf(Userinfo.getOrganizationId()).substring(11,15) + '.' + 
		       caseId.substring(0,4) + caseId.substring(10,15) + ':ref ]';
	}
	
	public static String generateIntegrationContactKey(String email, String firstName, String lastName){
		// build the integration key in format used by Informatica 
		firstName = firstName == null ? '' : firstName;
		lastName = lastName == null ? 'No supplied Name' : lastName;
		
		return email + ':' + lastName + ':' + firstName;
	}
	public static String truncateField(String myFieldValue, Integer maxLength, String newLine){
		String errorMessage = '***TRUNCATED***';
		if (newLine == '<br/>') errorMessage = '<font color="red">' + errorMessage + '</font>';
		Integer usedCharacters = (newLine + newLine + errorMessage).length();
		return myFieldValue.substring(0,maxLength-usedCharacters) + newLine + newLine + errorMessage;
	}
	
}
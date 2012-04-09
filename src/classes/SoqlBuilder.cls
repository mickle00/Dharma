public class SoqlBuilder {

	public class Condition{
		public String Field {get; set;}
		public String Value {get; set;}
		public String Operator {get; set;}
		
		public Condition(String field, String value) {
			buildCondition(field, value, '=');
		}
		
		public Condition(String field, String value, String operator){
			buildCondition(field, value, operator);
		}
		
		////////// Private methods
		private void buildCondition(String field, String value, String operator) {
			this.Field = field;
			this.Value = value;
			this.Operator = operator;
		}

		private String getCondition(SObjectType myObjectType) {
			
			if(this.Operator == 'In' || this.Operator == 'Not In'){
				// if in statement encapsulate the value in parenthesis;
				return this.Field + ' ' + this.Operator + ' (' + this.Value + ')';
			}else if(quotesNeeded(myObjectType)){
				// if the field is a string, email, id, phone, picklist, url or textarea encapsulate the value in single quotes
				return this.Field + ' ' + this.Operator + ' \'' + String.escapeSingleQuotes(this.Value) + '\'';
			}
			
			return this.Field + ' ' + this.Operator + ' ' + this.Value;
		}
		
		private Boolean quotesNeeded(SObjectType myObjectType) {
			String fieldName = this.Field;
			
			// get list of fields for object
			Map<String, Schema.SObjectField> lstFields = myObjectType.getDescribe().fields.getMap();
			if(this.Field.contains('.')){
		      	system.debug('>>>>> SoqlBuilder.Condition field: ' + this.Field);
				List<String> tmpList = this.Field.split('\\.');
				String objectName = tmpList.get(0).replace('__r', '__c');
				fieldName = tmpList.get(1);
				
				SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
				lstFields = objectType.getDescribe().fields.getMap();
			}
			
		 	if (lstFields.containsKey(fieldName)) {
		 		// determine the field type
		      	Schema.DisplayType displayType = lstFields.get(fieldName).getDescribe().getType();
		      	system.debug('>>>>> SoqlBuilder.Condition field type: ' + displayType + ' field ' + fieldName);
		      
				// if the field is a string, email, id, phone, picklist, url or textarea encapsulate the value in single quotes
				if(displayType == Schema.DisplayType.STRING || 
				   displayType == Schema.DisplayType.EMAIL || 
			       displayType == Schema.DisplayType.ID ||
			       displayType == Schema.DisplayType.PHONE || 
			       displayType == Schema.DisplayType.PICKLIST || 
			       displayType == Schema.DisplayType.URL || 
			       displayType == Schema.DisplayType.REFERENCE ||
			       displayType == Schema.DisplayType.TEXTAREA) {
			         	
					return true;
	      		} // END if
		 	}
		 	
		 	return false;
		}
		
	} // END Condition class
	
	public static List<SObject> ExecuteSelectQuery(String objectName, List<Condition> conditions) {
		
		return ExecuteSelectQuery('*', objectName, conditions, null, null);
	}

	public static List<SObject> ExecuteSelectQuery(String objectName, List<Condition> conditions, String conditionLogic) {
		
		return ExecuteSelectQuery('*', objectName, conditions, conditionLogic, null);
	}

	/// condition logic ex.: {0} or ({1} and {2})
	public static List<SObject> ExecuteSelectQuery(String myFields, String objectName, List<Condition> conditions, String conditionLogic, String orderBy) {
		List<SObject> listSObjects = new List<SObject>();
		
		String query = BuildQuery('Select', myFields, objectName, conditions, conditionLogic, orderBy);
        if(query == null) { return null; }
        
        system.debug('>>>>>>>>>> SoqlBuilder.ExecuteQuery query = ' + query);
        listSObjects = Database.query(query);
		
		return listSObjects;
	}
	
	/////////// Private Methods
	
	private static String BuildQuery(String queryType, String myFields, String objectName, List<Condition> conditions, String conditionLogic, String orderBy) {
		String query;
		
		// get the object type		
		SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
		if(objectType == null) { return null; }

		// get list of fields
		String fieldList = GetFields(myFields, objectType);
       
        // build query
        query = queryType + ' ' + fieldList + ' From ' + objectName;
        
        // include where clause
        if(conditions != null) {
        	query += ' Where ' + buildCondition(objectType, conditions, conditionLogic); //condition;
        }
        
        // include order by clause
        if(orderBy != null && orderBy != '') {
        	query += ' Order by ' + orderBy;
        }
        
        return query;
	}
	
	private static String buildCondition(SObjectType objectType, List<Condition> conditions, String conditionLogic){
        String condition;
        
        if(conditions.size() == 1) { 
        	// only one condition exists
        	condition = conditions.get(0).getCondition(objectType);
        }else if(conditions.size() > 1){
	        // get the logic pattern ex. {0} and {1} and {2})
	        if(conditionLogic == NULL) conditionLogic = buildConditionLogic(conditions);
	        system.debug('>>>>>> conditionLogic = ' + conditionLogic);
	        
	        // need to convert the list of conditions to a list of strings in order to use the string format function
	        List<String> arguments = new List<String>();
	        for(Condition myCondition : conditions) {
	        	arguments.add(myCondition.getCondition(objectType));
	        }
	        condition = String.format(conditionLogic, arguments);
	        
        }
        
		return condition;
	}
	
	// for each condition in the list build a logic pattern ex. {0} and {1} and {2}
	private static String buildConditionLogic(List<Condition> conditions) {
		String logic = '{0}';
		
		if(conditions.size() > 1){
	        for(Integer i = 1; i < conditions.size(); i++) {
				system.debug('>>>> logic = ' + logic);
	        	logic += ' And {' + i + '}';
				system.debug('>>>> logic = ' + logic);
	        }	
		}
        
        return logic;	
	}

	private static String GetFields(String myFields, SObjectType objectType) {
		String strFields;
		
		if(myFields == null || myFields.contains('*')) {
			String tmpFields;
			// get list of all fields
			List<Schema.SObjectField> listFields = objectType.getDescribe().fields.getMap().values();
			
	        tmpFields = listFields[0].getDescribe().LocalName;
	        for (Integer i = 1; i < listFields.size(); i++) {
	            tmpFields += ',' + listFields[i].getDescribe().LocalName;
	        }
	        
	        if( myFields == null) {
	        	strFields = tmpFields;
	        }else {
	        	strFields = myFields.replace('*', tmpFields);
	        }
	        
		}else {
			strFields = myFields;
		}
		
		return strFields;
	}
}
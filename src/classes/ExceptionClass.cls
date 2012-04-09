public class ExceptionClass {
    
    public static Id InsertException(Exception exc) {
 		// save exception
		return CreateException(exc);
    }
    
    public static List<Exception__c> findByIds(List<Id> exceptionIds) {
    	String strExceptionIds = Utilities.convertListToString(exceptionIds);
    	
		// build where clause
    	List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    	conditions.add(new SoqlBuilder.Condition('Id', strExceptionIds, 'In'));
    	
		return findBy('*', conditions, null, null);
    }
        
    public static void attachEmailToException(Messaging.InboundEmail email, Id exId, Messaging.InboundEnvelope envelope) {
    	// save original email as attachment
		AttachmentClass objAttachment = new AttachmentClass();

		// serialize the inbound email and store as attachment
		Blob emailBody = Blob.valueOf(system.Json.serializePretty(email));
		insert objAttachment.createAttachment(exId, 'OriginalEmail' + Datetime.now() + '.txt', emailBody, email.Subject);
    	
		// serialize the inbound envelope and store as attachment
		Blob serializedEnvelope = Blob.valueOf(system.Json.serializePretty(envelope));
		insert objAttachment.createAttachment(exId, 'EmailEnvelope' + Datetime.now() + '.txt', serializedEnvelope, 'Envelope');

        // save any additional attachments from the original email
        EmailUtilities objEmailUtil = new EmailUtilities();
        objEmailUtil.saveAttachmentsToParentFromInboundEmail(email, exId, true);
    }

	public static List<Messaging.InboundEmailResult> resubmitException(List<Id> exceptionIds) {
		Messaging.InboundEmail email;
		Messaging.InboundEnvelope envelope;
		List<Messaging.InboundEmailResult> results = new List<Messaging.InboundEmailResult>();
		
		// get emails and envelopes
		Map<Id, Attachment> emails = getAttachments(exceptionIds, 'email');
		Map<Id, Attachment> envelopes = getAttachments(exceptionIds, 'envelope');
		
		List<Exception__c> exceptions = ExceptionClass.findByIds(exceptionIds);
		
		for(Exception__c myException : exceptions) {
			myException.Resubmission_Attempts__c += 1;
			try{
				// deserialize attachments
				email = (Messaging.InboundEmail)system.Json.deserialize(emails.get(myException.Id).Body.toString(), Messaging.InboundEmail.class);
				envelope = (Messaging.InboundEnvelope)system.Json.deserialize(envelopes.get(myException.Id).Body.toString(), Messaging.InboundEnvelope.class);

				// attempt to resubmit the original email
				if(email != null && envelope != null) {
					EmailServicesHandler eHandler = new EmailServicesHandler();
					Messaging.InboundEmailResult result = eHandler.handleInboundEmail(email, envelope);
					myException.Successfully_Resubmitted__c = result.success;
					results.add(result);
				}
			}catch(Exception ex){
				Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
				result.success = false;
				result.message = myException.Name + ' - ' + ex.getMessage();
				results.add(result);
			}
				
		}

		update exceptions;

		return results;
	}
	
    /////// Private Methods
    
    private static Id CreateException(Exception exc) {
 		// save exception
		Exception__c ex = new Exception__c();
		ex.Message__c = exc.getMessage();
		ex.Type_Name__c = exc.getTypeName();
		ex.Line_Number__c = exc.getLineNumber();
		ex.Stack_Trace__c = exc.getStackTraceString();
		
		insert ex;

		return ex.Id;
    }
    
    private static List<Exception__c> findBy(String myFields, List<SoqlBuilder.Condition> conditions, String conditionLogic, String orderBy) {
		return SoqlBuilder.ExecuteSelectQuery(myFields, 'Exception__c', conditions, conditionLogic, orderBy);
    }

	private static Map<Id, Attachment> getAttachments(List<Id> exceptionIds, string typeOfAttachment) {
		Map<Id, Attachment> attachmentMap = new Map<Id, Attachment>();
		
		for(Attachment myAttachment : AttachmentClass.findExceptionAttachments(exceptionIds, typeOfAttachment)) {
			attachmentMap.put(myAttachment.ParentId, myAttachment);
		}
		
		return attachmentMap;
	}
}
global class LockedRowEmailServicesHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        //hardcode ContactId and RecordTypeId
        this.insertCase(email, '003M0000008nvWo', '012M00000008Yxh');

        return result;
    }
    
    global Case insertCase(Messaging.InboundEmail email, Id myContactId, Id myRecordTypeId){
    	Case myCase = new Case(Subject = email.subject
    						  ,Description = email.plainTextBody
    						  ,ContactId = myContactId
    						  ,RecordTypeId = myRecordTypeId
							  ,SuppliedEmail = email.fromAddress
                              ,SuppliedName = email.fromName
    				  );
	 	insert myCase;
	 	return myCase;    	
    }
}
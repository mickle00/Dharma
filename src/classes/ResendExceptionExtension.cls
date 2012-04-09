global class ResendExceptionExtension {

	webservice static List<Messaging.InboundEmailResult> Resubmit(List<Id> exceptionIds){
		return ExceptionClass.ResubmitException(exceptionIds);
	}
}
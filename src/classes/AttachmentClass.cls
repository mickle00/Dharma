public with sharing class AttachmentClass {
	
	public Attachment createAttachment(Id parentId, String fileName, Blob fileBody, String description) {
		System.debug('ATTACHMENT ParentId=' + parentId);
	  Attachment newAttachment = new Attachment(ParentId = parentId,
                                              Name = fileName, 
                                              Body = fileBody,
                                              Description = description);
    return newAttachment;
	}
	
  public static List<Attachment> findByParentId(Id parentId) {
    // build where clause
    List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    conditions.add(new SoqlBuilder.Condition('ParentId', parentId));
    	
		return findBy('*', conditions, null, null);
  }
	
  public static List<Attachment> findExceptionAttachments(List<Id> parentIds, String typeOfAttachment) {
    String strParentIds = Utilities.convertListToString(parentIds);
    	
    // build where clause
    List<SoqlBuilder.Condition> conditions = new List<SoqlBuilder.Condition>();
    conditions.add(new SoqlBuilder.Condition('ParentId', strParentIds, 'In'));
    
    if(typeOfAttachment == 'email'){
      conditions.add(new SoqlBuilder.Condition('Name', 'OriginalEmail%', 'Like'));
    }
    else {
	    conditions.add(new SoqlBuilder.Condition('Name', 'EmailEnvelope%', 'Like'));
    }
    	
		return findBy('*', conditions, null, null);
  }

	public static Database.DeleteResult deleteAttachment(Id attachmentId) {
	  return database.delete(attachmentId);
	}
	
	////// Private Methods
  private static List<Attachment> findBy(String myFields, List<SoqlBuilder.Condition> conditions, String conditionLogic, String orderBy) {
	  return SoqlBuilder.ExecuteSelectQuery(myFields, 'Attachment', conditions, conditionLogic, orderBy);
  }
}
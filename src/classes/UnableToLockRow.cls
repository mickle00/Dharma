public class UnableToLockRow {

    public static void addTasks(Id whoId) {
        List<Task> myTasks = new List<Task>();
		for (integer i=0; i<9500;i++){
			Task myTask = new Task(Subject = 'Test'+i, Status = 'Completed', WhoId = whoId, ActivityDate = system.Today());
			myTasks.add(myTask);
		}
		insert myTasks;
	}
	
	public static void addCases(Id myContactId){
		List<Case> myCases = new List<Case>();
		for (integer i=0; i<150;i++){
			Case myCase = new Case(Subject = 'Test'+i, Status = 'Completed', ContactId = myContactId);
			//myCases.add(myCase);
			insert myCase;
		}
		//insert myCases;
	}
	
	public static void deleteCases(){
		List<Case> casesToDelete = [SELECT Id FROM Case LIMIT 500];
		delete casesToDelete;
	}
	
	public static void addContacts(){
		List<Contact> myContacts = new List<Contact>();
		for (integer i=0; i<500;i++){
			Contact myContact = new Contact(LastName = 'Test'+i, Email = i+'test@test.com', AccountId = '001C000000qk2v1');
			myContacts.add(myContact);
		}
		insert myContacts;
	}
	
	public static void addCaseAndEmail(){
		List<Case> myCases = new List<Case>();
		for (integer i=0; i<200;i++){
			Case myCase = new Case(Subject = 'NewTest'+i, Status = 'Completed', ContactId = '003M0000008XogX');
			myCases.add(myCase);
		}
		insert myCases;
		List<EmailMessage> myEmails = new List<EmailMessage>();
		for (Case myCase : myCases){
			EmailMessage myEmail = new EmailMessage(ParentId = myCase.Id, Subject = 'ThisSucksToTroubleshoot');
			myEmails.add(myEmail);
		}
		insert myEmails;
	}
	
	public static void tryLockedStuff(Integer runCount){
		if (runCount < 2){
			Account myAccount = [SELECT Id FROM Account WHERE Id = '001C000000qk2v1' FOR UPDATE];
			Account myAccount2 = [SELECT Id FROM Account WHERE Id = '001C000000qk2v1' FOR UPDATE];
			Contact myContact = [SELECT Id FROM Contact WHERE Id = '003M0000008XogX' FOR UPDATE];
			
			Case myCase = new Case(Status = 'New', Subject = 'RunCount: ' + string.valueOf(runCount), AccountId = myAccount2.Id, ContactId = myContact.Id);
			insert myCase;
			
			Case myInsertedCase = [SELECT Id FROM Case WHERE Id = :myCase.Id FOR UPDATE];		
			EmailMessage myEM = new EmailMessage(ParentId = myInsertedCase.Id, Subject = 'LockedTest');
			insert myEM;
			
			Task myTask = new Task(Subject = 'Test', Status = 'Completed', WhoId = myContact.Id, WhatId = myCase.Id, ActivityDate = system.Today());
			insert myTask;
			
			UnableToLockRow.addTasks(myContact.Id);
			
			runCount += 1;
			UnableToLockRow.tryLockedStuff(runCount);
		}				
	}
	
	public static void waitBeforeInsert(){
		DateTime fiveSecondsFromNow = system.now().addSeconds(1);		
		while (system.now() < fiveSecondsFromNow){
			//system.debug('Killing Time');
			continue;
		}
		system.debug('done');	
		//insert stuff;	
	}
}
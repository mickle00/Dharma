//SHOULD WORK FOR EVERYTHING EXCEPT SUNDAYS
//SHOULD DO A TEST IF .TOSTARTOFWEEK == 0; THEN WEEK ENDING = TOSTARTOFEEK +0

trigger OffsetDate on Case (after insert, after update) {
    Set<Id> cIDs = new Set<Id>();
    List<Case> casestoupdate = new List<Case>();
    //date offset = date.today().toStartOfWeek().addDays(+6);
    //string soffset = string.valueof(offset);
    
    for (Case c : trigger.new){
        if (c.Created_Date_Week_Ending__c == NULL){         
            cIDs.add(c.Id);
        }
        if (c.Closed_Date_Week_Ending__c == NULL && c.IsClosed == true){            
            cIDs.add(c.Id);
        }
    }
    
    for (Case cs : [SELECT Id, Description, CreatedDate, LastModifiedDate, ClosedDate,Created_Date_Week_Ending__c, Closed_Date_Week_Ending__c FROM Case WHERE Id IN : cIDs]){

        date closed = NULL;
        datetime timecreated = cs.CreatedDate;
        date created = Date.newInstance(timecreated.year(), timecreated.month(), timecreated.day()).toStartOfWeek().addDays(+7);
        
        if (cs.ClosedDate != NULL){
        datetime timeclosed = cs.ClosedDate;
        closed = Date.newInstance(timeclosed.year(), timeclosed.month(), timeclosed.day()).toStartOfWeek().addDays(+7);
        }
        
        //cs.Description = string.valueof(created) + '\n' + string.valueof(closed);
        cs.Created_Date_Week_Ending__c = created;
        cs.Closed_Date_Week_Ending__c = closed;
        //cs.contactid = null;
        //cs.contactid = '003M0000001onRO';
        //cs.accountid = null; // testing nulling out the account

        casestoupdate.add(cs);      
    }
update casestoupdate;
}
trigger CaseTeamsInvolvedTest on Case (after insert, after update, before update, before insert) {
    
//build all of the possible picklist values from the involved teams field on the case object
Schema.DescribeFieldResult F = Case.Involved_Teams__c.getDescribe();
List<Schema.PicklistEntry> P = F.getPicklistValues();

string allPicklist = '';

for (Schema.PicklistEntry pe : P){
    allPicklist = allPicklist + pe.getValue() + ';';
}

List<Case_Checkoff__c> checkoffs = [SELECT Id from Case_Checkoff__c];
List<Checkoff_Junction__c> newjunc = new List<Checkoff_Junction__c>();

Id troubleshootingRecordType = [SELECT Id FROM RecordType WHERE DeveloperName ='Troubleshooting' and sObjectType = 'Case' LIMIT 1].Id;
Id troubleshootingQueueId = [SELECT Id, Name,(SELECT Id,SobjectType FROM QueueSobjects WHERE SobjectType = 'case') FROM Group WHERE type = 'Queue' and Name = 'Troubleshooting Transport Queue' LIMIT 1].Id;


if (trigger.isBefore && trigger.isInsert){
    for (case c: trigger.new){
        if (c.RecordTypeId == troubleshootingRecordType){
            c.OwnerId = troubleshootingQueueId;
            c.Involved_Teams__c = allPicklist;
        }               
    }
}

if (trigger.isBefore && trigger.isUpdate){
    for (case c: trigger.new){
        if (c.OwnerId == troubleshootingQueueId) c.RecordTypeId = troubleshootingRecordType;
        if (trigger.oldMap.get(c.id).RecordTypeId != troubleshootingRecordType && trigger.newMap.get(c.id).RecordTypeId == troubleshootingRecordType){
            c.Involved_Teams__c = allPicklist;
        }
    }
}


if (trigger.isInsert && trigger.isAfter){
    for (case c : trigger.new){
        if (c.RecordTypeId == troubleshootingRecordType){
            for (Case_Checkoff__c chk : checkoffs){
            Checkoff_Junction__c juncadd = new Checkoff_Junction__c(Case__c = c.Id, Case_Checkoff__c = chk.Id);
            newjunc.add(juncadd);
            }               
        }   
    }
    insert newjunc;
}

if (trigger.isUpdate && trigger.isAfter){
    system.debug('AfterUpdate Trigger');
    
    Map<Id, Integer> caseCheckoffJunctionCount = new Map<Id, Integer>();
    
    for (AggregateResult ar : 
            [SELECT Case__c, count(id) total FROM Checkoff_Junction__c WHERE Case__c IN : trigger.newmap.keyset() GROUP BY Case__c]){
        Id i = (Id) ar.get('Case__c');
        Integer tot = (Integer) ar.get('total');
        caseCheckoffJunctionCount.put(i, tot);
    }
        
    for (case c : trigger.new){
            if (!caseCheckoffJunctionCount.containsKey(c.Id)){
                if (c.RecordTypeId == troubleshootingRecordType){
                    for (Case_Checkoff__c chk : checkoffs){
                    Checkoff_Junction__c juncadd = new Checkoff_Junction__c(Case__c = c.Id, Case_Checkoff__c = chk.Id);
                    newjunc.add(juncadd);
                    caseCheckoffJunctionCount.put(c.Id, 1);
                    }
                }
            }       
    }   
    insert newjunc;
}
}
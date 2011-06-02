// IGNORE THIS TRIGGER
// WAS FOR TESTING SALESFORCE SITES & ASSIGNMENT RULES


trigger WebOwner on Case (after insert) {

List<Case> cupdate = new List<Case>();
Map<Case, ID> CaseID = new Map<Case,ID>();
Set<Id> cids = new Set<Id>();

for (case c : trigger.new){
    if (c.ownerid == '005M0000000Q8Pb'){
    cids.add(c.id);
    }
}
    
for (case c : [SELECT Id FROM Case WHERE ID IN : cids]){
    cupdate.add(c);
    }
    
for (case c : cupdate){
    c.ownerid = '005C0000003oJCT';
}

update cupdate;
}
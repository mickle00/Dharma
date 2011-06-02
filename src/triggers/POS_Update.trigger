trigger POS_Update on Case (after insert, after update) {

//I don't think I ever used these next two maps
// Map <String, Id> Caseid = new Map<String, Id> ();
// Map <Case, List<POS_Junction__c>> CasetoPOSes = new Map <Case, List<POS_Junction__c>>();

 List<POS_Junction__c> newJunctions = new List<POS_Junction__c>();
 List<POS_Junction__c> deleteJunctions = new List<POS_Junction__c>();
 
 List<String> insertedPOSes = new List<String>();
 
 List<POS__c> POSlist =  [SELECT Name, Brand__c, Id from POS__c];
 Map <String, Id> POSid = new Map<String, Id> ();
 
 for (POS__c p : POSlist){
 	String uniquePOSname = p.Name +'-'+p.Brand__c;
 	POSid.put(uniquePOSname, p.Id); 	
 } 

 List<POS_Junction__c> POSjunctionlist =  [SELECT Id, Case__c, POS__r.Name, POS__r.Brand__c from POS_Junction__c WHERE Case__c IN: trigger.newMap.keyset()];

if (trigger.isInsert){
	for (Case c : trigger.new){
	 	String allPOS = c.POS__c; 	
	 	if (c.POS__c != NULL) insertedPOSes = allPOS.split(';');
	 	
	 	for (String p : insertedPOSes){
	 		POS_Junction__c newposjunc = new POS_Junction__c(Case__c = c.id, POS__c = POSid.get(p));
	 		newjunctions.add(newposjunc);
	 	}
 	}
}
if (trigger.isUpdate){	
	for (Case c : trigger.new){
		if (c.POS__c == trigger.oldmap.get(c.id).POS__c){
			system.debug('theyre the same');
		}
		else{
			List<String> newPOS = new List<String>();
			Set<String> newPOSset = new Set<String>();
			if (c.POS__c != NULL) newPOS = c.POS__c.split(';');
			newPOSset.addAll(newPOS);
			
			List<String> oldPOS = new List<String>();
			if (trigger.oldmap.get(c.id).POS__c != NULL) oldPOS = trigger.oldmap.get(c.id).POS__c.split(';');
			Set<String> oldPOSset = new Set<String>();
			oldPOSset.addAll(oldPOS);
			
			system.debug('oldPOSset' + oldPOSset);
			system.debug('newPOSset' + newPOSset);
			
			Set<String> toAdd = new Set<String>();
			toAdd = newPOSset.clone();
			toAdd.removeAll(oldPOSset);
			
			Set<String> toDelete = new Set<String>();
			toDelete = oldPOSset.clone();
			toDelete.removeAll(newPOSset);
			
			for (String p : toAdd){
				POS_Junction__c newposjunc = new POS_Junction__c(Case__c = c.id, POS__c = POSid.get(p));
				newjunctions.add(newposjunc);
			}
			//need to figure out a more elegant way of mapping these.
			for (String d : toDelete){				
				for (POS_Junction__c pj : POSjunctionlist){
					String fakekey = pj.POS__r.Name +'-'+pj.POS__r.Brand__c;
					if (pj.Case__c == c.Id && fakekey == d){
						deletejunctions.add(pj);						
					}
				}				
			}
		}		
	}
}
insert newjunctions;
delete deletejunctions;
}
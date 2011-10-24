trigger UpdateInvolvedTeams on Checkoff_Junction__c (after update, before insert) {
    
    if (trigger.isInsert && trigger.isBefore){
        for (Checkoff_Junction__c cj : trigger.new){
            cj.Ready_to_Close2__c = 'No';
        }
    }
    else{       
    
    // bleh hardcoding
    Map<String, Id> queueNametoID = new Map<String, Id>{
        'Air Configuration & Pricing Research'=>'00GM0000000QWfF',
        'Air Fulfillment Process & Support'=> '00GM0000000QWfK',
        'Airline Debit Memos'=>'00GM0000000QWfL',
        'Car Operations'=>'00GM0000000QWfP',
        'Commissions'=>'00GM0000000QWYO',
        'Fare Filing'=>'00GM0000000QWfU',
        'Quality'=>'00GM0000000QWfZ',
        'Regional Team'=>'00GM0000000QWfe',
        'Settlement & Reporting'=>'00GM0000000QWfj',
        'Ticketing & Schedule Change'=>'00GM0000000QWfo',
        'Training'=>'00GM0000000QWft'
    };  
        
    Set<Id>CaseIDs = new Set<Id>();
    Set<Id>cjIDs = new Set<Id>();
    
    //Map cjId to Case Checkoff Name
    Map<Id, String> cjIDtoName = new Map<Id, String>();
    
    //Map linking cjID to the CaseId
    Map<Id, Id> cjIDtoCaseId = new Map<Id, Id>();
    
    //Map linkin cjID to the Case sObject
    Map<Id, Case> cjIDtoCase = new Map<Id, Case>();
    
    Map<Id, Checkoff_Junction__c> cjIDtoCj = new Map<Id, Checkoff_Junction__c>();
        
    for (Checkoff_Junction__c cj : trigger.new){
        CaseIDs.add(cj.Case__c);
        cjIDs.add(cj.Id);
        cjIDtoCaseId.put(cj.Id, cj.Case__c);
        cjIDtoCj.put(cj.Id, cj);
    }   
    
    List<Case> affectedCases = [SELECT Id, Involved_Teams__c, OwnerId, Status FROM Case WHERE Id IN :CaseIDs];
    
    //List of Cases to Update
    List<Case> toUpdate = new List<Case>();
    
    Map<Id, Case> cIdtoCase = new Map<Id, Case>();
    
    for (Case c : affectedCases){
        //build map between CaseID & Case
        cIdtoCase.put(c.Id, c);
    }
    
    //List<Checkoff_Junction__c> affectedCheckoffJunctions= [SELECT Id, Case_Checkoff__r.Name FROM Checkoff_Junction__c WHERE ID IN :cjIDs];
    
    for (Checkoff_Junction__c cj : [SELECT Id, Case_Checkoff__r.Name FROM Checkoff_Junction__c WHERE ID IN :cjIDs]){
        cjIDtoName.put(cj.Id, cj.Case_Checkoff__r.Name);
    }
    
    Map<Id,Case> casesToUpdateMap = new Map<Id, Case>();    
    
    List<AggregateResult> caseStatus = [SELECT Case__c, count(id) total FROM Checkoff_Junction__c WHERE Case__c IN : CaseIDs AND Ready_to_Close2__c != 'Yes' Group By Case__c];
    Map<Id, Integer> caseStatusCount = new Map<Id, Integer>();
    
    for (AggregateResult ar : caseStatus){
        Id i = (Id) ar.get('Case__c');
        Integer tot = (Integer) ar.get('total');
        caseStatusCount.put(i, tot);
    }
    
    Case cs;
    for (Checkoff_Junction__c cj : trigger.new){
        
        if (casesToUpdateMap.containsKey(cj.Case__c)){
            cs = casesToUpdateMap.get(cj.Case__c);
        }
        else{
            cs = cIdtoCase.get(cj.Case__c);         
        }   
        String cjName = cjIDtoName.get(cj.Id);
        if (cs.Involved_Teams__c == null) cs.Involved_Teams__c = '';    
        if (!caseStatusCount.containsKey(cj.Case__c)){
            cs.Status = 'Closed';
        }
        
        if (cj.Involvement_Needed__c != 'Owner'){
            if (trigger.oldmap.get(cj.id).Involvement_Needed__c == 'Owner' && cs.ownerid == queueNametoID.get(cjName)) cs.ownerid = '00GM0000000QWWm';
        }   
            
        if (cj.Involvement_Needed__c == 'No'){          
            if (cjName != null && cs.Involved_Teams__c.contains(cjName)) cs.Involved_Teams__c = cs.Involved_Teams__c.replace(cjName, '');
            if (caseStatusCount.containsKey(cj.Case__c) && (cs.Status == 'New' || cs.Status == 'Closed')) cs.Status ='Open';                    
        }
        if (cj.Involvement_Needed__c == 'Yes (Not Owner)' || cj.Involvement_Needed__c == 'Unknown' || cj.Involvement_Needed__c == 'Owner'){
            //if the status is new or closed, but there is reason to believe its being worked, changed status to open. this way it will not overwrite if we change the status later
            if (caseStatusCount.containsKey(cj.Case__c) && (cs.Status == 'New' || cs.Status == 'Closed')) cs.Status ='Open';    
            if (cjName != null && !cs.Involved_Teams__c.contains(cjName)){
                cs.Involved_Teams__c = cs.Involved_Teams__c + ';'+ cjName;                                          
            }           
        }

        if (cj.Involvement_Needed__c == 'Owner'){           
            cs.OwnerId = queueNametoID.get(cjName);
        }

        casesToUpdateMap.put(cj.Case__c, cs);               
    }
    
    update casesToUpdateMap.values();
    }
}
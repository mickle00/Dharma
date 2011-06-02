global class EmailServicesHandler implements Messaging.InboundEmailHandler {
    
    public Map<String,Id> orgWideEmailDisplayNameToId = EmailUtilities.getOrgWideEmailDisplayNameToId();
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
    system.debug('*** EmailServicesHandler => envelope.toAddress = ' + envelope.toAddress + ' ***');      
    CaseClass objCase = new CaseClass();
    
    // Look at To envelope.toAddress and call appropriate case, passing correct record type
    if (envelope.toAddress.toLowerCase().contains('hoth.ds@c-6859oj86mt4dydkot0vyguvb4.m8nm4maa.m.apex.sandbox.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('staging.ds@k-3k02tg17q1kgtvm7y7vlloa34.l8dajmay.l.apex.sandbox.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('production.ds@o-fei89ah5uzxln65dwgfaoscs.cpxqgmak.c.apex.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('dsmaint@expedia.com')) {
      
      //Destination services case 
      system.debug('***EmailServicesHandler => Before processEmail for DS');
      objCase.processEmail(email, 'Destination_Services');
    }
    else if (envelope.toAddress.toLowerCase().contains('hoth.geo@4-4uqisn6ksetmougqamyqvhfso.m8nm4maa.m.apex.sandbox.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('staging.geo@27dh7bhns72irxelriwlm05uy.l8dajmay.l.apex.sandbox.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('production.geo@5zvrzbr7vhfamla3bi2pqf6qc.cpxqgmak.c.apex.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('geosup@expedia.com')) {
      
      //Geography case 
      system.debug('***EmailServicesHandler => Before processEmail for GEO');
      objCase.processEmail(email, 'Geography');
    }
    else if (envelope.toAddress.toLowerCase().contains('dharma.test@25gamut209nflquxfeueeqaql.mcofzma0.m.apex.sandbox.salesforce.com') ||
         envelope.toAddress.toLowerCase().contains('production.ff@4jq6lfeg7jro9rdn6fl1aanls.cpxqgmak.c.apex.salesforce.com')) { 
       // Transport Fare Filing case
      system.debug('***EmailServicesHandler => Before processEmail for FF'); 
      objCase.processEmail(email, 'Fare_Filing');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.adm@21iuj73fmwqq0v3z0gds544gt.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.adm@a-6i470490emrqee8d8jisxlptj.cpxqgmak.c.apex.salesforce.com')) {       
      system.debug('***EmailServicesHandler => Before processEmail for ADM');
      //ADM case 
      objCase.processEmail(email, 'ADM');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.aircpr@1y34b9nz8hvzaraun3wgzj278.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.aircpr@k-1l0klq6ojlnax1zlx2pc6v934.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Air CPR');
      //Air CPR case 
      objCase.processEmail(email, 'Air_CPR');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.carops@3dulustn4ht0j00ldvwcyfbn8.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.carops@5kluk84albaort7ezk4pbgupo.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Car OPS');
      //Car Ops case 
      objCase.processEmail(email, 'CarOps');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.comm@t-33899g2egp7cs2tv0wtwaob1l.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.comm@5378nex8cajd3zop3d3bcppak.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Commissions');
      //Commissions case 
      objCase.processEmail(email, 'Commissions');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.ticket@h-5yu243xkx4ilvfnk986sde3mt.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.ticket@0-16p21ob3vpjgw63c4xukvxh0i.cpxqgmak.c.apex.salesforce.com')) {      
      system.debug('***EmailServicesHandler => Before processEmail for Ticketing');
      //Ticketing case 
      objCase.processEmail(email, 'Ticketing');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.sched@h-5yu243xkx4ilvfnk986sde3mt.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.sched@6-77frurhrk37duk7nui8iyasvu.cpxqgmak.c.apex.salesforce.com')) {      
      system.debug('***EmailServicesHandler => Before processEmail for Schedule Change');
      //Schedule Change case 
      objCase.processEmail(email, 'Schedule_Change');
    }
        
    else if (envelope.toAddress.toLowerCase().contains('staging.settle@j-kc9lk9tjo84reycjvqxfzhhy.l8dajmay.l.apex.sandbox.salesforce.com') ||
          envelope.toAddress.toLowerCase().contains('production.settle@4bbte27ao7xc1h9zsapbtucdf.cpxqgmak.c.apex.salesforce.com')) {       
      system.debug('***EmailServicesHandler => Before processEmail for Settlement');
      //Settlement case 
      objCase.processEmail(email, 'Settlement_Reporting');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.afps@7c0wbjptdd0psvwzfr1quj78m.l8dajmay.l.apex.sandbox.salesforce.com')) {      
    system.debug('***EmailServicesHandler => Before processEmail for Air Fulfillment Process & Support');
    //Air Fulfillment Process & Support
    objCase.processEmail(email, 'Air_Fulfillment_Process_Support');
  }
    else { // email not handled so forward on
        // REMOVED Because any email addresses this was sent to not handled would kickout an email.
        // May switch to creating a separate SF email alias for each case record type
        //forward on the email 
        //EmailUtilities.sendSingleEmailMessage(new String[] {'scook@expedia.com'}, new String[]{}, 'donotreply.gso@expedia.com', 'Expeida GSO', 
        //envelope.toAddress + '\n\n\n' + email.plainTextBody, 'ERROR - Unhandled Email: ' + email.subject, orgWideEmailDisplayNameToId.get('Expedia GSO'));
    }
    
    system.debug('***EmailServicesHandler => Before Return***');    
    return result;  
  }
}
public class sitesReContractingSubmissions {

	public List<GSOContract__c> contracts {get; set;}
	public GSOContract__c contract {get; set;}
	public Boolean completed {get; set;}

    public PSG_User__c PSGUser {
    	get {
    		if(PSGUser == null) {
		        String approver = Apexpages.currentPage().getParameters().get('MM');
		        PSGUser = PSGUserClass.findByEmail(approver);
    		}
    		return PSGUser;
    	}
    	set;
	}

	public sitesReContractingSubmissions() {
		if(PSGUser != null) {
			this.contracts = GSOContractClass.getActiveContractsByMM(this.PSGUser.Id);
		} 
		
		// check for contract id
		Id contractId = (Id)Apexpages.currentPage().getParameters().get('contractId');
		if(contractId != null) {
			this.contract = GSOContractClass.findById(contractId);
		}
		
		completed = false;
	}
	
    public PageReference VerifyAuthentication() {
        // User has not been authenticated redirect to the authentication page
        if(PSGUserClass.isAuthenticatedUser(PSGUser) == false) { 
            return Page.ReContractingAuthentication;
        }

        // User has been authenticated
        return null;
    }

	public PageReference Step1() {
    	PageReference p = Page.rcSubmissionsStep1;
    	p.setRedirect(true);
		p.getParameters().put('MM', PSGUser.Email__c);
		return p;
	}

	public PageReference cancel() {
		try {
			contract.Status__c = 'Cancelled';
			update contract;
			completed = true;
		}catch(Exception ex){
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, ex.getMessage()));
		}
		
		return Apexpages.currentPage();
	}
	
}
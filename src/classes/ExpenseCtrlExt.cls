global with sharing class ExpenseCtrlExt {
    
    public Expense__c expense {
        get;
        private set;
    }
    private ApexPages.StandardController stdCtrl;
 
 
    // CONSTRUCTOR
    
    public ExpenseCtrlExt(ApexPages.StandardController standardController) {
        stdCtrl = standardController;
        expense = (Expense__c) stdCtrl.getRecord();
    }
    

    //GLOBAL METHODS
    
    @RemoteAction
    global static Id findLocation(String city, String country) {
        Id result = LocationFinder.findLocation(city, country);
        
        return result;
    }
      
     
    // PUBLIC METHODS
    
    public String getRecordTypeName() {
        //String result = expense.RecordType.DeveloperName;
        
        //if(result == null) {
            //String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            Id recordTypeId = expense.RecordTypeId;
            String result = ExpenseType.getRecordTypeName(recordTypeId);
        //}
        
        return result;
    }
    
    
    public Boolean getIsMovement() {
        Boolean result = ExpenseType.isMovement(expense);
        
        return result;
    }
    
    
    public Id getTravelId() {
        Id result = expense.mdr_Travel__c;
        
        return result;
    }
    
    
    public String getDate() {
        String result = expense.dat_ExpenseDate__c.format();
        
        return result;
    }
    
    
    public String getMovementSubtitle() {
        String result;
        
        if(ExpenseType.isMovement(expense)) {
                if(ExpenseType.isFlight(expense)) {
                        result = 'Airfare';
                }
                else if(ExpenseType.isTrainRide(expense) || ExpenseType.isSeaTravel(expense)) {
                        result = 'Ticket Price';
                }
        }
        
        return result;
    }
    
    
    public Id getExpenseId() {
        return expense.Id;
    }
    
    
    public Boolean getHasMessages() {
        Boolean result;
        
        result = ApexPages.hasMessages();
        
        return result;
    }
    
    
    public PageReference doRedirectMobileDevices() {
        PageReference result = null;
        
        if( isMobileDevice() ) {
            String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
            String parameters = currentRequestURL.split('expenseEdit', 2)[1];
            result = new PageReference('/apex/expenseEditMobile' + parameters);
            result.setRedirect(true);          
        }
        
        return result;
    }
    
    
    public PageReference doRedirectDesktopDevices() {
        PageReference result = null;
        
        if( !isMobileDevice() ) {
            String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
            String parameters = currentRequestURL.split('expenseEditMobile', 2)[1];
            result = new PageReference('/apex/expenseEdit' + parameters);
            result.setRedirect(true);          
        }
        
        return result;
    }
    
    
    public PageReference doRedirectDesktopDevicesRobert() {
        PageReference result = null;
        
        if( !isMobileDevice() ) {
            String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
            String parameters = currentRequestURL.split('ExpenseEditBootstrapRobert', 2)[1];
            result = new PageReference('/apex/expenseEdit' + parameters);
            result.setRedirect(true);          
        }
        
        return result;
    }
    
    
    public void doJustSave() {
        try {
        	upsert expense;
        }
        catch(Exception e){
        }
    }
    
    
    public PageReference doSaveAndRedirectToTravel() {
        PageReference result = null;
        
        try {
        	upsert expense;
                
        	result = new PageReference('/' + expense.mdr_Travel__c);
        }
        catch(Exception ignore) {}
                
			return result;
    }
    
    
    public void doChangeToFlight() {
        expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
    }
    
    
    public void doChangeToPrivateVehicle() {
        expense.RecordTypeId = ExpenseType.getPrivateVehicleRecordTypeId();
    }
   
    
    // PRIVATE METHODS
    
    private Boolean isMobileDevice() {
        Boolean result = false;
        
        if( ApexPages.currentPage().getParameters().get('sfdcIFrameHost') !=null 
            || ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin') !=null
            || ApexPages.currentPage().getParameters().get('isdtp') == 'p1'
            || ( ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') ) ) {
            
            result = true;
        }
        
        return result;
    }
}
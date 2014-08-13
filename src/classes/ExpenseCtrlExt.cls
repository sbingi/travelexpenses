global with sharing class ExpenseCtrlExt {
<<<<<<< HEAD
// Note: Class "global" due to former architecture in managed package. Change to "public" if possible. 
=======
>>>>>>> refs/remotes/origin/master
    
    public Expense__c expense {
        get;
        private set;
    }
<<<<<<< HEAD
=======
    private ApexPages.StandardController stdCtrl;
>>>>>>> refs/remotes/origin/master
 
 
    // CONSTRUCTOR
    
    public ExpenseCtrlExt(ApexPages.StandardController standardController) {
        expense = (Expense__c) standardController.getRecord();
    }
    

    //GLOBAL METHODS
    // Note: Deprecated Method. To be deleted if possible.
    @RemoteAction
    global static Id findLocation(String city, String country) {
        Id result;
        
        /*DEPRECATED*/
        
        return result;
    }
      
     
    // PUBLIC METHODS
    
    public String getRecordTypeName() {
<<<<<<< HEAD
        Id recordTypeId = expense.RecordTypeId;
        String result = ExpenseType.getRecordTypeName(recordTypeId);
=======
        //String result = expense.RecordType.DeveloperName;
>>>>>>> refs/remotes/origin/master
        
<<<<<<< HEAD
        return result;
    }
    
    
    public Boolean getIsMovement() {
        Boolean result = ExpenseType.isMovement(expense);
        
        return result;
    }
    
    
    public List<CompensationRate__c> getVehicles() {
        List<CompensationRate__c> results = [SELECT Id, Name
                                             FROM CompensationRate__c
                                             WHERE RecordTypeId = :CompensationRateType.getVehicleId()];
                                             
        return results;
    }
    
    
    public Boolean getHasCostInfo() {
        Boolean result = !ExpenseType.isEntertainment(expense) && !ExpenseType.isPrivateVehicle(expense)
                         && !ExpenseType.IsPerDiem(expense) && !ExpenseType.isCompanyVehicle(expense);
        
        return result;
    }
    
    
    public String getMovementSubtitle() {
        String result;
        
        if(ExpenseType.isFlight(expense)) {
            result = 'Airfare';
        }
        else if(ExpenseType.isTrainRide(expense) || ExpenseType.isSeaTravel(expense)) {
            result = 'Ticket Price';
        }
        else if(ExpenseType.isMiscellaneous(expense) || ExpenseType.isAccommodation(expense)) {
            result = 'Overall Cost';
        }
        else if(ExpenseType.IsRentalVehicle(expense)) {
            result = 'Rental Cost';
        }
=======
        //if(result == null) {
            //String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            Id recordTypeId = expense.RecordTypeId;
            String result = ExpenseType.getRecordTypeName(recordTypeId);
        //}
>>>>>>> refs/remotes/origin/master
        
        return result;
    }
    
    
<<<<<<< HEAD
    public Boolean getHasMessages() {
        Boolean result;
        
        result = ApexPages.hasMessages();
=======
    public Boolean getIsMovement() {
        Boolean result = ExpenseType.isMovement(expense);
>>>>>>> refs/remotes/origin/master
        
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
    
    
<<<<<<< HEAD
    public void doSaveExpense() {
        try {
            upsert expense;
        }
        catch(Exception ignored) {}
=======
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
>>>>>>> refs/remotes/origin/master
    }
    
    
<<<<<<< HEAD
    public PageReference doSaveAndRedirectToTravel() {
        PageReference result = null;
=======
    public Boolean getHasMessages() {
        Boolean result;
>>>>>>> refs/remotes/origin/master
        
<<<<<<< HEAD
        try {
            upsert expense;
                
            result = new PageReference('/' + expense.mdr_Travel__c);
=======
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
>>>>>>> refs/remotes/origin/master
        }
<<<<<<< HEAD
        catch(Exception ignore) {}
                
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
    
=======
        
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
   
>>>>>>> refs/remotes/origin/master
    
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

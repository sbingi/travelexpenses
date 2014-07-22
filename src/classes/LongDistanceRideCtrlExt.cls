global with sharing class LongDistanceRideCtrlExt {
          
    private LongDistanceRide__c ride;
    private ApexPages.StandardController stdCtrl;
    
    
    // CONSTRUCTOR
    
    public LongDistanceRideCtrlExt(ApexPages.StandardController standardController) {
        stdCtrl = standardController;
        ride = (LongDistanceRide__c) stdCtrl.getRecord();
    }
    
    

    //GLOBAL METHODS
    
    @RemoteAction
    global static Id findLocation(String city, String country) {
        Id result = LocationFinder.findLocation(city, country);
        
        return result;
    }
    

    
    // PUBLIC METHODS
    
    public PageReference doSave() {
        try {  
            upsert ride;
            return ApexPages.currentPage();
        } 
        catch(Exception e) {  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getCause().getMessage()));  
            return null;
        }
    }
}
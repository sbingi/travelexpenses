public with sharing class LongDistanceRideCannotEndBeforeStart implements LongDistanceRideRule {
	
	
	// PUBLIC METHODS
	 
    public void validate(List<SObject> records) {
    	for(LongDistanceRide__c ldr : (List<LongDistanceRide__c>) records) {
    		
	        if (ldr.dtm_ArrivalTime__c <= ldr.dtm_DepartureTime__c) {
	        	ldr.dtm_ArrivalTime__c.addError('Long Distance Ride cannot end before it started.');
	        }
    	}
    }
}
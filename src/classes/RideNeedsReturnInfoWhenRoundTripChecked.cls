public with sharing class RideNeedsReturnInfoWhenRoundTripChecked implements LongDistanceRideRule{
    
    
    // PUBLIC METHODS
    
    public void validate(List<SObject> records) {
        for(LongDistanceRide__c ride : (List<LongDistanceRide__c>)records) {
        	
            if (ride.chk_RoundTrip__c) {
                if(ride.dtm_ReturnDeparture__c == null) {
                    ride.dtm_ReturnDeparture__c.addError('Return departure time is missing');
                }
                if(ride.dtm_ReturnArrival__c == null) {
                    ride.dtm_ReturnArrival__c.addError('Return arrival time is missing.');
                }
            }
        }
    }
}
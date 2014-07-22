public with sharing class LongDistanceRideHasValidLocation implements LongDistanceRideRule {
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		String errorMessage = 'Unknown location, please choose a location from the autocomplete drop-down list.';
		
    	for( LongDistanceRide__c ldr : (List<LongDistanceRide__c> ) records) {
    		
			if( ldr.lkp_LocationFrom__c == null ) {
				ldr.txt_From__c.addError(errorMessage);
			}
			if( ldr.lkp_LocationTo__c == null ) {
				ldr.txt_To__c.addError(errorMessage);
			}
    	}
    }
}
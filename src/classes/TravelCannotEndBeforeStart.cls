public with sharing class TravelCannotEndBeforeStart implements SaveTravelRule {
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		for(Travel__c travel : (List<Travel__c>)records) {
			
	        if (travel.dtm_End__c < travel.dtm_Start__c ) {
				travel.dtm_End__c.addError('Your travel can not end before it started.');     
	        }
		}
    }
}
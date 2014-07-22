public with sharing class LocationFinder {
	
	
	// PUBLIC METHODS
	
	public static Id findLocation(String city, String country) {
		Id result;
		
		CompensationRate__c location = getLocation(country, city);
		
		if(location != null) {
			result = location.Id;
		}
		
		return result;
	}
	
	
	// PRIVATE METHODS
	
	private static CompensationRate__c getLocation(String countryCode, String city) {
		CompensationRate__c result;
		
		Id location = CompensationRateType.getLocationId();
		
		for(CompensationRate__c rate : [SELECT Id
				  						FROM CompensationRate__c
				  						WHERE RecordTypeId = :location
									    AND txt_CityName__c = null
									    AND txt_CountryCode__c = :countryCode LIMIT 1]) {
	    	result = rate;
	    }
		
		if(result == null) {
			for(CompensationRate__c rate : [SELECT Id
									  	    FROM CompensationRate__c 
										    WHERE RecordTypeId = :location
										    AND txt_CountryCode__c = :countryCode 
										    AND txt_CityName__c = :city LIMIT 1]) {
		    	result = rate;
		    }
		}
		
		if(result == null) {
			for(CompensationRate__c rate : [SELECT Id
										    FROM CompensationRate__c 
										    WHERE RecordTypeId = :location
										    AND txt_CountryCode__c = :countryCode 
										    AND txt_CityName__c = 'Other' LIMIT 1]) {
		    	result = rate;
		    }															
		}
			
		return result;
	}
}
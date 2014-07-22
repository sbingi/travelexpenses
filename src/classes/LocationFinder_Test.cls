@isTest
private class LocationFinder_Test {
	
	static {
		CustomSettings.addDefault();
	}


	@isTest
	private static void succeedsWhenCorrectLocationIsReturned() {
		// Setup
		CompensationRate__c existingLocation1 = insertLocation('Deutschland(Stuttgart)', 'Deutschland','Stuttgart', 'DE');
		CompensationRate__c existingLocation2 = insertLocation('Deutschland(Other)', 'Deutschland', 'Other', 'DE');
		CompensationRate__c existingLocation3 = insertLocation('Afghanistan', 'Afghanistan', null, 'AF');
		CompensationRate__c existingLocation4 = insertLocation('Frankreich', 'Frankreich', null, 'FA');
		
		String inputCity = 'Kabul';
		String inputCountry = 'AF';
		
		
		// Exercise
		Id resultLocationId = LocationFinder.findLocation(inputCity,inputCountry);

		
		// Verify
		System.assertEquals(existingLocation3.id, resultLocationId);
	}
	
	
	@isTest
	private static void succeedsWhenCorrectLocationIsReturnedForMultipleSameCountryLocations() {
		// Setup
		CompensationRate__c existingLocation1 = insertLocation('Deutschland(Stuttgart)', 'Deutschland','Stuttgart', 'DE');
		CompensationRate__c existingLocation2 = insertLocation('Deutschland(Other)', 'Deutschland', 'Other', 'DE');
		CompensationRate__c existingLocation3 = insertLocation('Afghanistan', 'Afghanistan', null, 'AF');
		CompensationRate__c existingLocation4 = insertLocation('Frankreich', 'Frankreich', null, 'FA');
		CompensationRate__c existingLocation5 = insertLocation('Deutschland(M?nchen)', 'Deutschland', 'M?nchen', 'DE');
		
		String inputCity = 'Stuttgart';
		String inputCountry = 'DE';
		
		
		// Exercise
		Id resultLocationId = LocationFinder.findLocation(inputCity,inputCountry);
		
		
		
		// Verify
		System.assertEquals(existingLocation1.id, resultLocationId);
	}
	
	
	@isTest
	private static void succeedsWhenRemainderLocationIsReturnedForMultipleSameCountryLocations() {
		// Setup
		CompensationRate__c existingLocation1 = insertLocation('Deutschland(Stuttgart)', 'Deutschland','Stuttgart', 'DE');
		CompensationRate__c existingLocation2 = insertLocation('Deutschland(Other)', 'Deutschland', 'Other', 'DE');
		CompensationRate__c existingLocation3 = insertLocation('Afghanistan', 'Afghanistan', null, 'AF');
		
		String inputCity = 'M?nchen';
		String inputCountry = 'DE';
		
		
		// Exercise
		Id resultLocationId = LocationFinder.findLocation(inputCity,inputCountry);
		
		
		
		//Verify
		System.assertEquals(existingLocation2.id, resultLocationId);
	}
	
	
	@isTest
	private static void succeedsWhenNoLocationIsReturned() {
		// Setup
		CompensationRate__c existingLocation1 = insertLocation('Deutschland(Stuttgart)', 'Deutschland','Stuttgart', 'DE');
		CompensationRate__c existingLocation2 = insertLocation('Deutschland(Other)', 'Deutschland', 'Other', 'DE');
		CompensationRate__c existingLocation3 = insertLocation('Afghanistan', 'Afghanistan', null, 'AF');
		CompensationRate__c existingLocation4 = insertLocation('Frankreich', 'Frankreich', null, 'FA');
		
		String inputCity = 'Rom';
		String inputCountry = 'IT';
		
		
		// Exercise
		Id resultLocationId = LocationFinder.findLocation(inputCity,inputCountry);
		
		
		// Verify
		System.assertEquals(null, resultLocationId);
	}
	
	
	// TEST HELPER
	private static CompensationRate__c insertLocation(String name, String country, String city,  String countryCode) {
		CompensationRate__c result = new CompensationRate__c(Name = name,
                                                             txt_CountryName__c = country,	
                                                             txt_CityName__c = city,
															 txt_CountryCode__c = countryCode,
															 cur_FullDailyRate__c =50,
															 cur_PartialDailyRate__c =25,
															 cur_OvernightStayRate__c =60);
		insert result;
		
		return result;
	}  
}
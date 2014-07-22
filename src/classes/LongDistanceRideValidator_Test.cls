@isTest
private class LongDistanceRideValidator_Test {
	
	static {
		CustomSettings.addDefault();
	}
	
	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	private static final DateTime TODAY_NOW = System.now();
	private static final DateTime TOMORROW_NOW = TODAY_NOW.addDays(1);
	
	
	@isTest
	private static void succeedsWhenLongDistanceRideCannotEndBeforeStart() {
		// Setup
		String expectedMessage = 'Long Distance Ride cannot end before it started.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,TOMORROW_NOW)
										 .addRentalVehicleWithLongDistanceRide( DAY_TODAY, DAY_TOMORROW, 
										 										TOMORROW_NOW.addDays(1), TODAY_NOW.addDays(-1) )
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}

		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenLongDistanceRidesCannotBeOutOfRentalPeriod() {
		// Setup
		String expectedMessage = 'The Long Distance Ride cannot be outside of the rental period.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,TOMORROW_NOW)
										 .addRentalVehicleWithLongDistanceRide( DAY_TODAY, DAY_TOMORROW, 
										 										TODAY_NOW.addDays(-1), TOMORROW_NOW.addDays(1) )
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenLongDistanceRidesCannotOverlapWithExpenses() {
		// Setup
		String expectedMessage = 'Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										 .addDefaultFlight(TODAY_NOW, TODAY_NOW.addHours(3))										 
										 .addRentalVehicleWithLongDistanceRide(DAY_TODAY,DAY_TOMORROW,
										 									   TODAY_NOW.addHours(2),TOMORROW_NOW)
										 .create();							 
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenLongDistanceRidesCannotOverlapWithLongDistanceRides() {
		// Setup
		String expectedMessage = 'Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										 .addRentalVehicleWithTwoLongDistanceRides(DAY_TODAY,DAY_TOMORROW,
										 										   TODAY_NOW,TODAY_NOW.addHours(5),
										 										   TODAY_NOW.addHours(4),TOMORROW_NOW)
										 .create();							 
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenLongDistanceRideCannotBeInsertedWithoutValidLocation() {
		// Setup
		String expectedMessage = 'Unknown location, please choose a location from the autocomplete drop-down list.';
		Exception expectedException;
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										 .addRentalVehicleWithLongDistanceRideWithoutLocation(DAY_TODAY,DAY_TOMORROW,
										 										   			  TODAY_NOW,TODAY_NOW.addHours(5))
										 .create();			
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}


	// TEST HELPER
	private static void assertThrowsMessage(String errorMessage) {
		Boolean result = false;
		
		for(ApexPages.Message m : ApexPages.getMessages()) {
			if(m.getDetail().equals(errorMessage)) {
				result = true;
			}
		}
		
		System.assert(result);
	}
}
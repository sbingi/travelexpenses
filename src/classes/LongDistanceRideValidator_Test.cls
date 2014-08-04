@isTest
private class LongDistanceRideValidator_Test {
	
	static {
		CustomSettings.addDefault();
	}
	
	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	private static final DateTime TODAY_NOW = System.now();
	private static final DateTime TOMORROW_NOW = TODAY_NOW.addDays(1);
	private static final DateTime DAY_AFTER_TOMORROW_NOW = TODAY_NOW.addDays(2);
	
	
	// TESTING: LongDistanceRideCannotEndBeforeStart
	
	@isTest
	private static void succeedsWhenLongDistanceRideCannotEndBeforeStart() {
		// Setup
		String expectedMessage = 'Long Distance Ride cannot end before it started.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,TOMORROW_NOW)
										 .addRentalVehicleWithLongDistanceRide( DAY_TODAY, DAY_TOMORROW, 
										 										TOMORROW_NOW, TODAY_NOW)
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
	private static void succeedsWhenRoundTripCannotEndBeforeStart() {
		// Setup
		String expectedMessage = 'Long Distance Ride cannot end before it started.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,TOMORROW_NOW)
										 .addRentalVehicleWithRoundTripLongDistanceRide( DAY_TODAY, DAY_TOMORROW, 
										 												 TODAY_NOW, TODAY_NOW.addHours(2),
										 												 TOMORROW_NOW, TOMORROW_NOW.addHours(-3))
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}

		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	// TESTING: LongDistanceRideCannotBeOutOfRental
	
	@isTest
	private static void succeedsWhenLongDistanceRidesCannotBeOutOfRentalPeriod() {
		// Setup
		String expectedMessage = 'The Long Distance Ride cannot be outside of the rental period.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,DAY_AFTER_TOMORROW_NOW)
										 .addRentalVehicleWithLongDistanceRide( DAY_TODAY, DAY_TOMORROW, 
										 										TODAY_NOW, DAY_AFTER_TOMORROW_NOW)
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
	private static void succeedsWhenRoundTripCannotBeOutOfRentalPeriod() {
		// Setup
		String expectedMessage = 'The Long Distance Ride cannot be outside of the rental period.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,DAY_AFTER_TOMORROW_NOW)
										 .addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW, 
										 												TODAY_NOW, TOMORROW_NOW,
										 												TOMORROW_NOW.addHours(1),DAY_AFTER_TOMORROW_NOW)
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	// TESTING: LongDistanceRidesDontOverlap
	
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
	private static void succeedsWhenLongDistanceRideCannotOverlapWithOwnRoundTrip() {
				// Setup
		String expectedMessage = 'Long Distance Ride overlaps with own round trip.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										 .addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY,DAY_TOMORROW,
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
	private static void succeedsWhenRoundTripCannotOverlapWithExpense() {
		// Setup
		String expectedMessage = 'Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										 .addDefaultFlight(TODAY_NOW.addHours(5), TODAY_NOW.addHours(8))										 
										 .addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY,DAY_TOMORROW,
										 									   			TODAY_NOW, TODAY_NOW.addHours(3),
										 									   			TODAY_NOW.addHours(6),TOMORROW_NOW)
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
	private static void succeedsWhenRoundTripCannotOverlapWithLongDistanceRide() {
		// Setup
		String expectedMessage = 'Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										 .addRentalVehicleWithLongDistanceRide(DAY_TODAY,DAY_TODAY,
										 									   TODAY_NOW.addHours(5),TODAY_NOW.addHours(7))										 
										 .addRentalVehicleWithRoundTripLongDistanceRide(DAY_TOMORROW,DAY_TOMORROW,
										 									   			TODAY_NOW, TODAY_NOW.addHours(3),
										 									   			TODAY_NOW.addHours(6),TOMORROW_NOW)
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
	private static void succeedsWhenRoundTripCannotOverlapWithRoundTrip() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TODAY_NOW.addHours(6))
											    .addRoundFlight(TODAY_NOW,TODAY_NOW.addHours(1),
																TODAY_NOW.addHours(4),TODAY_NOW.addHours(5))
												.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY,DAY_TODAY,
																							   TODAY_NOW.addHours(2), TODAY_NOW.addHours(3),
											    											   TODAY_NOW.addHours(4),TODAY_NOW.addHours(5))
												.create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	// TESTING: LongDistanceRideHasValidLocation
	
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


	// TESTING: LongDistanceRideCannotBeOutsideOfTravel
	
	@isTest
	private static void succeedsWhenLongDistanceRideCannotBeOutOfTravelPeriod() {
		// Setup
		String expectedMessage = 'Long Distance Ride is outside of travel period.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,TOMORROW_NOW)
												.addRentalVehicleWithLongDistanceRide(DAY_TODAY,DAY_TOMORROW,
																					  TODAY_NOW.addHours(-1), DAY_AFTER_TOMORROW_NOW)
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
	private static void succeedsWhenRoundTripCannotBeOutOfTravelPeriod() {
		// Setup
		String expectedMessage = 'Long Distance Ride is outside of travel period.';
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW,TOMORROW_NOW)
												.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY,DAY_TOMORROW,
																							   TODAY_NOW, TODAY_NOW.addHours(3),
																							   TOMORROW_NOW.addHours(1), TOMORROW_NOW.addHours(2))
												.create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	// TESTING: LongDistanceRideNeedsReturnInfoWhenRT
	
	@isTest
	private static void succeedsWhenThereIsAlwaysReturnInformationWhenRoundTripIsChecked() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Return departure time is missing';
		String expectedMessage2 = 'Return arrival time is missing.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
												.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW,
																							   TODAY_NOW, TODAY_NOW.addHours(3),
																							   null, null)
										.create();
		}
		catch(Exception e) {
			expectedException = e;
		}						
			
									
		// Verify	
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
		assertThrowsMessage(expectedMessage2);
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
@isTest
private class LongDistanceRideValidator_Test {
	
	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	private static final DateTime TODAY_NOW = System.now();
	private static final DateTime TOMORROW_NOW = TODAY_NOW.addDays(1);
	private static final DateTime DAY_AFTER_TOMORROW_NOW = TODAY_NOW.addDays(2);
	
	static {
		CustomSettings.addDefault();
	}
	
	
	// TESTING: LongDistanceRideCannotEndBeforeStart
	
	@isTest
	private static void failsWhenLongDistanceRideEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW,TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TOMORROW_NOW, TODAY_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride cannot end before it started.');
	}
	
	
	@isTest
	private static void failsWhenRoundTripEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW,TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide( DAY_TODAY, DAY_TOMORROW, TODAY_NOW, TODAY_NOW.addHours(2), TOMORROW_NOW, TOMORROW_NOW.addHours(-3));
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage('Long Distance Ride cannot end before it started.');
	}
	
	
	// TESTING: LongDistanceRideCannotBeOutOfRental
	
	@isTest
	private static void failsWhenLongDistanceRideIsOutsideOfRentalPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW,DAY_AFTER_TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide( DAY_TODAY, DAY_TOMORROW, TODAY_NOW, DAY_AFTER_TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('The Long Distance Ride cannot be outside of the rental period.');
	}
	
	
	@isTest
	private static void failsWhenRoundTripIsOutsideOfRentalPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW,DAY_AFTER_TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW, TOMORROW_NOW, TOMORROW_NOW.addHours(1), DAY_AFTER_TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('The Long Distance Ride cannot be outside of the rental period.');
	}
	
	
	// TESTING: LongDistanceRidesDontOverlap
	
	@isTest
	private static void failsWhenLongDistanceRideOverlapsWithAnotherMovement() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addDefaultFlight(TODAY_NOW, TODAY_NOW.addHours(3));										 
			builder.addRentalVehicleWithLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW.addHours(2), TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage('Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.');
	}
	
	
	@isTest
	private static void failsWhenLongDistanceRideOverlapsWithAnotherOne() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithTwoLongDistanceRides(DAY_TODAY, DAY_TOMORROW, TODAY_NOW,TODAY_NOW.addHours(5), TODAY_NOW.addHours(4), TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.');
	}
	
	
	@isTest
	private static void failsWhenLongDistanceRideOverlapsWithOwnRoundTrip() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW,TODAY_NOW.addHours(5), TODAY_NOW.addHours(4), TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride overlaps with own round trip.');
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherMovement() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addDefaultFlight(TODAY_NOW.addHours(5), TODAY_NOW.addHours(8));										 
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW, TODAY_NOW.addHours(3), TODAY_NOW.addHours(6), TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.');
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherLongDistanceRide() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(DAY_TODAY, DAY_TODAY, TODAY_NOW.addHours(5), TODAY_NOW.addHours(7));										 
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TOMORROW, DAY_TOMORROW, TODAY_NOW, TODAY_NOW.addHours(3), TODAY_NOW.addHours(6), TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.');
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherRoundTrip() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TODAY_NOW.addHours(6));
		
		
		// Exercise
		try {
			builder.addRoundFlight(TODAY_NOW, TODAY_NOW.addHours(1), TODAY_NOW.addHours(4), TODAY_NOW.addHours(5));
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TODAY, TODAY_NOW.addHours(2), TODAY_NOW.addHours(3), TODAY_NOW.addHours(4), TODAY_NOW.addHours(5));
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.');
	}
	
	
	// TESTING: LongDistanceRideHasValidLocation
	
	@isTest
	private static void failsWhenLongDistanceRideHasInvalidLocation() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRideWithoutLocation(DAY_TODAY, DAY_TOMORROW, TODAY_NOW, TODAY_NOW.addHours(5));
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Unknown location, please choose a location from the autocomplete drop-down list.');
	}


	// TESTING: LongDistanceRideCannotBeOutsideOfTravel
	
	@isTest
	private static void failsWhenLongDistanceRideIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW.addHours(-1), DAY_AFTER_TOMORROW_NOW);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride is outside of travel period.');
	}
	
	
	@isTest
	private static void failsWhenRoundTripIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW, TODAY_NOW.addHours(3), TOMORROW_NOW.addHours(1), TOMORROW_NOW.addHours(2));
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Long Distance Ride is outside of travel period.');
	}
	
	
	// TESTING: LongDistanceRideNeedsReturnInfoWhenRT
	
	@isTest
	private static void failsWhenRoundTripInformationIsMissing() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY, DAY_TOMORROW, TODAY_NOW, TODAY_NOW.addHours(3), null, null);
		}
		catch(Exception ex) {
			expectedException = ex;
		}						
			
									
		// Verify	
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage('Return departure time is missing');
		assertThrowsMessage('Return arrival time is missing.');
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
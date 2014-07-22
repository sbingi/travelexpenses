@isTest
private class ExpenseValidator_Test {
	
	static {
		CustomSettings.addDefault();
	}
	
	private static final Date TRAVEL_BEGIN = System.today();
	
	private static final DateTime BEGIN_ONE_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(01,00,00,00));
	private static final DateTime BEGIN_TWO_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(02,00,00,00));
	private static final DateTime BEGIN_FIVE_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(05,00,00,00));
	private static final DateTime BEGIN_SIX_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(06,00,00,00));
	
	
	// TESTING ExpenseCannotBeOutsideOFTravelPeriod
	@isTest
	private static void succeedsWhenMovementExpenseCannotbeOutOfTravelPeriod() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense is outside of travel period.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addDefaultFlight(BEGIN_FIVE_AM.addDays(-1),BEGIN_SIX_AM.addDays(1))
										 .create();
		}	
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}

	
	@isTest
	private static void succeedsWhenLocalExpenseCannotOutOfTravelPeriod() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense is outside of travel period.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addDefaultMiscellaneousExpense(TRAVEL_BEGIN.addDays(1))
										 .create();
		}	
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}	

	
	@isTest
	private static void succeedsWhenAccommodationExpenseCannotOutOfTravelPeriod() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense is outside of travel period.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addDefaultAccommodation(TRAVEL_BEGIN.addDays(-1),TRAVEL_BEGIN.addDays(1))
										 .create();
		}	
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}	

	
	@isTest
	private static void succeedsWhenRentalVehicleExpenseCannotOutOfTravelPeriod() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense is outside of travel period.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addDefaultRentalVehicle(TRAVEL_BEGIN.addDays(-1),TRAVEL_BEGIN.addDays(1))
										 .create();
		}	
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}
	

	// TESTING ExpenseCannotEndBeforeStart
	@isTest
	private static void succeedsWhenMovementExpenseCannotEndBeforeStart() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense cannot end before it started.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addDefaultFlight(BEGIN_SIX_AM, BEGIN_FIVE_AM)
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenAccommodationExpenseCannotEndBeforeStart() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense cannot end before it started.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM.addDays(-1), BEGIN_SIX_AM)
										 .addDefaultAccommodation(TRAVEL_BEGIN, TRAVEL_BEGIN.addDays(-1))
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenRentalVehicleExpenseCannotEndBeforeStart() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense cannot end before it started.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM.addDays(-1), BEGIN_SIX_AM)
										 .addDefaultRentalVehicle(TRAVEL_BEGIN, TRAVEL_BEGIN.addDays(-1))
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}

	
	// TESTING ExpenseHasValidLocation
	@isTest
	private static void succeedsWhenMovementExpenseCannotHaveInvalidLocation() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Unknown location, please choose a location from the autocomplete drop-down list.';
		
		// Exercise
		Try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										.addDefaultFlightWithoutLocation(BEGIN_FIVE_AM,BEGIN_SIX_AM)
										.create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}

	
	@isTest
	private static void succeedsWhenAccommodationExpenseCannotHaveInvalidLocation() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Unknown location, please choose a location from the autocomplete drop-down list.';
		
		// Exercise
		Try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM.addDays(1))
										.addAccommodationWithoutLocation(TRAVEL_BEGIN,TRAVEL_BEGIN.addDays(1))
										.create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}	
	
	
	@isTest
	private static void succeedsWhenEntertainmentExpenseCannotHaveInvalidLocation() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Unknown location, please choose a location from the autocomplete drop-down list.';
		
		// Exercise
		Try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM.addDays(1))
										.addEntertainmentWithoutLocation(TRAVEL_BEGIN)
										.create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	// TESTING ExpenseNeedsReturnInformationIfRoundTrip
	@isTest
	private static void succeedsWhenThereIsAlwaysReturnInformationWhenRoundTripIsChecked() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Return departure time is missing';
		String expectedMessage2 = 'Return arrival time is missing.';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										.addRoundFlight(BEGIN_TWO_AM, BEGIN_FIVE_AM,
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
	
	
	// TESTING ExpensesDontOverlap
	@isTest
	private static void succeedsWhenExpensesCannotOverlapAtBegin() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense overlaps with an existing movement( flight, train ride, private or company vehicle ride, rental vehicle ride).';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_TWO_AM,BEGIN_SIX_AM)
										 .addDefaultFlight(BEGIN_ONE_AM, BEGIN_FIVE_AM)										 
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}


	@isTest
	private static void succeedsWhenExpensesCannotOverlapAtEnd() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense overlaps with an existing movement( flight, train ride, private or company vehicle ride, rental vehicle ride).';
		
		
		// Exercise
		try {
		Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
					    		  .addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_ONE_AM,BEGIN_FIVE_AM)
								  .addDefaultFlight(BEGIN_TWO_AM, BEGIN_SIX_AM)	
					    		  .create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}
	
	
	@isTest
	private static void succeedsWhenExpensesCannotContainOtherExpenses() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense overlaps with an existing movement( flight, train ride, private or company vehicle ride, rental vehicle ride).';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
										 .addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_ONE_AM,BEGIN_SIX_AM)
  										 .addDefaultFlight(BEGIN_TWO_AM, BEGIN_FIVE_AM)										 
										 .create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}

	
	@isTest
	private static void succeedsWhenExpensesCannotBeContainedByOtherExpenses() {
		// Setup
		Exception expectedException;
		String expectedMessage = 'Expense overlaps with an existing movement( flight, train ride, private or company vehicle ride, rental vehicle ride).';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM)
									  .addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_TWO_AM,BEGIN_FIVE_AM)
									  .addDefaultFlight(BEGIN_ONE_AM, BEGIN_SIX_AM)									  
									  .create();
		}
		catch(Exception e) {
			expectedException = e;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(expectedMessage);
	}

	
	//TEST HELPER
	private static DateTime dateTime(Date day, Time myTime) {
		DateTime result = DateTime.newInstance(day,myTime);
		
		return result;
	}
	
	
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
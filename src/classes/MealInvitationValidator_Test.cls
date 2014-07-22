@isTest
private class MealInvitationValidator_Test {
	
	static {
		CustomSettings.addDefault();
	}

	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	
	
	@isTest
	private static void acceptValidMealInvitation() {
		// Setup
		Exception unexpectedException;
		String message = '';
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(DAY_TODAY,DAY_TOMORROW)
										.addMealInvitation(DAY_TODAY, true, true, true)
										.addMealInvitation(DAY_TOMORROW, false, false, false)
										.create();
		}
		catch(DMLException e) {
			unexpectedException = e;
			message = unexpectedException.getStackTraceString();
		}
									
		
		// Verify
		System.assertEquals(null,unexpectedException,message);
	}
	
	
	@isTest
	private static void forbidMealInvitationOutOfTravel() {
		// Setup
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(DAY_TODAY,DAY_TOMORROW)
										.addMealInvitation(DAY_TODAY.addDays(-1), false, false, true)
										.addMealInvitation(DAY_TOMORROW.addDays(1), true, true, false)
										.create();
		}
		catch(DMLException e) {
			expectedException = e;
		}
									
		
		// Verify
		System.assertNotEquals(null,expectedException);
	}
	
	
	@isTest
	private static void forbidDuplicateDatesInSameTravel() {
		// Setup
		Exception expectedException;
		
		
		// Exercise
		try {
			Travel__c travel = new TravelBuilder(DAY_TODAY,DAY_TOMORROW)
										.addMealInvitation(DAY_TODAY, false, false, true)
										.addMealInvitation(DAY_TODAY, true, true, false)
										.create();
		}
		catch(DMLException e) {
			expectedException = e;
		}
									
		
		// Verify
		System.assertNotEquals(null,expectedException);
	}
}
@isTest
private class ExpensesTriggerHandler_Test {
	
	static {
		CustomSettings.addDefault();
	}

	private static final DateTime TRAVEL_BEGIN = dateTime(System.today(), Time.newInstance(12,00,00,00));
	private static final DateTime TRAVEL_END = dateTime(System.today().addDays(3), Time.newInstance(20,00,00,00));
	
	
	@isTest
	private static void succeedsWhenCorrectCorrectExpenseDateIsInitialized() {
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									.addDefaultFlight(TRAVEL_BEGIN,TRAVEL_BEGIN.addHours(3))
									.addDefaultAccommodation(TRAVEL_BEGIN.date(), TRAVEL_BEGIN.date().addDays(1))
									.addDefaultRentalVehicle(TRAVEL_BEGIN.date().addDays(1),TRAVEL_END.date())
									.create();
							
									
		// Verify
		Date flightExpenseDate = findFlightExpense(travel.Id).dat_ExpenseDate__c;
		Date accommodationExpenseDate = findAccommodationExpense(travel.Id).dat_ExpenseDate__c;
		Date rentalVehicleExpenseDate = findRentalVehicleExpense(travel.Id).dat_ExpenseDate__c;
		
		System.assertEquals(TRAVEL_BEGIN.date(), flightExpenseDate);
		System.assertEquals(TRAVEL_BEGIN.date().addDays(1), accommodationExpenseDate);
		System.assertEquals(TRAVEL_END.date(),RentalvehicleExpenseDate);
	}
	
	
	@isTest
	private static void succeedsWhenCorrectAmountIsInitialized() {
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									.addDefaultPrivateVehicleRide(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(5),100)
									.addDefaultEntertainment(TRAVEL_END.date(), 50, 20)
									.create();
									
									
		// Verify
		Decimal privateVehicleRideAmount = findPrivateVehicleRideExpense(travel.Id).cur_Amount__c;
		Decimal entertainmentAmount = findEntertainmentExpense(travel.Id).cur_Amount__c;
		
		System.assertEquals(30, privateVehicleRideAmount);
		System.assertEquals(70, entertainmentAmount);
	}
	
	
	@isTest
	private static void succeedsWhenCorrectReimbursementIsInitialized() {
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									 .addDefaultPrivateVehicleRide(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(5),100)
									 .addDefaultCompanyVehicleRide(TRAVEL_END.addHours(-2), TRAVEL_END)
									 .create();
									 
									 
		// Verify
		String privateVehicleReimbursement = findPrivateVehicleRideExpense(travel.Id).pkl_Reimbursement__c;
		String companyVehicleReimbursement = findCompanyVehicleRideExpense(travel.Id).pkl_Reimbursement__c;
		
		System.assertEquals('I paid for this, please reimburse me.', privateVehicleReimbursement);
		System.assertEquals('The company paid for this.', companyVehicleReimbursement);
	}
	
	
	@isTest
	private static void succeedsWhenCorrectReturnTripExpenseIsCreatedOnInsert() {
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									.addRoundFlight(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(3),
													TRAVEL_END.addHours(-3), TRAVEL_END)
									.create();
								
									
		// Verify	
		List<Expense__c> flights = findFlightExpenses(travel.Id);
		
		System.assert(flights.size() == 2);
		System.assertEquals(TRAVEL_END.addHours(-3), determineReturnFlight(flights).dtm_DepartureTime__c);
		System.assertEquals(TRAVEL_END, determineReturnFlight(flights).dtm_ArrivalTime__c);			
	}
	
	
	@isTest
	private static void succeedsWhenCorrectReturnTripExpenseIsDeletedOnDelete() {
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
									.addRoundFlight(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(3),
													TRAVEL_END.addHours(-3), TRAVEL_END)
									.create();
		
		
		// Exercise
		deleteOutgoingFlight(travel.Id);
		
		
		// Verify
		System.assertEquals(0,findFlightExpenses(travel.Id).size());
	}
	
	
	@isTest
	private static void succeedsWhenCorrectReturnTripExpenseIsCreatedOnUpdate() {
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
									.addRoundFlight(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(3),
													TRAVEL_END.addHours(-3), TRAVEL_END)
									.create();
									
		
		// Exercise 
		updateOutgoingFlight(travel.Id, TRAVEL_END.addHours(-4), TRAVEL_END.addHours(-1));
		
		
		// Verify 
		List<Expense__c> flights = findFlightExpenses(travel.Id);
		
		System.assert(flights.size() == 2);
		System.assertEquals(TRAVEL_END.addHours(-4), determineReturnFlight(flights).dtm_DepartureTime__c);
		System.assertEquals(TRAVEL_END.addHours(-1), determineReturnFlight(flights).dtm_ArrivalTime__c);
	}
	
	
	// TEST HELPER
	private static DateTime dateTime(Date day, Time myTime) {
		DateTime result = DateTime.newInstance(day,myTime);
		
		return result;
	}
	
	
	private static Expense__c findFlightExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getFlightRecordTypeId())[0];
		
		return result;
	}
	
	
	private static List<Expense__c> findFlightExpenses(Id travelId) {
		List<Expense__c> results = searchExpense(travelId,ExpenseType.getFlightRecordTypeId());
		
		return results;
	}
	
	
	private static Expense__c findAccommodationExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getAccommodationRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findRentalVehicleExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getRentalVehicleRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findPrivateVehicleRideExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getPrivateVehicleRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findCompanyVehicleRideExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getCompanyVehicleRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findEntertainmentExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getEntertainmentRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findPerDiemExpense(Id travelId) {
		Expense__c result = searchExpense(travelId,ExpenseType.getPerDiemRecordTypeId())[0];
		
		return result;
	}
	
	
	private static List<Expense__c> searchExpense(Id travelId, Id recordTypeId) {
		List<Expense__c> results = [SELECT Id,RecordTypeId,dat_ExpenseDate__c,dtm_DepartureTime__c,dtm_ArrivalTime__c,
										   cur_Amount__c,lkp_ReturnTrip__c,chk_RoundTrip__c, pkl_Reimbursement__c
							 		FROM Expense__c
							 		WHERE RecordTypeId = :recordTypeId
							 		AND mdr_Travel__c = :travelId];
		
		return results;
	}
	
	
	private static Expense__c determineReturnFlight(List<Expense__c> expenses) {
		Expense__c result;
		if(expenses[0].chk_RoundTrip__c) {
			result = expenses[1];
		}
		else if(expenses[1].chk_RoundTrip__c) {
			result = expenses[0];
		}
	
		return result;
	}
	
	
	private static void deleteOutgoingFlight(Id travelId) {
		for(Expense__c e : findFlightExpenses(travelId)) {
			if(e.chk_RoundTrip__c) {
				delete e;
			}
		}
	}
	
	
	private static void updateOutgoingFlight(Id travelId, DateTime changedDeparture, DateTime changedArrival) {
		for(Expense__c e : findFlightExpenses(travelId)) {
			if(e.chk_RoundTrip__c) {
				e.dtm_ReturnDeparture__c = changedDeparture;
				e.dtm_ReturnArrival__c = changedArrival;
				update e;				
			}
		}
	}
}
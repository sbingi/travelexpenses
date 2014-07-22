@isTest
private class ExpenseType_Test {
	
	static {
		CustomSettings.addDefault();
	}

	private static final Id FLIGHT_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Flight'].Id;
	private static final Id TRAIN_RIDE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'TrainRide'].Id;
	private static final Id SEA_TRAVEL_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'SeaTravel'].Id;
	private static final Id PRIVATE_VEHICLE_RIDE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'PrivateVehicleRide'].Id;
	private static final Id COMPANY_VEHICLE_RIDE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'CompanyVehicleRide'].Id;
	
	private static final Id RENTAL_VEHICLE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'RentalVehicle'].Id;
	private static final Id ACCOMMODATION_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Accommodation'].Id;
	private static final Id ENTERTAINMENT_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Entertainment'].Id;
	private static final Id MISCELLANEOUS_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Miscellaneous'].Id;
	
	private static final Id PER_DIEM_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'perDiem'].Id;


	@isTest
	private static void succeedsWhenMovementIsFound() {
		//Setup
		Set<Id> correctSet = new Set<Id>();
		correctSet.add(FLIGHT_ID);
		correctSet.add(TRAIN_RIDE_ID);
		correctSet.add(SEA_TRAVEL_ID);
		correctSet.add(PRIVATE_VEHICLE_RIDE_ID);
		correctSet.add(COMPANY_VEHICLE_RIDE_ID);
		
		
		//Excercise
		Set<Id> compareSet = ExpenseType.getMovementRecordTypeIds();
		
		//Verify
		System.assertEquals(correctSet, compareSet);
	}
	
	
	@isTest
	private static void succeedsWhenFlightIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getFlightRecordTypeId();
		
		
		// Verify 
		System.assertEquals(FLIGHT_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenPrivateVehicleIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getPrivateVehicleRecordTypeId();
		
		
		// Verify 
		System.assertEquals(PRIVATE_VEHICLE_RIDE_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenCompanyVehicleIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getCompanyVehicleRecordTypeId();
		
		
		// Verify 
		System.assertEquals(COMPANY_VEHICLE_RIDE_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenTrainRideIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getTrainRideRecordTypeId();
		
		
		// Verify 
		System.assertEquals(TRAIN_RIDE_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenRentalVehicleIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getRentalVehicleRecordTypeId();
		
		
		// Verify 
		System.assertEquals(RENTAL_VEHICLE_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenAccommodationExpenseIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getAccommodationRecordTypeId();
		
		
		// Verify 
		System.assertEquals(ACCOMMODATION_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenEntertainmentExpenseIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getEntertainmentRecordTypeId();
		
		
		// Verify 
		System.assertEquals(ENTERTAINMENT_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenMiscellaneousExpenseIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getMiscellaneousRecordTypeId();
		
		
		// Verify 
		System.assertEquals(MISCELLANEOUS_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenPerDiemExpenseIsFound() {
		// Setup
				
				
		// Exercise		
		Id returnedId = ExpenseType.getPerDiemRecordTypeId();
		
		
		// Verify 
		System.assertEquals(PER_DIEM_ID, returnedId);
	}
	
	
	@isTest
	private static void succeedsWhenCorrectNameIsFoundForId() {
		// Setup
		
		
		// Exercise
		String flight = ExpenseType.getRecordTypeName(FLIGHT_ID);
		String trainRide = ExpenseType.getRecordTypeName(TRAIN_RIDE_ID);
		String privateVehicleRide = ExpenseType.getRecordTypeName(PRIVATE_VEHICLE_RIDE_ID);
		String companyVehicleRide = ExpenseType.getRecordTypeName(COMPANY_VEHICLE_RIDE_ID);
		String seaTravel = ExpenseType.getRecordTypeName(SEA_TRAVEL_ID);
		
		String accommodation = ExpenseType.getRecordTypeName(ACCOMMODATION_ID);
		String rentalVehicle = ExpenseType.getRecordTypeName(RENTAL_VEHICLE_ID);
		String miscellaneous = ExpenseType.getRecordTypeName(MISCELLANEOUS_ID);
		String entertainment = ExpenseType.getRecordTypeName(ENTERTAINMENT_ID);
		
		String perDiem = ExpenseType.getRecordTypeName(PER_DIEM_ID);
		
		
		// Verify
		System.assertEquals('Flight', flight);
		System.assertEquals('TrainRide',trainRide);
		System.assertEquals('PrivateVehicleRide',privateVehicleRide);
		System.assertEquals('CompanyVehicleRide',companyVehicleRide);
		System.assertEquals('SeaTravel',seaTravel);
		
		System.assertEquals('Accommodation',accommodation);
		System.assertEquals('RentalVehicle',rentalVehicle);
		System.assertEquals('Miscellaneous',miscellaneous);
		System.assertEquals('Entertainment',entertainment);
		
		System.assertEquals('perDiem',perDiem);
	}
}
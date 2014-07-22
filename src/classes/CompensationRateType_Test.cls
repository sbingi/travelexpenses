@isTest
private class CompensationRateType_Test {
	
	static {
		CustomSettings.addDefault();
	}
	
	private static final Id LOCATION_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Location'].Id;
	private static final Id VEHICLE_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Vehicle'].Id;
	private static final Id MEAL_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Meal'].Id;
	
	
	@isTest
	private static void succeedsWhenLocationIsFound() {
		// Setup
		
		
		// Exercise
		Boolean foundLocation = CompensationRateType.isLocation(LOCATION_ID);
		Id foundId = CompensationRateType.getLocationId();
		
		
		// Verify
		System.assertEquals(true, foundLocation);
		System.assertEquals(LOCATION_ID, foundId);
	}
	
	
	@isTest
	private static void succeedsWhenVehicleIsFound() {
		// Setup
		
		
		// Exercise
		Boolean foundVehicle = CompensationRateType.isVehicle(VEHICLE_ID);
		Id foundId = CompensationRateType.getVehicleId();
		
		
		// Verify
		System.assertEquals(true, foundVehicle);
		System.assertEquals(VEHICLE_ID, foundId);
	}
	
	
	@isTest
	private static void succeedsWhenMealIsFound() {
		// Setup
		
		
		// Exercise
		Boolean foundMeal = CompensationRateType.isMeal(MEAL_ID);
		Id foundId = CompensationRateType.getMealId();
		
		
		// Verify
		System.assertEquals(true, foundMeal);
		System.assertEquals(MEAL_ID, foundId);
	}
	
	
	@isTest
	private static void succeedsWhenCorrectCompensationRateTypeIdIsFoundByName() {
		// Setup
		
		
		// Exercise
		String location = CompensationRateType.getRecordTypeName(LOCATION_ID);
		String vehicle = CompensationRateType.getRecordTypeName(VEHICLE_ID);
		String meal = CompensationRateType.getRecordTypeName(MEAL_ID);
		String nothing = CompensationRateType.getRecordTypeName('012F0000001CV6VIAW');
		
		
		// Verify
		System.assertEquals('Location', location);
		System.assertEquals('Vehicle', vehicle);
		System.assertEquals('Meal', meal);
		System.assertEquals(null, nothing);
	}
}
public class LongDistanceRideCannotBeOutsideOfRental implements LongDistanceRideRule {


	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<LongDistanceRide__c> rides = (List<LongDistanceRide__c>) records;
		String errorMessage = 'The Long Distance Ride cannot be outside of the rental period.';
		
		Map<Id,Expense__c> relevantRentalVehicles = queryRelevantRentalCarsById(rides);
		
		for(LongDistanceRide__c ride : rides) {
			Expense__c rentalVehicle = relevantRentalVehicles.get(ride.mdr_RentalVehicle__c);
			
			if(isOutsideOfRental(ride.dtm_DepartureTime__c, rentalVehicle)) {
				ride.dtm_DepartureTime__c.addError(errorMessage);
			}
			if(isOutsideOfRental(ride.dtm_ArrivalTime__c, rentalVehicle)) {
				ride.dtm_ArrivalTime__c.addError(errorMessage);
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id,Expense__c> queryRelevantRentalCarsById(List<LongDistanceRide__c> rides) {
		Set<Id> rentalVehicles = new Set<Id>();
		
		for(LongDistanceRide__c ride : rides){
			rentalVehicles.add(ride.mdr_RentalVehicle__c);
		}
		
		Map<Id,Expense__c> resultMap = new Map<Id,Expense__c>([SELECT dat_PickUpDate__c, dat_ReturnDate__c
															   FROM Expense__c
															   WHERE Id IN :rentalVehicles]);
															   
	   return resultMap;
	}
	
	
	private Boolean isOutsideOfRental(DateTime dtm, Expense__c e) {
    	Boolean result = dtm.date() < e.dat_PickUpDate__c || dtm.date() > e.dat_ReturnDate__c;
    	
    	return result;
    }
}
public with sharing class LongDistanceRidesDontOverlap implements LongDistanceRideRule {

	private Map<Id,Id> travelsByRentalVehicle;
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<LongDistanceRide__c> rides = (List<LongDistanceRide__c>) records;
		String errorMessage = 'Long Distance Ride overlaps with an existing Long Distance Ride or Movement Expense.';
		
        Map<Id,List<LongDistanceRide__c>> movementsByTravel = queryRelevantMovementsByTravel(rides);
        
		for(LongDistanceRide__c ride : rides) {
			Id travel = travelsByRentalVehicle.get(ride.mdr_RentalVehicle__c);
			
			List<LongDistanceRide__c> movements = movementsByTravel.get(travel);
			
			for(LongDistanceRide__c ldr : movements) {
				
				if(doOverlap(ride, ldr)) {

					if(ldr.Id == null) {
			            ride.addError(errorMessage);
			            
			            break;
					}
					else if(ride.Id != ldr.Id) {
			            ride.addError(errorMessage);
			            
			            break;
					}
				}
			}
		}   
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id,List<LongDistanceRide__c>> queryRelevantMovementsByTravel(List<LongDistanceRide__c> rides) {
    	Map<Id,List<LongDistanceRide__c>> resultMap = new Map<Id,List<LongDistanceRide__c>>();
    	
    	queryRelevantTravelsById(rides);
		
		Set<Id> movementRecordTypes = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypes.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, mdr_Travel__c, dtm_DepartureTime__c, dtm_ArrivalTime__c, 
									(SELECT Id, dtm_DepartureTime__c, dtm_ArrivalTime__c 
 		  	 						 FROM Long_Distance_Rides__r)
						    	  FROM Expense__c 
						    	  WHERE RecordTypeId IN :movementRecordTypes 
						    	  AND mdr_Travel__c IN :travelsByRentalVehicle.values()]) {
						    	  	
			Id travel = expense.mdr_Travel__c;
			
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<LongDistanceRide__c>());
			}
			
			List<LongDistanceRide__c> movements = resultMap.get(travel);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					
					movements.add(ride);
				}
			}
			else {
				LongDistanceRide__c falseLongDistanceRide = new LongDistanceRide__c();
				
				falseLongDistanceRide.dtm_DepartureTime__c = expense.dtm_DepartureTime__c;
				falseLongDistanceRide.dtm_ArrivalTime__c = expense.dtm_ArrivalTime__c;
				
				movements.add(falseLongDistanceRide);
			}	
		}
    	
    	return resultMap;
    }
    
    
    private void queryRelevantTravelsById(List<LongDistanceRide__c> rides) {
    	Set<Id> rentalVehicles = new Set<Id>();
    	
    	for(LongDistanceRide__c ride : rides) {
    		rentalVehicles.add(ride.mdr_RentalVehicle__c);
    	}
    	
    	travelsByRentalVehicle = new Map<Id,Id>();
    	
    	for(Expense__c expense : [SELECT mdr_Travel__c
    							  FROM Expense__c
    							  WHERE Id IN :rentalVehicles]) {
	  		
	  		travelsByRentalVehicle.put(expense.Id, expense.mdr_Travel__c);
		}
    }
    
    
    private Boolean doOverlap( LongDistanceRide__c ride, LongDistanceRide__c existing) {
        Boolean noOverlap = (existing.dtm_ArrivalTime__c < ride.dtm_DepartureTime__c
        				 	|| existing.dtm_DepartureTime__c > ride.dtm_ArrivalTime__c);

        return !noOverlap;
    }
}
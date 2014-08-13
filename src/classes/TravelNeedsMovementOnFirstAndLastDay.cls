public with sharing class TravelNeedsMovementOnFirstAndLastDay implements SubmitTravelRule {
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<Travel__c> newTravels = (List<Travel__c>) records;
		
<<<<<<< HEAD
		Map<Id, Set<Date>> datesWithMovements = queryDatesWithMovementExpenses(newTravels);
=======
		Map<Id, Set<Date>> datesWithMovements = queryDatesWithMovementExpenses(travels);
>>>>>>> refs/remotes/origin/master
										
<<<<<<< HEAD
		for(Travel__c travel : newTravels) {
=======
		for(Travel__c travel : travels) {
>>>>>>> refs/remotes/origin/master
			Set<Date> dates = datesWithMovements.get(travel.Id);
			
			if( dates == null ) {
				travel.addError('Your travel needs at least a movement expense on the first and last day.');
			}
			else {
				Date firstDay = travel.dtm_Start__c.date();
				Date lastDay = travel.dtm_End__c.date();
			
				if( !dates.contains(firstDay)) {
					travel.addError('Your travel needs a movement expense on the first day.');
				}
				if( !dates.contains(lastDay)) {
					travel.addError('Your travel needs a movement expense on the last day.');
				}
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id, Set<Date>> queryDatesWithMovementExpenses(List<Travel__c> travels) {
		Map<Id, Set<Date>> resultMap = new Map<Id, Set<Date>>();
		
		Set<Id> movementRecordTypeIds = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypeIds.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, dtm_DepartureTime__c, dtm_ArrivalTime__c, mdr_Travel__c,
										 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c,
										 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c,
										 		 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c
										  FROM Long_Distance_Rides__r)
								  FROM Expense__c
								  WHERE RecordTypeId IN :movementRecordTypeIds
								  AND mdr_Travel__c IN :travels]) {
								  	
			Id travel = expense.mdr_Travel__c;
								  	
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new Set<Date>());
			}
			
			Set<Date> expenseDates = resultMap.get(travel);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					expenseDates.add(ride.dtm_DepartureTime__c.date());
					expenseDates.add(ride.dtm_ArrivalTime__c.date());
					
					if(ride.chk_RoundTrip__c) {
						expenseDates.add(ride.dtm_ReturnDeparture__c.date());
						expenseDates.add(ride.dtm_ReturnArrival__c.date());
					}
				}
			}
			else {
				expenseDates.add(expense.dtm_DepartureTime__c.date());
				expenseDates.add(expense.dtm_ArrivalTime__c.date());
				
				if(expense.chk_RoundTrip__c) {
					expenseDates.add(expense.dtm_ReturnDeparture__c.date());
					expenseDates.add(expense.dtm_ReturnArrival__c.date());
				}		
			}		  	
		}
		
		return resultMap;
	}
}

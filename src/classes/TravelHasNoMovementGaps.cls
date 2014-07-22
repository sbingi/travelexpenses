public with sharing class TravelHasNoMovementGaps implements SubmitTravelRule {
	
	
	// PUBLIC METHODS

	public void validate(List<SObject> records) {
		List<Travel__c> travels = (List<Travel__c>) records;
		
		Map<Id,List<Expense__c>> movementExpensesByTravel = queryAndGroupMovementExpenses(travels);
					   			   					  
		for(Travel__c travel : travels) {
			List<Expense__c> movementExpenses = movementExpensesByTravel.get(travel.Id);
			
			if (movementExpenses != null) {
				movementExpenses = sortExpenses(movementExpenses);
				
				for(Integer i=0; i<(movementExpenses.size()-1) ;i++) {
					Expense__c expense1 = movementExpenses[i];
					Expense__c expense2 = movementExpenses[i+1];
					
					if(isGap(expense1, expense2)) {
						travel.addError('You forgot to state a movement between '+expense1.txt_To__c+' and '+expense2.txt_From__c);
					}
				}
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id,List<Expense__c>> queryAndGroupMovementExpenses(List<Travel__c> travels) {
		Map<Id,List<Expense__c>> resultMap = new Map<Id,List<Expense__c>>();
		
		Set<Id> movementRecordTypeIds = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypeIds.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, dtm_ArrivalTime__c,dtm_DepartureTime__c, lkp_LocationFrom__c, lkp_Location__c, txt_From__c, txt_To__c, mdr_Travel__c, 
										 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c, lkp_LocationFrom__c, lkp_LocationTo__c, txt_From__c, txt_To__c
										  FROM Long_Distance_Rides__r)
								  FROM Expense__c
								  WHERE RecordTypeId IN :movementRecordTypeIds
								  AND mdr_Travel__c IN :travels]) {
								  	
			Id travel = expense.mdr_Travel__c;
								  	
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<Expense__c>());
			}
			
			List<Expense__c> expenses = resultMap.get(travel);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					
					Expense__c falseExpense = new Expense__c();
		    		falseExpense.dtm_DepartureTime__c = ride.dtm_DepartureTime__c;
		    		falseExpense.dtm_ArrivalTime__c = ride.dtm_ArrivalTime__c;
		    		falseExpense.lkp_LocationFrom__c = ride.lkp_LocationFrom__c;
		    		falseExpense.lkp_Location__c = ride.lkp_LocationTo__c;
		    		falseExpense.txt_From__c = ride.txt_From__c;
		    		falseExpense.txt_To__c = ride.txt_To__c;
		    		
					expenses.add(falseExpense);		    		
				}
			}
			else {
				expenses.add(expense);
			}			
		}
		
		return resultMap;
	}
	
	
	private List<Expense__c> sortExpenses(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		Map<DateTime,Expense__c> expensesByDateTime = new Map<DateTime,Expense__c>();
		
		for(Expense__c e : expenses) {
			expensesByDateTime.put(e.dtm_DepartureTime__c, e);
		}
		
		List<DateTime> keys = new List<DateTime>(expensesByDateTime.keySet());
		keys.sort();
		
		for(DateTime dt : keys) {
			results.add(expensesByDateTime.get(dt));
		}
		
		return results;
	}
	
	
	private Boolean isGap(Expense__c firstExpense, Expense__c secondExpense) {
		return (firstExpense.lkp_Location__c != secondExpense.lkp_LocationFrom__c);
	}
}
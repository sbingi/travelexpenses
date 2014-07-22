public with sharing class ExpensesDontOverlap implements ExpenseRule {

    
    // PUBLIC METHODS
    
    public void validate(List<SObject> records) {
    	List<Expense__c> expenses = (List<Expense__c>) records;
    	String errorMessage = 'Expense overlaps with an existing movement( flight, train ride, private or company vehicle ride, rental vehicle ride).';
    	// Possible problem because inserted Expenses are not taken into account for other expenses.

    	Map<Id,List<Expense__c>> expensesByTravels = queryRelevantExpensesByTravel(expenses);
    	
    	for(Expense__c expense : expenses) {
    		
	        if(ExpenseType.isMovement(expense)) {
	        	List<Expense__c> movementExpenses = expensesByTravels.get(expense.mdr_Travel__c);
		        
		        for(Expense__c existing : movementExpenses) {
		        	
		        	if(doOverlap(expense, existing)) {
		        		
		        		if(existing.Id == null) {
		        			expense.addError(errorMessage);
		        					        		
		        			break;
		        		}
		        		else if(existing.Id != expense.Id) {
		        			expense.addError(errorMessage);
		        		
		        			break;		        			
		        		}
		        	}
		        }
	        }
    	}
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id, List<Expense__c>> queryRelevantExpensesByTravel(List<Expense__c> expenses) {
    	Map<Id, List<Expense__c>> resultMap = new Map<Id, List<Expense__c>>();
    	
    	Set<Id> movementRecordTypes = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypes.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c incomingExpense : expenses) {
			Id travel = incomingExpense.mdr_Travel__c;
			
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<Expense__c>());
			}
		}
		
		for(Expense__c expense : [SELECT Id, RecordTypeId, mdr_Travel__c, dtm_DepartureTime__c, dtm_ArrivalTime__c, 
									(SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c 
 		  	 						 FROM Long_Distance_Rides__r)
						    	  FROM Expense__c 
						    	  WHERE RecordTypeId IN :movementRecordTypes 
						    	  AND mdr_Travel__c IN :resultMap.keySet()]) {
			
			List<Expense__c> movementExpenses = resultMap.get(expense.mdr_Travel__c);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					
					Expense__c falseExpense = new Expense__c();
		    		falseExpense.dtm_DepartureTime__c = ride.dtm_DepartureTime__c;
		    		falseExpense.dtm_ArrivalTime__c = ride.dtm_ArrivalTime__c;
		    		
					movementExpenses.add(falseExpense);
				}
			}
			else {
				movementExpenses.add(expense);
			}	
		}
    	
    	return resultMap;
    }
    
    
    private Boolean doOverlap( Expense__c expense, Expense__c existing) {
        Boolean noOverlap = ( existing.dtm_ArrivalTime__c < expense.dtm_DepartureTime__c
        				 	|| existing.dtm_DepartureTime__c > expense.dtm_ArrivalTime__c );

        return !noOverlap;
    }
}
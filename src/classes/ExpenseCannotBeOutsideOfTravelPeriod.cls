public with sharing class ExpenseCannotBeOutsideOfTravelPeriod implements ExpenseRule{     
     
     // PUBLIC METHODS
     
    public void validate(List<SObject> records) {
    	String errorMessage = 'Expense is outside of travel period.';
    	List<Expense__c> expenses = (List<Expense__c>) records;

    	Map<Id,Travel__c> relevantTravels = queryRelevantTravels(expenses);
    	
		for(Expense__c expense : expenses) {
			Travel__c travel = relevantTravels.get(expense.mdr_Travel__c);
			
	        if(ExpenseType.isMovement(expense)) {
	        	
	        	if(isOutsideOfTravel(expense.dtm_DepartureTime__c,travel)) {
		            expense.dtm_DepartureTime__c.addError(errorMessage);            
	        	}
	        	if(isOutsideOfTravel(expense.dtm_ArrivalTime__c,travel)) {
	        		expense.dtm_ArrivalTime__c.addError(errorMessage);
	        	}
	        }
	        else if(ExpenseType.isAccommodation(expense)) {
	    		if(isOutsideOfTravel(expense.dat_CheckInDate__c, travel)) {
	        		expense.dat_CheckInDate__c.addError(errorMessage);     
	    		}
	    		if(isOutsideOfTravel(expense.dat_CheckOutDate__c,travel)) {
	    			expense.dat_CheckOutDate__c.addError(errorMessage);
	    		}
        	}
			else if(ExpenseType.isRentalVehicle(expense)) {
				if(isOutsideOfTravel(expense.dat_PickUpDate__c,travel)) {
					expense.dat_PickUpDate__c.addError(errorMessage);
				}
				if(isOutsideOfTravel(expense.dat_ReturnDate__c,travel)) {
					expense.dat_ReturnDate__c.addError(errorMessage);
				}				
			}
			else if((ExpenseType.isEntertainment(expense) || ExpenseType.isMiscellaneous(expense))
					&& IsOutsideOfTravel(expense.dat_ExpenseDate__c, travel)) {
				expense.dat_ExpenseDate__c.addError(errorMessage);
			}
		}
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id,Travel__c> queryRelevantTravels(List<Expense__c> expenses) {
    	Set<Id> travels = new Set<Id>();
    	
    	for(Expense__c e : expenses) {
    		travels.add(e.mdr_Travel__c);
    	}
    	
    	Map<Id,Travel__c> resultMap = new Map<Id,Travel__c>([SELECT Id, dtm_Start__c, dtm_End__c 
    														  FROM Travel__c
    														  WHERE Id IN :travels]);
    	
    	return resultMap;
    }
    
    
    private Boolean isOutsideOfTravel(Date day,Travel__c t) {
    	Boolean result = day < t.dtm_Start__c.date() || day > t.dtm_End__c.date();
        				  
        return result;
    }
    
    
    private Boolean isOutsideOfTravel(DateTime dtm, Travel__c t) {
    	Boolean result = dtm < t.dtm_Start__c || dtm > t.dtm_End__c;
    	
    	return result;
    }
}
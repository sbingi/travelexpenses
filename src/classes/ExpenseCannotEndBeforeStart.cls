public with sharing class ExpenseCannotEndBeforeStart implements ExpenseRule {
    
 
 	// PUBLIC METHODS
 	
    public void validate(List<SObject> records) {
    	String errorMessage = 'Expense cannot end before it started.';

    	for(Expense__c expense : (List<Expense__c>)records) {
    		
	        if (ExpenseType.isMovement(expense) && expense.dtm_ArrivalTime__c <= expense.dtm_DepartureTime__c) {
	        	expense.dtm_ArrivalTime__c.addError(errorMessage);
	        }
	        else if(ExpenseType.isAccommodation(expense) && expense.dat_CheckOutDate__c <= expense.dat_CheckInDate__c) {
		    	expense.dat_CheckOutDate__c.addError(errorMessage);
	        }
	        else if (ExpenseType.isRentalVehicle(expense) && expense.dat_ReturnDate__c < expense.dat_PickUpDate__c) {
	        	expense.dat_ReturnDate__c.addError(errorMessage);
	        }
    	}
    }
}
public with sharing class ExpenseHasValidLocation implements ExpenseRule{
	    
    
    public void validate(List<SObject> records) {
    	String errorMessage = 'Unknown location, please choose a location from the autocomplete drop-down list.';

    	for(Expense__c expense : (List<Expense__c>)records) {
			
	    	if(ExpenseType.isMovement(expense)) {
	    		if(expense.lkp_Location__c == null) {
		    		expense.txt_To__c.addError(errorMessage);
	    		}
		 		if(expense.lkp_LocationFrom__c == null) {
					expense.txt_From__c.addError(errorMessage);
				}
	    	}
	    	else if(ExpenseType.isAccommodation(expense) && expense.lkp_Location__c == null) {
				expense.txt_LodgingAdress__c.addError(errorMessage);
	    	}
	    	else if(ExpenseType.isEntertainment(expense) && expense.lkp_Location__c == null) {
				expense.txt_PlaceOfEntertainment__c.addError(errorMessage);
	    	}
    	}
    }
}
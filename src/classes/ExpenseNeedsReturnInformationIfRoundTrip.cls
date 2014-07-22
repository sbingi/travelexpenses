public with sharing class ExpenseNeedsReturnInformationIfRoundTrip  implements ExpenseRule {
 
 	// PUBLIC METHODS
 	
    public void validate(List<SObject> records) {

    	for(Expense__c expense : (List<Expense__c>)records) {
	        if ( expense.chk_RoundTrip__c ) {
	        	if( expense.dtm_ReturnDeparture__c == null ) {
	        		expense.dtm_ReturnDeparture__c.addError('Return departure time is missing');
	        	}
	        	if( expense.dtm_ReturnArrival__c == null ) {
	        		expense.dtm_ReturnArrival__c.addError('Return arrival time is missing.');
	        	}
	        }
    	}
    }
}
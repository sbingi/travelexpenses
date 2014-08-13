public with sharing class ExpensesTriggerHandler extends AbstractTriggerHandler{
	
	private List<Expense__c> newExpenses;
	private List<Expense__c> oldExpenses;
	
	private RuleValidator validator;
		
	
	//CONSTRUCTOR
	
	public ExpensesTriggerHandler() {
		newExpenses = filterOutPerDiems(Trigger.new);
		oldExpenses = filterOutPerDiems(Trigger.old);
		
		validator = new RuleValidator(RuleType.ExpenseRule);
	}
	
	
	// PUBLIC METHODS
	
	public override void onBeforeInsert() {
		validator.validate(newExpenses);	
			
		populateFields(newExpenses);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newExpenses);		
		
		populateFields(newExpenses);
	}
	
	
	public override void onAfterInsert() {
		calculatePerDiems(newExpenses);
	}
	
	
	public override void onAfterUpdate() {
		calculatePerDiems(newExpenses);
	}
	
	
	public override void onAfterDelete() {
		calculatePerDiems(oldExpenses);
	}
			
	
	// PRIVATE METHODS
	
	private List<Expense__c> filterOutPerDiems(List<SObject> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		if(expenses != null && !expenses.isEmpty()) {
			for(Expense__c e : (List<Expense__c>) expenses) {
				if(!ExpenseType.isPerDiem(e)) {
					results.add(e);
				}
			}
		}
		
		return results;
	}
	
	
	private void calculatePerDiems(List<Expense__c> expenses) {
		Set<Id> travels = new Set<Id>();
		for(Expense__c e : expenses) {
			travels.add(e.mdr_Travel__c);
		}
		
		for(Travel__c t : [SELECT Id, Name, CurrencyIsoCode, txt_Reason__c, txa_Description__c, 
     							  dtm_Start__c, dtm_End__c, Owner.FirstName, Owner.LastName, 
     							  rsum_TotalExpenses__c, rsum_ReimbursableExpenses__c, rsum_PerDiems__c, 
     							  fcur_Reimbursement__c
						   FROM Travel__c 
						   WHERE Id IN :travels]) {
						   	
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(t);
        	perDiemCalculator.calculate();
		}
	}
	
	
	private void populateFields(List<Expense__c> expenses) {
		for(Expense__c expense : expenses) {
			populateExpenseDate(expense);
			populateAmount(expense);
			populateReimbursement(expense);
			clearRoundTripFields(expense);
		}		
	}
	
	
	private void clearRoundTripFields(Expense__c expense) {
		if(expense.chk_RoundTrip__c == false) {
			expense.dtm_ReturnDeparture__c = null;
			expense.dtm_ReturnArrival__c = null;
		}
	}


	private void populateExpenseDate(Expense__c expense) {
		if(ExpenseType.isMovement(expense)) {
			expense.dat_ExpenseDate__c = expense.dtm_DepartureTime__c.date();
		}
		else if(ExpenseType.isAccommodation(expense)) {
			expense.dat_ExpenseDate__c = expense.dat_CheckOutDate__c;
		}
		else if(ExpenseType.isRentalVehicle(expense)) {
			expense.dat_ExpenseDate__c = expense.dat_ReturnDate__c;
		}
	}
	
	
	private void populateAmount(Expense__c expense) {
		if(ExpenseType.isPrivateVehicle(expense)) {			
			expense.cur_Amount__c = expense.fcur_MilageCosts__c;
		}
		else if(ExpenseType.isEntertainment(expense)) {
			expense.cur_Amount__c = expense.cur_Bill__c + expense.cur_Tip__c;
		}
	}
	
	
	private void populateReimbursement(Expense__c expense) {
		if(ExpenseType.isPrivateVehicle(expense)) {			
			expense.pkl_Reimbursement__c = 'I paid for this, please reimburse me.';
		}
		else if(ExpenseType.isCompanyVehicle(expense)) {			
			expense.pkl_Reimbursement__c = 'The company paid for this.';
		}
	}
}
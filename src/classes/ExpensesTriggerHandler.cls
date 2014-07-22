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
		
		createReturnTripExpenses(newExpenses);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newExpenses);		
		
		populateFields(newExpenses);
		
		deleteReturnTripExpenses(oldExpenses);
		createReturnTripExpenses(newExpenses);
	}
	
	
	public override void onBeforeDelete() {
		deleteReturnTripExpenses(oldExpenses);
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
		Set<Id> expenseIds = new Set<Id>();
		for(Expense__c e : expenses) {
			expenseIds.add(e.mdr_Travel__c);
		}
		
		List<Travel__c> allAffectedTravels = [SELECT Id, Name, CurrencyIsoCode, txt_Reason__c, txa_Description__c, 
                         							 dtm_Start__c, dtm_End__c, Owner.FirstName, Owner.LastName, 
                         							 rsum_TotalExpenses__c, rsum_ReimbursableExpenses__c, rsum_PerDiems__c, 
                         							 fcur_Reimbursement__c
											  FROM Travel__c 
											  WHERE Id IN :expenseIds];
		
		for(Travel__c t : allAffectedTravels) {
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(t);
        	perDiemCalculator.calculate();
		}
	}
	
	
	private void populateFields(List<Expense__c> expenses) {
		for(Expense__c expense : expenses) {
			populateExpenseDate(expense);
			populateAmount(expense);
			populateReimbursement(expense);
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
	
	
	private void createReturnTripExpenses(List<Expense__c> expenses) {
		for(Expense__c expense : expenses) {
			if(ExpenseType.isMovement(expense) && expense.chk_RoundTrip__c) {
				Expense__c returnTrip = new Expense__c();
				
				returnTrip.RecordTypeId = expense.RecordTypeId;
				returnTrip.cur_Amount__c = 0;
				returnTrip.lkp_LocationFrom__c = expense.lkp_Location__c;
				returnTrip.lkp_Location__c = expense.lkp_LocationFrom__c;
				returnTrip.pkl_Reimbursement__c = expense.pkl_Reimbursement__c;
				returnTrip.mdr_Travel__c = expense.mdr_Travel__c;
				returnTrip.chk_RoundTrip__c = false;
				returnTrip.dtm_DepartureTime__c = expense.dtm_ReturnDeparture__c;
				returnTrip.dtm_ArrivalTime__c = expense.dtm_ReturnArrival__c;
				returnTrip.txt_From__c = expense.txt_To__c;
				returnTrip.txt_To__c = expense.txt_From__c;
                returnTrip.dat_ExpenseDate__c = expense.dtm_ArrivalTime__c.date();
				
				try {
					insert returnTrip;	
					expense.lkp_ReturnTrip__c = returnTrip.Id;
				}
				catch(DMLException e) {
					expense.addError(e.getDMLMessage(0));
				}
			}
		}		
	}
	
	
	private void deleteReturnTripExpenses(List<Expense__c> expenses) {
		Set<Id> returnTripExpenseIds = new Set<Id>();
		
		for(Expense__c expense : expenses) {
			if(ExpenseType.isMovement(expense) && expense.chk_RoundTrip__c) {
				returnTripExpenseIds.add(expense.lkp_ReturnTrip__c);
			}
		}
		
		List<Expense__c> returnTripExpenses = [SELECT Id 
											   FROM Expense__c 
											   WHERE Id IN :returnTripExpenseIds];
									           						  
		delete returnTripExpenses;
	}							           						  
}
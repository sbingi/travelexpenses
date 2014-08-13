public with sharing class TravelsTriggerHandler extends AbstractTriggerHandler {
	
	private List<Travel__c> newTravels;
	private List<Travel__c> oldTravels;
	
	private RuleValidator validator;
	
	
	//CONSTRUCTOR
	
	public TravelsTriggerHandler() {
		newTravels = (List<Travel__c>) Trigger.new;
		oldTravels = (List<Travel__c>) Trigger.old;
		
		validator = new RuleValidator(RuleType.SaveTravelRule);
	}
	
	
	// PUBLIC METHODS
	
	public override void onBeforeInsert() {
		validator.validate(newTravels);
		
		setCurrencyToEUR(newTravels);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newTravels);
		
		setCurrencyToEUR(newTravels);
	}
	
	
	public override void onAfterInsert() {
		calculatePerDiems(newTravels);
	}
	
	
	public override void onAfterUpdate() {
		calculatePerDiems(newTravels);
	}
	
	
	// PRIVATE METHODS
	
	private void setCurrencyToEUR(List<Travel__c> travels) {
		for(Travel__c travel : travels) {
			travel.CurrencyIsoCode = 'EUR';
		}
	}
	
	
	private void calculatePerDiems(List<Travel__c> travels) {
		for(Travel__c travel : travels) {
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(travel);
        	perDiemCalculator.calculate();
		}
	}
}
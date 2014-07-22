public with sharing class CustomSettings {
	
	public static void addDefault() {
		CustomSettings__c settings = new CustomSettings__c();
		settings.Name = 'Test Defaults';
		settings.txt_CompensationRateRuleClasses__c = 'UP2GO_ITE.CompensationRatesCannotHaveSameName';
		settings.txt_ExpenseRuleClasses__c = 'UP2GO_ITE.ExpenseCannotBeOutsideOfTravelPeriod, UP2GO_ITE.ExpenseCannotEndBeforeStart, UP2GO_ITE.ExpenseHasValidLocation, UP2GO_ITE.ExpenseNeedsReturnInformationIfRoundTrip, UP2GO_ITE.ExpensesDontOverlap';
		settings.txt_LongDistanceRideRuleClasses__c = 'UP2GO_ITE.LongDistanceRideCannotBeOutsideOfRental, UP2GO_ITE.LongDistanceRideCannotEndBeforeStart, UP2GO_ITE.LongDistanceRideHasValidLocation, UP2GO_ITE.LongDistanceRidesDontOverlap';
		settings.txt_MealInvitationRuleClasses__c = 'UP2GO_ITE.MealInvitationCannotBeOutOfTravelPeriod, UP2GO_ITE.MealInvitationsCannotBeOnSameDay';
		settings.txt_SaveTravelRuleClasses__c = 'UP2GO_ITE.TravelCannotEndBeforeStart, UP2GO_ITE.TravelsDontOverlap';
		settings.txt_SubmitTravelRuleClasses__c ='UP2GO_ITE.TravelHasNoMovementGaps, UP2GO_ITE.TravelNeedsMovementOnFirstAndLastDay';
		
		insert settings;
	}
}
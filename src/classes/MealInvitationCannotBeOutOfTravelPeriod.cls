public class MealInvitationCannotBeOutOfTravelPeriod implements MealInvitationRule {
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<MealInvitation__c> mealInvitations = (List<MealInvitation__c>) records;

		Map<Id,Travel__c> travels = queryTravels(mealInvitations);
		
		for( MealInvitation__c invitation :  mealInvitations) {
			Travel__c travel = travels.get(invitation.mdr_Travel__c);
			
			if(isOutOfTravel(invitation.dat_Day__c,travel)) {
				invitation.dat_Day__c.addError('The date has to be within the travel period.');
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id,Travel__c> queryTravels(List<MealInvitation__c> invitations) {
		Set<Id> relevantTravels = new Set<Id>();
		
		for(MealInvitation__c invitation : invitations) {
			relevantTravels.add(invitation.mdr_Travel__c);
		}
		
		Map<Id,Travel__c> resultMap = new Map<Id,Travel__c>([SELECT dtm_Start__c, dtm_End__c
										   					 FROM Travel__c
										   					 WHERE Id IN :relevantTravels]);
										   	
		return resultMap;
	}
	
	
	private Boolean isOutOfTravel(Date day, Travel__c travel) {
		Boolean result = (day < travel.dtm_Start__c.date()) || (day > travel.dtm_End__c.date());
		
		return result;
	}
}
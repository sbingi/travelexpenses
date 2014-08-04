public class MealInvitationsCannotBeOnSameDay implements MealInvitationRule {

	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<MealInvitation__c> mealInvitations = (List<MealInvitation__c>) records;
		
		Map<Id, List<MealInvitation__c>> mealInvitationsByTravel = queryMealInvitationsByTravel(mealInvitations);
		
		for(MealInvitation__c invitation : mealInvitations) {
			List<MealInvitation__c> invitations = mealInvitationsByTravel.get(invitation.mdr_Travel__c);
			
			if(dateAlreadyExist(invitation, invitations)) {
				invitation.dat_Day__c.addError('There already exists a meal invitation for this date.');
			}
		}						   							 								   							 		
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id, List<MealInvitation__c>> queryMealInvitationsByTravel(List<MealInvitation__c> invitations) {
		Map<Id, List<MealInvitation__c>> resultMap = new Map<Id, List<MealInvitation__c>>();
		
		for(MealInvitation__c i : invitations) {
			Id travel = i.mdr_Travel__c;
			
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<MealInvitation__c>());
			}
		}
		
		for(MealInvitation__c j : [SELECT dat_Day__c, mdr_Travel__c
								   FROM MealInvitation__c
								   WHERE mdr_Travel__c IN :resultMap.keySet()]) {
								   	
			resultMap.get(j.mdr_Travel__c).add(j);
	    }
	    
	    return resultMap;
	}
	
	
	private Boolean dateAlreadyExist(MealInvitation__c invitation, List<MealInvitation__c> invitations) {
		Boolean result = false;
		
		for(MealInvitation__c m : invitations) {
			
			if( invitation.Id != m.Id && invitation.dat_Day__c == m.dat_Day__c) {
				result = true;
				
				break;
			}
		}
		
		return result;
	}
}
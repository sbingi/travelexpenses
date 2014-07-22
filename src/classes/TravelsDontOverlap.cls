public with sharing class TravelsDontOverlap implements SaveTravelRule {
	
	
	// PUBLIC METHODS
	    
    public void validate(List<SObject> records) {
    	List<Travel__c> travels = (List<Travel__c>) records;

    	Map<Id, List<Travel__c>> travelsByUser = queryAndGroupTravelsByUsers(travels);

		for(Travel__c travel : travels) {
			List<Travel__c> otherTravelsOfSameUser = travelsByUser.get(travel.OwnerId);
			
	        for(Travel__c other : otherTravelsOfSameUser) {
				
	            if( (travel.Id != other.Id) && doOverlap(travel, other)) {
	                travel.addError('Travel overlaps with existing travel: ' + other.Name);
	            }
	        }
		}
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id, List<Travel__c>> queryAndGroupTravelsByUsers(List<Travel__c> travels) {
    	Map<Id, List<Travel__c>> resultMap = new Map<Id, List<Travel__c>>();
    	
    	for(Travel__c t : travels) {
    		Id user = t.OwnerId;

    		if( !resultMap.containsKey(user)) {
    			resultMap.put(user, new List<Travel__c>());
    		}
    		
    	}
    	
    	for(Travel__c travel : [SELECT Name, dtm_Start__c, dtm_End__c, OwnerId 
							    FROM Travel__c
							    WHERE OwnerId IN :resultMap.keySet()]) {
							    	
			resultMap.get(travel.OwnerId).add(travel);
		}
		
		return resultMap;
    }
    
    
    private Boolean doOverlap(Travel__c travel, Travel__c other) {
        Boolean noOverlap = (other.dtm_End__c < travel.dtm_Start__c || other.dtm_Start__c > travel.dtm_End__c);

        return !noOverlap;
    }
}
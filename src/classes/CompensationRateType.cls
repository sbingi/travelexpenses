public with sharing class CompensationRateType {
	
	private static Map<Type, Id> rtIdByType;
	private static Map<Id, Type> rtTypeById;
	
	
	static {
		rtIdByType = new Map<Type, Id>();
		rtTypeById = new Map<Id, Type>();
		
		for(RecordType rt : [SELECT Id, Name, DeveloperName 
							 FROM RecordType 
							 WHERE SobjectType = 'UP2GO_ITE__CompensationRate__c']) {
							 	
			for(Type type : Type.values()) {
				if(type.name() == rt.DeveloperName) {
					rtIdByType.put(type, rt.Id);
					rtTypeById.put(rt.Id, type);
				}	 	 	
	 	 	}				 	
		}
	}
	
	
	// PUBLIC METHODS
	
	public static Boolean isLocation(Id recordTypeId) {
		Boolean result = is(Type.Location, recordTypeId);
		
		return result;
	}
	
	
	public static Boolean isVehicle(Id recordTypeId) {
		Boolean result = is(Type.Vehicle, recordTypeId);
		
		return result;		
	}
	
	
	public static Boolean isMeal(Id recordTypeId) {
		Boolean result = is(Type.Meal, recordTypeId);
		
		return result;
	}
    
	
	public static Id getLocationId() {
		Id result = rtIdByType.get(Type.Location);
		
		return result;
	}
	
	
	public static Id getVehicleId() {
		Id result = rtIdByType.get(Type.Vehicle);
		
		return result;
	}
	
	
	public static Id getMealId() {
		Id result = rtIdByType.get(Type.Meal);
		
		return result;
	}
	
	
	public static String getRecordTypeName(Id recordTypeId) {
		String result = rtTypeById.get(recordTypeId)!= null ? rtTypeById.get(recordTypeId).name() : null;
		
		return result;
	}
	
	
	// PRIVATE METHODS
	
	private static Boolean is(Type type,Id recordTypeId) {
		Boolean result = (rtTypeById.get(recordTypeId).name() == type.name());
		
		return result;
	}
	
	
	// ENUM
	
	public enum Type {
		Location, Vehicle, Meal
	}
}
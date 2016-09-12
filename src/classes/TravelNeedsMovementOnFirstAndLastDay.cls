global class Check_Movement implements SubmitTravelRule {

	global static final integer MAX_MOVEMENTS_PER_TRAVEL = 8;
	global static Boolean flag = false;
	
// Must be global so custom  JAVASCRIPT button can call it!!!
// Peter: TODO Do we still have that button? Why not take an Apex button? 
global static Map<Id, Set<Date>> GetDatesMap(Date start, Date end, Date firstHotel, List<Id> ids, User usr) {
	Map<Id, SET<Date>> themap = new Map<Id, Set<Date>>();
	Set<Id> movRts = getMovRts();
	
     for(Expense__c e : (List<Expense__c>)Database.query('select RecordTypeId, Departuretime__c, arrivalTime__c, MDR_TRAVEL__c, CHK_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c from Expense__c where mdr_Travel__c IN :ids')) {
		if(themap.get(e.MDR_TRAVEL__c) != null) themap.put(e.mdr_Travel__c, new Set<Date>());
		
		Set<Date> expDts = themap.get(t);
		if(ExpenseType.isRentalVehicle(e)){
			List<LongDistanceRide__c> rides = [SELECT dtm_departuretime__c, dtm_arrivalTime__c, chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c
										  	 from Long_Distance_Ride__c where  mdr_rentalvehicle__c=: e.id];
			for(LongDistanceRide__c r:rides) 
			{	expDts.add(r.dtm_DepartureTime__c.date());
				expDts.add(r.dtm_ArrivalTime__c.date());
				
				if(r.size() > MAX_MOVEMENTS_PER_TRAVEL || flag == true)
					break;// Had to add it for Bugfix 3452354
				else if(r.chk_RoundTrip__c) {
					expDts.add(r.dtm_ReturnDeparture__c.date());
					expDts.add(r.dtm_ReturnArrival__c.date());
				}
				
				
				else if(!e.chk_RoundTrip__c) 
						expDts.add(e.dtm_ReturnArrival__c.date());
			}
		}
			else{
				expDts.add(e.dtm_DepartureTime__c.date());
				expDts.add(e.dtm_ArrivalTime__c.date());
				
				if(e.chk_RoundTrip__c){
					expDts.add(e.dtm_ReturnDeparture__c.date());
					expDts.add(e.dtm_ReturnArrival__c.date());
				}	
				else if(!e.chk_RoundTrip__c)  {
					expDts.add(e.dtm_ReturnArrival__c.date());
				}
			}		  	
		}
		return themap;
	}

	private Set<Id> getMovRts() {
		Set<Id> movRts = ExpenseType.getMovementRecordTypeIds();
		movRts.add(ExpenseType.getRentalVehicleRecordTypeId());
		return movRts;
	}
	
	public void validate(List<SObject> records) {
		List<Travel__c> newTravels = (List<Travel__c>) records;
		
		Map<Id, Set<Date>> datesWithMovements = GetDatesMap(newTravels);
										
		for(Travel__c t : newTravels) {
			Set<Date> dates = datesWithMovements.get(t.Id);
			
			Date firstDay = t.dtm_Start__c.date();
			Date lastDay = t.dtm_End__c.date();
		
			if(dates == null || !dates.contains(firstDay)) {
				t.addError(System.Label.TravelNeedsMovementOnFirstDay);
			}
			if(dates == null || !dates.contains(lastDay)) {
				t.addError(System.Label.TravelNeedsMovementOnLastDay);
			}
		}
	}
}
public with sharing class PerDiemCalculator {
    
    private  Travel__c travel;
    private CompensationRate__c currentLocation; 
    
    private List<Expense__c> movementExpenses;
    private List<Expense__c> accommodationExpenses;
    private List<Expense__c> oldPerDiems;
    
    private Map<Id,CompensationRate__c> locations;
    private Map<Date,MealInvitation__c> mealInvitations;
    
    
    // CONSTRUCTOR
    
    public PerDiemCalculator(Travel__c travel) {
    	this.travel = travel;
 		initExpenses();
 		initLocations();
 		initMealInvitations();
    }
    
    
    // PUBLIC METHODS
    
    public void calculate() {
    	List<Expense__c> newPerDiems = new List<Expense__c>();
        
        delete oldPerDiems;
        
        try {
	    	if(isShorterOrEqualEightHours()) {
	    		newPerDiems.add(generateShortTravelPerDiem());
	    	}
	    	else {
	    		if(isOvernightTravel()) {
					newPerDiems.add(generateOverNightPerDiem());
	    		}
	    		else {
	    			newPerDiems.addAll(generatePerDiems());
	    		}
	    	}
	    	
	    	insert newPerDiems;
    	}
    	catch(Exception ignore) {}
    }
    
    
	// PRIVATE METHODS
	
	private void initExpenses() {
		movementExpenses = new List<Expense__c>();
		accommodationExpenses = new List<Expense__c>();
		oldPerDiems = new List<Expense__c>();
		
		Set<Id> recordTypes = new Set<Id>();
		recordTypes.add(ExpenseType.getEntertainmentRecordTypeId());
		recordTypes.add(ExpenseType.getMiscellaneousRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, dtm_ArrivalTime__c, dtm_DepartureTime__c,lkp_Location__c, lkp_LocationFrom__c,
    					   				 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c,lkp_LocationFrom__c,lkp_LocationTo__c
    					   			   	  FROM Long_Distance_Rides__r)	
    							  FROM Expense__c 
    							  WHERE mdr_travel__c = :travel.id
    							  AND RecordTypeId NOT IN :recordTypes]) {
    		
    		if(ExpenseType.isMovement(expense)) {
    			movementExpenses.add(expense);
    		}					  	
			else if(ExpenseType.isAccommodation(expense)) {
				accommodationExpenses.add(expense);
			}
			else if(ExpenseType.isPerDiem(expense)) {
				oldPerDiems.add(expense);
			}
			else if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ldr : expense.Long_Distance_Rides__r) {
					Expense__c falseExpense = new Expense__c();
					
		    		falseExpense.dtm_DepartureTime__c = ldr.dtm_DepartureTime__c;
		    		falseExpense.dtm_ArrivalTime__c = ldr.dtm_ArrivalTime__c;
		    		falseExpense.lkp_LocationFrom__c = ldr.lkp_LocationFrom__c;
		    		falseExpense.lkp_Location__c = ldr.lkp_LocationTo__c;
		    		
		    		movementExpenses.add(falseExpense);
				}
			}
		}
	}
	
	
	private void initLocations() {
		locations = new Map<Id,CompensationRate__c>([SELECT Id, CurrencyIsoCode,cur_FullDailyRate__c, cur_PartialDailyRate__c
												     FROM CompensationRate__c
												     WHERE RecordTypeId = :CompensationRateType.getLocationId()]);
	}
	
	
	private void initMealInvitations() {
    	mealInvitations = new Map<Date,MealInvitation__c>();
    	
    	for(MealInvitation__c invitation : [SELECT Id, dat_Day__c, lkp_Breakfast__c, 
    											   lkp_Breakfast__r.pct_FullDayAllowanceRate__c,
    									   		   lkp_Lunch__c, lkp_Lunch__r.pct_FullDayAllowanceRate__c,
    									   		   lkp_Dinner__c, lkp_Dinner__r.pct_FullDayAllowanceRate__c
    										FROM MealInvitation__c
    										WHERE mdr_Travel__c = :travel.Id]) {
    		mealInvitations.put(invitation.dat_Day__c,invitation);
    	}
	}
    
    
    // CHECKING METHODS
    
    private Boolean isShorterOrEqualEightHours() {
    	Long dt1 = travel.dtm_End__c.getTime();  
   		Long dt2 = travel.dtm_Start__c.getTime();
   		
   		Double difference = dt1 - dt2;
   		difference = difference/ 1000 / 60 / 60;
    	
    	Boolean result = (difference <= 8);
    	
    	return result;
    }
    
        
    private Boolean isOvernightTravel() {
    	Integer travelDuration = travel.dtm_End__c.day() - travel.dtm_Start__c.day();
    	
    	Boolean result = (travelDuration == 1) && (accommodationExpenses.isEmpty());
    	
    	return result;
    }
    
    
    // PER DIEM GENERATING METHODS
    
    private Expense__c generateShortTravelPerDiem() {
    	Date travelFirstDay = travel.dtm_Start__c.date();
    	Date travelLastDay = travel.dtm_End__c.date();
    	
    	determineLocationOfTheDay(travelFirstDay,travelLastDay);
   		
    	Expense__c result = createDefaultPerDiem(travelFirstDay);
    	
		result.cur_Amount__c = 0.00;
   		result.cur_OriginalAmount__c = 0.00;
   		result.cur_Deduction__c = 0.00;
   		result.dtm_Begin__c = travel.dtm_Start__c;
   		result.dtm_End__c = travel.dtm_End__c;
   		result.lkp_Location__c = currentLocation.Id;
   		result.CurrencyIsoCode = currentLocation.CurrencyIsoCode;
    	result.lkp_MealInvitation__c = findMealInvitation(travelFirstDay);
    	    	
    	return result;
    }
    
    
    private Expense__c generateOverNightPerDiem() {
    	Date travelFirstDay = travel.dtm_Start__c.date();
    	Date travelLastDay = travel.dtm_End__c.date();
    	
   		determineLocationOfTheDay(travelFirstDay, travelLastDay);
   		
    	Expense__c result = createDefaultPerDiem(travelFirstDay);
    	
   		result.dtm_Begin__c = travel.dtm_Start__c;
   		result.dtm_End__c = travel.dtm_End__c;
   		result.lkp_Location__c = currentLocation.Id;
   		result.CurrencyIsoCode = currentLocation.CurrencyIsoCode;
   		result.cur_OriginalAmount__c = currentLocation.cur_PartialDailyRate__c;
		result.cur_Deduction__c = calculateMealDeduction(travelFirstDay, true);
   		
   		Id mealInvitation = findMealInvitation(travelFirstDay);
   		if(mealInvitation == null) {
   			mealInvitation = findMealInvitation(travelLastDay);
   		}
   		result.lkp_MealInvitation__c = mealInvitation;
 		
   		Decimal amount = result.cur_OriginalAmount__c - result.cur_Deduction__c;
        if(amount < 0) {
            amount = 0;
        }
   		result.cur_Amount__c = amount;
   		 
   		return result;    			
    }
    	
    
    private List<Expense__c> generatePerDiems() {
    	Date travelFirstDay = travel.dtm_Start__c.date();
    	Date travelLastDay = travel.dtm_End__c.date();
    	
    	List<Expense__c> results = new List<Expense__c>();

		for( Date day = travelFirstDay ; day <= travelLastDay ; day = day.addDays(1)) {
            Expense__c perDiem = createDefaultPerDiem(day);
            
        	determineLocationOfTheDay(travelFirstDay, travelLastDay, day);
                        	
            if (day.isSameDay(travelFirstDay)) {
            	perDiem.dtm_Begin__c = travel.dtm_Start__c;
                perDiem.dtm_End__c = DateTime.newInstance(day,Time.newInstance(23,59,59,00));
                perDiem.cur_OriginalAmount__c = currentLocation.cur_PartialDailyRate__c;
            }
            else if(day.isSameDay(travelLastDay)) {
                perDiem.dtm_Begin__c = DateTime.newInstance(day,Time.newInstance(00,00,00,00));
                perDiem.dtm_End__c = travel.dtm_End__c;
                perDiem.cur_OriginalAmount__c = currentLocation.cur_PartialDailyRate__c;
            }
            else {
                perDiem.dtm_Begin__c = DateTime.newInstance(day,Time.newInstance(00,00,00,00));
                perDiem.dtm_End__c = DateTime.newInstance(day,Time.newInstance(23,59,59,00));
                perDiem.cur_OriginalAmount__c = currentLocation.cur_FullDailyRate__c;
            }
            
            perDiem.lkp_Location__c = currentLocation.Id;
	        perDiem.CurrencyIsoCode = currentLocation.CurrencyIsoCode;
	        perDiem.cur_Deduction__c = calculateMealDeduction(day,false);
            perDiem.lkp_MealInvitation__c = findMealInvitation(day);
 
			Decimal amount = perDiem.cur_OriginalAmount__c - perDiem.cur_Deduction__c;
	        if(amount < 0) {
	            amount = 0;
	        }
	   		perDiem.cur_Amount__c = amount;
            
            results.add(perDiem);
        }
        
        return results;
    }
	
	
	// CALCULATING AND DETERMINING METHODS
	
	private Expense__c createDefaultPerDiem(Date day) {
		Expense__c result = new Expense__c();
		
		result.mdr_Travel__c = travel.Id;
		result.RecordTypeId = ExpenseType.getPerDiemRecordTypeId();
		result.pkl_Reimbursement__c = 'I paid for this, please reimburse me.';
		result.dat_ExpenseDate__c = day;
		
		return result;
	}
	
	
	private Decimal calculateMealDeduction(Date day,Boolean overnight) {
		Double allowanceRate;
		
		if(overnight) {
			allowanceRate = calculateAllowanceRate(day) + calculateAllowanceRate(day.addDays(1));
		}
		else {
			allowanceRate = calculateAllowanceRate(day);
		}
		
		if(allowanceRate > 1) {
				allowanceRate = 1;
		}
		
		Decimal result = locations.get(currentLocation.Id).cur_FullDailyRate__c * allowanceRate;
				
		return result;
	}
	
	
	private Double calculateAllowanceRate(Date day) {
		Double result = 0.00;
		MealInvitation__c invitation = mealInvitations.get(day);
		
		if(invitation != null) {
			
			if(invitation.lkp_Breakfast__c != null) {
				result = result+ invitation.lkp_Breakfast__r.pct_FullDayAllowanceRate__c;
			}
			if(invitation.lkp_Lunch__c != null) {
				result = result+ invitation.lkp_Lunch__r.pct_FullDayAllowanceRate__c;
			}
			if(invitation.lkp_Dinner__c != null) {
				result = result+ invitation.lkp_Dinner__r.pct_FullDayAllowanceRate__c;
			}
		}
		
		return result/100;
	}
		
	
	private void determineLocationOfTheDay(Date firstDay, Date lastDay) {
		Expense__c movementOfTheDay;
		
		if(firstDay.isSameDay(lastDay)) {
			movementOfTheDay = determineLastExpensePerDay(firstDay);
		}
		else if(isOvernightTravel()) {
			movementOfTheDay = determineLastExpensePerDay(lastDay);
			
			if(movementOfTheDay == null) {
				movementOfTheDay = determineLastExpensePerDay(firstDay);
			}
		}
		
		if(movementOfTheDay != null) {
			currentLocation = locations.get(movementOfTheDay.lkp_LocationFrom__c);
		}
	}
		
	
	private void determineLocationOfTheDay(Date firstDay, Date lastDay, Date day) {
		Expense__c movementOfTheDay;
		
		if(firstDay.isSameDay(lastDay)) {
			movementOfTheDay = determineLastExpensePerDay(firstDay);
		
			if(movementOfTheDay != null) {
				currentLocation = locations.get(movementOfTheDay.lkp_LocationFrom__c);
			}
		}
		else {
			if(day.isSameDay(lastDay)) {
				movementOfTheDay = determineFirstExpensePerDay(day);
				
				if(movementOfTheDay != null) {
					currentLocation = locations.get(movementOfTheDay.lkp_LocationFrom__c);
				}
			}
			else {
				movementOfTheDay = determineLastExpensePerDay(day);
				
				if(day.IsSameDay(FirstDay) && movementOfTheDay == null) {
					movementOfTheDay = determineFirstExpensePerDay(day);
				}
				
				if(movementOfTheDay != null) {
					currentLocation = locations.get(movementOfTheDay.lkp_Location__c);
				}
			}
		}
	} 
	
	
	private Expense__c determineFirstExpensePerDay(Date day) {
		Expense__c result;
		DateTime compareTime = DateTime.newInstance(day,Time.newInstance(23,59,59,00));
		
		 for(Expense__c expense : movementExpenses) {
		 	DateTime departureTime = expense.dtm_DepartureTime__c;
		 	
		 	if( (departureTime.date() == day) && (departureTime < compareTime) ) {
	        	compareTime = departureTime;
	            result = expense;
		 	}
		 }
		 
		 return result;
	}


	private Expense__c determineLastExpensePerDay(Date day) {
		Expense__c result;
		DateTime compareTime = DateTime.newInstance(day,Time.newInstance(00,00,00,00));
		
		 for(Expense__c expense : movementExpenses) {
		 	DateTime arrivalTime = expense.dtm_ArrivalTime__c;
		 	
	 		if( (arrivalTime.date() == day) && (arrivalTime > compareTime) ) {
	        	compareTime = arrivalTime;
	            result = expense;
	    	}
		 }
		 
		 return result;
	}
	
	
    private Id findMealInvitation(Date day) {
    	Id result;
    	
		MealInvitation__c invitation = mealInvitations.get(day);
		
		if(invitation != null) {
			result = invitation.Id;
		}
		
		return result;
	}
}
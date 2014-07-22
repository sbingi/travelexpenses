@isTest
private class TravelOverviewMobileCtrl_Test {
	
	static {
		CustomSettings.addDefault();
	}
	
    private static final DateTime TODAY_START = dateTime(System.today(),Time.newInstance(00,00,00,00));
    private static final DateTime TODAY_MORNING = dateTime(System.today(),Time.newInstance(08,00,00,00));
    
    private static final DateTime TOMORROW_START = dateTime(System.today().addDays(1),Time.newInstance(00,00,00,00));
    private static final DateTime TOMORROW_MORNING = dateTime(System.today().addDays(1),Time.newInstance(08,00,00,00));
    private static final DateTime TOMORROW_END = dateTime(System.today().addDays(1),Time.newInstance(23,59,59,00));
    
    private static final DateTime DAY_AFTER_TOMORROW_MORNING = dateTime(System.today().addDays(2),Time.newInstance(08,00,00,00));
    
    private static final DateTime ONE_WEEK_FROM_TODAY_EVENING = dateTime(System.today().addDays(7),Time.newInstance(20,00,00,00));
    
    
	
	@isTest
	private static void succeedsWhenOnlyOpenAndRejectedTravelsInAllOpenTravels() {
		// Setup
		Travel__c travel1 = createTravel(TODAY_MORNING,TOMORROW_START);
		insert travel1;
		Travel__c travel2 = createTravel(TOMORROW_MORNING,TOMORROW_END);		
		insert travel2;				   
		Travel__c travel3 = createTravel(DAY_AFTER_TOMORROW_MORNING,ONE_WEEK_FROM_TODAY_EVENING);
		insert travel3;
									   
		submitTravel(travel2);
		submitAndRejectTravel(travel3);
		
		TravelOverviewMobileCtrl ctrl = new TravelOverviewMobileCtrl();
		
		
		// Exercise
		List<TravelOverviewMobileCtrl.ListElement> travels = ctrl.getOpenTravels();
	
		
		// Verify
		System.assertEquals(2, travels.size());
		assertAllTravelsAreOpenOrRejected(travels);
	}
	
	
	@isTest
	private static void succeedsWhenOnlyApprovedAndPendingTravelsInAllSubmittedTravels() {
		// Setup
		Travel__c travel1 = createTravel(TODAY_MORNING,TOMORROW_START);
		insert travel1;
		Travel__c travel2 = createTravel(TOMORROW_MORNING,TOMORROW_END);		
		insert travel2;				   
		Travel__c travel3 = createTravel(DAY_AFTER_TOMORROW_MORNING,ONE_WEEK_FROM_TODAY_EVENING);
		insert travel3;
									   
		submitTravel(travel2);
		submitAndApproveTravel(travel3);
		
		TravelOverviewMobileCtrl ctrl = new TravelOverviewMobileCtrl();
		
		
		// Exercise
		List<TravelOverviewMobileCtrl.ListElement> travels = ctrl.getSubmittedTravels();
		
		
		// Verify
		System.assertEquals(2, travels.size());
		assertAllTravelsArePendingOrApproved(travels);							   
	}
	
	
	@isTest
	private static void suceedsWhenOnlyOwnTravelsAreShownForTraveler() {
		// Setup
		List<TravelOverviewMobileCtrl.ListElement> seenTravels;
		List<TravelOverviewMobileCtrl.ListElement> allTravels;
		
        Travel__c travel1 = createTravel(TODAY_START,TOMORROW_START);
        Travel__c travel2 = createTravel(TOMORROW_MORNING,TOMORROW_END);
        Travel__c travel3 = createTravel(TODAY_START,TOMORROW_START);
        
        User traveler1;
        User traveler2;
        
        // Note: Prevent MIXED_DML (http://stackoverflow.com/questions/2387475/how-to-avoid-mixed-dml-operation-error-in-salesforce-tests-that-create-users)                     
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
			traveler1 = createNewTraveler('travelerOne');
        	traveler2 = createNewTraveler('travelerTwo');
		}
		
        System.runAs(traveler1) {
        	insert travel1;
        	insert travel2;
        }
        
        System.runAs(traveler2) {
        	insert travel3;
        }
        
        TravelOverviewMobileCtrl ctrl = new TravelOverviewMobileCtrl();
        allTravels = ctrl.getOpenTravels();
        
        
        // Exercise
        System.runAs(traveler1) {
        	ctrl = new TravelOverviewMobileCtrl();
        	seenTravels = ctrl.getOpenTravels();
        }
        
        
        
        // Verify
        System.assertEquals(3, allTravels.size());
        System.assertEquals(2, seenTravels.size());
        System.assertEquals(traveler1.Id, seenTravels[0].travel.OwnerId);
        System.assertEquals(traveler1.Id, seenTravels[1].travel.OwnerId);
	}
	
	
	@isTest
	private static void succeedsWhenAllTravelsAreShownForExpenseManager() {
		
		// Setup
		List<TravelOverviewMobileCtrl.ListElement> allTravels;
		List<TravelOverviewMobileCtrl.ListElement> seenTravels;
		
		Travel__c travel1 = createTravel(TODAY_START,TOMORROW_START);
        Travel__c travel2 = createTravel(TOMORROW_MORNING,TOMORROW_END);
        Travel__c travel3 = createTravel(TODAY_START,TOMORROW_START);
		
        User traveler1;
        User traveler2;
        User expenseManager;
        
        // Note: Prevent MIXED_DML (http://stackoverflow.com/questions/2387475/how-to-avoid-mixed-dml-operation-error-in-salesforce-tests-that-create-users)                     
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
	        traveler1 = createNewTraveler('travelerOne');
	        traveler2 = createNewTraveler('travelerTwo');
	        expenseManager = createNewExpenseManager('ManagerOne');
		}
		
        System.runAs(traveler1) {
        	insert travel1;
        	insert travel2;
        }
        
        System.runAs(traveler2) {
        	insert travel3;
        }

        TravelOverviewMobileCtrl ctrl = new TravelOverviewMobileCtrl();
        allTravels = ctrl.getOpenTravels();
        
        
        // Exercise
        System.runAs(expenseManager) {
        	ctrl = new TravelOverviewMobileCtrl();
        	seenTravels = ctrl.getOpenTravels();        	
        }
        
        
        // Verify
        System.assertEquals(3, allTravels.size());
        System.assertEquals(3,seenTravels.size());
	}
	
	
    // TEST HELPER
    
    private static DateTime dateTime(Date day, Time myTime) {
        DateTime result = DateTime.newInstance(day, myTime);
        
        return result;
    }
    
    
    private static void assertAllTravelsAreOpenOrRejected(List<TravelOverviewMobileCtrl.ListElement> travels) {
    	Boolean allTravelsAreOpenOrRejected = true;

    	for(TravelOverviewMobileCtrl.ListElement le : travels) {
    		if(le.recordStatus.equals('Pending') || le.recordStatus.equals('Approved')) {
    			allTravelsAreOpenOrRejected = false;
		    }
    	}
    	
    	System.assert(allTravelsAreOpenOrRejected);
    }
    
    
    private static void assertAllTravelsArePendingOrApproved(List<TravelOverviewMobileCtrl.ListElement> travels) {
    	Boolean allTravelsArePendingOrApproved = true;
    	
    	for(TravelOverviewMobileCtrl.ListElement le : travels) {
    		if(le.recordStatus.equals('Open') || le.recordStatus.equals('Rejected')) {
    			allTravelsArePendingOrApproved = false;
		    }
    	}
    	
    	System.assert(allTravelsArePendingOrApproved);
    }
    
    
    private static void submitTravel(Travel__c travel) {
    	Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(travel.Id);
        Approval.ProcessResult result = Approval.process(req);
    }
    
    
    private static void submitAndRejectTravel(Travel__c travel) {
    	Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setObjectId(travel.Id);
        Approval.ProcessResult submitResult = Approval.process(submitRequest);
        
    	List<Id> newWorkItemIds = submitResult.getNewWorkitemIds();
    	
    	Approval.ProcessWorkitemRequest rejectRequest = new Approval.ProcessWorkitemRequest();
        rejectRequest.setAction('Reject');
        rejectRequest.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        rejectRequest.setWorkitemId(newWorkItemIds.get(0));
        Approval.ProcessResult rejectResult =  Approval.process(rejectRequest);
    }
    
    
    private static void submitAndApproveTravel(Travel__c travel) {
    	Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setObjectId(travel.Id);
        Approval.ProcessResult submitResult = Approval.process(submitRequest);
        
    	List<Id> newWorkItemIds = submitResult.getNewWorkitemIds();
    	
    	Approval.ProcessWorkitemRequest approveRequest = new Approval.ProcessWorkitemRequest();
        approveRequest.setAction('Approve');
        approveRequest.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        approveRequest.setWorkitemId(newWorkItemIds.get(0));
        Approval.ProcessResult approveResult =  Approval.process(approveRequest);
    }
    
    
    private static User createNewUser(String name) {
        Profile standPlatUs = [SELECT Id FROM Profile WHERE Name='Standard Platform User'];
        
        String userName = name+'@testorg.com';
        
        User manager = new User(Alias = 'man', Email='managerOf'+name+'@testorg.com', EmailEncodingKey='UTF-8',
                               LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                               ProfileId = standPlatUs.Id, TimeZoneSidKey='America/Los_Angeles', UserName='managerOf'+name+'@testorg.com');
        insert manager;
        
        User result = new User(Alias = name.substring(0,2), Email=userName, EmailEncodingKey='UTF-8',
                               FirstName=name ,LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                               ProfileId = standPlatUs.Id, TimeZoneSidKey='America/Los_Angeles', UserName=userName,
                               ManagerId = manager.Id);
                               
	    insert result;
            
        return result;
    }
    
    
    private static User createNewTraveler(String name) {
    	User user = createNewUser(name);
    	
        PermissionSet traveler = [SELECT Id FROM PermissionSet WHERE Name = 'Traveler' LIMIT 1];
		PermissionSetAssignment assignTraveler = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = traveler.Id);
		
		insert assignTraveler;
		
		return user;
    }
    
    
    private static User createNewExpenseManager(String name) {
    	User user = createNewUser(name);
    	
        PermissionSet expenseManager = [SELECT Id FROM PermissionSet WHERE Name = 'ExpenseManager' LIMIT 1];
		PermissionSetAssignment assignExpenseManager = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = expenseManager.Id);
		
		insert assignExpenseManager;

		return user;
    }
    
    
    private static Travel__c createTravel(DateTime start, DateTime stop) {
        Travel__c result = new Travel__c();
        result.txt_Reason__c = 'testing';
        result.Name = 'TestTravel';
        result.dtm_Start__c = start;
        result.dtm_End__c = stop;
        
        return result;
    }
}
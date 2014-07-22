public with sharing class TravelOverviewMobileCtrl {

    private Set<Id> allOpenTravels;
    private Set<Id> allSubmittedTravels;
    private List<ProcessInstance> processInstances;


    // CONSTRUCTOR
    
    public TravelOverviewMobileCtrl() {
    	allOpenTravels = new Set<Id>();
        allSubmittedTravels = new Set<Id>();
        
        processInstances = [SELECT id, Status, CreatedDate, TargetObjectId 
                            FROM ProcessInstance];
        
        for(Travel__c t :[SELECT Id, Name, Owner.FirstName, Owner.LastName, dtm_Start__c, dtm_End__c
                          FROM Travel__c]) {
                          	
            String recordStatus = getRecordStatus(t.Id);
            
            if(recordStatus.equals('Pending') || recordStatus.equals('Approved')) {
                allSubmittedTravels.add(t.Id);
            }
            else {              
                allOpenTravels.add(t.Id);
            }                      
        }
    }
    
    
    // PUBLIC METHODS
    
    public List<ListElement> getOpenTravels() {
        List<ListElement> results = getTravels(allOpenTravels);
        
        return results;
    }
    
    
    public List<ListElement> getSubmittedTravels() {
        List<ListElement> results = getTravels(allSubmittedTravels);
        
        return results;
    }
    
    
    //PRIVATE METHODS
    
    private String getRecordStatus(Id travelId) {
        String result = '';
        
        List<ProcessInstance> recordProcessInstances = new List<ProcessInstance>();
        
        for(ProcessInstance p : processInstances) {
                if(p.TargetObjectId == travelId) {
                        recordProcessInstances.add(p);
                }
        }
        
        if(recordProcessInstances.size() > 0) {
            ProcessInstance processinstance = recordProcessInstances[0];
            
            for(ProcessInstance p : recordProcessInstances) {
                if(p.CreatedDate > processinstance.CreatedDate) {
                    processinstance = p;
                }
            }
            
            result = processinstance.Status;
        }
        
        return result;
    }    
    
    
    private List<ListElement> getTravels(Set<Id> travelIds) {
    	List<ListElement> results = new List<ListElement>();
    	
    	for(Travel__c travel : [SELECT Id, Name, Owner.FirstName, Owner.LastName, dtm_Start__c, dtm_End__c
	                            FROM Travel__c
	                            WHERE Id IN : travelIds
	                            ORDER BY dtm_Start__c DESC]) {
	                            	
    		ListElement element = new ListElement(travel, getRecordStatus(travel.Id));
    		results.add(element);
        }
        
        return results;
    }
    
    
    // INNER CLASS
    
    public class ListElement {
        
        public Travel__c travel { get; private set; }
        public String recordStatus { get; private set; }
        
        
        public ListElement(Travel__c travel,String recordStatus) {
            this.travel = travel;
            this.recordStatus = recordStatus.equals('') ? 'Open' : recordStatus;
        }
    } 
}
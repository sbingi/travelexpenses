global with sharing class ExpenseCtrlExt {
// lalalala          
    public Expense__c expense {
        get;
        private set;
    }
    private ApexPages.StandardController stdCtrl;
  
 
    // CONSTRUCTOR
    
    public ExpenseCtrlExt(ApexPages.StandardController standardController) {
        stdCtrl = standardController;
        expense = (Expense__c) stdCtrl.getRecord();
    }
    

    //GLOBAL METHODS
    
    @RemoteAction
    global static Id findLocation(String city, String country) {
        Id result = LocationFinder.findLocation(city, country);
        
        return result;
    }
      
     
    // PUBLIC METHODS
    
    public String getRecordTypeName() {
        String result = expense.RecordType.DeveloperName;
        
        if(result == null) {
            String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            result = ExpenseType.getRecordTypeName(recordTypeId);
        }
        
        return result;
    }   
   
    
    public String getDate() {
        String result = expense.dat_ExpenseDate__c.format();
        
        return result;
    }
    
    
    public String getExpenseId() {
        return expense.Id;
    }
    
    
    public PageReference doSaveAndNew() {
        String expenseEntityId = CustomSettings__c.getAll().values().get(0).txt_ExpenseEntityId__c;
        PageReference result = new PageReference('/setup/ui/recordtypeselect.jsp?ent=' + expenseEntityId + '&retURL=expenseEdit&save_new_??url=' + expenseEntityId + '/e');        
        
        try {  
            upsert expense;
            return result;
        } 
        catch(Exception e) {  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getCause().getMessage()));  
            return null;
        }
    }
}
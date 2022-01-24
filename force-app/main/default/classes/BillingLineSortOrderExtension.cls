public with sharing class BillingLineSortOrderExtension {
    
    public List<AcctSeed__Billing_Line__c> lines {get; set;}
    private map<id, AcctSeed__Billing_Line__c> linesMap = new map<id, AcctSeed__Billing_Line__c>();
    public String jsonStr {get; set;}
    
    // sales order id is
    public id billId {get; set;}
    
    public acctseed__Billing__c billing {get; set;}
    
    public boolean visible {get{
        
        if(visible == null) visible = true;
        return visible;
        
    } set;}
    
    public BillingLineSortOrderExtension(ApexPages.StandardSetController ssc){
        lines = new List<AcctSeed__Billing_Line__c>();
        
        billId = ApexPages.currentPage().getParameters().get('id');
        
        billing = [select name from acctseed__Billing__c where id=:billId];
        
        lines = [SELECT Id, Name, AcctSeed__Billing__c, AcctSeed__Comment__c, AcctSeed__Date__c, 
                 AcctSeed__Expense_GL_Account__c, AcctSeed__GL_Account_Variable_1__c, 
                 AcctSeed__Inventory_GL_Account__c, AcctSeed__Hours_Units__c, 
                 AcctSeed__List_Price__c, AcctSeed__Opportunity_Product_Id__c, 
                 AcctSeed__Product__c, AcctSeed__Product__r.name, AcctSeed__Project__c, AcctSeed__Rate__c, 
                 AcctSeed__Revenue_GL_Account__c, AcctSeed__Total__c, Item_Description__c, 
                 Unit_Cost__c, Total_Price__c, Size__c, Quantity__c, Product_Code__c, sort_order__c 
                 FROM AcctSeed__Billing_Line__c 
                 where AcctSeed__Billing__c =: billId order by sort_order__c,name,createddate asc];

        
        if(lines.isEmpty()){
            
		   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 
                                                     'No Products found.'
                                                     ));            
           visible = false; 
        }
    }
    public PageReference back(){
        
        PageReference page = new PageReference('/' + billid);
        page.setRedirect(true);
        
        return page;
        
    }
    public Pagereference createsort(){
        
        string obj = ApexPages.currentPage().getParameters().get('sortstring');
        
        if(obj.Length() > 0){
            
            // create a map of lines
            for(acctseed__billing_line__c line : lines){
                
                linesMap.put(line.id, line);
                
            }
            
            list<wrapper> sortlist = (list<wrapper>)JSON.deserialize(obj, list<Wrapper>.class);
            
            for(wrapper w : sortlist){
                // get the line from the map
                acctseed__billing_line__c line = linesMap.get(w.id);
                if(line == null) continue;
                
                line.Sort_Order__c = Decimal.valueOf(w.sorts);
            }
            
            list<acctseed__billing_line__c> linesUpdatables = new list<acctseed__billing_line__c>();
            
            linesUpdatables.addAll(linesMap.values());
            
            update linesUpdatables;
            
            Pagereference pr = new PageReference('/' + billId);
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    class Wrapper {
        
        public string id,sorts;
        
    }
}
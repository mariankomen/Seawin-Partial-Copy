public with sharing class SalesOrderLineSortOrder {
    
    public List<AcctSeedERP__Sales_Order_Line__c> lines {get; set;}
    private map<id, acctseederp__sales_order_line__c> linesMap = new map<id, acctseederp__sales_order_line__c>();
    public String jsonStr {get; set;}
    
    // sales order id is
    public id soId {get; set;}
    
    public acctseederp__sales_order__c so {get; set;}
    
    public boolean visible {get{
        
        if(visible == null) visible = true;
        return visible;
        
    } set;}
    
    public SalesOrderLineSortOrder(ApexPages.StandardSetController ssc){
        lines = new List<AcctSeedERP__Sales_Order_Line__c>();
        
        soId = ApexPages.currentPage().getParameters().get('id');
        
        so = [select name from acctseederp__sales_order__c where id=:soId];
        
        lines = [select id, name, acctseederp__product__r.name, productCode__c, 
                 sortorder__c, item_description__c, size__c, quantityformula__c,
                 quantity_allocated_formula__c, quantity_shipped_formula__c, sales_price__c, total_price__c 
                 from AcctSeedERP__Sales_Order_Line__c 
                 where AcctSeedERP__Sales_Order__c =: soId order by sortorder__c,name,createddate asc];
        
        if(lines.isEmpty()){
            
		   ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 
                                                     'No Products found.'
                                                     ));            
           visible = false; 
        }
    }
    public PageReference back(){
        
        PageReference page = new PageReference('/' + soid);
        page.setRedirect(true);
        
        return page;
        
    }
    public Pagereference createsort(){
        
        string obj = ApexPages.currentPage().getParameters().get('sortstring');
        
        if(obj.Length() > 0){
            
            // create a map of lines
            for(acctseederp__sales_order_line__c line : lines){
                
                linesMap.put(line.id, line);
                
            }
            
            list<wrapper> sortlist = (list<wrapper>)JSON.deserialize(obj, list<Wrapper>.class);
            
            for(wrapper w : sortlist){
                // get the line from the map
                acctseederp__sales_order_line__c line = linesMap.get(w.id);
                if(line == null) continue;
                
                line.SortOrder__c = Decimal.valueOf(w.sorts);
            }
            
            list<acctseederp__sales_order_line__c> linesUpdatables = new list<acctseederp__sales_order_line__c>();
            
            linesUpdatables.addAll(linesMap.values());
            
            update linesUpdatables;
            
            Pagereference pr = new PageReference('/' + soId);
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    class Wrapper {
        
        public string id,sorts;
        
    }
}
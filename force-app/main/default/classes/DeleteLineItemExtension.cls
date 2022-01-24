public class DeleteLineItemExtension {

    private Id oppId {get; set;}
    private Id SOID {get; set;}
    private List<OpportunityLineItem> OLIData {get; set;}
    private List<Optional_Products_Opportunity__c> OOLIData {get; set;}
    private List<AcctSeedERP__Sales_Order_Line__c> SLIData {get; set;}
    public List<AcctSeed__Billing__c> BillingOpp {get; set;}
    public List<AcctSeed__Billing__c> BillingSO {get; set;}
    public String LineType {get; set;}
    
    // tabstyle
    public string strTabName{set;}
    public String getStrTabName(){ 
        if(lineType == 'oli' || LineType == 'ooli')
        { 
            return 'Opportunity';
        }
        else if(lineType == 'sli'){
            return 'AcctSeedERP__Sales_Order__c';
        }
        return null;
    }
    
    
    public DeleteLineItemExtension(){
        
        OppId = Id.ValueOf(ApexPages.currentPage().getParameters().get('id'));
        SOID = Id.ValueOf(ApexPages.currentPage().getParameters().get('id'));
        lineType = ApexPages.currentPage().getParameters().get('linesType');
        integer count = Integer.valueOf(ApexPages.currentPage().getParameters().get('count'));
        
        OLIData = new List<OpportunityLineItem>();
        OOLIData = new LIST<Optional_Products_Opportunity__c>();
        BillingOpp = new List<AcctSeed__Billing__c>();
        SLIData = new List<AcctSeedERP__Sales_Order_Line__c>();
        BillingSO = new List<AcctSeed__Billing__c>();
        
        set<Id> recordIds = new set<Id>();
        
        for(integer i = 0; i < count; i++){
            Id lineID = Id.ValueOf(ApexPages.currentPage().getParameters().get('id'+i));
            recordIds.add(lineID);
        }
        
        if(lineType == 'oli'){
            
            BillingOpp = [select id from AcctSeed__Billing__c where
                          AcctSeed__Opportunity__c  =: OppId limit 1];
            
            OLIData = [SELECT Id FROM OpportunityLineItem 
                       where Id in : recordIds and OpportunityId =: OppId];
            
        }else if(lineType == 'ooli'){
            
            OOLIData = [SELECT Id FROM Optional_Products_Opportunity__c 
                        where Id in : recordIds and Opportunity__c =: OppId];
          
        }else if(lineType == 'sli'){
            
            BillingSO = [select id from AcctSeed__Billing__c 
                         where AcctSeedERP__Sales_Order__c =: SOID];
            
            SLIData = [SELECT Id FROM AcctSeedERP__Sales_Order_Line__c 
                       where Id in : recordIds and AcctSeedERP__Sales_Order__c =: SOID];
        }  
    }
    
    public PageReference dmlOperation() {

        System.debug('BillingOpp: ' + BillingOpp);
        System.debug('OLIData: ' + OLIData);
        System.debug('OOLIData: ' + OOLIData);
        System.debug('BillingSO: ' + BillingSO);
        System.debug('SLIData: ' + SLIData);
        
        if(BillingOpp.size() > 0){
            return null;
        }
        else if(OLIData.Size() > 0){     
            delete OLIData;
        }else if(OOLIData.size() > 0)
            delete OOLIData;
        else if (BillingSO.Size() > 0){
            return null;
        }else if (SLIData.size() > 0){
            delete SLIData;
        }
        
        PageReference retURL;
        if(lineType == 'oli' || LineType == 'ooli'){
            retURL = new PageReference('/' + oppId);
        }else{
            retURL = new PageReference('/' + SOID);
        }
        
        retURL.setRedirect(true);
        return retURL;
    }
    
    public PageReference back(){
        PageReference page;
        
        if(lineType == 'oli' || LineType == 'oli'){
            page = new PageReference('/' + oppId);
            
        }else{
            
            page = new PageReference('/' + SOID);
        }
        
        page.setRedirect(true);
        return page;
    }
}
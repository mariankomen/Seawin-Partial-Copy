public class CreditOrderSalesProcessPathExtension {
    
    public Credit_Order__c So {public get; private set;}
    
    public map<string, integer> StagePositionMap {get; set;}
    public list<string> StageValuesList {public get; private set;}
    public integer ListLength {public get; private set;}
    
    private ApexPages.StandardController stdController;
    public String redirectUrl {public get; private set;}
    public boolean shouldRedirect {public get; private set;}
    public Decimal billingBalances {get;set;}
    public integer sizeOfMap {get; set;}
    public string communityUrl {
        
        get{
            String contactId = [select contactId from user where id =: UserInfo.getUserId() Limit 1][0].contactId;
            
            return contactId == null ? '' : '/sales';
        }
        
    }
    
    public String alertMessage {get; set;}
    public Boolean getrenderList(){
    	return StagePositionMap.containsKey(So.Stage__c);
	}
    public boolean hasClearanceStage {get; set;}
    
    public string CoId {get; set;}
    
    public CreditOrderSalesProcessPathExtension(ApexPages.StandardController std){
        
        this.stdController = stdController;
        
        So = new Credit_Order__c();
        StageValuesList = new list<string>();
        StagePositionMap = new map<string, integer>();
        sizeOfMap = 0;
		hasClearanceStage = false;
        
        shouldRedirect = false;
        
        CoId = (string)std.getId();
        
        So = [select id, Stage__c, Status__c
              from Credit_Order__c where id =:CoId limit 1];
        
        
            
        Schema.DescribeFieldResult fieldResult = Credit_Order__c.Stage__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        Integer i = 1;
        for( Schema.PicklistEntry pickListVal : ple){

            StageValuesList.add(pickListVal.getLabel());
            StagePositionMap.put(pickListVal.getLabel(), i);
            
            i++;
        }
        checkBillingMemoBalances();
        sizeOfMap = StagePositionMap.size();
    }

    public void checkBillingMemoBalances(){
        Decimal total = 0.00;
        List<AcctSeed__Billing__c> memos = [SELECT Id, AcctSeed__Balance__c, AcctSeed__Status__c FROM AcctSeed__Billing__c WHERE Credit_Order__c=:So.Id];
        Integer unpostedCount = 0;
        if(!memos.isEmpty()){
            for(AcctSeed__Billing__c bill:memos){
                if(bill.AcctSeed__Status__c == 'Posted'){
                    total += bill.AcctSeed__Balance__c;
                }else{
                    unpostedCount++;
                }
            }
        }
        
        billingBalances = unpostedCount == 0 ? total : 1; //1 is random value, it set > 0 because on frontend we check all posted billings
    }

    public void receiveInventoryToWarehouse(){
        AcctSeedERP__Warehouse__c warehouse = [SELECT Id FROM AcctSeedERP__Warehouse__c WHERE Name='South Plainfield' LIMIT 1];
        List<Credit_Order_Line__c> credit_lines = [SELECT Id, 
                                                        Product__c,
                                                        Quantity_Ordered__c, 
                                                        Sales_Order_Line__r.AcctSeedERP__Unit_Price__c, 
                                                        GL_Account_Variable_1__c 
                                                        FROM Credit_Order_Line__c 
                                                        WHERE Credit_Order__c=:So.Id];
        Set<Id> product_ids = new Set<Id>();
        for(Credit_Order_Line__c cl:credit_lines){
            product_ids.add(cl.Product__c);
        }
        List<AcctSeedERP__Inventory_Balance__c> balances = [SELECT Id, 
                                                                    AcctSeedERP__Product__c 
                                                                    FROM AcctSeedERP__Inventory_Balance__c 
                                                                    WHERE AcctSeedERP__Product__c IN:product_ids 
                                                                    AND AcctSeedERP__Warehouse__c =: warehouse.Id];
        Map<Id, Id> map_prod_ib = new Map<Id, Id>();
        for(AcctSeedERP__Inventory_Balance__c bl:balances){
            map_prod_ib.put(bl.AcctSeedERP__Product__c, bl.Id);
        }
        system.debug('map_prod_ib: '+JSON.serialize(map_prod_ib));
        List<AcctSeedERP__Inbound_Inventory_Movement__c> inbound_inventory = new List<AcctSeedERP__Inbound_Inventory_Movement__c>();
        //SELECT Id, AcctSeedERP__Warehouse__c, AcctSeedERP__GL_Account_Variable_1__c, AcctSeedERP__Inventory_Balance__c, AcctSeedERP__Movement_Date__c, AcctSeedERP__Unit_Cost__c, AcctSeedERP__Type__c, AcctSeedERP__Quantity__c FROM AcctSeedERP__Inbound_Inventory_Movement__c
        for(Credit_Order_Line__c cl:credit_lines){
            if(map_prod_ib.containsKey(cl.Product__c)){
                AcctSeedERP__Inbound_Inventory_Movement__c inb = new AcctSeedERP__Inbound_Inventory_Movement__c();
                inb.AcctSeedERP__GL_Account_Variable_1__c = cl.GL_Account_Variable_1__c;
                inb.AcctSeedERP__Inventory_Balance__c = map_prod_ib.get(cl.Product__c);
                inb.AcctSeedERP__Movement_Date__c = system.today();
                inb.AcctSeedERP__Unit_Cost__c = cl.Sales_Order_Line__r.AcctSeedERP__Unit_Price__c;
                inb.AcctSeedERP__Type__c = 'Non-Accounting';
                inb.AcctSeedERP__Quantity__c = cl.Quantity_Ordered__c;

                inbound_inventory.add(inb);
            }
        }
        system.debug('inbound_inventory: '+JSON.serialize(inbound_inventory));
        insert inbound_inventory;
        // Database.insert(inbound_inventory,false);

    }
    public PageReference changeStage(){
        
        string stageNameIs = ApexPages.currentPage().getParameters().get('stageNameIs'); 
        
        if(stageNameis != null && stageNameIs != So.Stage__c){
            
            So.Stage__c = stageNameIs;
            
            try{
                update so;

                if(so.Stage__c == 'Received'){
                    receiveInventoryToWarehouse();
                }
                shouldRedirect = true;
                redirectUrl = communityUrl + '/' + So.id;
            }catch(Exception e){
                alertMessage = e.getMessage();
                system.debug(e.getMessage());
            }
            
            
        }
        
        return null;
    }
}
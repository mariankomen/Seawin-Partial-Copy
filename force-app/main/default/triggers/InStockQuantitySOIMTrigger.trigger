trigger InStockQuantitySOIMTrigger on AcctSeedERP__Sales_Order_Inventory_Movement__c (after update) {
    // This trigger is only fired when changes are made on SOIM for example shipment line is added/removed
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            
            set<id> inventoryIds = new set<id>();
            
            for(AcctSeedERP__Sales_Order_Inventory_Movement__c soim : Trigger.new){
                
                inventoryIds.add(soim.AcctSeedERP__Inventory_Balance__c);
            }
            
            InStockQuantityHandler.Process(inventoryIds);
        }   
    }
}
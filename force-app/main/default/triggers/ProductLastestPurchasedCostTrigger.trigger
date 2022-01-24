trigger ProductLastestPurchasedCostTrigger on AcctSeedERP__Purchase_Order_Line__c (after update) {
    
    if(Trigger.IsAfter && Trigger.IsUpdate){
        
        ProductLastestPurchasedCostHandler.AfterCreation(Trigger.old, Trigger.new);
        
    }
}
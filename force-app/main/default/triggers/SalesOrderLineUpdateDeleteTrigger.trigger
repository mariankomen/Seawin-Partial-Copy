trigger SalesOrderLineUpdateDeleteTrigger on AcctSeedERP__Sales_Order_Line__c (after update) {
    if(Trigger.IsUpdate && Trigger.IsAfter){
        
        SalesOrderLineUpdateDeleteHandler.UpdateCase(Trigger.new);
    }
}
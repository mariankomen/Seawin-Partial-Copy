trigger SalesOrderLineDescriptionTrigger on AcctSeedERP__Sales_Order_Line__c (after update) {
    if(Trigger.IsAfter && Trigger.IsUpdate){
        SalesOrderLineDescriptionHandler.UpdateIt(Trigger.old, Trigger.new);
    }
}
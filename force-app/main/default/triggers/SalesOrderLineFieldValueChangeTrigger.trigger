trigger SalesOrderLineFieldValueChangeTrigger on AcctSeedERP__Sales_Order_Line__c (after update) {
    if(Trigger.IsAfter && Trigger.IsUpdate){
        SalesOrderLineFieldValueChangeHandler.FieldValueChange(Trigger.old, Trigger.new);
    }
}
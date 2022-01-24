trigger PurchaseOrderLineHandlerTrigger on AcctSeedERP__Purchase_Order_Line__c (after insert) {
    if(Trigger.IsAfter && Trigger.IsInsert){
        
        PurchaseOrderLineHandler.UpdateFields(Trigger.new);
        
    }
}
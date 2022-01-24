trigger PurchaseOrderProjectTrigger on AcctSeedERP__Purchase_Order__c (after insert, after update) {
    
    if(Trigger.IsAfter && Trigger.IsInsert){
        
        PurchaseOrderProjectTriggerHandler.createIt(new list<AcctSeedERP__Purchase_Order__c>(), Trigger.new);
        
    }else if(Trigger.IsAfter && Trigger.IsUpdate){
        
        PurchaseOrderProjectTriggerHandler.createIt(Trigger.old, Trigger.new);
    }
}
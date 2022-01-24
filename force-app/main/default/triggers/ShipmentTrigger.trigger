trigger ShipmentTrigger on AcctSeedERP__Shipment__c (before insert, after update) {

    if(Trigger.IsBefore && Trigger.IsInsert){
        
        ShipmentHandler.createIt(Trigger.new);
    }else if(trigger.IsAfter && Trigger.isUpdate){
        
        ShipmentUpdateHandler.UpdateIt(Trigger.old, Trigger.new);
        
    }
}
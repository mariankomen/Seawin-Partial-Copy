trigger POShipmentUpdateTrigger on PO_Shipment__c (after insert, after update) {

    if(Trigger.IsAfter && Trigger.IsInsert){
        
        POShipmentUpdateHandler.UpdateIt(new List<PO_Shipment__c>(), Trigger.new);
        
    }else if(Trigger.IsAfter && Trigger.IsUpdate){
        
        POShipmentUpdateHandler.UpdateIt(Trigger.old, Trigger.new);
        
    }
    
}
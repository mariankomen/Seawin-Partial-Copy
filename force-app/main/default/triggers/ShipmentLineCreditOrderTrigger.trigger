trigger ShipmentLineCreditOrderTrigger on Shipment_Line_Credit_Order__c (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            ShipmentCreditOrderLineTriggerHandler.beforeInsertExtension(Trigger.new);
        }else if(Trigger.isUpdate){

        }
    }
}
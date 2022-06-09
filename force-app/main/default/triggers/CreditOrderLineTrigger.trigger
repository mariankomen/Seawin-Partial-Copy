trigger CreditOrderLineTrigger on Credit_Order_Line__c (after insert, after update, after delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CreditOrderLineTriggerHandler.insertExecute(Trigger.new);
        }
    }
}
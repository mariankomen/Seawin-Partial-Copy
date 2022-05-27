trigger CommissionsTrigger on Sales_Order_Commissions__c (after insert, after update, after delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            CommissionTriggerHandler.afterInsertHandler(Trigger.new);
        }else if(Trigger.isDelete){
            CommissionTriggerHandler.afterInsertHandler(Trigger.old);
        }
    }
}
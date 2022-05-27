trigger CommissionFieldsReplicateTrigger on AcctSeedERP__Sales_Order__c (after insert, after update) {

    if(Trigger.isAfter && Trigger.isInsert){

        CommissionFieldsReplicateHandler.Replicate(trigger.new);
        AllowOppSharingHandler.handleSalesOrderCreate(Trigger.new);

    }else if(Trigger.isAfter && Trigger.isUpdate){

        CommissionFieldsReplicateHandler.CopyNewValues(Trigger.old, Trigger.new);
        AllowOppSharingHandler.handleSalesOrderChange(Trigger.new, Trigger.old);
    }
}
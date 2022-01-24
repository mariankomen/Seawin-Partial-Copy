trigger CommissionFieldsReplicateTrigger on AcctSeedERP__Sales_Order__c (after insert, after update) {

    if(trigger.isAfter && trigger.isInsert){

        CommissionFieldsReplicateHandler.Replicate(trigger.new);
    }else if(trigger.isAfter && trigger.isUpdate){

        CommissionFieldsReplicateHandler.CopyNewValues(Trigger.old, Trigger.new);
    }
}
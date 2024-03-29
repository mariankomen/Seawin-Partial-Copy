trigger OpportunityStageTrigger on AcctSeedERP__Sales_Order__c (after insert, after update, after delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //System.debug('1');
            OpportunityStageHandler.CreateSO(Trigger.New);
            SalesOrderDashboardHandler.createNewRecords(Trigger.new);
        }
        
        else if(Trigger.isUpdate){
            //System.debug('2');
            OpportunityStageHandler.UpdateSO(Trigger.Old, Trigger.New);
            SalesOrderDashboardHandler.updateExistingRecordsSO(Trigger.new);
        }
        else if(Trigger.isDelete){
            //System.debug('3');
            SalesOrderDashboardHandler.deleteRecords(Trigger.old);
            OpportunityStageHandler.DeleteSo(Trigger.Old);
    }
    }
}
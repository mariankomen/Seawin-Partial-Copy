trigger AfterOpportunityTrigger on Opportunity (after update, before delete) {
	if(Trigger.isAfter && Trigger.isUpdate){
        
        RecordTypeSyncHandler.AfterUpdateOpportunity(Trigger.old, Trigger.new);
        ProcessApprovalOpportunityHandler.Check_Email(Trigger.old, Trigger.new);
        SyncOptionalProductsToQuoteHandler.SyncToQuote(Trigger.old, Trigger.new);
        
        OpportunityDashboardHandler.updateExistingRecords(Trigger.new);
    } else if(Trigger.isBefore && Trigger.isDelete){
        OpportunityDashboardHandler.deleteRecords(Trigger.old);
    }
}
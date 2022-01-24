trigger AfterOpportunityTrigger on Opportunity (after update) {
	if(Trigger.isAfter && Trigger.isUpdate){
        
        RecordTypeSyncHandler.AfterUpdateOpportunity(Trigger.old, Trigger.new);
        ProcessApprovalOpportunityHandler.Check_Email(Trigger.old, Trigger.new);
        SyncOptionalProductsToQuoteHandler.SyncToQuote(Trigger.old, Trigger.new);
        
    }
}
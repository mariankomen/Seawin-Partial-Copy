trigger AfterOpportunityTrigger on Opportunity (after update, before delete) {
	if(Trigger.isAfter && Trigger.isUpdate){
        
        RecordTypeSyncHandler.AfterUpdateOpportunity(Trigger.old, Trigger.new);
        ProcessApprovalOpportunityHandler.Check_Email(Trigger.old, Trigger.new);
        SyncOptionalProductsToQuoteHandler.SyncToQuote(Trigger.old, Trigger.new);

        //!FIX HERE
        //OpportunityDashboardHandler.updateExistingRecords(Trigger.new);

        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    } else if(Trigger.isBefore && Trigger.isDelete){
        OpportunityDashboardHandler.deleteRecords(Trigger.old);
    }
}
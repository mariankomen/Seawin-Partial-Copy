trigger OpportunityAccountUpdateTrigger on Opportunity (after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        
        OpportunityAccountUpdateHandler.UpdateQuoteAccount(Trigger.Old, Trigger.New);
        
    }
}
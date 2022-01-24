trigger OpportunityAccountChangeTrigger on Opportunity (before update) {
    if(trigger.isBefore && trigger.IsUpdate){
        OpportunityAccountChangeHandler.ChangeAccountAddress(trigger.old, trigger.new);
    }
}
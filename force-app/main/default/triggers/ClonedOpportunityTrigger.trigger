trigger ClonedOpportunityTrigger on Opportunity (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        for(Opportunity opp : Trigger.New) {
            if(opp.isClone() && opp.Type != 'Template'){
                ClonedOpportunityHandler.OnCloneCopyOP(Trigger.New);
            }
        }
    }
}
trigger OpportunityProjectTrigger on Opportunity (after insert, after update) {
    
    if(Trigger.IsAfter && Trigger.IsInsert){
        
        OpportunityProjectTriggerHandler.createIt(new list<Opportunity>(), Trigger.new);
        CommissionFieldsReplicateHandler.ReplicateOpportunities(trigger.new);
        
    }else if(Trigger.IsAfter && Trigger.IsUpdate){
        
        OpportunityProjectTriggerHandler.createIt(trigger.old, Trigger.new);
        CommissionFieldsReplicateHandler.CopyNewValuesOpportunity(Trigger.old, Trigger.new);
    }

}
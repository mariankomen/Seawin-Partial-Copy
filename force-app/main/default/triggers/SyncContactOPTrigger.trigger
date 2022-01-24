trigger SyncContactOPTrigger on Opportunity (after update) {
	if(Trigger.IsAfter){
        if(Trigger.IsUpdate){
            SyncContactOPandSOHandler.Opportunity_Update(trigger.old, trigger.new);
        }
        
    }
}
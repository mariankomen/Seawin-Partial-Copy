trigger OpportunitySyncShippingInfoTrigger on Opportunity (after update) {
    if(Trigger.IsAfter && Trigger.IsUpdate){
        
        OpportunitySyncShippingInfoHandler.StartUpdate(Trigger.old, Trigger.new);
    }
}
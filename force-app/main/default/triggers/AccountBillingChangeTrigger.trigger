trigger AccountBillingChangeTrigger on Account (after update) {
    
    if(Trigger.IsAfter && Trigger.IsUpdate){
        
        AccountBillingChangeHandler.AccountBillingChangeHandler(Trigger.old, Trigger.new);
        
    }
}
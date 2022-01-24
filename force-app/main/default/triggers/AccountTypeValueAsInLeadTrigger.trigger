trigger AccountTypeValueAsInLeadTrigger on Account (before insert) {
    
    if(Trigger.IsInsert && Trigger.isBefore){
        
        AccountTypeValueAsInLeadHandler.Populate(Trigger.new);
        
    }
}
trigger BeforeAccountTrigger on Account (before insert, before update) {
    
    if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate)){
        
        AutoSalesRepAssignmentHandler.Assignment(Trigger.new);
        NullifyTemporaryValues.Nullify(Trigger.new);
    }
}
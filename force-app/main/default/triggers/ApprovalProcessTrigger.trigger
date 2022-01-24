trigger ApprovalProcessTrigger on Account (after update) {
	
    if(Trigger.IsAfter && Trigger.IsUpdate){
        
        ApprovalProcessTriggerHandler.CheckGL(Trigger.old, Trigger.new);
        ApprovalProcessTriggerHandler.Check_Email(Trigger.old, Trigger.new);
        
    }
}
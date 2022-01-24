trigger CloneBeforeTrigger on Opportunity (before insert) {
    
    if(Trigger.isbefore && Trigger.isinsert){
        
     	CloneBeforeHandler.Process(Trigger.new);   
        
    }
}
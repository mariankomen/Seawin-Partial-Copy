trigger AccountGLPrePopulateTrigger on Account (before insert) {
    
    if(Trigger.IsInsert && Trigger.IsBefore){
        
        AccountGLPrePopulateHandler.PrePopulate(Trigger.new);
        
    }
}
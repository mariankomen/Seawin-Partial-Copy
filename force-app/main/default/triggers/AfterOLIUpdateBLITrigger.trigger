trigger AfterOLIUpdateBLITrigger on OpportunityLineItem (after update) {

    if(Trigger.isAfter && Trigger.isUpdate){
        
        AfterOLIUpdateBLIHandler.updateBLI(Trigger.old, Trigger.new);
        
    }
    
}
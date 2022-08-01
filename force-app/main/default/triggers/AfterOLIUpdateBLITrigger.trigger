trigger AfterOLIUpdateBLITrigger on OpportunityLineItem (after update, before delete) {

    if(Trigger.isAfter && Trigger.isUpdate){
        
        AfterOLIUpdateBLIHandler.updateBLI(Trigger.old, Trigger.new);
        
    }else if(Trigger.isBefore && Trigger.isDelete){
        AfterOLIUpdateBLIHandler.beforeDeleteExtension(Trigger.old);
    }
    
}
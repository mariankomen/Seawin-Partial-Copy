trigger BeforeOpportunityTrigger on Opportunity (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
     	
        AutoSalesRepAssignmentHandler.Assignment(Trigger.new);
        NullifyTemporaryValues.Nullify(Trigger.new);
    }else if(Trigger.isBefore && Trigger.isUpdate){
     
        // run the handler to update Leadsource upon contact change on opportunity
        NullifyTemporaryValues.Nullify(Trigger.new);
        OpportunityContactChangeHandler.runHandler(Trigger.old, Trigger.new);
    }
}
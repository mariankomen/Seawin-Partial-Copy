trigger BeforeOpportunityTrigger on Opportunity (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
     	
        AutoSalesRepAssignmentHandler.Assignment(Trigger.new);
        NullifyTemporaryValues.Nullify(Trigger.new);
    }else if(Trigger.isBefore && Trigger.isUpdate){
        System.debug('TEST: '+[SELECT Id, Manufacturer_Rep__c, Name FROM Opportunity WHERE id=:Trigger.new[0].Id]);
        // run the handler to update Leadsource upon contact change on opportunity
        NullifyTemporaryValues.Nullify(Trigger.new);
        OpportunityContactChangeHandler.runHandler(Trigger.old, Trigger.new);
    }
}
trigger SalRepTeamTrigger on Sales_Rep__c (after insert, after update, after delete) {

    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            SalRepTeamHandler.handleSharingAccess(Trigger.old,Trigger.new);
        }
    }
}
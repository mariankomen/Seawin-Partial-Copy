/*****************************************************************************************************
*   @trigger      : AllowOppSharingTrigger
*   @object       : Opportunity
*   @description  : trigger used for sharing access to opportunities after insert or changin owner
*   @author       : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/
trigger AllowOppSharingTrigger on Opportunity (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AllowOppSharingHandler.handleOpportunityCreate(Trigger.new);
        }
        if(Trigger.isUpdate){
            AllowOppSharingHandler.handleOpportunityChange(Trigger.new, Trigger.old);
        }
    }
}
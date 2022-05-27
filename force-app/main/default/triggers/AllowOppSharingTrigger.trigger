/*****************************************************************************************************
*   @trigger      : AllowOppSharingTrigger
*   @object       : Opportunity
*   @description  : trigger used for sharing access to opportunities after insert or changin owner
*   @author       : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/
trigger AllowOppSharingTrigger on Opportunity (after insert, after update) {
    if(!Test.isRunningTest()){
        if(Trigger.isAfter){
            if(Trigger.isInsert && !Test.isRunningTest()){
                AllowOppSharingHandler.handleOpportunityCreate(Trigger.new);
            }
            if(Trigger.isUpdate && !Test.isRunningTest()){
                AllowOppSharingHandler.handleOpportunityChange(Trigger.new, Trigger.old);
            }
        }
    }
    
}
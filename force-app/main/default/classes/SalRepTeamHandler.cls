/*****************************************************************************************************
*   @class        : SalRepTeamHandler
*   @description  : public class trigger handler of [SalRepTeamTrigger] on [Sales_Rep__c] object
*   @author       : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/
public with sharing class SalRepTeamHandler {
    
    
    /************************************************************************************************************
    *   @method       : handleSharingAccess
    *   @description  : static method which handler Visible_to field change, and add or remove opp and so sharing
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    ************************************************************************************************************/
    public static void handleSharingAccess(List<Sales_Rep__c> trigger_old, List<Sales_Rep__c> trigger_new){
        Map<Id, Sales_Rep__c> trigger_old_map = new Map<Id, Sales_Rep__c>(trigger_old);
        Map<Id, Sales_Rep__c> trigger_new_map = new Map<Id, Sales_Rep__c>(trigger_new);

        for(Sales_Rep__c sr: trigger_new){
            List<String> old_visible_to = trigger_old_map.get(sr.Id).Team__c.split(';');
            List<String> new_visible_to = sr.Team__c.split(';');

            Set<Id> for_adding_sharing = new Set<Id>();
            Set<Id> for_removing_sharing = new Set<Id>();

            for(String userId: old_visible_to){
                if(!new_visible_to.contains(userId)) for_removing_sharing.add((Id)userId);
            }
            for(String userId: new_visible_to){
                if(!old_visible_to.contains(userId)) for_adding_sharing.add((Id)userId);
            }

            if(for_adding_sharing.size() > 0){
                SharingAccessExtension.createSharing(for_adding_sharing, sr.Id);
                SharingAccessExtension.createSharingSalesOrder(for_adding_sharing, sr.Id);
            }
    
            if(for_removing_sharing.size() > 0){
                SharingAccessExtension.removeSharing(for_removing_sharing, sr.Id);
                SharingAccessExtension.removeSharingSalesOrder(for_removing_sharing, sr.Id);
            }

        }

    }

    
}

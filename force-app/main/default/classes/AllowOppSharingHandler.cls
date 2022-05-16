/*****************************************************************************************************
*   @class        : AllowOppSharingHandler
*   @description  : public class trigger handler of [AllowOppSharingTrigger] on [Opportunity] object
*   @author       : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/
public class AllowOppSharingHandler {
    
    /*****************************************************************************************************
    *   @method       : handleSharingOnOpportunities
    *   @description  : 
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static void handleOpportunityChange(List<Opportunity> trigger_new, List<Opportunity> trigger_old){
        Map<Id, Opportunity> trigger_new_map = new Map<Id, Opportunity>(trigger_new);
        Map<Id, Opportunity> trigger_old_map = new Map<Id, Opportunity>(trigger_old);
        Map<Id, Set<Id>> sal_rep_relation = getMembersOfSalesTeams();
        for(Id opp_new:trigger_new_map.keySet()){
            Id salRepId_old = trigger_old_map.get(opp_new).Sales_Rep_O__c;
            Id salRepId_new = trigger_new_map.get(opp_new).Sales_Rep_O__c;

            //Check did Sal Rep Team has been changed
            if(trigger_new_map.get(opp_new).Sales_Rep_O__c != trigger_old_map.get(opp_new).Sales_Rep_O__c){
                Set<Id> membersIds_remove = sal_rep_relation.get(trigger_old_map.get(opp_new).Sales_Rep_O__c);
                Set<Id> membersIds_add = sal_rep_relation.get(trigger_new_map.get(opp_new).Sales_Rep_O__c);

                SharingAccessExtension.removeSharing(membersIds_remove, salRepId_old);
                SharingAccessExtension.createSharing(membersIds_add, salRepId_new);
            }   

            if(trigger_new_map.get(opp_new).OwnerId != trigger_old_map.get(opp_new).OwnerId){
                SharingAccessExtension.removeSharing(new Set<Id>{trigger_new_map.get(opp_new).OwnerId}, salRepId_old);
            }
        }

    }

    /*****************************************************************************************************
    *   @method       : handleSharingOnOpportunities
    *   @description  : 
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static void handleOpportunityCreate(List<Opportunity> trigger_new){
        Map<Id, Set<Id>> sal_rep_relation = getMembersOfSalesTeams();

        for(Opportunity opp:trigger_new){
            if(String.isNotBlank(opp.Sales_Rep_O__c)){
                Id salRepId = opp.Sales_Rep_O__c;
                SharingAccessExtension.createSharing(sal_rep_relation.get(salRepId), salRepId);
            }
        }
    }



    /*****************************************************************************************************
    *   @method       : getMembersOfSalesTeams
    *   @description  : public method returns Map<SalRepID, Set<Id members>>
    *   @return       : Map<Id, Set<Id>>
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static Map<Id, Set<Id>> getMembersOfSalesTeams(){
        List<Sales_Rep__c> sales_rep_with_members = [SELECT Id, Team__c FROM Sales_Rep__c LIMIT 50000];
        Map<Id, Set<Id>> sal_rep_relation = new Map<Id, Set<Id>>();
        
        for(Sales_Rep__c sr: sales_rep_with_members){
            List<Id> members = (List<Id>)sr.Team__c.split(';');
            if(!sal_rep_relation.containsKey(sr.Id)){
                sal_rep_relation.put(sr.Id, new Set<Id>(members));
            }
        }

        return sal_rep_relation;
    }


    
}
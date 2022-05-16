/*****************************************************************************************************
*   @class        : SharingAccessExtension
*   @description  : public class used for creating,deleting sharing setting for opportunity or so 
*   @author       : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/

public with sharing class SharingAccessExtension {
    
    /*****************************************************************************************************
    *   @method       : createSharing
    *   @description  : static method which create Opportunity_Share records and execute batch for iserting them
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static void createSharing(Set<Id> usersIds, Id salRepId){
        List<Opportunity> related_opp_to_rep = [SELECT Id, OwnerId FROM Opportunity WHERE Sales_Rep_O__c=:salRepId];
        List<OpportunityShare> sharedList = [SELECT Id, OpportunityId, UserOrGroupId FROM OpportunityShare WHERE OpportunityId IN:related_opp_to_rep];

        //OpportunityId and list of shared User Ids
        Map<Id, List<Id>> opportunity_and_shared_users = new Map<Id, List<Id>>();
        for(OpportunityShare sh:sharedList){
            if(!opportunity_and_shared_users.containsKey(sh.OpportunityId)){
                List<Id> shared_to = new List<Id>{sh.UserOrGroupId};
                opportunity_and_shared_users.put(sh.OpportunityId, shared_to);
            }else {
                opportunity_and_shared_users.get(sh.OpportunityId).add(sh.UserOrGroupId);
            }
        }

        //User id and list of opportunities where need to share access
        Map<Id, List<Id>> need_share_to = new Map<Id, List<Id>>();

        //In current loop we search oppotunities of which should give access to user
        for(Id userId:usersIds){
            for(Id opp:opportunity_and_shared_users.keySet()){
                if(!opportunity_and_shared_users.get(opp).contains(userId)){
                    if(!need_share_to.containsKey(userId)){
                        need_share_to.put(userId, new List<Id>{opp});
                    }else{
                        need_share_to.get(userId).add(opp);
                    }
                }
            }
        }

        List<OpportunityShare> share_to_list = new List<OpportunityShare>();

        for(Id userId:need_share_to.keySet()){
            for(Id opp: need_share_to.get(userId)){
                OpportunityShare os = new OpportunityShare();
                os.OpportunityAccessLevel = 'Edit';
                os.OpportunityId = opp;
                os.RowCause = 'Manual';
                os.UserOrGroupId = userId;
                share_to_list.add(os);
            }
        }
        ShareOpportunityAccessBatch batch = new ShareOpportunityAccessBatch(share_to_list);
        Database.executeBatch(batch, 500);
    }


    /*****************************************************************************************************
    *   @method       : removeSharing
    *   @description  : Query sharing record by rer team for selected users and execute batch for deleting
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static void removeSharing(Set<Id> membersIds, Id salRepId){

        List<OpportunityShare> deletable = [SELECT  Id 
                                                    FROM OpportunityShare 
                                                    WHERE Opportunity.Sales_Rep_O__c =: salRepId 
                                                    AND UserOrGroupId IN:membersIds 
                                                    AND RowCause = 'Manual' 
                                                    LIMIT 50000];

        RemoveShareOpportunityAccessBatch batch = new RemoveShareOpportunityAccessBatch(deletable);
        Database.executeBatch(batch, 500);
    }


    /*****************************************************************************************************
    *   @method       : createSharingSalesOrder
    *   @description  : static method which create Opportunity_Share records and execute batch for iserting them
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static void createSharingSalesOrder(Set<Id> usersIds, Id salRepId){
        List<AcctSeedERP__Sales_Order__c> related_opp_to_rep = [SELECT Id, OwnerId FROM AcctSeedERP__Sales_Order__c WHERE Sales_Rep_O__c=:salRepId];
        List<AcctSeedERP__Sales_Order__Share> sharedList = [SELECT Id, ParentId, UserOrGroupId FROM AcctSeedERP__Sales_Order__Share WHERE ParentId IN:related_opp_to_rep];

        //Sales Order id and list of shared User Ids
        Map<Id, List<Id>> salesorder_and_shared_users = new Map<Id, List<Id>>();
        for(AcctSeedERP__Sales_Order__Share sh:sharedList){
            if(!salesorder_and_shared_users.containsKey(sh.ParentId)){
                List<Id> shared_to = new List<Id>{sh.UserOrGroupId};
                salesorder_and_shared_users.put(sh.ParentId, shared_to);
            }else{
                salesorder_and_shared_users.get(sh.ParentId).add(sh.UserOrGroupId);
            }
        }

        //User id and list of salesorders where need to share access
        Map<Id, List<Id>> need_share_to = new Map<Id, List<Id>>();

        //In current loop we search oppotunities of which should give access to user
        for(Id userId:usersIds){
            for(Id opp:salesorder_and_shared_users.keySet()){
                if(!salesorder_and_shared_users.get(opp).contains(userId)){
                    if(!need_share_to.containsKey(userId)){
                        need_share_to.put(userId, new List<Id>{opp});
                    }else{
                        need_share_to.get(userId).add(opp);
                    }
                }
            }
        }

        List<AcctSeedERP__Sales_Order__Share> share_to_list = new List<AcctSeedERP__Sales_Order__Share>();

        for(Id userId:need_share_to.keySet()){
            for(Id so: need_share_to.get(userId)){
                AcctSeedERP__Sales_Order__Share os = new AcctSeedERP__Sales_Order__Share();
                os.AccessLevel = 'Edit';
                os.ParentId = so;
                os.RowCause = 'Manual';
                os.UserOrGroupId = userId;
                share_to_list.add(os);
            }
        }
        ShareOpportunityAccessBatch batch = new ShareOpportunityAccessBatch(share_to_list);
        Database.executeBatch(batch, 500);
    }

    /*****************************************************************************************************
    *   @method       : removeSharingSalesOrder
    *   @description  : Query sharing record by rer team for selected users and execute batch for deleting
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public static void removeSharingSalesOrder(Set<Id> membersIds, Id salRepId){

        List<AcctSeedERP__Sales_Order__Share> deletable = [SELECT  Id
                                                        FROM AcctSeedERP__Sales_Order__Share 
                                                        WHERE Parent.Sales_Rep_O__c =: salRepId 
                                                        AND UserOrGroupId IN:membersIds 
                                                        AND RowCause = 'Manual' 
                                                        LIMIT 50000];
        RemoveShareOpportunityAccessBatch batch = new RemoveShareOpportunityAccessBatch(deletable);
        Database.executeBatch(batch, 500);
    }
}

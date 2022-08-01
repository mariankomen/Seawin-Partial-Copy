public class AfterOLIUpdateBLIHandler {
    
    public static void updateBLI(LIST<OpportunityLineItem> oldData, LIST<OpportunityLineItem> newData){
        
        List<Id> oliIDs = new List<Id>();
        Integer i = 0;
        
        for(OpportunityLineItem oli : newData){
            if(oli.Size__c != oldData[i].Size__c || oli.Item_Description__c != oldData[i].Item_Description__c)
                oliIDs.add(oli.Id);
            i++;
        }
        
        List<AcctSeed__Billing_Line__c> bliList = [select id,AcctSeed__Opportunity_Product_Id__c,Size_Custom__c,Item_Description__c
                                                   from AcctSeed__Billing_Line__c
                                                   where AcctSeed__Opportunity_Product_Id__c in: oliIDs];
        
        for(OpportunityLineItem oli : newData){
            for(AcctSeed__Billing_Line__c bli : bliList){
                if(bli.AcctSeed__Opportunity_Product_Id__c == oli.Id){
                    bli.Size_Custom__c = oli.Size__c;
                    bli.Item_Description__c = oli.Item_Description__c;
                }
            }   
        }
        System.debug('bliList2: ' + bliList);
        update bliList;
        
    }


    public static void beforeDeleteExtension(List<OpportunityLineItem> oldData){
        Set<Id> set_lines_id = new Set<Id>();
        for(OpportunityLineItem oli: oldData){
            set_lines_id.add(oli.Id);
        }

        List<AcctSeed__Billing_Line__c> billed_lines = [SELECT Id, 
                                                            AcctSeed__Opportunity_Product_Id__c 
                                                            FROM AcctSeed__Billing_Line__c 
                                                            where AcctSeed__Opportunity_Product_Id__c IN: set_lines_id];
        Map<Id, Id> map_oli_bill = new Map<Id, Id>();
        for(AcctSeed__Billing_Line__c bl:billed_lines){
            map_oli_bill.put((Id)bl.AcctSeed__Opportunity_Product_Id__c, bl.Id);
        }
        for(OpportunityLineItem oli: oldData){
            
            if(map_oli_bill.containsKey(oli.Id)){
                oli.addError('Opportunity Line Item can not be deleted because it associated with billing line.');
            }
        }


    }
}
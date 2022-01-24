public class AfterSalesOrderTriggerHandler {
    
    public static void LinkBillings(List<AcctSeedERP__Sales_Order__c> data){
        
        
        map<id, id> OpptyToOrderMap = new map<id, id>();
        set<id> orderIds = new set<id>();
        for(AcctSeedERP__Sales_Order__c order : data){
            
            if(order.acctseederp__opportunity__c != null){
                orderIds.add(order.id);
                OpptyToOrderMap.put(order.acctseederp__opportunity__c, order.id);
            }
        }
        
        // Associate Billing to this SO
        List<AcctSeed__Billing__c> billings = [select id, AcctSeedERP__Sales_Order__c,
                                               AcctSeed__Opportunity__c from AcctSeed__Billing__c
                                               where AcctSeed__Opportunity__c in:OpptyToOrderMap.keyset()
                                               and
                                               AcctSeed__Opportunity__c != null and
                                               AcctSeedERP__Sales_Order__c = null];
        set<id> billingIds = new set<id>();
        if(!Billings.isEmpty()){
            
            for(AcctSeed__Billing__c bill : billings){
                
                id SOId = OpptyToOrderMap.get(bill.AcctSeed__Opportunity__c);
                
                if(SOId == null) continue;
                
                bill.AcctSeedERP__Sales_Order__c = SOId;
                billingIds.add(bill.id);
            }
            
            try{
                
                update billings;
                
                // Associate Billing Lines with this SO lines
                ProcessFurther(orderIds, billingIds);
            }catch(Exception ex){
                
                system.debug('Exception occured during Updating Billing with Sales Order Id: ');
                system.debug(ex.getMessage());
            }
        }
    }
    @future
    public static void ProcessFurther(set<id> orderIds, set<id> billingIds){
        
        List<AcctSeedERP__Sales_Order_Line__c> OrderLines = [select id, AcctSeedERP__Opportunity_Product_Id__c
                                                             from AcctSeedERP__Sales_ORder_Line__c where
                                                             AcctSeedERP__SAles_order__c in:orderIds];
        
        map<id, id> OpptyProdToSolMap = new map<id, id>();
        if(!OrderLines.isEmpty()){
            
            for(AcctSeedERP__Sales_Order_Line__c sol : OrderLines){
                
                OpptyProdToSolMap.put(sol.AcctSeedERP__Opportunity_Product_Id__c, sol.id);
            }
            
        }
        
        if(OpptyProdToSolMap.size() > 0){
            
            // now update billing lines with the sales order line IDs
            List<AcctSeed__Billing_Line__c> billingLines = [select id,acctseederp__sales_order_line__c, 
                                                            AcctSeed__Opportunity_Product_id__c from
                                                            AcctSeed__Billing_Line__c where 
                                                            AcctSeed__Billing__c in:BillingIds]; 
            
            if(!BillingLines.isEmpty()){
                
                
                for(AcctSeed__Billing_Line__c bl : billingLines){
                    
                    Id SOLid = OpptyProdToSolMap.get(bl.AcctSeed__Opportunity_Product_id__c);
                    
                    bl.acctseederp__sales_order_line__c = SOLid;
                    
                }
                
                try{
                    update BillingLines;
                    
                }catch(Exception ex){
                    
                    system.debug('Exception occured during Updating Billing Lines with Sales Order Line Id: ');
                    system.debug(ex.getMessage());
                    
                }
            }
            
        }

        // Now calculate commissions on sales order for the newly added billings
        List<AcctSeed__Billing_Cash_Receipt__c> cashReceipts = [select id, AcctSeed__Billing__c 
        from AcctSeed__Billing_Cash_Receipt__c
        where acctseed__billing__c in:billingIds];

        if(!cashReceipts.isEmpty()){

            CalculateCommissionsHandler.Start(cashReceipts);
        }

        List<AcctSeed__Billing_Credit_Memo__c> memoReceipts = [select id,AcctSeed__Billing_Invoice__c 
        from AcctSeed__Billing_Credit_Memo__c
        where acctseed__billing_Invoice__c in:billingIds];

        if(!memoReceipts.isEmpty()){

            CalculateCommissionsHandler.Start(memoReceipts);
        }
    }
}
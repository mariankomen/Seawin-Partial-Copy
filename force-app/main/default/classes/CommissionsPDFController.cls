/*****************************************************************************************************
*   @class           : CommissionsPDFController
*   @description     : Public class which uses in render monthly commission pdf
*   @author          : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/

public with sharing class CommissionsPDFController {


    public String pdf_date {get{
        return system.today().format();
    }}
    public Id holderId {get;set;}
    public Boolean showCommissionsPipeline {get;set;}
    public Boolean showCommissionsDue {get;set;}
    public List<CommissionPipeline> commPipeline {get;set;}
    public Map<Id, Decimal> total_commissionable_products {get;set;}
    public Map<Id, Decimal> total_paid_commissions {get;set;}

    public CommissionsPDFController() {

        commPipeline = new List<CommissionPipeline>();
        total_commissionable_products = new Map<Id, Decimal>();
        total_paid_commissions = new Map<Id, Decimal>();

        holderId = apexpages.currentpage().getparameters().get('id');

        if(holderId != null){
            String holderObject = String.valueOf(holderId.getSObjectType());

            List<AggregateResult> total_comm = [SELECT SUM(AcctSeedERP__Total__c) total,
                                                        AcctSeedERP__Sales_Order__c so
                                                        FROM AcctSeedERP__Sales_Order_Line__c 
                                                        WHERE AcctSeedERP__Product__r.Commissionable_Product__c = true
                                                        GROUP BY AcctSeedERP__Sales_Order__c LIMIT 50000];
            for(AggregateResult agr:total_comm){
            total_commissionable_products.put((Id)agr.get('so'), (Decimal)agr.get('total'));
            }

            List<AggregateResult> sum_paid_commissions = [SELECT SUM(Commission_Paid__c) total,
                                                            Sales_Order__c so
                                                            FROM Sales_Order_Commissions__c
                                                            GROUP BY Sales_Order__c LIMIT 50000];
            for(AggregateResult agr:sum_paid_commissions){
                total_paid_commissions.put((Id)agr.get('so'), (Decimal)agr.get('total'));
            }


            List<AcctSeedERP__Sales_Order__c> all_orders_of_holder = [SELECT Id, 
                                                                            Name,
                                                                            AcctSeedERP__Opportunity__r.Name,
                                                                            Manufacturer_Rep__c,
                                                                            Commission_Rate_Manufacturer_Rep__c,
                                                                            Referral_Sales_Rep__c,
                                                                            Commission_Rate_Referral_Sales_Rep__c,
                                                                            Sales_Rep_O__c,
                                                                            Commission_Rate_Sales_Rep__c,
                                                                            Specified_Rep__c,
                                                                            Commission_Rate_Specified_Rep__c
                                                                            FROM AcctSeedERP__Sales_Order__c
                                                                            WHERE (Manufacturer_Rep__c=:holderId 
                                                                            OR Referral_Sales_Rep__c=:holderId
                                                                            OR Sales_Rep_O__c=: holderId
                                                                            OR Specified_Rep__c=: holderId)
                                                                            AND AcctSeedERP__Total__c > 0];

            if(!all_orders_of_holder.isEmpty()){
                for(AcctSeedERP__Sales_Order__c so:all_orders_of_holder){
                    commPipeline.addAll(makeWrapperFromSO(so));
                }
            } 

            showCommissionsPipeline = commPipeline.size() > 0 ? true : false;
        }else {
            showCommissionsPipeline = false;
        }
                                                                     
        system.debug(JSON.serialize(commPipeline));
    }

    



    /*****************************************************************************************************
    *   @method       : calculateCommissionableTotal
    *   @description  : Calculate total of commissinable SOL of Sales Order
    *   @return       : Decimal
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public Decimal calculateCommissionableTotal(Id soId){
        return total_commissionable_products.containsKey(soId) ? total_commissionable_products.get(soId) : 0.00;
    }

    /*****************************************************************************************************
    *   @method       : calculatePaidCommissionsTotal
    *   @description  : Calculate total of paid commissions amount
    *   @return       : Decimal
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public Decimal calculatePaidCommissionsTotal(Id soId){
        
        return total_paid_commissions.containsKey(soId) ? total_paid_commissions.get(soId) : 0.00;

    }

    /*****************************************************************************************************
    *   @method       : calculatePaidCommissionsTotal
    *   @description  : Calculate total of paid commissions amount
    *   @return       : Decimal
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public Decimal calculateCommission(Decimal comm_lines_total, Decimal comm_percent){
        system.debug('comm_lines_total: '+comm_lines_total);
        system.debug('comm_percent: '+comm_percent);
        Decimal commission = (comm_percent * comm_lines_total)/100;
        return commission;
    }

    /*****************************************************************************************************
    *   @method       : makeWrapperFromSO
    *   @description  : current method make wrapper for pdf from existing so
    *   @return       : Decimal
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public List<CommissionPipeline> makeWrapperFromSO(AcctSeedERP__Sales_Order__c so){
        List<CommissionPipeline> commissions = new List<CommissionPipeline>();

        if(so.Manufacturer_Rep__c != null && so.Manufacturer_Rep__c == holderId && so.Commission_Rate_Manufacturer_Rep__c != null){
            commissions.add(compileCommissionPipeline(so, so.Commission_Rate_Manufacturer_Rep__c));
        }
        if(so.Referral_Sales_Rep__c != null && so.Referral_Sales_Rep__c == holderId && so.Commission_Rate_Referral_Sales_Rep__c != null){
            commissions.add(compileCommissionPipeline(so, so.Commission_Rate_Referral_Sales_Rep__c));
        }
        if(so.Sales_Rep_O__c != null && so.Sales_Rep_O__c == holderId && so.Commission_Rate_Sales_Rep__c != null){
            commissions.add(compileCommissionPipeline(so, so.Commission_Rate_Sales_Rep__c));
        }
        if(so.Specified_Rep__c != null && so.Specified_Rep__c == holderId && so.Commission_Rate_Specified_Rep__c != null){
            commissions.add(compileCommissionPipeline(so, so.Commission_Rate_Specified_Rep__c));
        }
        return commissions;
    }

    /*****************************************************************************************************
    *   @method       : makeWrapperFromSO
    *   @description  : current method make wrapper for pdf from existing so
    *   @return       : Decimal
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public CommissionPipeline compileCommissionPipeline(AcctSeedERP__Sales_Order__c so, Decimal commission_rate){
        
        Decimal commissionable_total = calculateCommissionableTotal(so.Id);
        String oppName = so.AcctSeedERP__Opportunity__r.Name != null ? so.AcctSeedERP__Opportunity__r.Name : '-';

        system.debug('so.Name: '+so.Name);
        system.debug('oppName: '+oppName);
        system.debug('commissionable_total: '+commissionable_total);
        system.debug('scommission_rate: '+commission_rate);
        system.debug('calculateCommission(commissionable_total, commission_rate): '+calculateCommission(commissionable_total, commission_rate));
        system.debug('calculatePaidCommissionsTotal(so.Id): '+calculatePaidCommissionsTotal(so.Id));

        CommissionPipeline com_pipeline_record = new CommissionPipeline(
            so.Name,
            oppName,
            commissionable_total,
            commission_rate,
            calculateCommission(commissionable_total, commission_rate),
            calculatePaidCommissionsTotal(so.Id)
        );

        return com_pipeline_record;
    }

    public class CommissionPipeline{

        public String sales_order_name {get; set;}
        public String opportunity_name {get;set;}
        public Decimal commissionable_total {get; set;} //Total of all commissionable Sales Order Lines
        public Decimal commissionable_percent {get; set;}
        public Decimal commission_amount {get; set;}
        public Decimal commission_paid {get; set;}
        public Decimal commission_balance {get; set;} //Total com amount - paid

        public CommissionPipeline(String so, String opp, Decimal com_total, Decimal comm_perc, Decimal comm_am, Decimal comm_paid){
            sales_order_name = so;
            opportunity_name = opp;
            commissionable_total = com_total.setScale(2);
            commissionable_percent = comm_perc;
            commission_amount = comm_am.setScale(2);
            commission_paid = comm_paid.setScale(2);
            commission_balance = (comm_am - comm_paid).setScale(2);
        }
    }
}

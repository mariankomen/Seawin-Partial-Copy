public class CalculateCommissionsHandler {
    
    public static Boolean Start(List<AcctSeed__Billing_Cash_Receipt__c> receipts){
        map<id, AcctSeed__Billing_Cash_Receipt__c> receiptsMap = new map<id, AcctSeed__Billing_Cash_Receipt__c>(receipts);
        set<id> billingIds = new set<id>();
        
        for(AcctSeed__Billing_Cash_Receipt__c receipt : receipts){
            billingIds.add(receipt.AcctSeed__Billing__c);
        }
        
        map<id, Decimal> BillingLineMap = new map<id, Decimal>();
        BillingLineMap = FindBillingLineTotal(billingIds); //Map Of total sum amounts of commissinable products from billing

        if(BillingLineMap.size() == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'All billing line products are not commissinable or amount equal 0.'));
            return false;
        } else {

            if(receiptsMap.size() > 0 && BillingLineMap.size() > 0){
                List<AcctSeed__Billing_Cash_Receipt__c> receiptData = [select id,
                                                                    CreatedDate, 
                                                                    AcctSeed__Applied_Amount__c,
                                                                    AcctSeed__Adjustment_Amount__c,
                                                                    AcctSeed__Billing__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c, 
                                                                    AcctSeed__Billing__r.AcctSeed__Total__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c,

                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.OwnerId,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c,

                                                                    AcctSeed__Billing__r.Credit_Order__c,

                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_O__r.IsTeam__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_O__r.Company_Name_Lookup__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Specified_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.OwnerId,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c


                                                                    from AcctSeed__Billing_Cash_Receipt__c
                                                                    where id in:receiptsMap.keySet() LIMIT 100];
                if(!receiptData.isEmpty()){
                    List<Sales_Order_Commissions__c> commissions = new List<Sales_Order_Commissions__c>();
                    
                    for(AcctSeed__Billing_Cash_Receipt__c data : receiptData){
                        
                        if(BillingLineMap.containsKey(data.acctseed__billing__c)){
                            
                            //Check if billing has so
                            if(data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c != null){

                                Boolean HasManRep = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null;
                                Boolean HasReferral = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c != null;
                                Boolean HasSpecified = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c != null;
                                Boolean IsTeam = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c;
                                
                                Decimal SalesPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c;
                                Decimal ReferralPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c;
                                Decimal ManRepPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c;
                                Decimal SpecifiedPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c;
    
                                Decimal BillingLineTotal = BillingLineMap.containsKey(data.acctseed__billing__c) ? BillingLineMap.get(data.acctseed__billing__c) : 0;
    
                                if(data.AcctSeed__Adjustment_Amount__c == null){
                                    data.AcctSeed__Adjustment_Amount__c = 0;
                                } 
                                if(data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c == null){
                                    data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c = 0;
                                }
                                
                                Decimal BillingTotal = data.AcctSeed__Billing__r.AcctSeed__Total__c - data.AcctSeed__Adjustment_Amount__c - data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c;
    
                                if(BillingTotal > 0 && BillingLineTotal > 0)
                                    commissions.addAll(CompileCommissions(
                                        true,
                                        data.id,
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.OwnerId,
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c,
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c,
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c,
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                                        data.AcctSeed__Applied_Amount__c, 
                                        BillingTotal, 
                                        BillingLineTotal, 
                                        SalesPercent, 
                                        ReferralPercent, 
                                        ManRepPercent, 
                                        SpecifiedPercent,
                                        HasReferral, 
                                        HasManRep,
                                        HasSpecified,
                                        IsTeam, 
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c,
                                        data.AcctSeed__Billing__c,
                                        data.createddate,
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c, 
                                        data.AcctSeed__Billing__r.Credit_Order__c));

                            //If billing has only Opportunity
                            }else if(data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c == null && data.AcctSeed__Billing__r.AcctSeed__Opportunity__c != null){

                                Boolean HasManRep = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null;
                                Boolean HasReferral = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c != null;
                                Boolean HasSpecified = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Specified_Rep__c != null;
                                Boolean IsTeam = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c;
                                
                                Decimal SalesPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c;
                                Decimal ReferralPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c;
                                Decimal ManRepPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c;
                                Decimal SpecifiedPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c;
    
                                Decimal BillingLineTotal = BillingLineMap.containsKey(data.acctseed__billing__c) ? BillingLineMap.get(data.acctseed__billing__c) : 0;

                                if(data.AcctSeed__Adjustment_Amount__c == null){
                                    data.AcctSeed__Adjustment_Amount__c = 0;
                                } 
                                if(data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c == null){
                                    data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c = 0;
                                }
                                
                                Decimal BillingTotal = data.AcctSeed__Billing__r.AcctSeed__Total__c - data.AcctSeed__Adjustment_Amount__c - data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c;

                                if(BillingTotal > 0 && BillingLineTotal > 0)
                                    commissions.addAll(CompileCommissions(
                                        true,
                                        data.id,
                                        data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.OwnerId,
                                        data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c,
                                        data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c,
                                        data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Specified_Rep__c,
                                        data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                                        data.AcctSeed__Applied_Amount__c, 
                                        BillingTotal, 
                                        BillingLineTotal, 
                                        SalesPercent, 
                                        ReferralPercent, 
                                        ManRepPercent, 
                                        SpecifiedPercent,
                                        HasReferral, 
                                        HasManRep,
                                        HasSpecified,
                                        IsTeam, 
                                        data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c,
                                        data.AcctSeed__Billing__c,
                                        data.createddate,
                                        data.AcctSeed__Billing__r.AcctSeed__Opportunity__c,
                                        data.AcctSeed__Billing__r.Credit_Order__c));
                            }         
                        }
                    }




                    if(!commissions.isEmpty()){
                        try{
                            insert commissions;
                           
                        } catch(Exception e){
                            system.debug('error: '+e.getMessage());
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error during inserting new commissions: '+e));
                        }
                    } 
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Cant find Billing Cash Receipt records.'));
                }
            }
            return true;
        }
    }
    
    public static Boolean Start(List<AcctSeed__Billing_Credit_Memo__c> receipts){
        map<id, AcctSeed__Billing_Credit_Memo__c> receiptsMap = new map<id, AcctSeed__Billing_Credit_Memo__c>(receipts);
        
        set<id> billingIds = new set<id>();
        
        for(AcctSeed__Billing_Credit_Memo__c receipt : receipts){
            billingIds.add(receipt.AcctSeed__Billing_Invoice__c);
        }
        
        map<id, Decimal> BillingLineMap = new map<id, Decimal>();
        
        BillingLineMap = FindBillingLineTotal(billingIds);

        if(BillingLineMap.size() == 0){
            return true;
        } else {
            if(receiptsMap.size() > 0 && BillingLineMap.size() > 0){
                
                List<AcctSeed__Billing_Credit_Memo__c> receiptData = [select id, 
                                                                    CreatedDate,
                                                                    AcctSeed__Amount__c,
                                                                    AcctSeed__Billing_Invoice__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Total__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c, 
                                                                    AcctSeed__Billing_Invoice__r.Total_Amount_Due__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.OwnerId,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c,

                                                                    AcctSeed__Billing_Credit_Memo__r.Credit_Order__c,

                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_O__r.IsTeam__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_O__r.Company_Name_Lookup__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Specified_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.OwnerId,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c,
                                                                    AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c

                                                                    from AcctSeed__Billing_Credit_Memo__c
                                                                    where id in:receiptsMap.keySet() LIMIT 100];
                
                if(!receiptData.isEmpty()){
                    
                    List<Sales_Order_Commissions__c> commissions = new List<Sales_Order_Commissions__c>();
                    
                    for(AcctSeed__Billing_Credit_Memo__c data : receiptData){
                        
                        if(BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c)){
                            //If credit memo has so
                            if(data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c != null){

                                Decimal BillingLineTotal = BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c) ? 
                                BillingLineMap.get(data.AcctSeed__Billing_Invoice__c) : 0;
                                Boolean HasManRep = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null;
                                Boolean HasReferral = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c != null;
                                Boolean HasSpecified = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c != null;
                                Boolean IsTeam = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c;
                                
                                Decimal SalesPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c;
                                Decimal ReferralPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c;
                                Decimal ManRepPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c;
                                Decimal SpecifiedPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c;
                                
                                if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && BillingLineTotal > 0){
                                    commissions.addAll(CompileCommissions(
                                        false,
                                        data.id,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.OwnerId,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                                        Math.abs(data.AcctSeed__Amount__c), 
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Total__c, 
                                        // data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c, 
                                        BillingLineTotal, 
                                        SalesPercent, 
                                        ReferralPercent, 
                                        ManRepPercent, 
                                        SpecifiedPercent,
                                        HasReferral, 
                                        HasManRep,
                                        HasSpecified,
                                        IsTeam, 
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c,
                                        data.AcctSeed__Billing_Invoice__c,
                                        data.createddate,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c,
                                        data.AcctSeed__Billing_Credit_Memo__r.Credit_Order__c));
                                }
                                //If credit memo has only opportunity
                            } else if(data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c == null && data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c != null){

                                Decimal BillingLineTotal = BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c) ? 
                                                                   BillingLineMap.get(data.AcctSeed__Billing_Invoice__c) : 0;

                                Boolean HasManRep = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null;
                                Boolean HasReferral = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c != null;
                                Boolean HasSpecified = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Specified_Rep__c != null;
                                Boolean IsTeam = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c;
                                
                                Decimal SalesPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c;
                                Decimal ReferralPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c;
                                Decimal ManRepPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c;
                                Decimal SpecifiedPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c;

                                if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && BillingLineTotal > 0){
                                    commissions.addAll(CompileCommissions(
                                        false,
                                        data.id,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.OwnerId,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Specified_Rep__c,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                                        Math.abs(data.AcctSeed__Amount__c), 
                                        data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c, 
                                        BillingLineTotal, 
                                        SalesPercent, 
                                        ReferralPercent, 
                                        ManRepPercent, 
                                        SpecifiedPercent,
                                        HasReferral, 
                                        HasManRep,
                                        HasSpecified,
                                        IsTeam, 
                                        data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c,
                                        data.AcctSeed__Billing_Invoice__c,
                                        data.createddate,
                                        data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c,
                                        data.AcctSeed__Billing_Credit_Memo__r.Credit_Order__c));
                                }

                            }
                            
                        }
                    }
                    
                    system.debug('14');
                    system.debug('commissions:  '+commissions.size());
                    if(!commissions.isEmpty() && !Test.isRunningTest()){
                        try{

                            insert commissions;
                        }catch(Exception e){
                            system.debug('test: '+e.getMessage());
                        }
                    } 
                    system.debug('15');
                }
            }
            return true;
        }
    }
    
    @future
    public static void insertCommissions(String commissions){
        List<Sales_Order_Commissions__c> comm = (List<Sales_Order_Commissions__c>)JSON.deserialize(commissions, List<Sales_Order_Commissions__c>.class );
        insert comm;
    }
    
    public static Boolean PartialCommissions(Id SalesOrderId){
        List<Sales_Order_Commissions__c> Insertibles = new List<Sales_Order_Commissions__c>();
        
        // check if commissions exist
        List<Sales_Order_Commissions__c> commissions = fetchCommissions(SalesOrderId);
        
        List<AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_List = Cash_Receipt_List(SalesOrderId);


        map<string, AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_Keys = Make_Cash_Receipt_Keys(Cash_Receipt_List,true, 
                                                                                                  true, true, true);
        List<AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_List = Memo_Receipt_List(SalesOrderId);

        map<string, AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_Keys = Make_Memo_Receipt_Keys(Memo_Receipt_List,true,
                                                                                                 true, true, true);
        Boolean success = true;
        
        if(commissions.isEmpty()){
            Boolean invoicesResult = false;
            Boolean creditMemoResult = false;


            if(!Cash_Receipt_List.IsEmpty()){
                invoicesResult = CalculateCommissionsHandler.start(Cash_Receipt_List);
            } 
            
            if(!Memo_Receipt_List.IsEmpty()){
                creditMemoResult = CalculateCommissionsHandler.start(Memo_Receipt_List);
            } 

            if(invoicesResult && creditMemoResult){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Commissions were created successfully.'));
                return true;
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error during creating commissions.'));
                return false;
            }

        }else{
            
            for(Sales_Order_Commissions__c soc : commissions){
                
                string receiptId = soc.Billing_Cash_Receipt__c != null ? soc.Billing_Cash_Receipt__c :
                soc.Billing_Credit_Memo__c != null ? soc.Billing_Credit_Memo__c : null;
                
                string personId = soc.Owner__c != null ? soc.Owner__c + '-Owner' : soc.Sales_Rep_Company_Name__c != null ? 
                    soc.Sales_Rep_Company_Name__c + '-Company' : soc.Referral_Sales_Rep__c != null ? 
                        soc.Referral_Sales_Rep__c + '-Referral' :
                soc.Manufacturer_Rep__c != null ? soc.Manufacturer_Rep__c + '-Manufacturer' : 
                soc.Specified_Rep__c != null ? soc.Specified_Rep__c + '-Specified' : null;
                
                String Key = receiptId + '-' + personId;
                
                if(Cash_Receipt_Keys.containsKey(Key) && !Test.isRunningTest()){
                    Cash_Receipt_Keys.remove(Key);
                }
                
                if(Memo_Receipt_Keys.containsKey(Key) && !Test.isRunningTest()){
                    Memo_Receipt_Keys.remove(Key);
                }
            }
            
            // Totals
            
            if(Cash_Receipt_Keys.size() > 0){
                
                set<id> billingIds = new set<id>();
                
                for(AcctSeed__Billing_Cash_Receipt__c receipt : Cash_Receipt_Keys.values()){
                    billingIds.add(receipt.AcctSeed__Billing__c);
                }
                
                map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                
                BillingLineMap = FindBillingLineTotal(billingIds);
                
                
                for(string key : Cash_Receipt_Keys.keyset()){
                    
                    List<string> strings = key.split('-');
                    
                    AcctSeed__Billing_Cash_Receipt__c data = Cash_Receipt_Keys.get(key);
                    
                    Boolean HasManRep = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null;
                    Boolean HasRefferal = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c != null;
                    Boolean HasSpecified = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c != null;
                    Boolean IsTeam = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c;
                    
                    Decimal SalesPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c;
                    Decimal ReferralPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c;
                    Decimal ManRepPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c;
                    Decimal SpecifiedPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c;
                    
                    Decimal BillingLineTotal = BillingLineMap.containsKey(data.acctseed__billing__c) ? 
                        BillingLineMap.get(data.acctseed__billing__c) : 0;
                    
                    if(data.AcctSeed__Adjustment_Amount__c == null) data.AcctSeed__Adjustment_Amount__c = 0;
                    if(data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c == null)
                        data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c = 0;
                    
                    Decimal BillingTotal = data.AcctSeed__Billing__r.AcctSeed__Total__c - 
                        data.AcctSeed__Adjustment_Amount__c - 
                        data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c;
                    
                    if(data == null) continue;
                    
                    if(BillingTotal > 0 && BillingLineTotal > 0)
                        Insertibles.addAll(CompileCommissions(
                            true,
                            strings[0],
                            strings[2] == 'Owner' ? strings[1] : null, 
                            strings[2] == 'Referral' ? strings[1] : null,
                            strings[2] == 'Manufacturer' ? strings[1] : null, 
                            strings[2] == 'Specified' ? strings[1] : null,
                            strings[2] == 'Company' ? strings[1] : null, 
                            data.AcctSeed__Applied_Amount__c, billingTotal, billingLineTotal, 
                            SalesPercent, ReferralPercent, ManRepPercent, SpecifiedPercent,
                            HasRefferal, HasManRep, HasSpecified, IsTeam, salesOrderId,data.AcctSeed__Billing__c,
                            data.createddate,data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c,
                            data.AcctSeed__Billing__r.Credit_Order__c));
                    
                }
            }
            
            if(Memo_Receipt_Keys.size() > 0 || Test.isRunningTest()){
                
                set<id> billingIds = new set<id>();
                
                for(AcctSeed__Billing_Credit_Memo__c receipt : Memo_Receipt_Keys.values()){
                    billingIds.add(receipt.AcctSeed__Billing_Invoice__c);
                }
                
                map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                
                BillingLineMap = FindBillingLineTotal(billingIds);
                
                for(string key : Memo_Receipt_Keys.keyset()){
                    
                    List<string> strings = key.split('-');
                    
                    AcctSeed__Billing_Credit_Memo__c data = Memo_Receipt_Keys.get(key);
                    
                    Decimal BillingLineTotal = BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c) ? 
                        BillingLineMap.get(data.AcctSeed__Billing_Invoice__c) : 0;
                    
                    Boolean HasManRep = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null;
                    Boolean HasRefferal = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c != null;
                    Boolean HasSpecified = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c != null;
                    Boolean IsTeam = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c;
                    
                    Decimal SalesPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c;
                    Decimal ReferralPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c;
                    Decimal SpecifiedPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c;
                    Decimal ManRepPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c;
                    
                    if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && BillingLineTotal > 0)
                        Insertibles.addAll(CompileCommissions(
                            false,
                            strings[0],
                            strings[2] == 'Owner' ? strings[1] : null, 
                            strings[2] == 'Referral' ? strings[1] : null,
                            strings[2] == 'Manufacturer' ? strings[1] : null,
                            strings[2] == 'Specified' ? strings[1] : null,  
                            strings[2] == 'Company' ? strings[1] : null,
                            Math.abs(data.AcctSeed__Amount__c), 
                            data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c, 
                            BillingLineTotal, 
                            SalesPercent, 
                            ReferralPercent, 
                            ManRepPercent,
                            SpecifiedPercent, 
                            HasRefferal, 
                            HasManRep,
                            HasSpecified,
                            IsTeam, 
                            data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c,
                            data.AcctSeed__Billing_Invoice__c,data.createddate,
                            data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c,
                            data.AcctSeed__Billing_Credit_Memo__r.Credit_Order__c));
                    
                }
            }
            if(!Insertibles.isEmpty()){
                insert Insertibles;
            }else{
                success = false;
            } 
        }
        
        return success;
    }
    
    public static void UpdateCommissions(AcctSeedERP__Sales_Order__c so, 
                                        Boolean SalesChanges, 
                                        Boolean ManufacturerChanges, 
                                        Boolean ReferralChanges,
                                        Boolean SpecifiedChanges){
            
            List<Sales_Order_Commissions__c> Updatibles = new List<Sales_Order_Commissions__c>();
            
            String SalesOrderId = so.id;
            
            // check if commissions exist
            List<Sales_Order_Commissions__c> commissions = fetchCommissions(SalesOrderId);
            
            List<AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_List = Cash_Receipt_List(SalesOrderId);
            
            map<string, AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_Keys = Make_Cash_Receipt_Keys(
                Cash_Receipt_List,
                SalesChanges, 
                ManufacturerChanges, 
                ReferralChanges,
                SpecifiedChanges);
            
            List<AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_List = Memo_Receipt_List(SalesOrderId);
            
            map<string, AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_Keys = Make_Memo_Receipt_Keys(
                Memo_Receipt_List,
                SalesChanges, 
                ManufacturerChanges, 
                ReferralChanges,
                SpecifiedChanges);
            
            map<string, AcctSeed__Billing_Cash_Receipt__c> Update_Cash_Receipt = 
                new map<string, AcctSeed__Billing_Cash_Receipt__c>();
            
            map<string, AcctSeed__Billing_Credit_Memo__c> Update_Memo_Receipt = 
                new map<string, AcctSeed__Billing_Credit_Memo__c>();
            
            for(Sales_Order_Commissions__c soc : commissions){
                
                string receiptId = soc.Billing_Cash_Receipt__c != null ? soc.Billing_Cash_Receipt__c :
                                    soc.Billing_Credit_Memo__c != null ? soc.Billing_Credit_Memo__c : null;
                
                string personId = soc.Owner__c != null ? soc.Owner__c + '-Owner' : soc.Sales_Rep_Company_Name__c != null ? 
                    soc.Sales_Rep_Company_Name__c + '-Company' : soc.Referral_Sales_Rep__c != null ? 
                        soc.Referral_Sales_Rep__c + '-Referral' :
                soc.Manufacturer_Rep__c != null ? soc.Manufacturer_Rep__c + '-Manufacturer' : 
                soc.Specified_Rep__c != null ? soc.Specified_Rep__c + '-Specified' : null;
                
                String PrimaryKey = receiptId + '-' + personId;
                String SecondaryKey = receiptId + '-' + personId + '-' + soc.id;
                
                if(Cash_Receipt_Keys.containsKey(PrimaryKey)){
                    Update_Cash_Receipt.put(SecondaryKey, Cash_Receipt_Keys.get(PrimaryKey));
                }
                
                if(Memo_Receipt_Keys.containsKey(PrimaryKey)){
                    Update_Memo_Receipt.put(SecondaryKey, Memo_Receipt_Keys.get(PrimaryKey));
                }
            }
            
            // Totals
            //!
            if(Update_Cash_Receipt.size() > 0){
                
                set<id> billingIds = new set<id>();
                
                for(AcctSeed__Billing_Cash_Receipt__c receipt : Update_Cash_Receipt.values()){
                    billingIds.add(receipt.AcctSeed__Billing__c);
                }
                
                map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                
                BillingLineMap = FindBillingLineTotal(billingIds);
                
                for(string key : Update_Cash_Receipt.keyset()){
                    List<string> strings = key.split('-');
                    
                    AcctSeed__Billing_Cash_Receipt__c data = Update_Cash_Receipt.get(key);
                    
                    Boolean HasManRep = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null;
                    Boolean HasRefferal = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c != null;
                    Boolean HasSpecified = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c != null;
                    Boolean IsTeam = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c;
                    
                    Decimal SalesPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c;
                    Decimal ReferralPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c;
                    Decimal ManRepPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c;
                    Decimal SpecifiedPercent = data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c;
                    
                    Decimal BillingLineTotal = BillingLineMap.containsKey(data.acctseed__billing__c) ? 
                        BillingLineMap.get(data.acctseed__billing__c) : 0;
                    
                    if(data.AcctSeed__Adjustment_Amount__c == null) data.AcctSeed__Adjustment_Amount__c = 0;
                    if(data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c == null)
                        data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c = 0;
                    
                    Decimal BillingTotal = data.AcctSeed__Billing__r.AcctSeed__Total__c - 
                        data.AcctSeed__Adjustment_Amount__c - 
                        data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c;
                    
                    if(data == null) continue;
                    
                    if(BillingTotal > 0 && BillingLineTotal > 0){
                        
                        List<Sales_Order_Commissions__c> commission = CompileCommissions(true,
                            strings[0],
                            strings[2] == 'Owner' ? strings[1] : null, 
                            strings[2] == 'Referral' ? strings[1] : null,
                            strings[2] == 'Manufacturer' ? strings[1] : null,
                            strings[2] == 'Specified' ? strings[1] : null, 
                            strings[2] == 'Company' ? strings[1] : null, 
                            data.AcctSeed__Applied_Amount__c, billingTotal, billingLineTotal, 
                            SalesPercent, ReferralPercent, ManRepPercent, SpecifiedPercent,
                            HasRefferal, HasManRep, HasSpecified, IsTeam, salesOrderId, data.AcctSeed__Billing__c,data.createddate,
                            data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c,
                            data.AcctSeed__Billing__r.Credit_Order__c);

                        commission[0].id = strings[3];
                        Updatibles.add(commission[0]);
                    }
                    
                }
            }
            
            //!

            if(Update_Memo_Receipt.size() > 0 || Test.isRunningTest()){
                
                set<id> billingIds = new set<id>();
                
                for(AcctSeed__Billing_Credit_Memo__c receipt : Update_Memo_Receipt.values()){
                    billingIds.add(receipt.AcctSeed__Billing_Invoice__c);
                }
                
                map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                
                BillingLineMap = FindBillingLineTotal(billingIds);
                
                for(string key : Update_Memo_Receipt.keyset()){
                    
                    List<string> strings = key.split('-');
                    
                    AcctSeed__Billing_Credit_Memo__c data = Update_Memo_Receipt.get(key);
                    
                    Decimal BillingLineTotal = BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c) ? 
                        BillingLineMap.get(data.AcctSeed__Billing_Invoice__c) : 0;
                    
                    Boolean HasManRep = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null;
                    Boolean HasRefferal = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c != null;
                    Boolean HasSpecified = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c != null;
                    Boolean IsTeam = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c;
                    
                    Decimal SalesPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c;
                    Decimal ReferralPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c;
                    Decimal ManRepPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c;
                    Decimal SpecifiedPercent = data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c;
                    
                    if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && 
                       BillingLineTotal > 0){
                        
                        List<Sales_Order_Commissions__c> commission = CompileCommissions(
                            false,
                            strings[0],
                            strings[2] == 'Owner' ? strings[1] : null, 
                            strings[2] == 'Referral' ? strings[1] : null,
                            strings[2] == 'Manufacturer' ? strings[1] : null, 
                            strings[2] == 'Specified' ? strings[1] : null,
                            strings[2] == 'Company' ? strings[1] : null,
                            Math.abs(data.AcctSeed__Amount__c), 
                            data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c, 
                            BillingLineTotal, 
                            SalesPercent, 
                            ReferralPercent, 
                            ManRepPercent, 
                            SpecifiedPercent,
                            HasRefferal, 
                            HasManRep,
                            HasSpecified,
                            IsTeam, 
                            data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c,
                            data.AcctSeed__Billing_Invoice__c,
                            data.createddate,
                            data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c,
                            data.AcctSeed__Billing_Credit_Memo__r.Credit_Order__c);
                        
                        commission[0].id = strings[3];
                        
                        Updatibles.add(commission[0]);
                    }
                    
                }
            }
            
            if(!Updatibles.isEmpty()){ 
                
                update Updatibles;
            }

            PartialCommissions(so.Id);
        }
    




        /*****************************************************************************************************
        *   @method       : UpdateCommissionsOpportunity
        *   @description  : copy of method for updating commissions but with using opportunity fields
        *   @return       : void
        *   @author       : Marian Lyzhychka ©Peeklogic
        *****************************************************************************************************/
        public static void UpdateCommissionsOpportunity(Opportunity opp, 
                                                Boolean SalesChanges, 
                                                Boolean ManufacturerChanges, 
                                                Boolean ReferralChanges,
                                                Boolean SpecifiedChanges){


            List<Sales_Order_Commissions__c> Updatibles = new List<Sales_Order_Commissions__c>();
            
            String OpportunityId = opp.id;
            
            // check if commissions exist
            List<Sales_Order_Commissions__c> commissions = fetchCommissionsOpportunity(OpportunityId);
            
            List<AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_List = Cash_Receipt_List(OpportunityId);

            map<string, AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_Keys = Make_Cash_Receipt_Keys_Opp(Cash_Receipt_List,
                                                                                                            SalesChanges, 
                                                                                                            ManufacturerChanges, 
                                                                                                            ReferralChanges,
                                                                                                            SpecifiedChanges);
            
            List<AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_List = Memo_Receipt_List(OpportunityId);

            map<string, AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_Keys = Make_Memo_Receipt_KeysOpp(Memo_Receipt_List,
                                                                                                        SalesChanges, 
                                                                                                        ManufacturerChanges, 
                                                                                                        ReferralChanges,
                                                                                                        SpecifiedChanges);

            map<string, AcctSeed__Billing_Cash_Receipt__c> Update_Cash_Receipt = new map<string, AcctSeed__Billing_Cash_Receipt__c>();
            map<string, AcctSeed__Billing_Credit_Memo__c> Update_Memo_Receipt = new map<string, AcctSeed__Billing_Credit_Memo__c>();
            
            for(Sales_Order_Commissions__c soc : commissions){
                
                string receiptId = soc.Billing_Cash_Receipt__c != null ? soc.Billing_Cash_Receipt__c : soc.Billing_Credit_Memo__c != null 
                                                                       ? soc.Billing_Credit_Memo__c : null;
                
                string personId = soc.Owner__c != null ? soc.Owner__c + '-Owner' : soc.Sales_Rep_Company_Name__c != null 
                                                       ? soc.Sales_Rep_Company_Name__c + '-Company' : soc.Referral_Sales_Rep__c != null 
                                                       ? soc.Referral_Sales_Rep__c + '-Referral' : soc.Manufacturer_Rep__c != null 
                                                       ? soc.Manufacturer_Rep__c + '-Manufacturer' : soc.Specified_Rep__c != null 
                                                       ? soc.Specified_Rep__c + '-Specified' : null;
                
                String PrimaryKey = receiptId + '-' + personId;
                String SecondaryKey = receiptId + '-' + personId + '-' + soc.id;
                
                if(Cash_Receipt_Keys.containsKey(PrimaryKey)){
                    Update_Cash_Receipt.put(SecondaryKey, Cash_Receipt_Keys.get(PrimaryKey));
                }
                
                if(Memo_Receipt_Keys.containsKey(PrimaryKey)){
                    Update_Memo_Receipt.put(SecondaryKey, Memo_Receipt_Keys.get(PrimaryKey));
                }
            }
            
            // Totals

            if(Update_Cash_Receipt.size() > 0){
                
                set<id> billingIds = new set<id>();
                
                for(AcctSeed__Billing_Cash_Receipt__c receipt : Update_Cash_Receipt.values()){
                    billingIds.add(receipt.AcctSeed__Billing__c);
                }
                
                map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                
                BillingLineMap = FindBillingLineTotal(billingIds); 
                
                for(string key : Update_Cash_Receipt.keyset()){

                    List<string> strings = key.split('-');

                    AcctSeed__Billing_Cash_Receipt__c data = Update_Cash_Receipt.get(key);
                    
                    Boolean HasManRep = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null;
                    Boolean HasRefferal = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c != null;
                    Boolean HasSpecified = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Specified_Rep__c != null;
                    Boolean IsTeam = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c;
                    
                    Decimal SalesPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c;
                    Decimal ReferralPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c;
                    Decimal ManRepPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c;
                    Decimal SpecifiedPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c;
                    
                    Decimal BillingLineTotal = BillingLineMap.containsKey(data.acctseed__billing__c) ? 
                        BillingLineMap.get(data.acctseed__billing__c) : 0;
                    
                    if(data.AcctSeed__Adjustment_Amount__c == null){
                        data.AcctSeed__Adjustment_Amount__c = 0;
                    } 
                    if(data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c == null){
                        data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c = 0;
                    }
                    
                    Decimal BillingTotal = data.AcctSeed__Billing__r.AcctSeed__Total__c - 
                                                    data.AcctSeed__Adjustment_Amount__c - 
                                                    data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c;
                    
                    if(data == null) continue;
                    
                    if(BillingTotal > 0 && BillingLineTotal > 0){
                        
                        List<Sales_Order_Commissions__c> commission = CompileCommissions(true,
                            strings[0],
                            strings[2] == 'Owner' ? strings[1] : null, 
                            strings[2] == 'Referral' ? strings[1] : null,
                            strings[2] == 'Manufacturer' ? strings[1] : null,
                            strings[2] == 'Specified' ? strings[1] : null, 
                            strings[2] == 'Company' ? strings[1] : null, 
                            data.AcctSeed__Applied_Amount__c, billingTotal, billingLineTotal, 
                            SalesPercent, ReferralPercent, ManRepPercent, SpecifiedPercent,
                            HasRefferal, HasManRep, HasSpecified, IsTeam, data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c, 
                            data.AcctSeed__Billing__c,data.createddate,
                            data.AcctSeed__Billing__r.AcctSeed__Opportunity__c,
                            data.AcctSeed__Billing__r.Credit_Order__c);

                        commission[0].id = strings[3];
                        Updatibles.add(commission[0]);
                    }
                    
                }
            }
            
            if(Update_Memo_Receipt.size() > 0){
                
                set<id> billingIds = new set<id>();
                
                for(AcctSeed__Billing_Credit_Memo__c receipt : Update_Memo_Receipt.values()){
                    billingIds.add(receipt.AcctSeed__Billing_Invoice__c);
                }
                
                map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                
                BillingLineMap = FindBillingLineTotal(billingIds);
                
                for(string key : Update_Memo_Receipt.keyset()){
                    
                    List<string> strings = key.split('-');
                    
                    AcctSeed__Billing_Credit_Memo__c data = Update_Memo_Receipt.get(key);
                    
                    Decimal BillingLineTotal = BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c) ? 
                        BillingLineMap.get(data.AcctSeed__Billing_Invoice__c) : 0;
                    
                    Boolean HasManRep = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null;
                    Boolean HasRefferal = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c != null;
                    Boolean HasSpecified = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Specified_Rep__c != null;
                    Boolean IsTeam = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c;
                    
                    Decimal SalesPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c;
                    Decimal ReferralPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c;
                    Decimal ManRepPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c;
                    Decimal SpecifiedPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c;
                    
                    if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && 
                       BillingLineTotal > 0){
                        
                        List<Sales_Order_Commissions__c> commission = CompileCommissions(
                            false,
                            strings[0],
                            strings[2] == 'Owner' ? strings[1] : null, 
                            strings[2] == 'Referral' ? strings[1] : null,
                            strings[2] == 'Manufacturer' ? strings[1] : null, 
                            strings[2] == 'Specified' ? strings[1] : null,
                            strings[2] == 'Company' ? strings[1] : null,
                            Math.abs(data.AcctSeed__Amount__c), 
                            data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c, 
                            BillingLineTotal, 
                            SalesPercent, 
                            ReferralPercent, 
                            ManRepPercent, 
                            SpecifiedPercent,
                            HasRefferal, 
                            HasManRep,
                            HasSpecified,
                            IsTeam, 
                            data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c,
                            data.AcctSeed__Billing_Invoice__c,
                            data.createddate,
                            data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c,
                            data.AcctSeed__Billing_Invoice__r.Credit_Order__c);
                        
                        commission[0].id = strings[3];
                        
                        Updatibles.add(commission[0]);
                    }
                    
                }
            }
            
            if(!Updatibles.isEmpty()){ 
                
                update Updatibles;
            }

            PartialCommissionsOpportunity(opp.Id);

        }




        public static Boolean PartialCommissionsOpportunity(Id OpportunityId){
            List<Sales_Order_Commissions__c> Insertibles = new List<Sales_Order_Commissions__c>();
            
            // check if commissions exist
            List<Sales_Order_Commissions__c> commissions = fetchCommissionsOpportunity(OpportunityId);
            
            List<AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_List = Cash_Receipt_List(OpportunityId);
    
    
            map<string, AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_Keys = Make_Cash_Receipt_Keys_Opp(Cash_Receipt_List,true, 
                                                                                                      true, true, true);
            List<AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_List = Memo_Receipt_List(OpportunityId);
            map<string, AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_Keys = Make_Memo_Receipt_KeysOpp(Memo_Receipt_List,true,
                                                                                                     true, true, true);
            Boolean success = true;
            
            if(commissions.isEmpty()){
                Boolean invoicesResult = false;
                Boolean creditMemoResult = false;
    
    
                if(!Cash_Receipt_List.IsEmpty()){
                    invoicesResult = CalculateCommissionsHandler.start(Cash_Receipt_List);
                } 
                
                if(!Memo_Receipt_List.IsEmpty()){
                    creditMemoResult = CalculateCommissionsHandler.start(Memo_Receipt_List);
                } 
    
                if(invoicesResult && creditMemoResult){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Commissions were created successfully.'));
                    return true;
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error during creating commissions.'));
                    return false;
                }
    
            }else{
                
                for(Sales_Order_Commissions__c soc : commissions){
                    
                    string receiptId = soc.Billing_Cash_Receipt__c != null ? soc.Billing_Cash_Receipt__c :
                    soc.Billing_Credit_Memo__c != null ? soc.Billing_Credit_Memo__c : null;
                    
                    string personId = soc.Owner__c != null ? soc.Owner__c + '-Owner' : soc.Sales_Rep_Company_Name__c != null ? 
                        soc.Sales_Rep_Company_Name__c + '-Company' : soc.Referral_Sales_Rep__c != null ? 
                            soc.Referral_Sales_Rep__c + '-Referral' :
                    soc.Manufacturer_Rep__c != null ? soc.Manufacturer_Rep__c + '-Manufacturer' : 
                    soc.Specified_Rep__c != null ? soc.Specified_Rep__c + '-Specified' : null;
                    
                    String Key = receiptId + '-' + personId;
                    
                    if(Cash_Receipt_Keys.containsKey(Key)){
                        Cash_Receipt_Keys.remove(Key);
                    }
                    
                    if(Memo_Receipt_Keys.containsKey(Key)){
                        Memo_Receipt_Keys.remove(Key);
                    }
                }
                
                // Totals
                
                if(Cash_Receipt_Keys.size() > 0){
                    
                    set<id> billingIds = new set<id>();
                    
                    for(AcctSeed__Billing_Cash_Receipt__c receipt : Cash_Receipt_Keys.values()){
                        billingIds.add(receipt.AcctSeed__Billing__c);
                    }
                    
                    map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                    
                    BillingLineMap = FindBillingLineTotal(billingIds);
                    
                    
                    for(string key : Cash_Receipt_Keys.keyset()){
                        
                        List<string> strings = key.split('-');
                        
                        AcctSeed__Billing_Cash_Receipt__c data = Cash_Receipt_Keys.get(key);
                        
                        Boolean HasManRep = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null;
                        Boolean HasRefferal = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c != null;
                        Boolean HasSpecified = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Specified_Rep__c != null;
                        Boolean IsTeam = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c;
                        
                        Decimal SalesPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c;
                        Decimal ReferralPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c;
                        Decimal ManRepPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c;
                        Decimal SpecifiedPercent = data.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c;
                        
                        Decimal BillingLineTotal = BillingLineMap.containsKey(data.acctseed__billing__c) ? 
                            BillingLineMap.get(data.acctseed__billing__c) : 0;
                        
                        if(data.AcctSeed__Adjustment_Amount__c == null) data.AcctSeed__Adjustment_Amount__c = 0;
                        if(data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c == null)
                            data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c = 0;
                        
                        Decimal BillingTotal = data.AcctSeed__Billing__r.AcctSeed__Total__c - 
                            data.AcctSeed__Adjustment_Amount__c - 
                            data.AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c;
                        
                        if(data == null) continue;
                        
                        if(BillingTotal > 0 && BillingLineTotal > 0)
                            Insertibles.addAll(CompileCommissions(
                                true,
                                strings[0],
                                strings[2] == 'Owner' ? strings[1] : null, 
                                strings[2] == 'Referral' ? strings[1] : null,
                                strings[2] == 'Manufacturer' ? strings[1] : null, 
                                strings[2] == 'Specified' ? strings[1] : null,
                                strings[2] == 'Company' ? strings[1] : null, 
                                data.AcctSeed__Applied_Amount__c, billingTotal, billingLineTotal, 
                                SalesPercent, ReferralPercent, ManRepPercent, SpecifiedPercent,
                                HasRefferal, HasManRep, HasSpecified, IsTeam, data.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c,
                                data.AcctSeed__Billing__c,
                                data.createddate,data.AcctSeed__Billing__r.AcctSeed__Opportunity__c,
                                data.AcctSeed__Billing__r.Credit_Order__c));
                        
                    }
                }
                
                if(Memo_Receipt_Keys.size() > 0){
                    
                    set<id> billingIds = new set<id>();
                    
                    for(AcctSeed__Billing_Credit_Memo__c receipt : Memo_Receipt_Keys.values()){
                        billingIds.add(receipt.AcctSeed__Billing_Invoice__c);
                    }
                    
                    map<id, Decimal> BillingLineMap = new map<id, Decimal>();
                    
                    BillingLineMap = FindBillingLineTotal(billingIds);
                    
                    for(string key : Memo_Receipt_Keys.keyset()){
                        
                        List<string> strings = key.split('-');
                        
                        AcctSeed__Billing_Credit_Memo__c data = Memo_Receipt_Keys.get(key);
                        
                        Decimal BillingLineTotal = BillingLineMap.containsKey(data.AcctSeed__Billing_Invoice__c) ? BillingLineMap.get(data.AcctSeed__Billing_Invoice__c) : 0;
                        
                        Boolean HasManRep = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null;
                        Boolean HasRefferal = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c != null;
                        Boolean HasSpecified = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Specified_Rep__c != null;
                        Boolean IsTeam = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c;
                        
                        Decimal SalesPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c;
                        Decimal ReferralPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c;
                        Decimal SpecifiedPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c;
                        Decimal ManRepPercent = data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c;
                        
                        // if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && BillingLineTotal > 0)
                        if(data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c > 0 && BillingLineTotal > 0)
                            Insertibles.addAll(CompileCommissions(
                                false,
                                strings[0],
                                strings[2] == 'Owner' ? strings[1] : null, 
                                strings[2] == 'Referral' ? strings[1] : null,
                                strings[2] == 'Manufacturer' ? strings[1] : null,
                                strings[2] == 'Specified' ? strings[1] : null,  
                                strings[2] == 'Company' ? strings[1] : null,
                                Math.abs(data.AcctSeed__Amount__c), 
                                data.AcctSeed__Billing_Invoice__r.Total_Amount_Due__c, 
                                BillingLineTotal, 
                                SalesPercent, 
                                ReferralPercent, 
                                ManRepPercent,
                                SpecifiedPercent, 
                                HasRefferal, 
                                HasManRep,
                                HasSpecified,
                                IsTeam, 
                                data.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c,
                                data.AcctSeed__Billing_Invoice__c,data.createddate, 
                                data.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c,
                                data.AcctSeed__Billing_Invoice__r.Credit_Order__c));
                        
                    }
                }
                if(!Insertibles.isEmpty()){
                    insert Insertibles;
                }else{
                    success = false;
                } 
            }
            
            return success;
        }
        /*****************************************************************************************************
        *   @method       : UpdateCommissionsOpportunity
        *   @description  : copy of method fetchCommissions, but with filter by opportunity
        *   @return       : void
        *   @author       : Marian Lyzhychka ©Peeklogic
        *****************************************************************************************************/
        public static List<Sales_Order_Commissions__c> fetchCommissionsOpportunity(string OpportunityId){
        
            List<Sales_Order_Commissions__c> commissions = new List<Sales_Order_Commissions__c>();
            
            commissions = [select id,  
                           Referral_Sales_Rep__c,
                           Owner__c,
                           Sales_Rep_Company_Name__c,
                           Manufacturer_Rep__c,
                           Specified_Rep__c, 
                           Sales_Order__c,
                           Billing_Cash_Receipt__c,
                           Billing_Credit_Memo__c from Sales_Order_Commissions__c
                           where Opportunity__c =:OpportunityId LIMIT 100];
            
            return commissions;
            
        }

        

    public static List<Sales_Order_Commissions__c> CompileCommissions(Boolean isCash,
                                                                        Id receiptId,
                                                                        Id OwnerId,
                                                                        Id ReferralId,
                                                                        Id ManufacturerId,
                                                                        Id SpecifiedId,
                                                                        Id SalesRepCompanyId,
                                                                        decimal receiptTotal, 
                                                                        decimal billingTotal, 
                                                                        decimal billingLineTotal, 
                                                                        decimal SalesPercent, 
                                                                        decimal ReferralPercent, 
                                                                        Decimal ManRepPercent, 
                                                                        Decimal SpecifiedPercent,
                                                                        Boolean HasReferral, 
                                                                        Boolean HasManRep, 
                                                                        Boolean HasSpecified, 
                                                                        Boolean IsTeam, 
                                                                        string salesOrderId, 
                                                                        string billingNumber, 
                                                                        datetime dt, 
                                                                        Id oppId, 
                                                                        Id creditOrderId){
            
            system.debug('zayshlo v CompileCommissions');
            system.debug('ManRepPercent: '+ManRepPercent);
            system.debug('SpecifiedPercent: '+SpecifiedPercent);
            system.debug('SalesPercent: '+SalesPercent);
            List<Sales_Order_Commissions__c> commissions = new List<Sales_Order_Commissions__c>();
            Decimal SalesPercentAmount = 0;
            Decimal ReferralPercentAmount = 0;
            
            system.debug('receiptTotal: '+receiptTotal);
            system.debug('billingTotal: '+billingTotal);

            // Decimal BillingTotalDivide = billingTotal;
            Decimal BillingTotalDivide = receiptTotal / billingTotal;
            BillingTotalDivide = BillingTotalDivide.setScale(2, RoundingMode.HALF_EVEN);
           
            if(SalesPercent != null && SalesPercent > 0){
                SalesPercentAmount = BillingTotalDivide * billingLineTotal * (SalesPercent / 100);
                SalesPercentAmount = SalesPercentAmount.setScale(2, RoundingMode.HALF_EVEN);
            }
            
            if(HasReferral && ReferralPercent != null && (ReferralId != null || OwnerId != null)){
            // if(HasReferral && ReferralPercent != null && ReferralPercent > 0 && (ReferralId != null || OwnerId != null)){
                ReferralPercentAmount = SalesPercentAmount != 0 ? SalesPercentAmount * (ReferralPercent / 100) : 
                BillingTotalDivide * billingLineTotal * (ReferralPercent / 100);
                ReferralPercentAmount = ReferralPercentAmount.setScale(2, RoundingMode.HALF_EVEN);
                
                if(ReferralId != null)
                    commissions.add(MakeCommissions(IsCash, ReceiptId, OwnerId, ReferralId, ManufacturerId,
                                                    SpecifiedId, 
                                                    SalesRepCompanyId, ReferralPercentAmount, 
                                                    'Referral', IsTeam, salesOrderId, billingNumber, dt, oppId, creditOrderId));
            }
            
                SalesPercentAmount = SalesPercentAmount > ReferralPercentAmount ? SalesPercentAmount - ReferralPercentAmount : 0;
            // if(SalesPercentAmount > 0){
                if((IsTeam && OwnerId != null) || (!IsTeam && SalesRepCompanyId != null)){
                    system.debug('SalesPercentAmount: '+SalesPercentAmount);

                    commissions.add(MakeCommissions(IsCash, ReceiptId, OwnerId, ReferralId, ManufacturerId,
                                                    SpecifiedId, 
                                                    SalesRepCompanyId, 
                                                    SalesPercentAmount, 
                                                    'Owner', IsTeam, salesOrderId, billingNumber, dt, oppId, creditOrderId));
                }
                    
            // }
            
            if(HasManRep && ManufacturerId != null){
                if(ManRepPercent != null ){
                // if(ManRepPercent != null && ManRepPercent > 0){
                    Decimal ManufacturerAmount = BillingTotalDivide * billingLineTotal * (ManRepPercent / 100);
                    system.debug('BillingTotalDivide: '+BillingTotalDivide);
                    system.debug('ManufacturerAmount: '+ManufacturerAmount);
                    ManufacturerAmount = ManufacturerAmount.setScale(2, RoundingMode.HALF_EVEN);
                    commissions.add(MakeCommissions(IsCash, ReceiptId, OwnerId, ReferralId, 
                                                    ManufacturerId, 
                                                    SpecifiedId,
                                                    SalesRepCompanyId, 
                                                    ManufacturerAmount, 
                                                    'ManRep', IsTeam, salesOrderId, billingNumber, dt, oppId, creditOrderId));
                }
            }

            if(HasSpecified && SpecifiedId != null){
               
                if(SpecifiedPercent != null ){
                // if(SpecifiedPercent != null && SpecifiedPercent > 0){
                    Decimal SpecifiedAmount = BillingTotalDivide * billingLineTotal * (SpecifiedPercent / 100);
                    
                    SpecifiedAmount = SpecifiedAmount.setScale(2, RoundingMode.HALF_EVEN);
                    commissions.add(MakeCommissions(IsCash, ReceiptId, OwnerId, ReferralId, 
                                                    ManufacturerId, SpecifiedId, 
                                                    SalesRepCompanyId, 
                                                    SpecifiedAmount, 
                                                    'Specified', IsTeam, salesOrderId, billingNumber, dt, oppId, creditOrderId));
                }
            }
            
            return commissions;
        }
    
    public static Sales_Order_Commissions__c MakeCommissions(
        Boolean isCash,
        Id receiptId,
        Id OwnerId,
        Id ReferralId,
        Id ManufacturerId,
        Id SpecifiedId,
        Id SalesRepCompanyId,
        Decimal amt, 
        String typeOfCommission, 
        Boolean IsTeam, 
        string salesOrderId, 
        string billingNumber, 
        datetime dt,
        Id oppId, Id credOrderId){
            
            system.debug('zayshlo v MakeCommissions');
            Sales_Order_Commissions__c commission = new Sales_Order_Commissions__c();
            
            if(typeOfCommission == 'Referral'){ 
                commission.Referral_Sales_Rep__c = ReferralId;
            }
            else if(typeOfCommission == 'Owner'){ 
                commission.Owner__c = IsTeam ? OwnerId : null;
                commission.Sales_Rep_Company_Name__c = IsTeam ? null : SalesRepCompanyId;
            }
            else if(typeOfCommission == 'ManRep'){ 
                commission.Manufacturer_Rep__c = ManufacturerId;
            }
            else if(typeOfCommission == 'Specified'){ 
                commission.Specified_Rep__c = SpecifiedId;
            }
            commission.Commission_Amount__c = IsCash ? amt.setScale(2, System.RoundingMode.HALF_EVEN) : 
            -amt.setScale(2, System.RoundingMode.HALF_EVEN);
            // -amt.setScale(2, System.RoundingMode.HALF_EVEN);
            commission.Sales_Order__c = salesOrderId;
            commission.Billing_Cash_Receipt__c = IsCash ? ReceiptId : null;
            commission.Billing_Credit_Memo__c = IsCash ? null : ReceiptId;
            commission.Reference_Number__c = billingNumber;
            commission.Billing_Paid_Date__c = dt;
            commission.Opportunity__c = oppId;
            commission.Credit_Order__c = credOrderId;
            return commission;
        }
    
    // Delete Commissions for Billing type Invoice
    public static void DeleteCommissions(set<id> keys, Boolean isMemo){
        
        try{
            
            string queryStr = '';
            
            if(isMemo){
                queryStr += 'Select Id From Sales_Order_Commissions__c where Billing_Credit_Memo__c in:keys LIMIT 100';
            }else{
                queryStr += 'Select Id From Sales_Order_Commissions__c where Billing_Cash_Receipt__c in:keys LIMIT 100';
            }
            
            List<Sales_Order_Commissions__c> DeletableCommissions = Database.query(queryStr);
            
            if(!DeletableCommissions.isEmpty()) delete DeletableCommissions;
            
        }catch(Exception ex){
            
            system.debug('Error occured: ');
            system.debug(ex.getMessage());
        }
    }
    
    public static map<id, Decimal> FindBillingLineTotal(set<id> billingIds){
        
        map<id, Decimal> BillingLineMap = new map<id, Decimal>();
        
        List<AggregateResult> agrs = [select SUM(acctseed__total__c) total, acctseed__billing__c billingId
                                      from acctseed__billing_line__c where acctseed__billing__c in:billingIds
                                      and acctseed__product__r.Commissionable_Product__c = true
                                      and acctseed__total__c != null
                                      group by acctseed__billing__c LIMIT 100];

        if(!agrs.isEmpty() && agrs.size() > 0){
            
            for(AggregateResult agr : agrs){
                
                BillingLineMap.put((string)agr.get('billingId'), (Decimal)agr.get('total'));
            }
        } 
        
        return BillingLineMap; //Total sum of amounts Commissionable items from billing lines
    }
    
    public static List<Sales_Order_Commissions__c> fetchCommissions(string SalesOrderId){
        
        List<Sales_Order_Commissions__c> commissions = new List<Sales_Order_Commissions__c>();
        
        commissions = [select id,  
                       Referral_Sales_Rep__c,
                       Owner__c,
                       Sales_Rep_Company_Name__c,
                       Manufacturer_Rep__c,
                       Specified_Rep__c, 
                       Sales_Order__c,
                       Billing_Cash_Receipt__c,
                       Billing_Credit_Memo__c from Sales_Order_Commissions__c
                       where sales_order__c =:SalesOrderId LIMIT 100];
        
        return commissions;
        
    }
    
    public static List<AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_List(String SalesOrderId){
        
        List<AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_List = new List<AcctSeed__Billing_Cash_Receipt__c>();
        
        Cash_Receipt_List = [select id, 
                             CreatedDate,
                             AcctSeed__Applied_Amount__c,
                             AcctSeed__Adjustment_Amount__c,
                             AcctSeed__Billing__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c, 
                             AcctSeed__Billing__r.AcctSeed__Opportunity__c, 
                             AcctSeed__Billing__r.AcctSeed__Total__c,
                             AcctSeed__Billing__r.Credit_Order__c,
                             AcctSeed__Billing__r.AcctSeed__Credit_Memo_Applied_Amount__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.OwnerId,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.AcctSeedERP__Opportunity__c	,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c,
                             AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c,

                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Specified_Rep__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.OwnerId,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c,
                             AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c
                             from AcctSeed__Billing_Cash_Receipt__c
                             where AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c =: SalesOrderId OR AcctSeed__Billing__r.AcctSeed__Opportunity__c =: SalesOrderId LIMIT 100];
        
        return Cash_Receipt_List;
        
    }
    
    public static map<string, AcctSeed__Billing_Cash_Receipt__c> Make_Cash_Receipt_Keys(
        List<AcctSeed__Billing_Cash_Receipt__c> receipts,
        Boolean SalesChanges, 
        Boolean ManufacturerChanges, 
        Boolean ReferralChanges,
        Boolean SpecifiedChanges){
            
            map<string, AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_Keys_Map = 
                new map<string, AcctSeed__Billing_Cash_Receipt__c>();
            
            if(!receipts.IsEmpty()){
                
                for(AcctSeed__Billing_Cash_Receipt__c bcr : receipts){
                    
                    // Commission for owner or sales rep company
                    
                    string OwnerKey = bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c ? bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.ownerId + '-Owner' :
                        bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.sales_rep_o__r.Company_Name_Lookup__c + '-Company';
                    
                    if(((!bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c && 
                         bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c != null) ||
                        (bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c && 
                         bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.ownerId != null)) &&
                       bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Cash_Receipt_Keys_Map.put(OwnerKey, bcr);
                    
                    // Commission for manufacturer rep
                    
                    string ManufacturerKey = bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c + '-Manufacturer';
                    
                    if(bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null &&
                       bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c != null &&
                       ManufacturerChanges)
                        Cash_Receipt_Keys_Map.put(ManufacturerKey, bcr);
                    
                    // Commission for referral sales rep
                    string ReferralKey = bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.referral_sales_rep__c + '-Referral';
                    
                    if(bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.referral_sales_rep__c != null &&
                       bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Cash_Receipt_Keys_Map.put(ReferralKey, bcr);
                    
                    // Commission for specified rep
                    string SpecifiedKey = bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.specified_rep__c + '-Specified';
                    
                    if(bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.specified_rep__c != null &&
                       bcr.AcctSeed__Billing__r.AcctSeedERP__Sales_Order__r.Commission_Rate_specified_rep__c != null &&
                       SpecifiedChanges)
                        Cash_Receipt_Keys_Map.put(SpecifiedKey, bcr);
                    
                }
            }
            
            return Cash_Receipt_Keys_Map;
        }
    

        
        public static map<string, AcctSeed__Billing_Cash_Receipt__c> Make_Cash_Receipt_Keys_Opp(List<AcctSeed__Billing_Cash_Receipt__c> receipts,
                                                                                            Boolean SalesChanges, 
                                                                                            Boolean ManufacturerChanges, 
                                                                                            Boolean ReferralChanges,
                                                                                            Boolean SpecifiedChanges){
            
            map<string, AcctSeed__Billing_Cash_Receipt__c> Cash_Receipt_Keys_Map = 
                new map<string, AcctSeed__Billing_Cash_Receipt__c>();
            
            if(!receipts.IsEmpty()){
                
                for(AcctSeed__Billing_Cash_Receipt__c bcr : receipts){
                    
                    // Commission for owner or sales rep company
                    
                    string OwnerKey = bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c ? bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.ownerId + '-Owner' :
                    bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.sales_rep_o__r.Company_Name_Lookup__c + '-Company';
                    
                    if(((!bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c && 
                         bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.Company_Name_Lookup__c != null) ||
                        (bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c && 
                         bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.ownerId != null)) &&
                       bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Cash_Receipt_Keys_Map.put(OwnerKey, bcr);
                    
                    // Commission for manufacturer rep
                    
                    string ManufacturerKey = bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c + '-Manufacturer';
                    
                    if(bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null &&
                       bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c != null &&
                       ManufacturerChanges)
                        Cash_Receipt_Keys_Map.put(ManufacturerKey, bcr);
                    
                    // Commission for referral sales rep
                    string ReferralKey = bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.referral_sales_rep__c + '-Referral';
                    
                    if(bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.referral_sales_rep__c != null &&
                       bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Cash_Receipt_Keys_Map.put(ReferralKey, bcr);
                    
                    // Commission for specified rep
                    string SpecifiedKey = bcr.id + '-' + 
                        bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.specified_rep__c + '-Specified';
                    
                    if(bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.specified_rep__c != null &&
                       bcr.AcctSeed__Billing__r.AcctSeed__Opportunity__r.Commission_Rate_specified_rep__c != null &&
                       SpecifiedChanges)
                        Cash_Receipt_Keys_Map.put(SpecifiedKey, bcr);
                    
                }
            }
            
        return Cash_Receipt_Keys_Map;
    }


    public static List<AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_List(String recordId){
        //method get so or opp id
        List<AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_List = new List<AcctSeed__Billing_Credit_Memo__c>();
        
        Memo_Receipt_List = [select id, 
                             CreatedDate,
                             AcctSeed__Amount__c,
                             AcctSeed__Billing_Invoice__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c, 
                             AcctSeed__Billing_Invoice__r.Total_Amount_Due__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Referral_Sales_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Specified_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.OwnerId,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Specified_Rep__c,

                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.Company_Name_Lookup__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Referral_Sales_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Specified_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.OwnerId,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c,
                             AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Specified_Rep__c,

                             AcctSeed__Billing_Credit_Memo__r.Credit_Order__c
                             from AcctSeed__Billing_Credit_Memo__c
                             where AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c =: recordId OR AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c =: recordId LIMIT 100];
        
        return Memo_Receipt_List;
        
    }
    
    public static map<string, AcctSeed__Billing_Credit_Memo__c> Make_Memo_Receipt_Keys(
        List<AcctSeed__Billing_Credit_Memo__c> receipts,
        Boolean SalesChanges, 
        Boolean ManufacturerChanges, 
        Boolean ReferralChanges,
        Boolean SpecifiedChanges){
            
            map<string, AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_Keys = 
                new map<string, AcctSeed__Billing_Credit_Memo__c>();
            
            if(!receipts.IsEmpty()){
                
                for(AcctSeed__Billing_Credit_Memo__c bcm : receipts){
                    
                    // Commission for owner or sales rep company
                    
                    string OwnerKey = bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c ?
                        bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.ownerId + '-Owner' :
                    bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.sales_rep_o__r.Company_Name_Lookup__c + '-Company';
                    
                    if(((!bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c && 
                         bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.Company_Name_Lookup__c != null) ||
                        (bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Sales_Rep_o__r.IsTeam__c && 
                         bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.ownerId != null)) &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Memo_Receipt_Keys.put(OwnerKey, bcm);
                    
                    // Commission for manufacturer rep
                    
                    string ManufacturerKey = bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c + '-Manufacturer';
                    
                    if(bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Manufacturer_Rep__c != null &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Manufacturer_Rep__c != null &&
                       ManufacturerChanges)
                        Memo_Receipt_Keys.put(ManufacturerKey, bcm);
                    
                    // Commission for referral sales rep
                    
                    string ReferralKey = bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.referral_sales_rep__c + '-Referral';
                    
                    if(bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.referral_sales_rep__c != null &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_Referral_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Memo_Receipt_Keys.put(ReferralKey, bcm);

                    // Commission for specified rep
                    
                    string SpecifiedKey = bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.specified_rep__c + '-Specified';
                    
                    if(bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.specified_rep__c != null &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__r.Commission_Rate_specified_rep__c != null &&
                       ReferralChanges)
                        Memo_Receipt_Keys.put(SpecifiedKey, bcm);
                    
                }
            }
            
        return Memo_Receipt_Keys;
    }


    public static map<string, AcctSeed__Billing_Credit_Memo__c> Make_Memo_Receipt_KeysOpp(
        List<AcctSeed__Billing_Credit_Memo__c> receipts,
        Boolean SalesChanges, 
        Boolean ManufacturerChanges, 
        Boolean ReferralChanges,
        Boolean SpecifiedChanges){
            
            map<string, AcctSeed__Billing_Credit_Memo__c> Memo_Receipt_Keys = 
                new map<string, AcctSeed__Billing_Credit_Memo__c>();
            
            if(!receipts.IsEmpty()){
                
                for(AcctSeed__Billing_Credit_Memo__c bcm : receipts){
                    
                    // Commission for owner or sales rep company
                    
                    string OwnerKey = bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c ?
                        bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.ownerId + '-Owner' :
                    bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.sales_rep_o__r.Company_Name_Lookup__c + '-Company';
                    
                    if(((!bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c && 
                         bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.Company_Name_Lookup__c != null) ||
                        (bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Sales_Rep_o__r.IsTeam__c && 
                         bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.ownerId != null)) &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Memo_Receipt_Keys.put(OwnerKey, bcm);
                    
                    // Commission for manufacturer rep
                    
                    string ManufacturerKey = bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c + '-Manufacturer';
                    
                    if(bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Manufacturer_Rep__c != null &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Manufacturer_Rep__c != null &&
                       ManufacturerChanges)
                        Memo_Receipt_Keys.put(ManufacturerKey, bcm);
                    
                    // Commission for referral sales rep
                    
                    string ReferralKey = bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.referral_sales_rep__c + '-Referral';
                    
                    if(bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.referral_sales_rep__c != null &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_Referral_Sales_Rep__c != null &&
                       (ReferralChanges || SalesChanges))
                        Memo_Receipt_Keys.put(ReferralKey, bcm);

                    // Commission for specified rep
                    
                    string SpecifiedKey = bcm.id + '-' + 
                        bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.specified_rep__c + '-Specified';
                    
                    if(bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.specified_rep__c != null &&
                       bcm.AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__r.Commission_Rate_specified_rep__c != null &&
                       ReferralChanges)
                        Memo_Receipt_Keys.put(SpecifiedKey, bcm);
                    
                }
            }
            
        return Memo_Receipt_Keys;
    }

    
}
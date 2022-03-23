public without sharing class SalesOrderPDFController {
    
    public string headerUrl {get; set;}
    public string footerUrl {get; set;}
    public string terms {get; set;}
    private Id soId {get; set;}
    public list<AcctSeedERP__Sales_Order_line__c> lines {get; set;}
    public AcctSeedERP__Sales_Order__c so {get; set;}
    public Map<Id, AcctSeedERP__Sales_Order_Line__c> sol_map {get; set;}
    public List<AcctSeed__Billing_Cash_Receipt__c> receipts {get; set;}
    public List<wrapper> CreditMemos {get; set;}
    
    public SalesOrderPDFController(){
        receipts = new List<AcctSeed__Billing_Cash_Receipt__c>();
        // soId = std.getId();
        soId = ApexPages.currentPage().getParameters().get('id');
        sol_map = new Map<Id, AcctSeedERP__Sales_Order_Line__c>();

        Map<Id, List<Id>> kit_relation = getKitsRelation();
        Map<Id, List<Id>> current_so_relation = new Map<Id, List<Id>>();
        
        // get the sales order record
        so = [SELECT Id, Name, acctSeederp__opportunity__c,Shipping_Account__c,
              Shipping_Account__r.Name,
              AcctSeedERP__Billing_City__c, AcctSeedERP__Billing_Country__c, 
              AcctSeedERP__Billing_PostalCode__c, AcctSeedERP__Billing_State__c,shipping_term__c, 
              AcctSeedERP__Billing_Street__c, AcctSeedERP__Customer__r.name,approval_date__c,
              AcctSeedERP__Customer__r.AcctSeed__Billing_Terms_Name__c,
              AcctSeedERP__Opportunity__r.name, AcctSeedERP__Shipping_City__c, 
              AcctSeedERP__Shipping_Country__c, AcctSeedERP__Shipping_PostalCode__c, 
              AcctSeedERP__Shipping_State__c, AcctSeedERP__Shipping_Street__c,
              Gl_Account_Variable_1__r.Name, Gl_Account_Variable_1__r.Sales_Order_Terms__c, 
              Gl_Account_Variable_1__r.Sales_Order_Header__c, Gl_Account_Variable_1__r.Sales_Order_Footer__c,
              AcctSeedERP__Status__c, AcctSeedERP__Total__c, Sales_Rep_o__c, Sales_Rep_o__r.name,Contact__r.Name,CreatedDate, 
              Contact__r.Phone, Contact__r.Email FROM AcctSeedERP__Sales_Order__c where id=:soId limit 1];
        
        // get the lines
        lines = new list<AcctSeedERP__Sales_Order_line__c>();
        
        lines = [SELECT AcctSeedERP__Product__c, Name, Id,size__c,image__c, Allow_Product_Description_Change__c,Kit__c,Kit_Children__c,
                 AcctSeedERP__Total__c, QuantityFormula__c,AcctSeedERP__Unit_Price__c,
                 Sales_Price__c,Total_Price__c,AcctSeedERP__Product__r.name,
                 AcctSeedERP__Product__r.Product_Image_Short_URL__c,
                 AcctSeedERP__Product__r.ProductImageURL__c,AcctSeedERP_Description__c, ProductCode__c 
                 FROM AcctSeedERP__Sales_Order_Line__c where AcctSeedERP__Sales_Order__c =:soId 
                 order by sortorder__c,name,createddate asc];
        
        List<AcctSeedERP__Sales_Order_line__c> not_kit_not_kitprod = new List<AcctSeedERP__Sales_Order_line__c>();

        for(AcctSeedERP__Sales_Order_Line__c sol: lines){
            sol_map.put(sol.AcctSeedERP__Product__c, sol); //Making map <ProductId, SalesOrderLine>

            //Sales Order can have not KIT and not KIT Product lines
            //We make another list with this items and will add to the end of pdf in code above
            if(sol.Kit__c == false && sol.Kit_Children__c == false){
                not_kit_not_kitprod.add(sol);
            }
        }


        /* This part of code sort Sales Order Lines in order KIT parent and above him related Kit Products */

        for(Id solId: sol_map.keySet()){
            if(sol_map.get(solId).Kit__c == true && kit_relation.containsKey(solId)){
                List<Id> childs = new List<Id>(); //List of related to KIT -> KIT products

                //We make map with Kit and related Kit products to him 
                for(Id kit_prod:kit_relation.get(solId)){
                    if(sol_map.containsKey(kit_prod)){
                        childs.add(kit_prod);
                    }
                }
                current_so_relation.put(solId, childs); //Putting map with ProductId(KIT) and list of child(KIT Products)
            }
        }

        //We clear the main list because above we add new sorted items.
        //This clearing is preventing for line duplication.
        lines.clear(); 

        for(Id product: current_so_relation.keySet()){
            if(sol_map.containsKey(product)){
                lines.add(sol_map.get(product));
            }
            for(Id child:current_so_relation.get(product)){
                if(sol_map.containsKey(child)){
                    lines.add(sol_map.get(child));
                }
            }
        }

        lines.addAll(not_kit_not_kitprod); //Adding not KIT and not KIT Product lines
        /* (END) This part of code sort Sales Order Lines in order KIT parent and above him related Kit Products */


        system.debug('current_so_relation: '+JSON.serialize(current_so_relation));

        system.debug('lines sol: '+JSON.serialize(lines));

        // checkout billing and process receipts
        CheckBillings();
        CheckCreditMemos();

        // Getting Header and Footer of PDF From accounting variable fields related to Sales Order
        headerUrl = Test.isRunningTest() ? null : getImageURL(so.Gl_Account_Variable_1__r.Sales_Order_Header__c);
        footerUrl = Test.isRunningTest() ? null : getImageURL(so.Gl_Account_Variable_1__r.Sales_Order_Footer__c);
        terms = getFilteredTerms(so.Gl_Account_Variable_1__r.Sales_Order_Terms__c);
    }
    

    /*****************************************************************************************************
    *   @method      : getKitsRelation
    *   @description : non static method used to get map of Kit parent Id and List of related children Kit Ids 
    *   @return      : Map<Id, List<Id>>
    *   @author      : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/

    public Map<Id, List<Id>> getKitsRelation(){
        List<AcctSeed__Product_Part__c> kits = [SELECT Id, Kit_Product__c, Kit_Children__c FROM AcctSeed__Product_Part__c LIMIT 50000];
        Map<Id, List<Id>> kit_parent_childrens = new Map<Id, List<Id>>();

        for(AcctSeed__Product_Part__c kit:kits){
            if(kit.Kit_Product__c != null){
                if(!kit_parent_childrens.containsKey(kit.Kit_Product__c)){
                    List<Id> childrenIds = new List<Id>{kit.Kit_Children__c};
                    kit_parent_childrens.put(kit.Kit_Product__c, childrenIds);
                } else {
                    if(kit_parent_childrens.containsKey(kit.Kit_Product__c)){
                        kit_parent_childrens.get(kit.Kit_Product__c).add(kit.Kit_Children__c);
                    }
                }
            }
            
        }

        return kit_parent_childrens;
    }

    /*****************************************************************************************************
    *   @method      : CheckBillings
    *   @description : non static method used to get related billings to current Sales Order
    *   @return      : void
    *   @author      : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/

    public void CheckBillings(){
        receipts = new List<AcctSeed__Billing_Cash_Receipt__c>();

        // Getting all Billings related to open Sales Order
        List<AcctSeed__Billing__c> billings = [select id from AcctSeed__Billing__c 
                                               where AcctSeedERP__Sales_Order__c=:soId];
        
        // Check do Sales Order has related billings
        if(!billings.isEmpty()){
            
            set<id> billIds = new set<id>();
            
            for(AcctSeed__Billing__c bl : billings){
                billIds.add(bl.id);
            }
            
            // get the billing cash receipts
            receipts = [SELECT Id, Name, AcctSeed__Billing__r.Name,
                        AcctSeed__Billing__r.AcctSeed__Customer__r.name, 
                        AcctSeed__Cash_Receipt__r.Name,
                        AcctSeed__Cash_Receipt__r.AcctSeed__Receipt_Date__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Account__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Accounting_Period__r.name, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Accounting_Year__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Amount__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Balance__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Bank_Account__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Bank_Deposit__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Bank_Reconciliation__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Cleared_Date__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Credit_GL_Account__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Currency_Conversion_Rate__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__GL_Account_Variable_1__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__GL_Account_Variable_2__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__GL_Account_Variable_3__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__GL_Account_Variable_4__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Ledger_Amount__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Payment_Reference__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Project_Task__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Project__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Purpose__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Status__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Applied_Amount__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Number_of_Billing_Cash_Receipts__c, 
                        AcctSeed__Cash_Receipt__r.AcctSeed__Ledger__c,                                                          
                        AcctSeed__Cash_Receipt__r.Payment_Method__c,                                                          
                        AcctSeed__Accounting_Period__c, 
                        AcctSeed__Adjustment_Amount__c, 
                        AcctSeed__Adjustment_GL_Account__c, 
                        AcctSeed__Applied_Amount__c, 
                        AcctSeed__Period_Applied__c 
                        FROM AcctSeed__Billing_Cash_Receipt__c
                        where AcctSeed__Billing__c in:billIds];
        }
        
    }

    /************************************************************************************************************
    *   @method      : CheckCreditMemos
    *   @description : non static method used to get related billings with type CreditMemo to current Sales Order
    *   @return      : void
    *   @author      : Marian Lyzhychka ©Peeklogic
    *************************************************************************************************************/

    public void CheckCreditMemos(){
        
        CreditMemos = new List<wrapper>(); 
        
       List<AcctSeed__Billing__c> CreditMemo_Billings = [SELECT Id, Name, 
                       AcctSeed__Billing__c.AcctSeed__Customer__r.name, 
                       AcctSeed__Date__c, AcctSeed__Total__c, AcctSeed__Credit_Memo_Applied_Amount__c 
                       FROM AcctSeed__Billing__c where acctseederp__sales_order__c =:soId
                      and AcctSeed__Type__c = 'Credit Memo'];
        
        if(!CreditMemo_Billings.isEmpty()){
            
            for(AcctSeed__Billing__c b : CreditMemo_Billings){
                
                wrapper w = new wrapper(b, b.AcctSeed__Credit_Memo_Applied_Amount__c);
                
                CreditMemos.add(w);
                
            }
            
        }
    }

    public string getImageURL(string url){

        String imageURL = '';
        Matcher imgMatcher = Pattern.compile('<img(.+?)>').matcher(url);
        if(imgMatcher.find()) {
            String imageTag = imgMatcher.group();
            imageURL= imageTag.substringBetween(' src="', '"');
        }
        
        return imageURL.unescapeHtml4();
    }

    public string getFilteredTerms(string terms){

        try{

            if(so.AcctSeedERP__Customer__r.AcctSeed__Billing_Terms_Name__c == null)
            so.AcctSeedERP__Customer__r.AcctSeed__Billing_Terms_Name__c = 'Not Applicable';

            string patternValue = string.valueOf(so.AcctSeedERP__Customer__r.AcctSeed__Billing_Terms_Name__c);
            terms = terms.replaceAll('AcctSeed__Billing_Terms_Name__c', patternValue);
            
            patternValue = string.valueOf(so.AcctSeedERP__Customer__r.Name);
            terms = terms.replaceAll('AcctSeedERP__Customer__r.Name', patternValue);
    
            terms = terms.replaceAll('#', '');
            terms  = terms.unescapeHtml4();
            terms = terms.replaceAll('&39;', '\'');
    
            return terms;
        }
        catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public class wrapper{
        
        public acctseed__billing__c billing {get; set;}
        public decimal total {get; set;}
        
        public wrapper(acctseed__billing__c b, decimal t){
            
            billing = b;
			total = Math.abs(t);	
        }
    }

}
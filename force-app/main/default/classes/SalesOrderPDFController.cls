public without sharing class SalesOrderPDFController {
    
    public string headerUrl {get; set;}
    public string footerUrl {get; set;}
    public string terms {get; set;}
    private Id soId {get; set;}
    public list<AcctSeedERP__Sales_Order_line__c> lines {get; set;}
    public AcctSeedERP__Sales_Order__c so {get; set;}
    
    public List<AcctSeed__Billing_Cash_Receipt__c> receipts {get; set;}
    public List<wrapper> CreditMemos {get; set;}
    
    public SalesOrderPDFController(){
        receipts = new List<AcctSeed__Billing_Cash_Receipt__c>();
        // soId = std.getId();
        soId = ApexPages.currentPage().getParameters().get('id');
        
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
        
        lines = [SELECT AcctSeedERP__Product__c, Name, Id,size__c,image__c, 
                 AcctSeedERP__Total__c, QuantityFormula__c,AcctSeedERP__Unit_Price__c,
                 Sales_Price__c,Total_Price__c,AcctSeedERP__Product__r.name,
                 AcctSeedERP__Product__r.Product_Image_Short_URL__c,
                 AcctSeedERP__Product__r.ProductImageURL__c,AcctSeedERP_Description__c, ProductCode__c 
                 FROM AcctSeedERP__Sales_Order_Line__c where AcctSeedERP__Sales_Order__c =:soId 
                 order by sortorder__c,name,createddate asc];
        
        // checkout billing and process receipts
        CheckBillings();
        CheckCreditMemos();

        // PDF Logic
        headerUrl = Test.isRunningTest() ? null : getImageURL(so.Gl_Account_Variable_1__r.Sales_Order_Header__c);
        footerUrl = Test.isRunningTest() ? null : getImageURL(so.Gl_Account_Variable_1__r.Sales_Order_Footer__c);
        terms = getFilteredTerms(so.Gl_Account_Variable_1__r.Sales_Order_Terms__c);
    }
    
    public void CheckBillings(){
        receipts = new List<AcctSeed__Billing_Cash_Receipt__c>();
        // get all the so billings
        List<AcctSeed__Billing__c> billings = [select id from AcctSeed__Billing__c 
                                               where AcctSeedERP__Sales_Order__c=:soId];
        
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
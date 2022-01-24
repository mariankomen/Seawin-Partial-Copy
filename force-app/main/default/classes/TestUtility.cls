@isTest
public class TestUtility {
    
    public static void CreateData() 
 	{
        
        list<AcctSeed__Accounting_Variable__c> avList = new list<AcctSeed__Accounting_Variable__c>();
        
    	avList.add(new AcctSeed__Accounting_Variable__c(Name = 'Seawin China',AcctSeed__Type__c = 'GL Account Variable 1'));
        
        avList.add(new AcctSeed__Accounting_Variable__c(Name = 'Seawin USA',AcctSeed__Type__c = 'GL Account Variable 1'));
        insert avList;
        
        Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Seawin USA Hospitality').getRecordTypeId();
        
        Id RecordTypeIdSO = Schema.SObjectType.AcctSeedERP__Sales_Order__c.getRecordTypeInfosByName().get('Seawin USA Hospitality').getRecordTypeId();

        // Accounting Period
        Date dt = date.today();
        
        AcctSeed__Accounting_Period__c ap = new AcctSeed__Accounting_Period__c();
        ap.name = dt.year() + '-' + ((dt.month() < 10)?'0' + dt.month():String.ValueOf(dt.month()));
        system.debug(dt.year() + '-' + ((dt.month() < 9)?Integer.ValueOf('0' + dt.month()):dt.month()));
        ap.AcctSeed__Start_Date__c = Date.today() - (dt.day() - 1);
        ap.AcctSeed__End_Date__c = Date.today() + 28;
        ap.AcctSeed__Status__c = 'Open';
        insert ap;
        
    	// create account
    	list<Account> acctList = new list<Account>();
        
        Account acct = new Account();
        
        acct.Name = 'myAccount';
        acct.Type = 'Customer';
        acct.AcctSeed__Billing_Terms_Name__c = 'Example terms';
        
        acctList.add(acct);
        
        Account acct2 = new Account();
        
        acct2.Name = 'myAccount2';
        acct2.Type = 'Customer';
        acct2.billingCountry = 'Pakistan';
        acct2.billingCity = 'Rawalpindi';
        acct2.billingState = 'Punjab';
        acct2.billingPostalCode = '46000';
        acct2.billingstreet = 'Satellite Town';

        acctList.add(acct2);
        
        insert acctList;
		
        // create contact
        Contact cont = new Contact();
        
        cont.LastName = 'myLastName';
        cont.AccountId = acctList[0].Id;
        
        insert cont;
        
        list<AcctSeed__GL_Account__c> glList = new list<AcctSeed__GL_Account__c>();
        
        AcctSeed__GL_Account__c gl = new AcctSeed__GL_Account__c();
        
        gl.name = 'GL Account First';
        gl.AcctSeed__type__c = 'Balance Sheet';
        gl.AcctSeed__Sub_Type_1__c = 'Liabilities';
        gl.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        gl.AcctSeed__Active__c = true;
        
        glList.add(gl);
        
        		
        // ledger creation
        AcctSeed__GL_Account__c aegl = new AcctSeed__GL_Account__c();
        aegl.name = 'glaccount';
        aegl.AcctSeed__Type__c = 'Expense';
        aegl.AcctSeed__Sub_Type_1__c = 'Facilities';
        aegl.AcctSeed__Sub_Type_2__c = 'Rent';
        aegl.AcctSeed__Bank__c = true;
        
        glList.add(aegl);
        
        AcctSeed__GL_Account__c vch = new AcctSeed__GL_Account__c();
        vch.name = '2010-Vouchers Payable';
        vch.AcctSeed__Type__c = 'Balance Sheet';
        vch.AcctSeed__Sub_Type_1__c = 'Liabilities';
        vch.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        vch.AcctSeed__Active__c = true;
        
        glList.add(vch);
        
        AcctSeed__GL_Account__c vch1 = new AcctSeed__GL_Account__c();
        vch1.name = '2010-Vouchers Payable1';
        vch1.AcctSeed__Type__c = 'Balance Sheet';
        vch1.AcctSeed__Sub_Type_1__c = 'Liabilities';
        vch1.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        vch1.AcctSeed__Active__c = true;
        
        glList.add(vch1);
        
        AcctSeed__GL_Account__c vch2 = new AcctSeed__GL_Account__c();
        vch2.name = '2010-Vouchers Payable2';
        vch2.AcctSeed__Type__c = 'Balance Sheet';
        vch2.AcctSeed__Sub_Type_1__c = 'Liabilities';
        vch2.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        vch2.AcctSeed__Active__c = true;
        
        glList.add(vch2);
        
        AcctSeed__GL_Account__c vch3 = new AcctSeed__GL_Account__c();
        vch3.name = '2010-Vouchers Payable3';
        vch3.AcctSeed__Type__c = 'Balance Sheet';
        vch3.AcctSeed__Sub_Type_1__c = 'Liabilities';
        vch3.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        vch3.AcctSeed__Active__c = true;
        
        glList.add(vch3);
        
        AcctSeed__GL_Account__c gl1 = new AcctSeed__GL_Account__c();
        gl1.name = '2010-Vouchers Payable1';
        gl1.AcctSeed__Type__c = 'Balance Sheet';
        gl1.AcctSeed__Sub_Type_1__c = 'Liabilities';
        gl1.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        gl1.AcctSeed__Active__c = true;
        
        glList.add(gl1);
        
        AcctSeed__GL_Account__c gl2 = new AcctSeed__GL_Account__c();
        gl2.name = '2010-Vouchers Payable2';
        gl2.AcctSeed__Type__c = 'Balance Sheet';
        gl2.AcctSeed__Sub_Type_1__c = 'Liabilities';
        gl2.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        gl2.AcctSeed__Active__c = true;
        
        glList.add(gl2);
        
        AcctSeed__GL_Account__c gl3 = new AcctSeed__GL_Account__c();
        gl3.name = '2010-Vouchers Payable3';
        gl3.AcctSeed__Type__c = 'Balance Sheet';
        gl3.AcctSeed__Sub_Type_1__c = 'Liabilities';
        gl3.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        gl3.AcctSeed__Active__c = true;
        
        glList.add(gl3);
        
        AcctSeed__GL_Account__c gl4 = new AcctSeed__GL_Account__c();
        gl4.name = '2010-Vouchers Payable4';
        gl4.AcctSeed__Type__c = 'Balance Sheet';
        gl4.AcctSeed__Sub_Type_1__c = 'Liabilities';
        gl4.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
        gl4.AcctSeed__Active__c = true;
        
        glList.add(gl4);
        
        insert glList;
        
        list<sales_rep__c> salesrepList = new list<sales_rep__c>();
        
        sales_rep__c salesrep = new sales_rep__c();
        
        salesrep.User__c = Userinfo.getUserId();
        salesrep.Active__c = 'Yes';
        salesrep.Name = 'New User';
        salesrep.Price_Level_1_12__c = 1;
        salesrep.Price_Level_13_20__c = 2;
        salesrep.Price_Level_21_26__c = 3;
        salesrep.Price_Level_27_30__c = 4;
        
        salesrepList.add(salesrep);
        
        sales_rep__c salesrep2 = new sales_rep__c();
        
        salesrep2.User__c = Userinfo.getUserId();
        salesrep2.Active__c = 'Yes';
        salesrep2.Name = 'New User 2';
        salesrep2.Price_Level_1_12__c = 1;
        salesrep2.Price_Level_13_20__c = 2;
        salesrep2.Price_Level_21_26__c = 3;
        salesrep2.Price_Level_27_30__c = 4;
        
        salesrepList.add(salesrep2);
        
        insert salesrepList;
        
        // create product
        Product2 prod = new Product2();
        
        prod.Name = 'myProduct';
        prod.ProductCode = 'ABC123';
        prod.Description = 'myDescription';
        prod.AcctSeed__Unit_Cost__c = 100;
        prod.IsActive = true;
        prod.Category__c = 'Shower Door';
        prod.Sub_Category__c = 'Single Sliding';
        prod.AcctSeed__Inventory_Type__c = 'Purchased';
        prod.AcctSeed__Expense_GL_Account__c = glList[0].id;
        prod.AcctSeed__Inventory_GL_Account__c = glList[0].id;
        prod.AcctSeed__Revenue_GL_Account__c = glList[0].id;
        prod.AcctSeed__Inventory_Product__c = true;

        insert prod;

        // get the standard price book id
        Id pricebookId = Test.getStandardPricebookId();
        
        // create standard price book entry
        PricebookEntry pricebentry = new PricebookEntry();
        
        pricebentry.Pricebook2Id = pricebookId;
  		pricebentry.Product2Id = prod.Id;
        pricebentry.UnitPrice = 100;
        pricebentry.IsActive = true;
        
        insert pricebentry;
        
        // create opportunity
        list<Opportunity> oppList = new list<Opportunity>();
        
        Opportunity opp = new Opportunity();
        
        opp.Name = 'myOpportunity';
        opp.AccountId = acctList[0].Id;
        opp.Type = 'Actual Order';
        opp.StageName = 'Closed Won';
        opp.CloseDate = system.today();
        opp.ContactPerson__c = cont.Id;
        opp.GL_Account_Variable_1__c = avList[0].id;
        opp.RecordTypeId = RecordTypeIdOpportunity;
        opp.Pricebook2Id = pricebookId;
        //opp.IsApproved__c= false;
        opp.Sales_Rep_O__c = salesrepList[0].id;
        
        insert opp;
        
        Opportunity ClonedOpp = opp.clone(false, false, false, false);
        ClonedOpp.Name = 'Cloned Opportunity';
        
        oppList.add(ClonedOpp);
        
        //oppList.add(opp);
        
        // create opportunity
        Opportunity opp2 = new Opportunity();
        
        opp2.Name = 'myOpportunity2';
        opp2.AccountId = acctList[0].Id;
        opp2.Type = 'Actual Order';
        opp2.StageName = 'Follow up';
        opp2.CloseDate = system.today();
        opp2.ContactPerson__c = cont.Id;
        opp2.GL_Account_Variable_1__c = avList[0].id;
        opp2.Pricebook2Id = pricebookId;
        opp2.Sales_Rep_O__c = salesrepList[0].id;
        
        oppList.add(opp2);
        
        insert oppList;
        
        list<opportunitylineitem> l1List = new list<opportunitylineitem>();
        
        opportunitylineitem l1 = new opportunitylineitem();
        
        l1.Quantity = 2;
        l1.UnitPrice = 2;
        l1.Product2Id = prod.id;
        l1.PricebookEntryId = pricebentry.id;
        l1.OpportunityId = oppList[0].id;
        
        l1List.add(l1);

        opportunitylineitem l2 = new opportunitylineitem();
        
        l2.Quantity = 2;
        l2.UnitPrice = 2;
        l2.Product2Id = prod.id;
        l2.PricebookEntryId = pricebentry.id;
        l2.OpportunityId = oppList[1].id;
        
        l1List.add(l2);

        insert l1List;

        
        // create quote
        Quote qt = new Quote();
        
        qt.OpportunityId = oppList[0].Id;
        //qt.AccountId = acct.Id;
        qt.Name = 'myQuote';
        qt.Quote_Date__c = Date.today();
        qt.Pricebook2Id = pricebookId;
        
        insert qt;
        
        //----------------------- Quote Line Items

        quotelineitem qlis = new quotelineitem();
        
        qlis.QuoteId = qt.id;
        qlis.Product2Id = prod.id;
        qlis.Quantity = 1;
        qlis.UnitPrice = 1;
        qlis.PricebookEntryId = pricebentry.id;

        insert qlis;
        
        // ----------------------- Content Document
        // documents
        
        Contentversion portfolio = new contentversion();
        portfolio.Title = 'Portfolio';
        portfolio.VersionData = Blob.valueOf('Test data.');
        portfolio.PathOnClient = 'Test data';
        
        insert portfolio;
        
        ContentDocument document = [SELECT Id, Title FROM ContentDocument where title='Portfolio' limit 1];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=qt.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=document.Id;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        system.assertEquals(portfolio.ContentDocumentId, null);
        
        prod.Technical_Specs_Id__c = document.Id;
        
        update prod;
        
        list<AcctSeed__Billing_Format__c> abfList = new list<AcctSeed__Billing_Format__c>();
        
        AcctSeed__Billing_Format__c abf = new AcctSeed__Billing_Format__c();
        
        abf.Name = 'newPDF Format';
        abf.AcctSeed__Type__c = 'Purchase Order';
        abf.AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStatementPDF';
        abf.AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template';
        
        abfList.add(abf);

        AcctSeed__Billing_Format__c abf2 = new AcctSeed__Billing_Format__c();
        
        abf2.Name = 'Default Purchase Order';
        abf2.AcctSeed__Type__c = 'Purchase Order';
        abf2.AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStatementPDF';
        abf2.AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template';
        
        abfList.add(abf2);
        
        insert abfList;

        AcctSeed__Ledger__c ledger = new AcctSeed__Ledger__c();
        
        ledger.Name = 'myLedger';
        ledger.AcctSeed__Type__c = 'Transactional';
        ledger.AcctSeed__Billing_Activity_Statement_Format__c = abfList[0].id;
        ledger.AcctSeed__Billing_Outstanding_Statement_Format__c = abfList[0].id;
        ledger.AcctSeed__Default_Bank_Account__c = glList[1].id;
        ledger.AcctSeed__Default_Billing_Format__c = abfList[0].id; 
        ledger.AcctSeed__Default_Purchase_Order_Format__c = abfList[0].id;
        ledger.AcctSeed__Default_Packing_Slip_Format__c = abfList[0].id;
        
        insert ledger;
        
        // create a sales order
        list<AcctSeedERP__Sales_Order__c> salesorderList = new list<AcctSeedERP__Sales_Order__c>();  
        
        AcctSeedERP__Sales_Order__c salesorder = new AcctSeedERP__Sales_Order__c(); 
        
        salesorder.AcctSeedERP__Customer__c = acctList[0].Id;
        salesorder.AcctSeedERP__Opportunity__c = opp.Id;
        salesorder.Contact__c = cont.Id;
        salesorder.AcctSeedERP__Status__c = 'Open';
       	salesorder.AcctSeedERP__Ledger__c = ledger.id;
        salesorder.GL_Account_Variable_1__c = avList[0].id;
        salesorder.Stage__c = 'Production';
        salesorder.RecordTypeId = RecordTypeIdSO;
        salesorder.Sales_Rep_O__c = salesrepList[0].id;

        salesorderList.add(salesorder);
        
        // -----------------------
        // create a sales order
        AcctSeedERP__Sales_Order__c salesorder2 = new AcctSeedERP__Sales_Order__c(); 
        
        salesorder2.AcctSeedERP__Customer__c = acctList[0].Id;
        salesorder2.AcctSeedERP__Opportunity__c = oppList[1].Id;
        salesorder2.Contact__c = cont.Id;
        salesorder2.AcctSeedERP__Status__c = 'Open';
       	salesorder2.AcctSeedERP__Ledger__c = ledger.id;
        salesorder2.GL_Account_Variable_1__c = avList[0].id;
        salesorder2.Stage__c = 'Production';
        salesorder2.RecordTypeId = RecordTypeIdSO;
        salesorder.Sales_Rep_O__c = salesrepList[0].id;

        salesorderList.add(salesorder2);
        
        insert salesorderList;
        
        list<AcctSeedERP__Sales_Order_Line__c> solinesList = new list<AcctSeedERP__Sales_Order_Line__c>(); 
        
        // create a sales order lines
        AcctSeedERP__Sales_Order_Line__c solines = new AcctSeedERP__Sales_Order_Line__c(); 
        
        solines.AcctSeedERP__Sales_Order__c = salesorderList[0].id;
        solines.AcctSeedERP__Unit_Price__c = 1.1;
        solines.AcctSeedERP_Description__c = 'This is salesorder line item';
        solines.AcctSeedERP__Product__c = prod.id;
        solines.AcctSeedERP__Quantity_Ordered__c = 2;
        
        solinesList.add(solines);

        // create a sales order lines
        AcctSeedERP__Sales_Order_Line__c solines2 = new AcctSeedERP__Sales_Order_Line__c(); 
        
        solines2.AcctSeedERP__Sales_Order__c = salesorderList[1].id;
        solines2.AcctSeedERP__Unit_Price__c = 1.1;
        solines2.AcctSeedERP_Description__c = 'This is salesorder line item';
        solines2.AcctSeedERP__Product__c = prod.id;
        solines2.AcctSeedERP__Quantity_Ordered__c = 2;
        
        solinesList.add(solines2);
        
        insert solinesList;
        // -----------------------
        
        List<AcctSeed__Billing__c> billList = new List<AcctSeed__Billing__c>();
        
        AcctSeed__Billing__c bill = new AcctSeed__Billing__c();
        
        bill.AcctSeed__Status__c = 'Approved';
        bill.AcctSeed__PDF_Email_Status__c = 'Unsent';
        bill.AcctSeed__Billing_Format__c = abfList[0].id;
        bill.AcctSeedERP__Sales_Order__c = salesorderList[1].id; 
        bill.AcctSeed__Date__c = Date.Today();
        bill.AcctSeed__Due_Date2__c = Date.Today();
        bill.AcctSeed__Ledger__c = salesorderList[0].AcctSeedERP__Ledger__c;
        bill.AcctSeed__Opportunity__c = salesorderList[0].AcctSeedERP__Opportunity__c;
        bill.AcctSeed__Customer__c = salesorderList[0].AcctSeedERP__Customer__c;
        bill.AcctSeed__Shipping_City__c = salesorderList[0].AcctSeedERP__Shipping_City__c;
        bill.AcctSeed__Shipping_Contact__c = salesorderList[0].Contact__c;
        bill.AcctSeed__Shipping_Country__c = salesorderList[0].AcctSeedERP__Shipping_Country__c;
        bill.AcctSeed__Shipping_PostalCode__c = salesorderList[0].AcctSeedERP__Shipping_PostalCode__c;
        bill.AcctSeed__Shipping_State__c = salesorderList[0].AcctSeedERP__Shipping_State__c;
        bill.AcctSeed__Shipping_Street__c = salesorderList[0].AcctSeedERP__Shipping_Street__c;
        bill.AcctSeed__Billing_Contact__c = salesorderList[0].Contact__c;
        bill.AcctSeed__Billing_Country__c = salesorderList[0].AcctSeedERP__Billing_Country__c;
        bill.AcctSeed__Billing_PostalCode__c = salesorderList[0].AcctSeedERP__Billing_PostalCode__c;
        bill.AcctSeed__Billing_State__c = salesorderList[0].AcctSeedERP__Billing_State__c;
        bill.AcctSeed__Billing_Street__c = salesorderList[0].AcctSeedERP__Billing_Street__c;
        bill.AcctSeed__Billing_City__c = salesorderList[0].AcctSeedERP__Billing_City__c;
        bill.AcctSeed__Accounting_Period__c = ap.id;

        billList.add(bill);

        // credit memo
        AcctSeed__Billing__c bill2 = new AcctSeed__Billing__c();
        
        bill2.AcctSeed__Status__c = 'Approved';
        bill2.AcctSeed__PDF_Email_Status__c = 'Unsent';
        bill2.AcctSeed__Billing_Format__c = abfList[0].id;
        bill2.AcctSeedERP__Sales_Order__c = salesorderList[1].id; 
        bill2.AcctSeed__Date__c = Date.Today();
        bill2.AcctSeed__Due_Date2__c = Date.Today();
        bill2.AcctSeed__Ledger__c = salesorderList[0].AcctSeedERP__Ledger__c;
        bill2.AcctSeed__Opportunity__c = salesorderList[0].AcctSeedERP__Opportunity__c;
        bill2.AcctSeed__Customer__c = salesorderList[0].AcctSeedERP__Customer__c;
        bill2.AcctSeed__Shipping_City__c = salesorderList[0].AcctSeedERP__Shipping_City__c;
        bill2.AcctSeed__Shipping_Contact__c = salesorderList[0].Contact__c;
        bill2.AcctSeed__Shipping_Country__c = salesorderList[0].AcctSeedERP__Shipping_Country__c;
        bill2.AcctSeed__Shipping_PostalCode__c = salesorderList[0].AcctSeedERP__Shipping_PostalCode__c;
        bill2.AcctSeed__Shipping_State__c = salesorderList[0].AcctSeedERP__Shipping_State__c;
        bill2.AcctSeed__Shipping_Street__c = salesorderList[0].AcctSeedERP__Shipping_Street__c;
        bill2.AcctSeed__Billing_Contact__c = salesorderList[0].Contact__c;
        bill2.AcctSeed__Billing_Country__c = salesorderList[0].AcctSeedERP__Billing_Country__c;
        bill2.AcctSeed__Billing_PostalCode__c = salesorderList[0].AcctSeedERP__Billing_PostalCode__c;
        bill2.AcctSeed__Billing_State__c = salesorderList[0].AcctSeedERP__Billing_State__c;
        bill2.AcctSeed__Billing_Street__c = salesorderList[0].AcctSeedERP__Billing_Street__c;
        bill2.AcctSeed__Billing_City__c = salesorderList[0].AcctSeedERP__Billing_City__c;
        bill2.AcctSeed__Accounting_Period__c = ap.id;
        
        billList.add(bill2);

        insert billList;
        
        List<AcctSeed__Billing_Line__c> blineList = new List<AcctSeed__Billing_Line__c>();
        
        AcctSeed__Billing_Line__c bline = new AcctSeed__Billing_Line__c();
        bline.AcctSeed__Billing__c = billList[0].id;
        bline.AcctSeed__Date__c = date.today();
        bline.AcctSeed__Hours_Units__c = 1;
        bline.AcctSeed__Product__c = solinesList[0].AcctSeedERP__Product__c;
        bline.AcctSeedERP__Sales_Order_Line__c = solinesList[0].id;
        bline.AcctSeed__Rate__c = solinesList[0].AcctSeedERP__Unit_Price__c;
        bline.Item_Description__c = solinesList[0].Item_Description__c;
        
        blineList.add(bline);
        
        AcctSeed__Billing_Line__c bline2 = new AcctSeed__Billing_Line__c();
        bline2.AcctSeed__Billing__c = billList[1].id;
        bline2.AcctSeed__Date__c = date.today();
        bline2.AcctSeed__Hours_Units__c = 1;
        bline2.AcctSeed__Product__c = solinesList[0].AcctSeedERP__Product__c;
        bline2.AcctSeedERP__Sales_Order_Line__c = solinesList[0].id;
        bline2.AcctSeed__Rate__c = -solinesList[0].AcctSeedERP__Unit_Price__c;
        bline2.Item_Description__c = solinesList[0].Item_Description__c;
        
        blineList.add(bline2);
        
        insert blineList;
        
        List<AcctSeed__Billing_Credit_Memo__c> abcList = new List<AcctSeed__Billing_Credit_Memo__c>();
        
        AcctSeed__Billing_Credit_Memo__c abc = new AcctSeed__Billing_Credit_Memo__c();
        
        abc.AcctSeed__Accounting_Period__c = ap.id;
        abc.AcctSeed__Amount__c = -0.5;
        abc.AcctSeed__Billing_Credit_Memo__c = billList[1].id;
        abc.AcctSeed__Billing_Invoice__c = billList[0].id;
        
        abcList.add(abc);
        
        AcctSeed__Billing_Credit_Memo__c abc2 = new AcctSeed__Billing_Credit_Memo__c();
        
        abc2.AcctSeed__Accounting_Period__c = ap.id;
        abc2.AcctSeed__Amount__c = -0.5;
        abc2.AcctSeed__Billing_Credit_Memo__c = billList[1].id;
        abc2.AcctSeed__Billing_Invoice__c = billList[0].id;
        
        abcList.add(abc2);
        
        insert abcList;
        
        delete abcList[1];
        
        list<acctseederp__purchase_order__c> poList = new list<acctseederp__purchase_order__c>();
        
        acctseederp__purchase_order__c po = new acctseederp__purchase_order__c();
        
        po.AcctSeedERP__Order_Date__c = date.today();
        po.AcctSeedERP__Status__c = 'Open';
        po.AcctSeedERP__Type__c = 'Drop Shipment';
        po.Stage__c = 'In Production';
        po.AcctSeedERP__Purchase_Order_Format__c = abfList[0].Id;
        po.AcctSeedERP__Ledger__c = ledger.Id;
        po.GL_Account_Variable_1__c = avList[0].id;
        po.Sales_Order__c = salesorderList[0].id;
        po.AcctSeedERP__Vendor_Contact__c = cont.id;
        po.AcctSeedERP__Vendor__c = acctList[0].id;
        
        poList.add(po);
        
        acctseederp__purchase_order__c po2 = new acctseederp__purchase_order__c();
        
        po2.AcctSeedERP__Order_Date__c = date.today();
        po2.AcctSeedERP__Status__c = 'Open';
        po2.AcctSeedERP__Type__c = 'Standard';
        po2.Stage__c = 'In Production';
        po2.AcctSeedERP__Purchase_Order_Format__c = abfList[0].Id;
        po2.AcctSeedERP__Ledger__c = ledger.Id;
        po2.GL_Account_Variable_1__c = avList[0].id;
        po2.Sales_Order__c = salesorderList[1].id;
        
        poList.add(po2);
        
        insert poList;
        
        list<acctseederp__purchase_order_line__c> polList = new list<acctseederp__purchase_order_line__c>();
        
        acctseederp__purchase_order_line__c pol = new acctseederp__purchase_order_line__c();
        
        pol.AcctSeedERP__Product__c = prod.id;
        pol.AcctSeedERP__Quantity__c = 4;
        pol.AcctSeedERP__Purchase_Order__c = poList[0].id;
        pol.AcctSeedERP__Unit_Price__c = 1;
        
        polList.add(pol);
        
        //-------------------------
        
        
        acctseederp__purchase_order_line__c pol2 = new acctseederp__purchase_order_line__c();
        
        pol2.AcctSeedERP__Product__c = prod.id;
        pol2.AcctSeedERP__Quantity__c = 2;
        pol2.AcctSeedERP__Purchase_Order__c = poList[1].id;
        pol2.AcctSeedERP__Unit_Price__c = 1;
        
        polList.add(pol2);
        
        insert polList;
        
        solinesList[0].AcctSeedERP__Purchase_Order_Line__c = polList[0].id;
        
        update solinesList[0];
        
        AcctSeed__Account_Payable__c payable = new AcctSeed__Account_Payable__c();
        
        payable.AcctSeed__Accounting_Period__c = ap.id;  
        payable.AcctSeed__Date__c  = date.today();
        payable.AcctSeed__Due_Date__c = date.today() + 7;
        payable.AcctSeed__Status__c = 'Approved';
        payable.AcctSeed__Vendor__c = poList[0].AcctSeedERP__Vendor__c;
        payable.AcctSeed__Ledger__c = poList[0].AcctSeedERP__Ledger__c;
        payable.AcctSeedERP__Purchase_Order__c = poList[0].id;
        payable.AcctSeed__Payee_Reference__c = poList[0].Name + ' - ' + System.Now().formatLong(); 
            
        insert payable;

        AcctSeed__Account_Payable_Line__c payline = new AcctSeed__Account_Payable_Line__c();
                
        payline.AcctSeed__Account_Payable__c = payable.id;
        payline.AcctSeed__Amount__c = 1;
        payline.AcctSeed__Date__c = date.today();
        payline.AcctSeed__Expense_GL_Account__c = glList[0].id;
        payline.AcctSeed__GL_Account_Variable_1__c = avList[0].id;
        payline.AcctSeed__Quantity__c = 1;
        payline.AcctSeedERP__Purchase_Order_Line__c = polList[0].id;
        payline.Item_description__c = 'Test Description.';
        
        insert payline;
        
        //-------------------------
		list<AcctSeederp__warehouse__c> warehouseList = new list<AcctSeederp__warehouse__c>();
        // create inventory balances 1
        AcctSeederp__warehouse__c warehouse = new AcctSeederp__warehouse__c();
        warehouse.Name = 'myWarehouse';

        warehouseList.add(warehouse);
        
        // create inventory balances 2
        AcctSeederp__warehouse__c warehouse2 = new AcctSeederp__warehouse__c();
        warehouse2.Name = 'myWarehouse2';
        warehouseList.add(warehouse2);
        
        insert warehouseList;
        
        list<AcctSeedErp__location__c> locationList = new list<AcctSeedErp__location__c>();
        
        AcctSeedErp__location__c location = new AcctSeedErp__location__c();
        location.Name = 'myLocation';
        location.AcctSeedERP__Warehouse__c = warehouseList[0].id;

        locationList.add(location);
        
        AcctSeedErp__location__c location2 = new AcctSeedErp__location__c();
        location2.Name = 'myLocation2';
        location2.AcctSeedERP__Warehouse__c = warehouseList[1].id;

        locationList.add(location2);
        
        insert locationList;
        
        acctseederp__inventory_balance__c ib = new acctseederp__inventory_balance__c();
        
        ib.AcctSeedERP__Warehouse__c = warehouseList[0].id;
        ib.AcctSeedERP__Location__c = locationList[0].id;
        ib.AcctSeedERP__Product__c = prod.id;
        ib.AcctSeedERP__Ledger__c = ledger.id;
        insert ib;

        AcctSeed__Accounting_Settings__c custm = new AcctSeed__Accounting_Settings__c();
        
        custm.AcctSeed__Vouchers_Payable_GL_Account__c = glList[3].id;
        custm.AcctSeed__AP_Control_GL_Account__c= glList[6].id; 
            custm.AcctSeed__AR_Control_GL_Account__c = glList[4].id;
            custm.AcctSeed__Current_Year_Earnings_GL_Account__c = glList[7].id; 
            custm.AcctSeed__Default_Ledger__c = ledger.id; 
            custm.AcctSeed__Retained_Earnings_GL_Account__c = glList[8].id;
            custm.AcctSeed__Revenue_GL_Account__c = glList[5].id; 
            custm.AcctSeed__Unapplied_Cash_GL_Account__c = glList[9].id;
            
            
        insert custm;
        
        list<AcctSeedERP__Purchase_Order_Inventory_Movement__c> poimList = 
            new list<AcctSeedERP__Purchase_Order_Inventory_Movement__c>();

        AcctSeedERP__Purchase_Order_Inventory_Movement__c poim = 
            new AcctSeedERP__Purchase_Order_Inventory_Movement__c();
        poim.AcctSeedERP__GL_Account_Variable_1__c = avList[0].id;
        poim.AcctSeedERP__Inventory_Balance__c = ib.id;
        poim.AcctSeedERP__Quantity__c = 2;
        poim.AcctSeedERP__Purchase_Order_Line__c = polList[0].id;
        poim.AcctSeedERP__Movement_Date__c = date.today();
        poim.AcctSeedERP__Unit_Cost__c = 1;
        
        poimList.add(poim);
        
        list<AcctSeedERP__Sales_Order_Inventory_Movement__c> soimList = 
            new list<AcctSeedERP__Sales_Order_Inventory_Movement__c>();
        
        
        AcctSeedERP__Sales_Order_Inventory_Movement__c soim = new AcctSeedERP__Sales_Order_Inventory_Movement__c();
        soim.AcctSeedERP__GL_Account_Variable_1__c = avList[0].id;
        soim.AcctSeedERP__Inventory_Balance__c = ib.id;
        soim.AcctSeedERP__Quantity__c = 1;
        soim.AcctSeedERP__Movement_Date__c = date.today();
        soim.AcctSeedERP__Sales_Order_Line__c = solinesList[0].id;
        soim.AcctSeedERP__Unit_Cost__c = 1;
        
        soimList.add(soim);

        acctseederp__inventory_balance__c ib2 = new acctseederp__inventory_balance__c();
        
        ib2.AcctSeedERP__Warehouse__c = warehouseList[1].id;
        ib2.AcctSeedERP__Location__c = locationList[1].id;
        ib2.AcctSeedERP__Product__c = prod.id;
        ib2.AcctSeedERP__Ledger__c = ledger.id;
        insert ib2;
        
        AcctSeedERP__Purchase_Order_Inventory_Movement__c poim2 = new AcctSeedERP__Purchase_Order_Inventory_Movement__c();
        poim2.AcctSeedERP__GL_Account_Variable_1__c = avList[0].id;
        poim2.AcctSeedERP__Inventory_Balance__c = ib2.id;
        poim2.AcctSeedERP__Quantity__c = 2;
        poim2.AcctSeedERP__Purchase_Order_Line__c = polList[0].id;
        poim2.AcctSeedERP__Movement_Date__c = date.today();
        poim2.AcctSeedERP__Unit_Cost__c = 1;
        
        poimList.add(poim2);
        
        insert poimList;
        
        AcctSeedERP__Sales_Order_Inventory_Movement__c soim2 = new AcctSeedERP__Sales_Order_Inventory_Movement__c();
        soim2.AcctSeedERP__GL_Account_Variable_1__c = avlist[0].id;
        soim2.AcctSeedERP__Inventory_Balance__c = ib2.id;
        soim2.AcctSeedERP__Quantity__c = 1;
        soim2.AcctSeedERP__Movement_Date__c = date.today();
        soim2.AcctSeedERP__Sales_Order_Line__c = solinesList[0].id;
        soim2.AcctSeedERP__Unit_Cost__c = 1;
        
        soimList.add(soim2);
        
        insert soimList;
        
        AcctSeed__Billing_Format__c PackingSlipFormat = new AcctSeed__Billing_Format__c();
        
        PackingSlipFormat.Name = 'Packing Slip Default';
        PackingSlipFormat.AcctSeed__Type__c = 'Packing Slip';
        PackingSlipFormat.AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStatementPDF';
        PackingSlipFormat.AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template';
        
        insert PackingSlipFormat; 
        
        AcctSeedERP__Shipment__c shipment = new AcctSeedERP__Shipment__c();
        
        shipment.AcctSeedERP__Sales_Order__c = salesorderList[0].id;
        shipment.AcctSeedERP__Shipment_Date__c = Date.today();
        shipment.AcctSeedERP__Status__c = 'Scheduled';
        shipment.AcctSeedERP__Packing_Slip_Format__c = PackingSlipFormat.id;
        
        insert shipment;
        
        AcctSeedERP__Shipment_Line__c Lines = new AcctSeedERP__Shipment_Line__c();
        
        Lines.AcctSeedERP__Sales_Order_Line__c = solinesList[0].id;
        Lines.AcctSeedERP__Shipment__c = shipment.id;
        Lines.AcctSeedERP__Quantity_Shipped__c = 1;
        
        insert Lines;
        

    }
}
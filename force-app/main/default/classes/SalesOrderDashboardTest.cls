@isTest
public with sharing class SalesOrderDashboardTest {
    
    @TestSetup
    public static void makeData(){
        
        AcctSeed__Accounting_Variable__c accVar = new AcctSeed__Accounting_Variable__c();
      accVar.Name = 'Seawin USA';
      accVar.AcctSeed__Type__c = 'GL Account Variable 1';
      insert accVar;
  
      list<AcctSeed__GL_Account__c> glList = new List<AcctSeed__GL_Account__c>();
  
      AcctSeed__GL_Account__c gl = new AcctSeed__GL_Account__c();
  
      gl.name = 'GL Account First';
      gl.AcctSeed__type__c = 'Balance Sheet';
      gl.AcctSeed__Sub_Type_1__c = 'Liabilities';
      gl.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      gl.AcctSeed__Active__c = true;
      gl.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(gl);
  
      // ledger creation
      AcctSeed__GL_Account__c aegl = new AcctSeed__GL_Account__c();
      aegl.name = 'glaccount';
      aegl.AcctSeed__Type__c = 'Expense';
      aegl.AcctSeed__Sub_Type_1__c = 'Facilities';
      aegl.AcctSeed__Sub_Type_2__c = 'Rent';
      aegl.AcctSeed__Bank__c = true;
      aegl.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(aegl);
  
      AcctSeed__GL_Account__c vch = new AcctSeed__GL_Account__c();
      vch.name = '2010-Vouchers Payable';
      vch.AcctSeed__Type__c = 'Balance Sheet';
      vch.AcctSeed__Sub_Type_1__c = 'Liabilities';
      vch.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      vch.AcctSeed__Active__c = true;
      vch.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(vch);
  
      AcctSeed__GL_Account__c vch1 = new AcctSeed__GL_Account__c();
      vch1.name = '2010-Vouchers Payable1';
      vch1.AcctSeed__Type__c = 'Balance Sheet';
      vch1.AcctSeed__Sub_Type_1__c = 'Liabilities';
      vch1.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      vch1.AcctSeed__Active__c = true;
      vch1.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(vch1);
  
      AcctSeed__GL_Account__c vch2 = new AcctSeed__GL_Account__c();
      vch2.name = '2010-Vouchers Payable2';
      vch2.AcctSeed__Type__c = 'Balance Sheet';
      vch2.AcctSeed__Sub_Type_1__c = 'Liabilities';
      vch2.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      vch2.AcctSeed__Active__c = true;
      vch2.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(vch2);
  
      AcctSeed__GL_Account__c vch3 = new AcctSeed__GL_Account__c();
      vch3.name = '2010-Vouchers Payable3';
      vch3.AcctSeed__Type__c = 'Balance Sheet';
      vch3.AcctSeed__Sub_Type_1__c = 'Liabilities';
      vch3.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      vch3.AcctSeed__Active__c = true;
      vch3.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(vch3);
  
      AcctSeed__GL_Account__c gl1 = new AcctSeed__GL_Account__c();
      gl1.name = '2010-Vouchers Payable1';
      gl1.AcctSeed__Type__c = 'Balance Sheet';
      gl1.AcctSeed__Sub_Type_1__c = 'Liabilities';
      gl1.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      gl1.AcctSeed__Active__c = true;
      gl1.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(gl1);
  
      AcctSeed__GL_Account__c gl2 = new AcctSeed__GL_Account__c();
      gl2.name = '2010-Vouchers Payable2';
      gl2.AcctSeed__Type__c = 'Balance Sheet';
      gl2.AcctSeed__Sub_Type_1__c = 'Liabilities';
      gl2.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      gl2.AcctSeed__Active__c = true;
      gl2.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(gl2);
  
      AcctSeed__GL_Account__c gl3 = new AcctSeed__GL_Account__c();
      gl3.name = '2010-Vouchers Payable3';
      gl3.AcctSeed__Type__c = 'Balance Sheet';
      gl3.AcctSeed__Sub_Type_1__c = 'Liabilities';
      gl3.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      gl3.AcctSeed__Active__c = true;
      gl3.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(gl3);
  
      AcctSeed__GL_Account__c gl4 = new AcctSeed__GL_Account__c();
      gl4.name = '2010-Vouchers Payable4';
      gl4.AcctSeed__Type__c = 'Balance Sheet';
      gl4.AcctSeed__Sub_Type_1__c = 'Liabilities';
      gl4.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
      gl4.AcctSeed__Active__c = true;
      gl4.GL_Account_Variable_1__c = accVar.Id;
  
      glList.add(gl4);
  
      insert glList;
  
      // Accounting Period
      Date dt = date.today();
  
      AcctSeed__Accounting_Period__c ap = new AcctSeed__Accounting_Period__c();
      ap.name =
        dt.year() +
        '-' +
        ((dt.month() < 10) ? '0' + dt.month() : String.ValueOf(dt.month()));
      system.debug(
        dt.year() +
        '-' +
        ((dt.month() < 9) ? Integer.ValueOf('0' + dt.month()) : dt.month())
      );
      ap.AcctSeed__Start_Date__c = Date.today() - (dt.day() - 1);
      ap.AcctSeed__End_Date__c = Date.today() + 28;
      ap.AcctSeed__Status__c = 'Open';
      insert ap;
  
      // create account
      Account acct = new Account();
      //acct.Sales_Rep_O__c = sr.id;
      acct.Name = 'myAccount';
      acct.Type = 'Designer';
      acct.AcctSeed__Accounting_Type__c = 'Customer';
      acct.AcctSeed__GL_Account_Variable_1__c = accVar.Id;
      insert acct;
  
      Sales_Rep__c sr = new Sales_Rep__c();
  
      sr.name = 'Test Team';
      sr.Email__c = 'team@test.com';
      sr.Team__c = UserInfo.getUserId();
      sr.Price_Level_1_12__c = 1;
      sr.Price_Level_13_20__c = 1;
      sr.Price_Level_21_26__c = 1;
      sr.Price_Level_27_30__c = 1;
      sr.Man_Rep_Price_Level_1_12__c = 1;
      sr.Man_Rep_Price_Level_13_20__c = 1;
      sr.Man_Rep_Price_Level_21_26__c = 1;
      sr.Man_Rep_Price_Level_27_30__c = 1;
      sr.GL_Account_Variable_to_Sales_Rep__c = accVar.Id; 
  
      insert sr;
  
      // create account
      Account acct2 = new Account();
      acct2.Name = 'Manufacturer Representative';
      acct2.Sales_Rep_O__c = sr.id;
      acct2.Type = 'Designer';
      acct2.AcctSeed__Accounting_Type__c = 'Sales Represantative';
      acct2.AcctSeed__GL_Account_Variable_1__c = accVar.Id;
      acct2.Price_Level_1_12__c = 1;
      acct2.Price_Level_13_20__c = 1;
      acct2.Price_Level_21_26__c = 1;
      acct2.Price_Level_27_30__c = 1;
  
      insert acct2;
  
      // create contact
      Contact cont = new Contact();
      cont.LastName = 'myLastName';
      cont.AccountId = acct.Id;
      cont.LeadSource = 'AAOHA 2020';
      cont.GL_Account_Variable_1__c = accVar.Id;
      insert cont;
  
      AcctSeed__GL_Account__c glAccount2 = new AcctSeed__GL_Account__c();
      glAccount2.name = 'glaccount';
      glAccount2.AcctSeed__Type__c = 'Expense';
      glAccount2.AcctSeed__Sub_Type_1__c = 'Facilities';
      glAccount2.AcctSeed__Sub_Type_2__c = 'Rent';
      glAccount2.AcctSeed__Bank__c = false;
      glAccount2.GL_Account_Variable_1__c = accVar.Id;
      insert glAccount2;
  
      // create product
      Product2 prod = new Product2();
      prod.Name = 'myProduct';
      prod.ProductCode = 'ABC123';
      prod.AcctSeed__Unit_Cost__c = 100;
      prod.IsActive = true;
      prod.AcctSeed__Inventory_Type__c = 'Purchased';
      prod.AcctSeed__Expense_GL_Account__c = aegl.id;
      prod.AcctSeed__Inventory_GL_Account__c = aegl.id;
      prod.AcctSeed__Revenue_GL_Account__c = aegl.id;
  
      insert prod;
      // create opportunity
      Opportunity opp = new Opportunity();
  
      opp.Name = 'myOpportunity';
      //opp.Sales_Rep_O__c = sr.id;
      opp.AccountId = acct.Id;
      opp.Type = 'Actual Order';
      opp.StageName = 'Follow up';
      opp.CloseDate = system.today();
      opp.ContactPerson__c = cont.Id;
      opp.GL_Account_Variable_1__c = accVar.Id;
      opp.Run_Validation_Rule__c = true;
      insert opp;
  
      // insert to standard price book
      Id pricebookId = Test.getStandardPricebookId();
  
      // create standard price book entry
      PricebookEntry pricebentry = new PricebookEntry();
  
      pricebentry.Pricebook2Id = pricebookId;
      pricebentry.Product2Id = prod.Id;
      pricebentry.UnitPrice = 100;
      pricebentry.IsActive = true;
  
      insert pricebentry;
  
      // create opportunity line item
  
      OpportunityLineItem oli = new OpportunityLineItem();
  
      oli.OpportunityId = opp.Id;
      oli.Product2Id = prod.Id;
      oli.PricebookEntryId = pricebentry.Id;
      oli.Quantity = 10;
      oli.UnitPrice = 100;
      oli.Description = 'myDescription';
  
      insert oli;
  
      AcctSeed__Billing_Format__c abf = new AcctSeed__Billing_Format__c();
  
      abf.Name = 'newPDF Format';
      abf.AcctSeed__Type__c = 'Purchase Order';
      abf.AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStatementPDF';
      abf.AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template';
  
      insert abf;
  
      AcctSeed__Ledger__c ledger = new AcctSeed__Ledger__c();
  
      ledger.Name = 'myLedger';
      ledger.AcctSeed__Type__c = 'Transactional';
      ledger.AcctSeed__Billing_Activity_Statement_Format__c = abf.id;
      ledger.AcctSeed__Billing_Outstanding_Statement_Format__c = abf.id;
      ledger.AcctSeed__Default_Bank_Account__c = aegl.id;
      ledger.AcctSeed__Default_Billing_Format__c = abf.id;
      ledger.AcctSeed__Default_Purchase_Order_Format__c = abf.id;
      ledger.AcctSeed__Default_Packing_Slip_Format__c = abf.id;
  
      insert ledger;

      // GL Account
      AcctSeed__GL_Account__c expense = new AcctSeed__GL_Account__c();
      expense.Name = 'Expense GL Account';
      expense.AcctSeed__Active__c = true;
      expense.AcctSeed__Type__c = 'Expense';
      expense.AcctSeed__Sub_Type_1__c = 'Cost of Goods Sold';
      expense.AcctSeed__Sub_Type_2__c = 'Materials';
      expense.GL_Account_Variable_1__c = accVar.Id;
  
      insert expense;
  
      AcctSeed__GL_Account__c inventory = new AcctSeed__GL_Account__c();
      inventory.Name = 'Inventory GL Account';
      inventory.AcctSeed__Active__c = true;
      inventory.AcctSeed__Type__c = 'Balance Sheet';
      inventory.AcctSeed__Sub_Type_1__c = 'Assets';
      inventory.AcctSeed__Sub_Type_2__c = 'Current Assets';
      inventory.GL_Account_Variable_1__c = accVar.Id;
  
      insert inventory;
  
      AcctSeed__GL_Account__c revenue = new AcctSeed__GL_Account__c();
      revenue.Name = 'Revenue GL Account';
      revenue.AcctSeed__Active__c = true;
      revenue.AcctSeed__Type__c = 'Revenue';
      revenue.AcctSeed__Sub_Type_1__c = 'Product Revenue';
      revenue.AcctSeed__Sub_Type_2__c = null;
      revenue.GL_Account_Variable_1__c = accVar.Id;
  
      insert revenue;
  
      AcctSeed__Accounting_Settings__c custm = new AcctSeed__Accounting_Settings__c();
  
      custm.AcctSeed__Vouchers_Payable_GL_Account__c = glList[3].id;
      custm.AcctSeed__AP_Control_GL_Account__c = glList[6].id;
      custm.AcctSeed__AR_Control_GL_Account__c = glList[4].id;
      custm.AcctSeed__Current_Year_Earnings_GL_Account__c = glList[7].id;
      custm.AcctSeed__Default_Ledger__c = ledger.id;
      custm.AcctSeed__Retained_Earnings_GL_Account__c = glList[8].id;
      custm.AcctSeed__Revenue_GL_Account__c = glList[5].id;
      custm.AcctSeed__Unapplied_Cash_GL_Account__c = glList[9].id;
  
      insert custm;
  

      Id RecordTypeIdSO = Schema.SObjectType.AcctSeedERP__Sales_Order__c.getRecordTypeInfosByName()
        .get('Seawin USA Hospitality')
        .getRecordTypeId();
  
      // create a sales order
      AcctSeedERP__Sales_Order__c salesorder = new AcctSeedERP__Sales_Order__c();
  
      //salesorder.name = 'testSalesOrder';
      salesorder.RecordTypeId = RecordTypeIdSO;
      salesorder.AcctSeedERP__Customer__c = acct.Id;
      salesorder.AcctSeedERP__Opportunity__c = opp.Id;
      salesorder.Manufacturer_Rep__c = acct2.id;
      salesorder.Referral_Sales_Rep__c = UserInfo.getUserId();
      salesorder.Sales_Rep_O__c = sr.id;
      salesorder.Contact__c = cont.Id;
      salesorder.Price_Level__c = 'Level 3';
      salesorder.AcctSeedERP__Status__c = 'Open';
      salesorder.AcctSeedERP__Ledger__c = ledger.id;
      salesorder.GL_Account_Variable_1__c = accVar.Id;
      salesorder.Commission_Rate_Sales_Rep__c = 1;
      salesorder.Commission_Rate_Referral_Sales_Rep__c = 1;
      salesorder.Commission_Rate_Manufacturer_Rep__c = 1;
      insert salesorder;
  
      // create a sales order
      AcctSeedERP__Sales_Order_Line__c soline = new AcctSeedERP__Sales_Order_Line__c();
  
      soline.AcctSeedERP__Sales_Order__c = salesorder.id;
      soline.AcctSeedERP__Unit_Price__c = 100;
      soline.AcctSeedERP_Description__c = 'This is salesorder line item';
      soline.AcctSeedERP__Product__c = prod.id;
      soline.AcctSeedERP__Quantity_Ordered__c = 1;
  
      insert soline;
      AcctSeedERP__Sales_Order__c salesorder2 = new AcctSeedERP__Sales_Order__c();
  
      //salesorder.name = 'testSalesOrder';
      salesorder2.RecordTypeId = RecordTypeIdSO;
      salesorder2.AcctSeedERP__Customer__c = acct.Id;
      salesorder2.AcctSeedERP__Opportunity__c = opp.Id;
      salesorder2.Manufacturer_Rep__c = acct2.id;
      salesorder2.Referral_Sales_Rep__c = UserInfo.getUserId();
      salesorder2.Sales_Rep_O__c = sr.id;
      salesorder2.Contact__c = cont.Id;
      salesorder2.Price_Level__c = 'Level 3';
      salesorder2.AcctSeedERP__Status__c = 'Open';
      salesorder2.AcctSeedERP__Ledger__c = ledger.id;
      salesorder2.GL_Account_Variable_1__c = accVar.Id;
      salesorder2.Commission_Rate_Sales_Rep__c = 1;
      salesorder2.Commission_Rate_Referral_Sales_Rep__c = 1;
      salesorder2.Commission_Rate_Manufacturer_Rep__c = 1;
      insert salesorder2;

      delete salesorder2;
    }

    @IsTest
    public static void monthlysalesorderbatchTest(){
        List<AcctSeedERP__Sales_Order__c> k = [SELECT Id FROM AcctSeedERP__Sales_Order__c];
        system.debug(k.size());
        Test.startTest();
        
        MonthlySalesOrderBatch batch = new MonthlySalesOrderBatch();
        Database.executeBatch(batch, 1);
        Test.stopTest();
    }
    @IsTest
    public static void monthlysalesorderscheduleTest(){
        Test.startTest();

        SchedulableContext sc = null;
        MonthlySalesOrderSchedule dlc = new MonthlySalesOrderSchedule();
        dlc.execute(sc);

        Test.stopTest();
    }
}

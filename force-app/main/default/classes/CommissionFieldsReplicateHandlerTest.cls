@isTest
public class CommissionFieldsReplicateHandlerTest {
  @testSetup
  static void runTests() {

    AcctSeed__Accounting_Variable__c av = new AcctSeed__Accounting_Variable__c();

    av.Name = 'Seawin USA';
    av.AcctSeed__Type__c = 'GL Account Variable 1';
    insert av;

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
    sr.GL_Account_Variable_to_Sales_Rep__c = av.Id;

    insert sr;
      
    Sales_Rep__c sr2 = new Sales_Rep__c();

    sr2.name = 'Test Team 2';
    sr2.Email__c = 'team2@test.com';
    sr2.Team__c = UserInfo.getUserId();
    sr2.Price_Level_1_12__c = 1;
    sr2.Price_Level_13_20__c = 1;
    sr2.Price_Level_21_26__c = 1;
    sr2.Price_Level_27_30__c = 1;
    sr2.Man_Rep_Price_Level_1_12__c = 1;
    sr2.Man_Rep_Price_Level_13_20__c = 1;
    sr2.Man_Rep_Price_Level_21_26__c = 1;
    sr2.Man_Rep_Price_Level_27_30__c = 1;

    insert sr2;

    // create account
    Account acct = new Account();
    acct.Name = 'myAccount';
    acct.Type = 'Designer';
    acct.AcctSeed__Accounting_Type__c = 'Customer';
    acct.AcctSeed__GL_Account_Variable_1__c = av.Id;
    insert acct;
      
    Account acct2 = new Account();
    acct2.Name = 'myAccount2';
    acct2.Type = 'Designer';
    acct2.AcctSeed__Accounting_Type__c = 'Customer';
    acct2.AcctSeed__GL_Account_Variable_1__c = av.Id;
    insert acct2;

    AcctSeed__GL_Account__c gl = new AcctSeed__GL_Account__c();
    gl.name = 'GL Account First';
    gl.AcctSeed__type__c = 'Balance Sheet';
    gl.AcctSeed__Sub_Type_1__c = 'Liabilities';
    gl.AcctSeed__Sub_Type_2__c = 'Current Liabilities';
    gl.AcctSeed__Active__c = true;
    gl.AcctSeed__Bank__c = true;
    gl.GL_Account_Variable_1__c = av.Id;
    insert gl;

    AcctSeed__Billing_Format__c abf = new AcctSeed__Billing_Format__c();
    abf.Name = 'newPDF Format';
    abf.AcctSeed__Type__c = 'Purchase Order';
    abf.AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStatementPDF';
    abf.AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template';
    insert abf;

    AcctSeed__Ledger__c ledger = new AcctSeed__Ledger__c();
    ledger.Name = 'Actual';
    ledger.AcctSeed__Type__c = 'Transactional';
    ledger.AcctSeed__Billing_Activity_Statement_Format__c = abf.id;
    ledger.AcctSeed__Billing_Outstanding_Statement_Format__c = abf.id;
    ledger.AcctSeed__Default_Bank_Account__c = gl.id;
    ledger.AcctSeed__Default_Billing_Format__c = abf.id;
    ledger.AcctSeed__Default_Purchase_Order_Format__c = abf.id;
    ledger.AcctSeed__Default_Packing_Slip_Format__c = abf.id;
    insert ledger;

    Id RecordTypeIdSO = Schema.SObjectType.AcctSeedERP__Sales_Order__c.getRecordTypeInfosByName()
      .get('Seawin USA Hospitality')
      .getRecordTypeId();
      
    List<AcctSeedERP__Sales_Order__c> soList = new List<AcctSeedERP__Sales_Order__c>();  

    AcctSeedERP__Sales_Order__c so = new AcctSeedERP__Sales_Order__c();
    so.AcctSeedERP__Customer__c = acct.Id;
    so.Sales_Rep_O__c = sr.id;
    so.manufacturer_rep__c = acct.id;
    so.Referral_Sales_Rep__c = UserInfo.getUserId();
    so.AcctSeedERP__Status__c = 'Open';
    so.AcctSeedERP__Ledger__c = ledger.id;
    so.Stage__c = 'Production';
    so.RecordTypeId = RecordTypeIdSO;
    so.Price_Level__c = 'Level 3';
    so.GL_Account_Variable_1__c = av.Id;
      
    soList.add(so);
      
    AcctSeedERP__Sales_Order__c so2 = new AcctSeedERP__Sales_Order__c();
    so2.AcctSeedERP__Customer__c = acct.Id;
    so2.Sales_Rep_O__c = sr.id;
    so2.manufacturer_rep__c = acct.id;
    so2.Referral_Sales_Rep__c = UserInfo.getUserId();
    so2.AcctSeedERP__Status__c = 'Open';
    so2.AcctSeedERP__Ledger__c = ledger.id;
    so2.Stage__c = 'Production';
    so2.RecordTypeId = RecordTypeIdSO;
    so2.Price_Level__c = 'Level 15';
    so2.GL_Account_Variable_1__c = av.Id;
      
    soList.add(so2);
      
    AcctSeedERP__Sales_Order__c so3 = new AcctSeedERP__Sales_Order__c();
    so3.AcctSeedERP__Customer__c = acct.Id;
    so3.Sales_Rep_O__c = sr.id;
    so3.manufacturer_rep__c = acct.id;
    so3.Referral_Sales_Rep__c = UserInfo.getUserId();
    so3.AcctSeedERP__Status__c = 'Open';
    so3.AcctSeedERP__Ledger__c = ledger.id;
    so3.Stage__c = 'Production';
    so3.RecordTypeId = RecordTypeIdSO;
    so3.Price_Level__c = 'Level 24';
    so3.GL_Account_Variable_1__c = av.Id;
      
    soList.add(so3);
      
    AcctSeedERP__Sales_Order__c so4 = new AcctSeedERP__Sales_Order__c();
    so4.AcctSeedERP__Customer__c = acct.Id;
    so4.Sales_Rep_O__c = sr.id;
    //so4.manufacturer_rep__c = acct.id;
    so4.Referral_Sales_Rep__c = UserInfo.getUserId();
    so4.AcctSeedERP__Status__c = 'Open';
    so4.AcctSeedERP__Ledger__c = ledger.id;
    so4.Stage__c = 'Production';
    so4.RecordTypeId = RecordTypeIdSO;
    so4.Price_Level__c = 'Level 27';
    so4.GL_Account_Variable_1__c = av.Id;
      
    soList.add(so4);
      
    insert soList;
      
    so.sales_rep_o__c = sr2.id;
    so.Referral_Sales_Rep__c = UserInfo.getUserId();
    so.manufacturer_rep__c = acct2.id;
    so.specified_rep__c = acct2.id;
      
    Update so;
  }

  @isTest
  static void StartTest() {

  }
}
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
    sr.Team__c = String.valueOf(UserInfo.getUserId());
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
    sr2.Team__c = String.valueOf(UserInfo.getUserId());
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
    AcctSeed__Accounting_Variable__c accVar = new AcctSeed__Accounting_Variable__c();
    accVar.Name = 'Seawin USA';
    accVar.AcctSeed__Type__c = 'GL Account Variable 1';
    insert accVar;
    
    // create account
    Account acct = new Account();
    acct.Name = 'myAccount';
    acct.Type = 'Designer';
    acct.AcctSeed__Accounting_Type__c = 'Customer';
    acct.AcctSeed__GL_Account_Variable_1__c = accVar.Id;
    insert acct;
      
    AcctSeed__GL_Account__c expenceAcc = new AcctSeed__GL_Account__c();
    expenceAcc.name = 'glaccount';
    expenceAcc.AcctSeed__Type__c = 'Expense';
    expenceAcc.AcctSeed__Sub_Type_1__c = 'Facilities';
    expenceAcc.AcctSeed__Sub_Type_2__c = 'Rent';
    expenceAcc.AcctSeed__Bank__c = true;
    expenceAcc.GL_Account_Variable_1__c = accVar.id;
    

    insert expenceAcc;

    Account acct2 = new Account();
    acct2.Name = 'myAccount2';
    acct2.Type = 'Designer';
    acct2.AcctSeed__Accounting_Type__c = 'Manufacture Representative';
    acct2.AcctSeed__GL_Account_Variable_1__c = accVar.Id;
    acct2.AcctSeed__Default_Expense_GL_Account__c = expenceAcc.Id;
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
    so.GL_Account_Variable_1__c = accVar.Id;
      
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
    so2.GL_Account_Variable_1__c = accVar.Id;
      
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
    so3.GL_Account_Variable_1__c = accVar.Id;
      
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
    so4.GL_Account_Variable_1__c = accVar.Id;
      
    soList.add(so4);
      
    insert soList;
      
    so.sales_rep_o__c = sr2.id;
    so.Referral_Sales_Rep__c = UserInfo.getUserId();
    so.manufacturer_rep__c = acct2.id;
    so.specified_rep__c = acct2.id;
      
    Update so;

    Contact cont = new Contact();
    cont.LastName = 'myLastName';
    cont.AccountId = acct.Id;
    cont.GL_Account_Variable_1__c = accVar.Id;
    insert cont;

    Id RecordTypeIdOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Seawin USA Hospitality').getRecordTypeId();

    sales_rep__c salesrep = new sales_rep__c();
    salesrep.User__c = Userinfo.getUserId();
    salesrep.Active__c = 'Yes';
    salesrep.Name = 'New User';
    salesrep.Price_Level_1_12__c = 1;
    salesrep.Price_Level_13_20__c = 2;
    salesrep.Price_Level_21_26__c = 3;
    salesrep.Price_Level_27_30__c = 4;
    insert salesrep;

    AcctSeed__GL_Account__c aegl = new AcctSeed__GL_Account__c();
    aegl.name = 'glaccount';
    aegl.AcctSeed__Type__c = 'Expense';
    aegl.AcctSeed__Sub_Type_1__c = 'Facilities';
    aegl.AcctSeed__Sub_Type_2__c = 'Rent';
    aegl.AcctSeed__Bank__c = true;
    aegl.GL_Account_Variable_1__c = accVar.id;
    insert aegl;


    Account man_rep_acc = new Account(name='myAccount2', AcctSeed__GL_Account_Variable_1__c=accVar.id,
    Price_Level__c='Level 3',AcctSeed__Billing_Terms_Name__c='New Billing Term Name',
    Deposit__c='30',
    AcctSeed__Billing_Days_Due__c=15,
    AcctSeed__Billing_Format__c=abf.id,
    AcctSeed__Accounting_Type__c='Manufacture Representative', 
    Price_Level_1_12__c = 12, 
    Price_Level_13_20__c = 12,
    Price_Level_21_26__c = 12,
    Price_Level_27_30__c=22,
    AcctSeed__Default_Expense_GL_Account__c = aegl.id);

    insert man_rep_acc;

    Account man_rep_acc_new = new Account(name='myAccount44', AcctSeed__GL_Account_Variable_1__c=accVar.id,
    Price_Level__c='Level 3',AcctSeed__Billing_Terms_Name__c='New Billing Term Name',
    Deposit__c='30',
    AcctSeed__Billing_Days_Due__c=15,
    AcctSeed__Billing_Format__c=abf.id,
    AcctSeed__Accounting_Type__c='Manufacture Representative', 
    Price_Level_1_12__c = 12, 
    Price_Level_13_20__c = 12,
    Price_Level_21_26__c = 12,
    Price_Level_27_30__c=22,
    AcctSeed__Default_Expense_GL_Account__c = aegl.id);

    insert man_rep_acc_new;

    Opportunity opp = new Opportunity();
    opp.Name = 'myOpportunity44';
    opp.AccountId = acct.Id;
    opp.Type = 'Actual Order';
    opp.StageName = 'Closed Won';
    opp.CloseDate = system.today();
    opp.ContactPerson__c = cont.Id;
    opp.GL_Account_Variable_1__c = accVar.id;
    opp.RecordTypeId = RecordTypeIdOpportunity;
    opp.Sales_Rep_O__c = salesrep.id;
    opp.Manufacturer_Rep__c = man_rep_acc.id;
    opp.Price_Level__c = 'Level 2';
    insert opp;


  }

  @isTest
  static void StartTest() {
    List<AcctSeedERP__Sales_Order__c> so = [SELECT
                                                    id,
                                                    Commission_Rate_Sales_Rep__c,
                                                    commission_rate_manufacturer_rep__c,
                                                    commission_rate_referral_sales_rep__c,
                                                    commission_rate_specified_rep__c,
                                                    referral_sales_rep__c,
                                                    Manufacturer_Rep__c,
                                                    Specified_Rep__c,
                                                    Price_Level__c,

                                                    Manufacturer_Rep__r.Price_Level_1_12__c,
                                                    Manufacturer_Rep__r.Price_Level_13_20__c,
                                                    Manufacturer_Rep__r.Price_Level_21_26__c,
                                                    Manufacturer_Rep__r.Price_Level_27_30__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_1_12__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_13_20__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_21_26__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_27_30__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_1_12__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_13_20__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_21_26__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_27_30__c,

                                                    Specified_Rep__r.Price_Level_1_12__c,
                                                    Specified_Rep__r.Price_Level_13_20__c,
                                                    Specified_Rep__r.Price_Level_21_26__c,
                                                    Specified_Rep__r.Price_Level_27_30__c,
                                                    Specified_Rep__r.Referral_Price_Level_1_12__c,
                                                    Specified_Rep__r.Referral_Price_Level_13_20__c,
                                                    Specified_Rep__r.Referral_Price_Level_21_26__c,
                                                    Specified_Rep__r.Referral_Price_Level_27_30__c,
                                                    Specified_Rep__r.Specified_Price_Level_1_12__c,
                                                    Specified_Rep__r.Specified_Price_Level_13_20__c,
                                                    Specified_Rep__r.Specified_Price_Level_21_26__c,
                                                    Specified_Rep__r.Specified_Price_Level_27_30__c,

                                                    Sales_Rep_O__r.Price_Level_1_12__c,
                                                    Sales_Rep_O__r.Price_Level_13_20__c,
                                                    Sales_Rep_O__r.Price_Level_21_26__c,
                                                    Sales_Rep_O__r.Price_Level_27_30__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_1_12__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_13_20__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_21_26__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_27_30__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_1_12__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_13_20__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_21_26__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_27_30__c
                                                    FROM AcctSeedERP__Sales_Order__c];
  List<Opportunity> opp = [SELECT Id,
                                                    Run_Validation_Rule__c,
                                                    Commission_Rate_Manufacturer_Rep__c,
                                                    Commission_Rate_Referral_Sales_Rep__c,
                                                    Commission_Rate_Sales_Rep__c,
                                                    Commission_Rate_Specified_Rep__c,
                                                    Manufacturer_Rep__c,
                                                    Specified_Rep__c,
                                                    Sales_Rep_O__c,
                                                    Referral_Sales_Rep__c,
                                                    Price_Level__c,
                
                                                    Manufacturer_Rep__r.Price_Level_1_12__c,
                                                    Manufacturer_Rep__r.Price_Level_13_20__c,
                                                    Manufacturer_Rep__r.Price_Level_21_26__c,
                                                    Manufacturer_Rep__r.Price_Level_27_30__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_1_12__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_13_20__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_21_26__c,
                                                    Manufacturer_Rep__r.Referral_Price_Level_27_30__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_1_12__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_13_20__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_21_26__c,
                                                    Manufacturer_Rep__r.Specified_Price_Level_27_30__c,
                                          
                                                    Specified_Rep__r.Price_Level_1_12__c,
                                                    Specified_Rep__r.Price_Level_13_20__c,
                                                    Specified_Rep__r.Price_Level_21_26__c,
                                                    Specified_Rep__r.Price_Level_27_30__c,
                                                    Specified_Rep__r.Referral_Price_Level_1_12__c,
                                                    Specified_Rep__r.Referral_Price_Level_13_20__c,
                                                    Specified_Rep__r.Referral_Price_Level_21_26__c,
                                                    Specified_Rep__r.Referral_Price_Level_27_30__c,
                                                    Specified_Rep__r.Specified_Price_Level_1_12__c,
                                                    Specified_Rep__r.Specified_Price_Level_13_20__c,
                                                    Specified_Rep__r.Specified_Price_Level_21_26__c,
                                                    Specified_Rep__r.Specified_Price_Level_27_30__c,
                                          
                                                    Sales_Rep_O__r.Price_Level_1_12__c,
                                                    Sales_Rep_O__r.Price_Level_13_20__c,
                                                    Sales_Rep_O__r.Price_Level_21_26__c,
                                                    Sales_Rep_O__r.Price_Level_27_30__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_1_12__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_13_20__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_21_26__c,
                                                    Sales_Rep_O__r.Man_Rep_Price_Level_27_30__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_1_12__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_13_20__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_21_26__c,
                                                    referral_sales_rep__r.Ref_Rep_Price_Level_27_30__c
                                              FROM Opportunity];
                                              

    CommissionFieldsReplicateHandler.Replicate(so);
    CommissionFieldsReplicateHandler.ReplicateOpportunities(opp);
    CommissionFieldsReplicateHandler.Assign_ManufacturerRep_Commission(so[0], 27);
    CommissionFieldsReplicateHandler.Assign_SpecifiedRep_Commission(so[0], 27);
    CommissionFieldsReplicateHandler.Assign_SalesRep_Commission_Opportunity(opp[0], 27, true);
    CommissionFieldsReplicateHandler.Assign_ManufacturerRep_Commission_Opportunity(opp[0], 27);
    CommissionFieldsReplicateHandler.Assign_SpecifiedRep_Commission_Opportunity(opp[0], 27);
    CommissionFieldsReplicateHandler.Assign_ReferralRep_Commission_Opportunity(opp[0], 27);

    Opportunity opport = [SELECT  Id, 
                                  Manufacturer_Rep__c,
                                  Specified_Rep__c,
                                  Sales_Rep_O__c,
                                  Referral_Sales_Rep__c
                          FROM Opportunity WHERE Name='myOpportunity44' LIMIT 1];

    Account acc = [SELECT Id FROM Account WHERE Name='myAccount44' LIMIT 1];
    opport.Manufacturer_Rep__c = acc.Id;
    opport.Specified_Rep__c = acc.Id;
    update opport;

  }
}
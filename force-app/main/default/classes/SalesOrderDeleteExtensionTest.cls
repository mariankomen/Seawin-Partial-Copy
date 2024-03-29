@isTest
public class SalesOrderDeleteExtensionTest {

    @testSetup static void createData(){
    
        AcctSeed__Accounting_Variable__c av = new AcctSeed__Accounting_Variable__c();
        av.Name = 'GL acc var1';
        av.AcctSeed__Type__c = 'GL Account Variable 1';
        insert av;
        
        AcctSeed__Billing_Format__c abf = new AcctSeed__Billing_Format__c();
        abf.Name = 'newPDF Format';
        abf.AcctSeed__Type__c = 'Purchase Order';
        abf.AcctSeed__Visualforce_PDF_Page__c = 'BillingActivityStatementPDF';
        abf.AcctSeed__Default_Email_Template__c = 'Activity_Statement_Email_Template';
        insert abf;
        
        AcctSeed__GL_Account__c aegl = new AcctSeed__GL_Account__c();
        aegl.name = 'glaccount';
        aegl.AcctSeed__Type__c = 'Expense';
        aegl.AcctSeed__Sub_Type_1__c = 'Facilities';
        aegl.AcctSeed__Sub_Type_2__c = 'Rent';
        aegl.AcctSeed__Bank__c = true;
        aegl.GL_Account_Variable_1__c = av.Id;
        insert aegl;
        
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
        
         // create a sales order
        AcctSeedERP__Sales_Order__c salesorder = new AcctSeedERP__Sales_Order__c(); 
        //salesorder.name = 'testSalesOrder';
        //salesorder.AcctSeedERP__Customer__c = acct.Id;
        //salesorder.Contact__c = cont.Id;
        salesorder.AcctSeedERP__Status__c = 'Open';
       	salesorder.AcctSeedERP__Ledger__c = ledger.id;
        salesorder.GL_Account_Variable_1__c = av.Id;
        insert salesorder;
        
        
        
    }
    
    @isTest static void StartProcess(){
        
        //Account acc = [select id from Account where name = 'myAccount' limit 1];
        
        AcctSeedERP__Sales_Order__c so = [select id from AcctSeedERP__Sales_Order__c limit 1];
        
        Test.startTest();
         
        ApexPages.currentPage().getParameters().put('id', so.id);
        ApexPages.StandardController std = new ApexPages.StandardController(so);
        
        ApexPages.currentPage().getParameters().put('retURL', '/' + so.id);
        SalesOrderDeleteExtension NoObject = new SalesOrderDeleteExtension(std);
        
        ApexPages.currentPage().getParameters().put('retURL', '/a1H/o');
        SalesOrderDeleteExtension ListView = new SalesOrderDeleteExtension(std);
        
        ApexPages.currentPage().getParameters().put('retURL', 'OpportunityPage');
        SalesOrderDeleteExtension OpportunityObject = new SalesOrderDeleteExtension(std);
        
        ApexPages.currentPage().getParameters().put('retURL', 'AccountPage');
        SalesOrderDeleteExtension AccountObject = new SalesOrderDeleteExtension(std);
        
        ListView.DeleteProcess();
        ListView.back();
        
        Test.stopTest();
        
    }
}
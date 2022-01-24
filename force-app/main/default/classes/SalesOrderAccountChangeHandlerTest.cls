@isTest
public class SalesOrderAccountChangeHandlerTest {
    
    @testSetup static void createData(){
        TestUtility.CreateData();
    }
    
    @isTest static void SalesOrderAccountChange(){
        Account acct2 = [select id from account where name ='myAccount2' limit 1];
        Opportunity opp = [select id from opportunity where name='myOpportunity' limit 1];
        acctseederp__sales_order__c so = null;
         so = [select id,contact__c,acctseederp__customer__c, 
                                          Sales_Order_Format__r.AcctSeed__Default_Email_Template__c  
                                          from acctseederp__sales_order__c                                          
                                          where acctseederp__opportunity__c =:opp.id limit 1];
        
        so.AcctSeedERP__Customer__c = acct2.id;
        
        update so;

    }
}
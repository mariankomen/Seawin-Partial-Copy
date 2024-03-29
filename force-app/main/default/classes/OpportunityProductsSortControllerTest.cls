@isTest
public with sharing class OpportunityProductsSortControllerTest {
    
    @TestSetup
    static void makeData(){
        Profile pf = [Select Id from profile where Name = 'System Administrator']; 
        // Profile pf = [Select Id from profile where Name = 'Sales Rep'];
         
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName = orgId + dateString + RandomId; 
        
        User uu1 = new User(firstname = 'ABC', 
                             lastName = 'XYZ', 
                             email = uniqueName + '@test' + orgId + '.org', 
                             Username = uniqueName + '@test' + orgId + '.org', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             Alias = uniqueName.substring(18, 23), 
                             TimeZoneSidKey = 'America/Los_Angeles', 
                             LocaleSidKey = 'en_US', 
                             LanguageLocaleKey = 'en_US', 
                             ProfileId = pf.Id
                            ); 

        insert uu1;
        
        Sales_rep__c sr = new Sales_rep__c();
        sr.Active__c = 'Yes';
        sr.Name = 'John Doe';
        sr.User__c = uu1.id;
        sr.Team__c = ''+uu1.id;
        insert sr;
        
        uu1.Sales_Rep_Id__c = sr.id;
        
        update uu1;
        
        // create account
        Account acct = new Account();
        
        acct.Sales_Rep_O__c = sr.id;
        acct.Name = 'myAccount';
        acct.Type = 'Customer';
        
        insert acct;
		
        // create contact
        Contact cont = new Contact();
        
        cont.LastName = 'myLastName';
        cont.AccountId = acct.Id;
        
        insert cont;
        
        list<AcctSeed__Accounting_Variable__c> avList = new list<AcctSeed__Accounting_Variable__c>();
        
    	avList.add(new AcctSeed__Accounting_Variable__c(Name = 'Seawin China',AcctSeed__Type__c = 'GL Account Variable 1'));
        
        avList.add(new AcctSeed__Accounting_Variable__c(Name = 'Seawin USA',AcctSeed__Type__c = 'GL Account Variable 1'));
        insert avList;

        AcctSeed__GL_Account__c aegl = new AcctSeed__GL_Account__c();
        aegl.name = 'glaccount';
        aegl.AcctSeed__Type__c = 'Expense';
        aegl.AcctSeed__Sub_Type_1__c = 'Facilities';
        aegl.AcctSeed__Sub_Type_2__c = 'Rent';
        aegl.AcctSeed__Bank__c = true;
        aegl.GL_Account_Variable_1__c = avList[1].Id;
        
        insert aegl;
        
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
        opp.Sales_Rep_O__c = sr.id;
        opp.AccountId = acct.Id;
        opp.Type = 'Actual Order';
        opp.StageName = 'Follow up';
        opp.CloseDate = system.today();
        opp.ContactPerson__c = cont.Id;
        opp.GL_Account_Variable_1__c = avList[1].Id;
        opp.Sales_Rep_O__c = sr.Id;
        insert opp;
        
        // create pricebook2
        Pricebook2 priceb2 = new Pricebook2();
        
        priceb2.Name = 'myPriceBook';
        priceb2.Description = 'myPBDescription';
        priceb2.IsActive = true;
        //priceb2.IsStandard = true;
        
        insert priceb2;
        
        // insert to standard price book
        Id pricebookId = Test.getStandardPricebookId();
        
        // create standard price book entry
        PricebookEntry pricebentry1 = new PricebookEntry();
        
        pricebentry1.Pricebook2Id = pricebookId;
  		pricebentry1.Product2Id = prod.Id;
        pricebentry1.UnitPrice = 100;
        pricebentry1.IsActive = true;
        
        insert pricebentry1;
        
        // create pricebookentry
        PricebookEntry pricebentry2 = new PricebookEntry();
        
        pricebentry2.Pricebook2Id = priceb2.Id;
  		pricebentry2.Product2Id = prod.Id;
        pricebentry2.UnitPrice = 100;
        pricebentry2.IsActive = true;
        
        insert pricebentry2;
        
        // create opportunity line item
        
        OpportunityLineItem oli = new OpportunityLineItem();
        
        oli.OpportunityId = opp.Id;
        oli.Product2Id = prod.Id;
        oli.PricebookEntryId = pricebentry2.Id;
        oli.Quantity = 10;
        oli.UnitPrice = 100;
        oli.Description = 'myDescription';
        
        insert oli;

        Optional_Products_Opportunity__c opop = new Optional_Products_Opportunity__c();
        
        opop.Description__c = oli.Description;
        opop.UnitPrice__c = oli.UnitPrice;
        opop.Product__c = oli.Product2Id;
        opop.Opportunity__c = oli.OpportunityId;
        opop.PriceBookEntryId__c = oli.PricebookEntryId;
        opop.Quantity__c = 1;
        
        insert opop;
    }

    @IsTest
    public static void sortTest(){
        Opportunity opp = [select id from opportunity where name='myOpportunity' limit 1];
        
        // get the sales order lines list
        list<Optional_Products_Opportunity__c> opoplines = new list<Optional_Products_Opportunity__c>([select id 
                                                    from Optional_Products_Opportunity__c 
                                                    where opportunity__c =: opp.id]);
        Test.startTest();
        PageReference pageRef = Page.OpportunityProductsSortPage;
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('oppId', opp.id);
        ApexPages.currentPage().getParameters().put('recordType', 'oli');

        OpportunityProductsSortController opsl = new OpportunityProductsSortController();
        
        ApexPages.currentPage().getParameters().put('sortstring', '[{"'+opoplines[0].id+'": 1}]');
        

        OpportunityProductsSortController bso = new OpportunityProductsSortController();
        OpportunityProductsSortController.executeSorting('[{"solId": "'+opoplines[0].Id+'","sortNumber": 1}]',String.valueOf(opp.Id), 'oli');
        // bso.createsort();
        bso.back();
        // BillingLineSortOrderExtension.saveSorting('[{"solId": "'+opoplines[0].Id+'","sortNumber": 1}]',String.valueOf(opp.Id), 'oli');
        OpportunityProductsSortController.SortingWrapper sortWrapper = new OpportunityProductsSortController.SortingWrapper(opoplines[0].id, 1);
        Test.stopTest();
    }

    @isTest
    public static void sortOPOTest(){
        Opportunity opp = [select id from opportunity where name='myOpportunity' limit 1];
        
        // get the sales order lines list
        list<Optional_Products_Opportunity__c> opoplines = new list<Optional_Products_Opportunity__c>([select id 
                                                    from Optional_Products_Opportunity__c 
                                                    where opportunity__c =: opp.id]);
        Test.startTest();
        PageReference pageRef = Page.OpportunityProductsSortPage;
        Test.setCurrentPage(pageRef);
		
        ApexPages.currentPage().getParameters().put('oppId', opp.id);
        ApexPages.currentPage().getParameters().put('recordType', 'opo');

        OpportunityProductsSortController opsl = new OpportunityProductsSortController();
        
        ApexPages.currentPage().getParameters().put('sortstring', '[{"'+opoplines[0].id+'": 1}]');
        

        OpportunityProductsSortController bso = new OpportunityProductsSortController();
        
        // bso.createsort();
        bso.back();
        OpportunityProductsSortController.executeSorting('[{"solId": "'+opoplines[0].Id+'","sortNumber": 1}]',String.valueOf(opp.Id), 'opo');
        OpportunityProductsSortController.SortingWrapper sortWrapper = new OpportunityProductsSortController.SortingWrapper(opoplines[0].id, 1);
        Test.stopTest();
    }

}

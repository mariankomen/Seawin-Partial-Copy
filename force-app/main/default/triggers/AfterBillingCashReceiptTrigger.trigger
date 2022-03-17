trigger AfterBillingCashReceiptTrigger on AcctSeed__Billing_Cash_Receipt__c (after insert, before delete, after delete) {
    
    if(Trigger.IsAfter && Trigger.IsInsert){

        CalculateCommissionsHandler.Start(Trigger.new);
    }else if(Trigger.IsBefore && Trigger.IsDelete){

        CalculateCommissionsHandler.DeleteCommissions(Trigger.oldMap.keySet(), false); // false says its not a billing credit memo

        
        
    } else if(Trigger.IsAfter && Trigger.IsDelete){
        system.debug('Trigger.old[0].Id: '+Trigger.old[0].Id);

        //AcctSeed__Billing_Cash_Receipt__c bcr = [SELECT Id, AcctSeed__Billing__c, AcctSeed__Cash_Receipt__c FROM AcctSeed__Billing_Cash_Receipt__c WHERE Id=:Trigger.old[0].Id];
        // List<AcctSeed__Cash_Receipt__c> c = [SELECT Id, AcctSeed__Status__c FROM AcctSeed__Cash_Receipt__c WHERE Id=:Trigger.old[0].AcctSeed__Cash_Receipt__c];

        // AcctSeed.PostResult[] unpostResults = AcctSeed.CashReceiptPostService.unpostCashReceipts(c);

        // List<AcctSeed__Billing_Cash_Receipt__c> bl = [SELECT Id, AcctSeed__Cash_Receipt__c FROM AcctSeed__Billing_Cash_Receipt__c WHERE AcctSeed__Cash_Receipt__c=:Trigger.old[0].AcctSeed__Cash_Receipt__c];
        // List<AcctSeed__Billing_Cash_Receipt__c> china = [SELECT Id FROM AcctSeed__Billing_Cash_Receipt__c WHERE AcctSeed__Cash_Receipt__c =:Trigger.old[0].AcctSeed__Cash_Receipt__c ];
        // delete china;

        // delete c;
        
    }
}
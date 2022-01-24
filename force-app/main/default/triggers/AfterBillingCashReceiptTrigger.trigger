trigger AfterBillingCashReceiptTrigger on AcctSeed__Billing_Cash_Receipt__c (after insert, before delete) {
    
    if(Trigger.IsAfter && Trigger.IsInsert){

        CalculateCommissionsHandler.Start(Trigger.new);
    }else if(Trigger.IsBefore && Trigger.IsDelete){

        CalculateCommissionsHandler.DeleteCommissions(Trigger.oldMap.keySet(), false); // false says its not a billing credit memo
    }
}
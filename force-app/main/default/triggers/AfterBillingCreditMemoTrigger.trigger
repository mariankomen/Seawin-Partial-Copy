trigger AfterBillingCreditMemoTrigger on AcctSeed__Billing_Credit_Memo__c (after insert, before delete) {
    if(Trigger.IsAfter && Trigger.IsInsert){

        CalculateCommissionsHandler.Start(Trigger.new);
    }else if(Trigger.IsBefore && Trigger.IsDelete){

        CalculateCommissionsHandler.DeleteCommissions(Trigger.oldMap.keySet(), true); // true says its a billing credit memo
    }
}
trigger AfterBillingCashReceiptTrigger on AcctSeed__Billing_Cash_Receipt__c (after insert, before delete, after delete) {
    
    if(Trigger.IsAfter && Trigger.IsInsert){

        CalculateCommissionsHandler.Start(Trigger.new);
    }else if(Trigger.IsBefore && Trigger.IsDelete){

        CalculateCommissionsHandler.DeleteCommissions(Trigger.oldMap.keySet(), false); // false says its not a billing credit memo

        
        
    } else if(Trigger.IsAfter && Trigger.IsDelete){
        Set<Id> cash_rec_ids = new Set<Id>();

        for(AcctSeed__Billing_Cash_Receipt__c cr: Trigger.old){
            cash_rec_ids.add(cr.AcctSeed__Cash_Receipt__c);
        }

        AfterBillingCashReceiptExtension.unpostRelatedCashReceipts(cash_rec_ids);
        
    }
}
trigger BillingLineResortTrigger on AcctSeed__Billing_Line__c (after insert, after delete, after undelete) {
   
    if(Trigger.IsAfter){
        if(Trigger.IsInsert || Trigger.IsUndelete){
            
            billinglineResortHandler.reSort(Trigger.new);
        }else if(Trigger.IsDelete){
            
            billinglineResortHandler.reSort(Trigger.old);
        }
    }    
}
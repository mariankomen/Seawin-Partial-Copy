trigger RollupBillingReceivedOpptyTrigger on AcctSeed__Billing__c (after insert, after update) {
    
    if(trigger.IsAfter){
        if(Trigger.IsInsert || Trigger.IsUpdate){
            
            //if(!Test.isRunningTest()){
                RollupBillingReceivedOpptyHandler.rollup(Trigger.new);
            //}
            
        }
    }

}
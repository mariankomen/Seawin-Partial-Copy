trigger RollupPayablePaidPOTrigger on AcctSeed__Account_Payable__c (after insert, after update) {
	if(trigger.IsAfter){
        if(Trigger.IsInsert || Trigger.IsUpdate){
            RollupPayablePaidPOHandler.rollup(Trigger.new);
            
        }
    }
}
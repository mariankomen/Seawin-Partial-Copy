trigger OpportunityTrigger on Opportunity (before insert, before update) {

    boolean duplicateCheck = (Test.isRunningTest()) ? true : OpportunityTrigger__c.getValues('Opportunity Duplicate Check Rule').Active__c;
    if(duplicateCheck){
        //Commented below code because it generated error of duplicate opportunity on some cases. 
        //e.g If a duplicate opportunity create "test dup opp" by marking the "allow duplicate opportunity" checkbox
        //So, issue arises because now we have 2 opportunites with one has  "allow duplicate opportunity" checkbox marked while other has not.
        //In case of any issue reported by client we will discuss and implement the solution accordingly, In real scenario this is not a case 
        //that will arise much as, user not frequently change the opportunity name.
        //if(trigger.IsInsert || trigger.IsUpdate){
        if(trigger.IsInsert){
            OpportunityHandler.checkDuplicate(Trigger.new);
        }
    }
}
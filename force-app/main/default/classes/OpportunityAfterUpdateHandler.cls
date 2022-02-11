public with sharing class OpportunityAfterUpdateHandler {

    public static void checkAccountChanging(List<Opportunity> oldOppList, List<Opportunity> newOppList){
        Opportunity oldOpp = oldOppList[0];
        Opportunity newOpp = newOppList[0];

        system.debug('OLD SYDA: '+JSON.serialize(oldOppList));
        system.debug('NEW SYDA: '+JSON.serialize(newOppList));
    }   
}

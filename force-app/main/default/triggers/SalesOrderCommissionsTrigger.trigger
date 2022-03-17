trigger SalesOrderCommissionsTrigger on Sales_Order_Commissions__c (before insert) {

    //system.debug('test chinazka: '+JSON.serialize(Trigger.new));
}
trigger SalesOrderLineInfoTrigger on AcctSeedERP__Sales_Order_Line__c (before insert) {
    
    if(Trigger.IsBefore && Trigger.IsInsert){
        
        SalesOrderLineInfoHandler.UpdateInfo(Trigger.new);
        
    }

}
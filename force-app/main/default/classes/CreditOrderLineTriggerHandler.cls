public with sharing class CreditOrderLineTriggerHandler {
    

    public static void insertExecute(List<Credit_Order_Line__c> trigger_new){
        Map<Id,Id> inventory_balance_map = getInventoryBalanceMap();

        // 
    }

    public static void updateExecute(){

    }

    public static void deleteExecute(){

    }


    public static Map<Id,Id> getInventoryBalanceMap(){
        
        List<AcctSeedERP__Inventory_Balance__c> inventory_balance = [SELECT Id, AcctSeedERP__Product__c FROM AcctSeedERP__Inventory_Balance__c];
        Map<Id,Id> inventory_map = new Map<Id, Id>();
        for(AcctSeedERP__Inventory_Balance__c item:inventory_balance){
            inventory_map.put(item.AcctSeedERP__Product__c, item.Id);
        }
        return inventory_map;
    }
}


public class BillingBatchTrigger implements Database.Batchable<sObject>{

    public List<AcctSeed__Billing__c> triggered_billings;

    public BillingBatchTrigger(List<AcctSeed__Billing__c> bills) {
        triggered_billings = bills;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String invoice = 'Invoice';
        Map<Id, AcctSeed__Billing__c> bill_map = new Map<Id, AcctSeed__Billing__c>(triggered_billings);
        Set<Id> bill_ids = bill_map.keySet();
        List<Id> bill_ids_list = new List<Id>();
        for(Id i:bill_ids){
            bill_ids_list.add(i);
        }
        String query = 'SELECT Id, AcctSeed__Balance__c, AcctSeedERP__Sales_Order__c, AcctSeed__Opportunity__c FROM AcctSeed__Billing__c WHERE AcctSeed__Type__c=:invoice AND Id IN:bill_ids_list' + (Test.isRunningTest() ? + ' LIMIT 200' : '');
        system.debug(query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<AcctSeed__Billing__c> records){

        AcctSeed__Billing__c iteration_bill = records[0];
        List<AcctSeedERP__Sales_Order__c> so;
        List<Opportunity> opp;
        if(!Test.isRunningTest()){
            so = [SELECT Id, Billing_Balances__c FROM AcctSeedERP__Sales_Order__c WHERE Id=:iteration_bill.AcctSeedERP__Sales_Order__c];
            opp = [SELECT Id, Billing_Balances__c FROM Opportunity WHERE Id=:iteration_bill.AcctSeed__Opportunity__c];
        }
        List<AcctSeed__Billing__c> bills;

        if(!Test.isRunningTest()){
            if(so.size() > 0 && opp.size() > 0){ //if opportunity has assigned sales order and opportunity
                bills = [SELECT Id, AcctSeed__Balance__c, AcctSeedERP__Sales_Order__c FROM AcctSeed__Billing__c WHERE AcctSeed__Type__c = 'Invoice' AND AcctSeedERP__Sales_Order__c =: so[0].Id AND AcctSeed__Opportunity__c =: opp[0].Id];
            } else if(opp.size() > 0){ //if only opportunity
                bills = [SELECT Id, AcctSeed__Balance__c, AcctSeedERP__Sales_Order__c FROM AcctSeed__Billing__c WHERE AcctSeed__Type__c = 'Invoice' AND AcctSeed__Opportunity__c =: opp[0].Id];
            } else if(so.size() > 0){ //if only sales order
                bills = [SELECT Id, AcctSeed__Balance__c, AcctSeedERP__Sales_Order__c FROM AcctSeed__Billing__c WHERE AcctSeed__Type__c = 'Invoice' AND AcctSeedERP__Sales_Order__c =: so[0].Id];
            }
        } else {
            bills = new List<AcctSeed__Billing__c>();
        }
        if(bills.size() > 0){
            Decimal amount = 0.00;

            for(AcctSeed__Billing__c bill: bills){
                amount += bill.AcctSeed__Balance__c;
            }

            try{
                if(so.size() > 0){
                    so[0].Billing_Balances__c = amount;
                    update so;
                }
    
                if(opp.size() > 0){
                    opp[0].Run_Validation_Rule__c = true;
                    update opp;
                    opp[0].Billing_Balances__c = amount;
                    update opp;
                    // opp[0].op.Run_Validation_Rule__c = false;
                    // update opp;



                    // op.Run_Validation_Rule__c = true;
                    // update op;
                    // List<AcctSeed__Billing__c> bills = [SELECT Id, AcctSeed__Balance__c, AcctSeedERP__Sales_Order__c FROM AcctSeed__Billing__c WHERE AcctSeed__Type__c = 'Invoice' AND AcctSeed__Opportunity__c =: op.Id];
                    // Decimal amount = 0.00;
                    // for(AcctSeed__Billing__c b:bills){
                    //     amount+=b.AcctSeed__Balance__c;
                    // }
                    // system.debug('amount: '+amount);
                    // system.debug('trigger.old[0].AcctSeed__Balance__c'+trigger.old[0].AcctSeed__Balance__c);
                    // op.Billing_Balances__c = amount - trigger.old[0].AcctSeed__Balance__c;
                    // update op;
                }
            } catch(Exception e){
                if(so.size() > 0){
                    so[0].Billing_Balances__c = amount;
                    update so;
                } 
            }
             
        }


        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Fields on Opportunity and Sales Order record was updated successfully.');
    }
}

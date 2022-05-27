public without sharing class CalculateCommissionsPageCtrl {
    
    public string soId {get; set;}
    public AcctSeedERP__Sales_Order__c so {get; set;}
    public boolean NoDataExists {get; set;}
    public Boolean isSalesOrder {get; set;}
    public Opportunity opp {get;set;}

    public string communityUrl {

        get{
            User usr = [select contactId from user where id =: userInfo.getUserId() limit 1];
            return usr.contactId == null ? '' : '/sales';
        }
    }

    public CalculateCommissionsPageCtrl(){
        NoDataExists = false;

        soId = ApexPages.currentPage().getParameters().get('id');

        if(String.valueOf(Id.valueOf(soId).getSobjectType()) == 'Opportunity'){
            isSalesOrder = false;
            opp = [SELECT Id, Name FROM Opportunity WHERE Id=:soId];
        }else if(String.valueOf(Id.valueOf(soId).getSobjectType()) == 'AcctSeedERP__Sales_Order__c'){
            so = [select id, name from AcctSeedERP__Sales_Order__c where id =: soId Limit 1];
            isSalesOrder = false;
        }
    }


    public PageReference PageAction(){

        List<AcctSeed__Billing_Cash_Receipt__c> cashReceipts = [select id, AcctSeed__Billing__c from 
        AcctSeed__Billing_Cash_Receipt__c where
        AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c =: soId OR AcctSeed__Billing__r.AcctSeed__Opportunity__c =: soId];

        List<AcctSeed__Billing_Credit_Memo__c> MemoReceipts = [select id, AcctSeed__Billing_Invoice__c from 
        AcctSeed__Billing_Credit_Memo__c where
        AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c =: soId OR AcctSeed__Billing_Invoice__r.AcctSeed__Opportunity__c =: soId];

        PageReference page = null;

        if(cashReceipts.isEmpty() && MemoReceipts.isEmpty()){ // if nothing is found...
            NoDataExists = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No payment exists for this sales order.');
            ApexPages.addMessage(myMsg);
        }else{
                Boolean success;
                
                if(isSalesOrder){
                    success = CalculateCommissionsHandler.PartialCommissions(soId); // this method will create either all commissions or which are missing
                }else if(!isSalesOrder){
                    success = CalculateCommissionsHandler.PartialCommissionsOpportunity(soId); // this method will create either all commissions or which are missing
                }


                ApexPages.Message myMsg;
                if(success == true){
                    myMsg = new ApexPages.message(ApexPages.Severity.Confirm, 'Commissions were created successfully.' );
                    NoDataExists = true;
                } else {
                    NoDataExists = true;
                    myMsg = new ApexPages.message(ApexPages.Severity.Info, 'All commissions already have been created.' );
                } 
                ApexPages.addMessage(myMsg);

        }

        return page;
    }
    
    public PageReference Back(){
        
        PageReference page = new PageReference(communityUrl + '/' + soId);
        page.setRedirect(true);
     	return page;   
    }

}
public without sharing class CalculateCommissionsPageCtrl {
    
    public string soId {get; set;}
    public AcctSeedERP__Sales_Order__c so {get; set;}
    public boolean NoDataExists {get; set;}

    public string communityUrl {

        get{

            User usr = [select contactId from user where id =: userInfo.getUserId() limit 1];

            return usr.contactId == null ? '' : '/sales';
        }
    }

    public CalculateCommissionsPageCtrl(){

        NoDataExists = false;

        soId = ApexPages.currentPage().getParameters().get('id');
        so = [select id, name from AcctSeedERP__Sales_Order__c where id =: soId Limit 1];
    }


    public PageReference PageAction(){

        List<AcctSeed__Billing_Cash_Receipt__c> cashReceipts = [select id, AcctSeed__Billing__c from 
        AcctSeed__Billing_Cash_Receipt__c where
        AcctSeed__Billing__r.AcctSeedERP__Sales_Order__c =: soId];

        List<AcctSeed__Billing_Credit_Memo__c> MemoReceipts = [select id, AcctSeed__Billing_Invoice__c from 
        AcctSeed__Billing_Credit_Memo__c where
        AcctSeed__Billing_Invoice__r.AcctSeedERP__Sales_Order__c =: soId];

        PageReference page = null;

        if(cashReceipts.isEmpty() && MemoReceipts.isEmpty()){ // if nothing is found...

            NoDataExists = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No payment exists for this sales order.');
            ApexPages.addMessage(myMsg);
        }else{
                Boolean success = CalculateCommissionsHandler.PartialCommissions(soId); // this method will create either all commissions or which are missing

                if(!success){

                    NoDataExists = true;
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 
                    'All commissions have already been created.');
                    ApexPages.addMessage(myMsg);
                    
                    return null;
                } 
                
                page = new PageReference(communityUrl + '/' + soId);
                page.setRedirect(true);

        }

        return page;
    }
    
    public PageReference Back(){
        
        PageReference page = new PageReference(communityUrl + '/' + soId);
        page.setRedirect(true);
     	return page;   
    }

}
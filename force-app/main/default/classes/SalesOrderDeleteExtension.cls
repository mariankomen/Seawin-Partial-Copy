public class SalesOrderDeleteExtension {

    public string SOID {get; set;}
    public string RetURL {get; set;}
    public AcctSeedERP__Sales_Order__c SO{get; set;}
    Public Boolean ErrorMsgPO {get; set;}
    public string tabname{get; set;}
    public string title{get; set;}
    
    public SalesOrderDeleteExtension(ApexPages.StandardController std){
         
        SOID = ApexPages.currentPage().getParameters().get('id');
        RetURL = ApexPages.currentPage().getParameters().get('retURL');
        
            if(RetURL.contains('/a1H/o')){
                tabname = 'AcctSeedERP__Sales_Order__c';
                title = 'Sales Order';
                System.debug('tabName1: ' + tabname);
                
            }else if(RetURL.contains('OpportunityPage')){
                tabname = 'Opportunity';
                title = 'Opportunity';
                System.debug('tabName2: ' + tabname);
                
            }else if(RetURL.contains('AccountPage')){
                tabname = 'Account';
                title = 'Account';
                System.debug('tabName3: ' + tabname);
                
            }else{
                Id ObjectId = (RetURL.split('/')[1]);
                tabname = ObjectId.getSObjectType().getDescribe().getName();
                System.debug('tabName4: ' + tabname);
                title = ObjectId.getSObjectType().getDescribe().getLabel();
            } 
        
        SO = [select id from AcctSeedERP__Sales_Order__c
              where id =: SOID limit 1];
        
        ErrorMsgPO  = false;
    }
    
    public PageReference DeleteProcess(){
     
        PageReference page = new PageReference(RetURL);
        page.setRedirect(true);
        List<AcctSeedERP__Purchase_Order__c> po =[select id from AcctSeedERP__Purchase_Order__c
                                           where Sales_Order__c =: SO.Id limit 1];
        
        
        if(po.isEmpty()){
            delete SO;
            return page;
        }
        else if(!po.isEmpty()){    
            ErrorMsgPO = true;
        }
        
        return null;
    }
    
    public PageReference back(){
      
         if(tabname == 'AcctSeedERP__Sales_Order__c')
         {
             RetURL = '/'+SOID;
         }
         
         PageReference page = new PageReference(RetURL);
         System.debug('RetURL: ' + RetURL);
         page.setRedirect(true);
         return page;
         
     }
    
}
public class OpportunityDeleteOverrideExtension {
    
    private string oppId {private get; private set;}
    private opportunity opp {private get; private set;}
    private string parentId {private get; private set;}
    private string retUrl {private get; private set;}
    public string tabname{get; set;}
  
    Public Boolean DeleteErrorMsgOpp {get; set;}
    
    public OpportunityDeleteOverrideExtension(ApexPages.StandardController std){
        
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        oppId = (string)std.getId();
        
        opp = [select id, parent_opportunity__c from opportunity where id =:oppId limit 1];
        
        parentId = opp.Parent_Opportunity__c;
        DeleteErrorMsgOpp = false;
    }
    
    public PageReference TryDelete(){
        List<AcctSeed__Billing__c> billings_list = [SELECT Id, AcctSeed__Opportunity__c FROM AcctSeed__Billing__c WHERE AcctSeed__Opportunity__c =:Opp.Id LIMIT 50000];
        if(!billings_list.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can`t delete opportunity with billing(s)!')); return null;
        }
        LIST<AcctSeedERP__Sales_Order__c> SO = [select id from AcctSeedERP__Sales_Order__c
                                                where AcctSeedERP__Opportunity__c =: Opp.Id limit 1];
        if(!SO.isEmpty()){
            DeleteErrorMsgOpp = true;
            return null;
        }
        
        pagereference page = new pagereference('/006/o');
        
        if(opp.Parent_Opportunity__c == null){
            
            // its a delete case, so delete it
            delete opp;
        }else{
            
            if(retUrl == '/apex/OpportunityPage?id='+parentId.substring(0, 15)+'&sfdc.override=1'){
                // delete is being triggered from an opportunity, its unparent case, so unparent the opportunity
            	opp.Parent_Opportunity__c = null;
            	update opp;
                
                page = new pagereference('/' + parentId);
                
            }else{
                
                delete opp;
            }
        }
        
		page.setRedirect(true);
        
        return page;
    }
    
    public PageReference back(){
      
         if(retUrl.contains('/006/o')){
             retUrl = '/apex/OpportunityPage?id='+oppId+'&sfdc.override=1';
         }
         
         PageReference page = new PageReference(RetURL);
         page.setRedirect(true);
         return page;
     }
    
}
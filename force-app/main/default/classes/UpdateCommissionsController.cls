public class UpdateCommissionsController {
    
    public AcctSeedERP__Sales_Order__c so {get; set;}
    public Boolean CommissionRateHasChanged {get; set;}
    
    public boolean SalesCommissionChanges {get; set;}
    public boolean ManufacturerCommissionChanges {get; set;}
    public boolean ReferralCommissionChanges {get; set;}
    public boolean SpecifiedCommissionChanges {get; set;}
    
    public string communityUrl {
        
        get{
            
            User usr = [select contactId from user where id =: userInfo.getUserId() limit 1];
            
            return usr.contactId == null ? '' : '/sales';
        }
    }
    
    public UpdateCommissionsController(){
        
        String soId = ApexPages.currentPage().getParameters().get('salesorderid');
        
        SalesCommissionChanges = true;
        ManufacturerCommissionChanges = true;
        ReferralCommissionChanges = true;
        SpecifiedCommissionChanges = true;
        
        so = [select id, Name,
              Commission_Rate_Sales_Rep__c,
              Commission_Rate_Manufacturer_Rep__c,
              Commission_Rate_Referral_Sales_Rep__c,
              Commission_Rate_Specified_Rep__c
              from AcctSeedERP__Sales_Order__c 
              where Id =: soId Limit 1];
        
    }
    
    public PageReference PageAction(){
        
        Pagereference page = null;
        
        CalculateCommissionsHandler.UpdateCommissions(so, SalesCommissionChanges, ManufacturerCommissionChanges, 
                                                      ReferralCommissionChanges, SpecifiedCommissionChanges);
        
        page = new PageReference(communityUrl + '/' + so.id);
        page.setRedirect(true);
        return page;
    }
    
    public PageReference back(){
        
        PageReference page = new PageReference(communityURL + '/' + so.id);
        page.setRedirect(true);
        
        return page;
    }
}
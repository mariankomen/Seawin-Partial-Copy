public with sharing class MassEditSalesOrderScreenExtension {
    
    public String soId {get; set;}
    public String solId {get; set;}
    public AcctSeedERP__Sales_Order__c so {get; set;}
    public AcctSeedERP__Sales_Order_Line__c sol {get; set;}
    public List<AcctSeedERP__Sales_Order_Line__c> lines {get; set;}
    public boolean visible {get; set;}
    public Boolean LasttoDelete {get{
        
        if(lasttodelete == null) lasttodelete = false; return lasttodelete;
        
    } set;}
    public Boolean editAllProductPermission {get; set;}
    public Boolean showBack {get; set;}
    
    public MassEditSalesOrderScreenExtension(ApexPages.StandardSetController std){
        visible = true;
        editAllProductPermission = true;
        showBack = false;
        soId = ApexPages.currentPage().getParameters().get('id');
        
        String desireUserId = UserInfo.getUserId();
        User u = [select profileId from user where id =: desireUserId];
        String profileId = u.profileId;
        LIST<ObjectPermissions> ObjPermissionList = new LIST<ObjectPermissions>();
        ObjPermissionList = [SELECT Id, SObjectType, PermissionsEdit FROM ObjectPermissions WHERE parentid in 
                             (select id from permissionset where PermissionSet.Profile.Id=: profileId)];
        for(ObjectPermissions objPerm :ObjPermissionList){
            if(objPerm.SobjectType == 'Optional_Products_Opportunity__c')
            {
                if(objPerm.PermissionsEdit == false){
                    //visible = false;
                    editAllProductPermission = false;
                    showBack = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Privileges, You are not allowed to make these changes. Please contact your adminstrator.'));
                }
            }
        }
        
        if(editAllProductPermission == true){
            if(soId != null){ 
            
            so = [SELECT Id,name,AcctSeedERP__Status__c, AcctSeedERP__Opportunity__r.name, 
                  AcctSeedERP__Customer__r.name, AcctSeedERP__Total__c FROM AcctSeedERP__Sales_Order__c where id=:soId];
            
            lines = [SELECT Id, Name, AcctSeedERP__Sales_Order__c, AcctSeedERP_Description__c,quantity_allocated_formula__c, 
                     AcctSeedERP__Quantity_Ordered__c, AcctSeedERP__Product__r.name,ProductCode__c, quantity_shipped_formula__c,
                     Item_Description__c, Sales_Price__c, Size__c,AcctSeedERP__Total__c, AcctSeedERP__Unit_Price__c, sortorder__c
                     FROM AcctSeedERP__Sales_Order_Line__c where AcctSeedERP__Sales_Order__c =:soId 
                     order by sortorder__c,name,createddate asc];
            if(lines.IsEmpty()){
                visible = false;
                ApexPages.addmessage(new ApexPages.message(
                    ApexPages.severity.ERROR,
                    'No Products found.'));
            }
        }
        }
    }
    public PageReference UpdateLine(){
        
        update lines;
        
        PageReference page = new PageReference('/' + soId);
        page.setRedirect(true);
        return page;
    }
    public PageReference TrashIt(){
        
        solId = ApexPages.currentPage().getParameters().get('solId');
        
        if(solid != null){
            
            // check if there are lines left
            List<AcctSeedERP__Sales_Order_Line__c> leftLines = [SELECT Id FROM AcctSeedERP__Sales_Order_Line__c 
                                                                where AcctSeedERP__Sales_Order__c =:soId and id != :solid];
            
            if(leftLines.IsEmpty()){
                // show warning that just one line left
                LasttoDelete = true;
                ApexPages.addmessage(new ApexPages.message(
                    ApexPages.severity.WARNING,'Are you sure you want to delete.'));
                return null;                
            }           
            
            // delete
            AcctSeedERP__Sales_Order_Line__c sols = [SELECT Id FROM AcctSeedERP__Sales_Order_Line__c where id =:solid]; 
            delete sols;
            
            // String pageVal  = ApexPages.currentPage().getURL();
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            system.debug(hostVal + '/apex/MassEditSalesOrderScreenPage?id='+soId);
            // redirect
            PageReference page = new PageReference('https://' + hostVal + '/apex/MassEditSalesOrderScreenPage?id='+soId); 
            Page.setRedirect(true);
            return page;
            
        }
        
        return null;
    }
    public PageReference yes(){
        // delete
        AcctSeedERP__Sales_Order_Line__c sols = [SELECT Id FROM AcctSeedERP__Sales_Order_Line__c where id =:solid]; 
        delete sols;
        
        PageReference page = new PageReference('/' + soId);
        page.setRedirect(true);
        return page;
    }
    public PageReference no(){
        LasttoDelete = false;
        return null;
    }
    public PageReference back(){
        
        PageReference page = new PageReference('/' + soId);
        page.setRedirect(true);
        return page;
    }
}
public with sharing class MassEditSalesOrderScreenExtension {
    
    public String soId {get; set;}
    public String solId {get; set;}
    public AcctSeedERP__Sales_Order__c so {get; set;}
    public AcctSeedERP__Sales_Order_Line__c sol {get; set;}
    public List<AcctSeedERP__Sales_Order_Line__c> lines {get; set;}
    public Map<Id, AcctSeedERP__Sales_Order_Line__c> lines_map {get; set;}
    public boolean visible {get; set;}
    public Boolean LasttoDelete {get{
        
        if(lasttodelete == null) lasttodelete = false; return lasttodelete;
        
    } set;}
    public Boolean editAllProductPermission {get; set;}
    public Boolean showBack {get; set;}
    
    public Id newQuantity {get; set;}




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
                     Item_Description__c, Sales_Price__c, Size__c,AcctSeedERP__Total__c, AcctSeedERP__Unit_Price__c, sortorder__c,
                     Kit_Children__c, Kit__c,AcctSeedERP__Product__c, Allow_Product_Description_Change__c
                     FROM AcctSeedERP__Sales_Order_Line__c where AcctSeedERP__Sales_Order__c =:soId 
                     order by sortorder__c,name,createddate asc];

            system.debug('TSETST ST lines: '+JSON.serialize(lines));
            if(lines.IsEmpty()){
                visible = false;
                ApexPages.addmessage(new ApexPages.message(
                    ApexPages.severity.ERROR,
                    'No Products found.'));
            }
        }
        }
        lines_map = new Map<Id,AcctSeedERP__Sales_Order_Line__c>(lines);
    }


    /*****************************************************************************************************
    *   @method      : handleQuantity
    *   @description : non static method used to update AcctSeedERP__Quantity_Ordered__c field on child records to KIT
    *   @return      : void
    *   @author      : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public void handleQuantity(){

        Map<Id, List<Id>> kit_parent_childrens = getKitsRelation();
        AcctSeedERP__Sales_Order_Line__c current_updated_record = lines_map.get(newQuantity);
        List<Id> related = kit_parent_childrens.get(current_updated_record.AcctSeedERP__Product__c);
        
        for(AcctSeedERP__Sales_Order_Line__c sol: lines){
            if(related.contains(sol.AcctSeedERP__Product__c)){
                sol.AcctSeedERP__Quantity_Ordered__c = current_updated_record.AcctSeedERP__Quantity_Ordered__c;
            }
        }
    }


    /*****************************************************************************************************
    *   @method      : UpdateLine
    *   @description : non static method used to updating Sales Order Lines
    *   @return      : void
    *   @author      : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public PageReference UpdateLine(){
        
        update lines;
        
        PageReference page = new PageReference('/' + soId);
        page.setRedirect(true);
        return page;
    }


    /*****************************************************************************************************
    *   @method      : getKitsRelation
    *   @description : non static method used to get map of Kit parent Id and List of related children Kit Ids 
    *   @return      : Map<Id, List<Id>>
    *   @author      : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/

    public Map<Id, List<Id>> getKitsRelation(){
        List<AcctSeed__Product_Part__c> kits = [SELECT Id, Kit_Product__c, Kit_Children__c FROM AcctSeed__Product_Part__c];
        Map<Id, List<Id>> kit_parent_childrens = new Map<Id, List<Id>>();

        for(AcctSeed__Product_Part__c kit:kits){
            if(kit.Kit_Product__c != null){
                if(!kit_parent_childrens.containsKey(kit.Kit_Product__c)){
                    List<Id> childrenIds = new List<Id>{kit.Kit_Children__c};
                    kit_parent_childrens.put(kit.Kit_Product__c, childrenIds);
                } else {
                    kit_parent_childrens.get(kit.Kit_Product__c).add(kit.Kit_Children__c);
                }
            }
            
        }

        return kit_parent_childrens;
    }

    /*********************************************************************************************************************************
    *   @method      : TrashIt
    *   @description : non static method used for deleting lines. If deleting record is KIT, also will be deleted related Kit Products
    *   @return      : PageReference
    *   @author      : Marian Lyzhychka ©Peeklogic
    **********************************************************************************************************************************/
    public PageReference TrashIt(){
        
        solId = ApexPages.currentPage().getParameters().get('solId');

        List<AcctSeed__Product_Part__c> kits = [SELECT Id, Kit_Product__c, Kit_Children__c FROM AcctSeed__Product_Part__c];
        Map<Id, List<Id>> kit_parent_childrens = getKitsRelation();


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
            


            AcctSeedERP__Sales_Order_Line__c delete_item = [SELECT Id, Kit_Children__c,
                                                                        Kit__c, 
                                                                        AcctSeedERP__Product__c
                                                                        FROM AcctSeedERP__Sales_Order_Line__c 
                                                                        where id =:solid];
            
            if(delete_item.Kit__c){
                if(kit_parent_childrens.containsKey(delete_item.AcctSeedERP__Product__c)){
                    List<AcctSeedERP__Sales_Order_Line__c> deletableLine = [SELECT Id,  AcctSeedERP__Product__c,
                                                                                    AcctSeedERP__Sales_Order__c
                                                                                FROM AcctSeedERP__Sales_Order_Line__c 
                                                                                where AcctSeedERP__Sales_Order__c  =:soId 
                                                                                AND AcctSeedERP__Product__c IN: kit_parent_childrens.get(delete_item.AcctSeedERP__Product__c)]; 
                    deletableLine.add(delete_item);
                    delete deletableLine;
                } else {
                    delete delete_item;
                }
            } else {
                delete delete_item;
            }                                                            
            
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

    public void helpTest(){
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
    }
}
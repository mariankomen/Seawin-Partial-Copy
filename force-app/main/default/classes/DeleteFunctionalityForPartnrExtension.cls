public class DeleteFunctionalityForPartnrExtension {
    
    private String objectIdToBeDeltd {get; set;}
    private String objType {get; set;}
    
    public DeleteFunctionalityForPartnrExtension(){
        
        objType = ApexPages.currentPage().getParameters().get('object');
        objectIdToBeDeltd =  ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference deleteRecord(){
        
        Database.delete(objectIdToBeDeltd, false);
        
        PageReference page;
        
        if(objType == 'account'){
            page = new PageReference ('/001/o');
        }else if(objType == 'contact'){
            page = new PageReference ('/003/o');
        }else if(objType == 'opportunity'){
            page = new PageReference ('/006/o');
        }else if(objType == 'product'){
            page = new PageReference ('/apex/ProductPage?save_new=1&sfdc.override=1');
        }else if(objType == 'quote'){
            page = new PageReference ('/0Q0/o');
        }else if (objType == 'lead'){
            page = new PageReference ('/00Q/o');           
        }else if (objType == 'case'){
            page = new PageReference ('/500/o');           
        }
        
        page.setRedirect(true);
        return page;
    }
    
}
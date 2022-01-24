public class EditProjectExtension {
    
    public Id projectId {get; set;}
    public AcctSeed__Project__c project {get; set;}
    public string retUrl {get; set;}
    
    public EditProjectExtension(ApexPages.StandardController std){
        
        projectId = (Id)std.getId();
        
        project = new AcctSeed__Project__c();
        
        retUrl = ApexPages.currentPage().getParameters().get('retUrl');
        
        project = [SELECT Id, Name, OwnerId, CreatedDate,Project_Date__c, Project_Manager__c, 
                   AcctSeed__Account__c,Note__c,
                   Barn_Doors_ETA__c,
                    LED_Mirrors_ETA__c,
                    Shower_Bases_ETA__c,
                    Shower_Doors_ETA__c,
                    Wall_Surrounds_ETA__c,
                   Mockup_ETA__c,
                   AcctSeed__Status__c, Contact__c, LastModifiedById, 
                   LastModifiedDate, CreatedById FROM AcctSeed__Project__c
                   where id =:projectId limit 1];

    }
    
    public PageReference saveRecord(){
        
        // check if there is no account and no contact provided
        if(Project.AcctSeed__Account__c == null && Project.Contact__c == null){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       'Atleast an account or a contact is required for a project.'));
            return null;
        }
        Acctseed__project__c p = new Acctseed__project__c();
		
        Boolean OpportunityClosed = true;
        Boolean SalesOrdersClosed = true;
        Boolean PurchaseOrdersClosed = true;
        // check if the status has been changed
        if(project.AcctSeed__Status__c == 'Closed'){
            
            // find out the status of each associated OP
            
            list<Opportunity> opportunities = [select id, StageName from 
                                                             Opportunity where project__c =:project.id];
            
            if(!opportunities.IsEmpty()){
                
                for(Opportunity o:opportunities){
                    
                    if(o.StageName != 'Closed Won' && o.StageName != 'Closed Lost'){
                        if(OpportunityClosed == true) OpportunityClosed = false;
                    }
                }
                
            }
            
            // find out the status of each associated SO and PO
            
            list<AcctSeedERP__Sales_Order__c> salesorders = [select id, AcctSeedERP__Status__c from 
                                                             AcctSeedERP__Sales_Order__c where project__c =:project.id];
            
            if(!salesorders.IsEmpty()){
                
                for(AcctSeedERP__Sales_Order__c sales:salesorders){
                    
                    if(sales.AcctSeedERP__Status__c != 'Closed'){
                        if(SalesOrdersClosed == true) SalesOrdersClosed = false;
                    }
                }
                
            }
            
            list<AcctSeedERP__Purchase_Order__c> purchaseorders = [select id, AcctSeedERP__Status__c from 
                                                                   AcctSeedERP__Purchase_Order__c where project__c =:project.id];
            
            if(!purchaseorders.IsEmpty()){
                
                for(AcctSeedERP__Purchase_Order__c purchases:purchaseorders){
                    
                    if(purchases.AcctSeedERP__Status__c != 'Closed'){
                        if(PurchaseOrdersClosed == true) PurchaseOrdersClosed = false;
                    }
                }
                
            }
            // if the statusBell stays true, means rang, then update the project status to completed
            
            if(!PurchaseOrdersClosed || !SalesOrdersClosed || !OpportunityClosed){
                
                // if not true then show a message 
                String msg = 'Project status cannot be updated, as some ' + 
                    ((!OpportunityClosed)?'opportunity ':'')+
                    ((!OpportunityClosed && !SalesOrdersClosed && PurchaseOrdersClosed) ? 
                     'and ':((!OpportunityClosed && !SalesOrdersClosed && !PurchaseOrdersClosed) ? ', ':'')) +
                    ((!SalesOrdersClosed)?'sales order(s) ':'') +
                    ((!SalesOrdersClosed && !PurchaseOrdersClosed) ? 'and ':'')+
                    ((!PurchaseOrdersClosed) ? 'purchase order(s) ':'')
                    + 'are still open.';
                
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 
                                                           msg));
                
                return null;
                
            }
        }
        
        try{

            update project;
            
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        
        
        PageReference page = new PageReference('/' + projectId);
        
        if(retUrl != ''){
            
            page = new pageReference(retUrl);
        }
        
        return page;
    }
    
    public PageReference cancelOperation(){
        
        PageReference page = new PageReference('/' + projectId);
        
        if(retUrl != ''){
            
            page = new pageReference(retUrl);
        }
        
        return page;
    }
}
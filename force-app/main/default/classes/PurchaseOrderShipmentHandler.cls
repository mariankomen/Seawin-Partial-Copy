public class PurchaseOrderShipmentHandler {
    
    public static void CreateShipment(list<AcctSeedERP__Purchase_Order_Inventory_Movement__c> data){
        
        
        set<id> movementIds = new set<id>();
        for(AcctSeedERP__Purchase_Order_Inventory_Movement__c movement : data){
            
            movementIds.add(movement.id);
        }
        
        if(movementIds.size() > 0){
            
            // fetch the movement data
            list<AcctSeedERP__Purchase_Order_Inventory_Movement__c> 
                movements = [SELECT Id, Name, 
                             AcctSeedERP__Inventory_Balance__c,
                             AcctSeedERP__Purchase_Order_Line__c,
                             AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c,
                             AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Name,
                             AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.project__c,
                             AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c,
                             AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Sales_Order__c,
                             AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c,
                             AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Product__c,
                             AcctSeedERP__GL_Account_Variable_1__c, 
                             AcctSeedERP__Location__c, 
                             AcctSeedERP__Movement_Date__c,
                             AcctSeedERP__Quantity__c, 
                             AcctSeedERP__Product__c, AcctSeedERP__ProductId__c, AcctSeedERP__Unit_Cost__c 
                             FROM 
                             AcctSeedERP__Purchase_Order_Inventory_Movement__c where id in:movementIds];
            
            // initialize the po shipment lines list
            list<Po_shipment_Line__c> lines = new list<PO_Shipment_Line__c>();
            
            if(!movements.IsEmpty()){
                
                // There is going to be one purchase order in a single receive, meaning one shipment
                AcctSeedERP__Purchase_Order_Inventory_Movement__c mvts = movements[0];
                
                if(mvts.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c 
                   != 'Drop Shipment'){
                       
                       Po_shipment__c ps = new Po_Shipment__c();
                       
                       ps.Date__c = mvts.AcctSeedERP__Movement_Date__c;
                       ps.GL_Account_Variable_1__c = mvts.AcctSeedERP__GL_Account_Variable_1__c;
                       ps.Project__c = mvts.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.project__c;
                       ps.Purchase_Order__c = mvts.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c;
                       ps.Sales_Order__c = mvts.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Sales_Order__c;
                       ps.Reference__c = 
                           mvts.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c +'-'
                           +mvts.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Name;
                       ps.Status__c = 'Shipped';
                       
                       insert ps;
                       
                       for(AcctSeedERP__Purchase_Order_Inventory_Movement__c mvt : movements){
                           // create shipment line
                           
                           Po_shipment_Line__c sl = new PO_Shipment_Line__c();
                           
                           sl.PO_Shipment__c = ps.id;
                           sl.Product__c = mvt.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Product__c;
                           sl.Purchase_Order__c = mvt.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c;
                           sl.Purchase_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__c;
                           sl.Quantity_Shipped__c = mvt.AcctSeedERP__Quantity__c;
                           sl.Sales_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c;
                           
                           lines.add(sl);
                           
                       }
                   }
                
                if(!lines.IsEmpty()){
                    try{
                        insert lines; 
                        
                    }catch(exception ex){
                        system.debug(ex.getMessage());
                    }            
                }
            }
        }
    }
}
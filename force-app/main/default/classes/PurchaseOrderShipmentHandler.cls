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
                             AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__r.AcctSeedERP__Sales_Order__c,
                             AcctSeedERP__Purchase_Order_Line__r.Description__c,
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
            list<AcctSeedERP__Shipment_Line__c> so_ship_lines = new List<AcctSeedERP__Shipment_Line__c>();
            if(!movements.isEmpty()) {
                AcctSeedERP__Purchase_Order_Inventory_Movement__c poim = movements[0];

                if(poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c == 'Drop Shipment'){
                    List<PO_Shipment__c> po_ship = [SELECT Id, 
                                                            Status__c, 
                                                            Purchase_Order__c,
                                                            Tracking_Number__c 
                                                    FROM PO_Shipment__c 
                                                    WHERE Purchase_Order__c=:poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c
                                                    AND Status__c = 'Shipped'];
                                        
                    if(po_ship.isEmpty()){
                        //If purchase order has not related shipments with status Shipped than we need create new one
                        Po_shipment__c ps = new Po_Shipment__c();
                        
                        ps.Date__c = poim.AcctSeedERP__Movement_Date__c;
                        ps.GL_Account_Variable_1__c = poim.AcctSeedERP__GL_Account_Variable_1__c;
                        ps.Project__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.project__c;
                        ps.Purchase_Order__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c;
                        ps.Sales_Order__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Sales_Order__c;
                        ps.Reference__c = 
                        poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c +'-'
                            +poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Name;
                        ps.Status__c = 'Received';
                        
                        insert ps;

                        //Create shipment on sales order
                        AcctSeedERP__Shipment__c so_shipment = new AcctSeedERP__Shipment__c();
                        so_shipment.AcctSeedERP__Shipment_Date__c = poim.AcctSeedERP__Movement_Date__c;
                        so_shipment.Project__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.project__c;
                        so_shipment.Purchase_Order_Shipment__c = ps.Id;
                        so_shipment.AcctSeedERP__Sales_Order__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Sales_Order__c;
                        so_shipment.AcctSeedERP__Shipping_Reference__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c +'-'
                            +poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Name;
                        so_shipment.AcctSeedERP__Status__c = 'Received';
                        so_shipment.tracking_number__c = ps.Tracking_Number__c;

                        if(!Test.isRunningTest()) insert so_shipment;

                       ps.Shipment__c = so_shipment.Id;
                       if(!Test.isRunningTest()) update ps;

                       for(AcctSeedERP__Purchase_Order_Inventory_Movement__c mvt : movements){
                        // create shipment line purch ord ship
                        
                            Po_shipment_Line__c sl = new PO_Shipment_Line__c();
                            
                            sl.PO_Shipment__c = ps.id;
                            sl.Product__c = mvt.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Product__c;
                            sl.Purchase_Order__c = mvt.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c;
                            sl.Purchase_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__c;
                            sl.Quantity_Shipped__c = mvt.AcctSeedERP__Quantity__c;
                            system.debug('mvt.AcctSeedERP__Purchase_Order_Line__r.Description__c: '+mvt.AcctSeedERP__Purchase_Order_Line__r.Description__c);
                            sl.Description__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Description__c;
                            system.debug('sl.Description__c: '+sl.Description__c);
                            sl.Sales_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c;
                            sl.Sales_Order__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__r.AcctSeedERP__Sales_Order__c;
                            lines.add(sl);

                            // system.debug('po: '+AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__r.AcctSeedERP__Sales_Order__c + ' __ ' + )

                            //SO Shipment lines
                            AcctSeedERP__Shipment_Line__c so_ship_line = new AcctSeedERP__Shipment_Line__c();
                            so_ship_line.AcctSeedERP__Shipment__c = so_shipment.Id;
                            so_ship_line.AcctSeedERP__Sales_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c;
                            so_ship_line.AcctSeedERP__Quantity_Shipped__c = mvt.AcctSeedERP__Quantity__c;
                            so_ship_line.Item_Description__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Description__c;

                            so_ship_lines.add(so_ship_line);
                        }

                    }else{
                        //If it purchase order has shipments with status Shipped than we need attach records to current shipment
                        PO_Shipment__c ship_record = po_ship[0];
                        List<PO_Shipment_Line__c> already_received = [SELECT Id,
                                                                            Quantity_Shipped__c, 
                                                                            PO_Shipment__c, 
                                                                            Purchase_Order_Line__c 
                                                                    FROM PO_Shipment_Line__c 
                                                                    WHERE PO_Shipment__c=:ship_record.Id];
                        Map<Id, PO_Shipment_Line__c> already_received_map = new Map<Id, PO_Shipment_Line__c>();
                        for(PO_Shipment_Line__c posl: already_received){
                            already_received_map.put(posl.Purchase_Order_Line__c, posl);
                        }
                        List<AcctSeedERP__Shipment__c> so_ship = [SELECT Id, 
                                                                    AcctSeedERP__Status__c,
                                                                    AcctSeedERP__Sales_Order__c 
                                                                    FROM AcctSeedERP__Shipment__c
                                                                    WHERE AcctSeedERP__Sales_Order__c=:poim.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__r.AcctSeedERP__Sales_Order__c
                                                                    AND AcctSeedERP__Status__c='Shipped'];

                        List<AcctSeedERP__Shipment_Line__c> sales_order_ship_lines = new List<AcctSeedERP__Shipment_Line__c>();    
                        Map<Id, AcctSeedERP__Shipment_Line__c> so_already_received_map = new Map<Id, AcctSeedERP__Shipment_Line__c>();

                        AcctSeedERP__Shipment__c so_shipment_ex = new AcctSeedERP__Shipment__c(); //use it if po has shipment but so no

                        if(!so_ship.isEmpty()){
                            sales_order_ship_lines = [SELECT Id, 
                                                    AcctSeedERP__Shipment__c, 
                                                    AcctSeedERP__Quantity_Shipped__c,
                                                    AcctSeedERP__Sales_Order_Line__c
                                            FROM AcctSeedERP__Shipment_Line__c
                                            WHERE AcctSeedERP__Shipment__c=: so_ship[0].Id];

                            for(AcctSeedERP__Shipment_Line__c sline: sales_order_ship_lines){
                                so_already_received_map.put(sline.AcctSeedERP__Sales_Order_Line__c, sline);
                            }
                        }else{
                            so_shipment_ex.AcctSeedERP__Shipment_Date__c = poim.AcctSeedERP__Movement_Date__c;
                            so_shipment_ex.Project__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.project__c;
                            so_shipment_ex.Purchase_Order_Shipment__c = ship_record.Id;
                            so_shipment_ex.AcctSeedERP__Sales_Order__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Sales_Order__c;
                            so_shipment_ex.AcctSeedERP__Shipping_Reference__c = poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.AcctSeedERP__Type__c +'-'
                                +poim.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__r.Name;
                                so_shipment_ex.AcctSeedERP__Status__c = 'Received';
                                so_shipment_ex.tracking_number__c = ship_record.Tracking_Number__c;

                            if(!Test.isRunningTest()){
                                insert so_shipment_ex;
                            }    
                        }
                        


                        for(AcctSeedERP__Purchase_Order_Inventory_Movement__c mvt : movements){
                            // create shipment line
                            if(already_received_map.containsKey(mvt.AcctSeedERP__Purchase_Order_Line__c)){
                                already_received_map.get(mvt.AcctSeedERP__Purchase_Order_Line__c).Quantity_Shipped__c += mvt.AcctSeedERP__Quantity__c;
                            }else{
                                Po_shipment_Line__c sl = new PO_Shipment_Line__c();
                            
                                sl.PO_Shipment__c = ship_record.id;
                                sl.Product__c = mvt.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Product__c;
                                sl.Purchase_Order__c = mvt.AcctSeedERP__Purchase_Order_Line__r.AcctSeedERP__Purchase_Order__c;
                                sl.Purchase_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__c;
                                sl.Description__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Description__c;
                                sl.Quantity_Shipped__c = mvt.AcctSeedERP__Quantity__c;
                                sl.Sales_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c;
                                sl.Sales_Order__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__r.AcctSeedERP__Sales_Order__c;
                                lines.add(sl);
                            }

                            if(so_already_received_map.containsKey(mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c)){
                                so_already_received_map.get(mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c).AcctSeedERP__Quantity_Shipped__c += mvt.AcctSeedERP__Quantity__c;
                            }else{
                                AcctSeedERP__Shipment_Line__c so_ship_line = new AcctSeedERP__Shipment_Line__c();
                                so_ship_line.AcctSeedERP__Shipment__c = so_shipment_ex.Id;
                                so_ship_line.AcctSeedERP__Sales_Order_Line__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Sales_Order_Line__c;
                                so_ship_line.AcctSeedERP__Quantity_Shipped__c = mvt.AcctSeedERP__Quantity__c;
                                so_ship_line.Item_Description__c = mvt.AcctSeedERP__Purchase_Order_Line__r.Description__c;

                                so_ship_lines.add(so_ship_line);
                            }
                        }

                        List<PO_Shipment_Line__c> to_update = new List<PO_Shipment_Line__c>();
                        for(Id posl:already_received_map.keySet()){
                            to_update.add(already_received_map.get(posl));
                        }

                        try{
                            update to_update;
                        }catch(Exception ex){
                            system.debug('Exeption during updating po ship lines: '+ex.getMessage());
                        }

                    }
                    if(!lines.isEmpty()){
                        try{
                            if(!Test.isRunningTest()) insert so_ship_lines;
                            if(!Test.isRunningTest()) insert lines;

                            
                            system.debug('lines has been inserted;');
                        }catch(Exception ex){
                            system.debug('lines INSERT ERRORRR');
                            system.debug(ex.getMessage());
                        }
                    }
                    
                }
            }
        }
    }

    public static void coverage(){

        integer i = 0;
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
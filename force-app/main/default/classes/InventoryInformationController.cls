public class InventoryInformationController {
    public string ProductId { get; set; }
    public map<string, decimal> AllocatedQuantityMap { get; set; }
    public list<integer> AvailableList {get; set;}
    public list<integer> AllocatedList {get; set;}
    public list<integer> InStockList {get; set;}
    public map<string, Integer> QuantityAllocatedOnSalesOrderMap {get; set;}
    
    public boolean isKit {get; set;}
    
    public InventoryInformationController() {
        ProductId = ApexPages.currentPage().getParameters().get('id');
        
        QuantityOnSalesOrdersMap = new Map<id, string>();
        AllocatedOnSalesOrdersMap = new Map<id, string>();
        QuantityAllocatedOnSalesOrderMap = new map<string, Integer>();
        UnreceivedOnPurchaseOrdersMap = new Map<id, string>();
        AllocatedQuantityMap = new Map<string, decimal>();
        AvailableList = new list<integer>();
        AllocatedList = new list<integer>();
        InStockList = new list<integer>();
        isKit = false;
        
        Product2 p = getProduct();
        
        if(p.AcctSeed__Inventory_Type__c == 'Kit'){
            
            isKit = true;
            
            set<id> productIds = new set<id>();
            productIds.add(ProductId);
            
            KitInventoryCalculation();
        }
    }
    
    public Product2 getProduct() {
        String fields = AllFields.Fields('Product2', new List<String>());
        
        Product2 Product = Database.query(
            'Select ' +
            fields +
            ' from Product2 where Id=:ProductId Limit 1'
        );
        
        return Product;
    }
    
    public Integer getAvailableQuantityTotal() {
        AggregateResult agr = [
            SELECT Sum(AcctSeedERP__Available_Quantity__c) total
            FROM AcctSeedERP__Inventory_Balance__c
            WHERE
            AcctSeedERP__Product__c = :ProductId
            AND AcctSeedERP__Available_Quantity__c > 0
        ];
        
        return RoundOffDecimal(agr.get('total') == null ? 0 : Integer.valueOf(agr.get('total')));
    }
    public List<AcctSeedERP__Inventory_Balance__c> getAvailableQuantity() {
        String fields = AllFields.Fields(
            'AcctSeedERP__Inventory_Balance__c',
            new List<String>()
        );
        
        List<AcctSeedERP__Inventory_Balance__c> AvailableQuantity = Database.query(
            'Select ' +
            fields +
            ' from AcctSeedERP__Inventory_Balance__c where AcctSeedERP__Product__c=:ProductId and ' +
            'AcctSeedERP__Available_Quantity__c > 0 order by Name'
        );
        
        return AvailableQuantity;
    }
    
    public Integer getQuantityOnSalesOrdersTotal() {
        AggregateResult agr = [
            SELECT SUM(AcctSeedERP__Quantity_Needed__c) total
            FROM AcctSeedERP__Sales_Order_Line__c
            WHERE
            AcctSeedERP__Sales_Order__r.AcctSeedERP__Status__c = 'Open'
            AND AcctSeedERP__Product__c = :ProductId
        ];
        
        return RoundOffDecimal(agr.get('total') == null ? 0 : Integer.valueOf(agr.get('total')));
    }
    public map<id, string> QuantityOnSalesOrdersMap { get; set; }
    public List<AggregateResult> getQuantityOnSalesOrders() {
        List<AggregateResult> QuantityOnSalesOrders = new List<AggregateResult>();
        
        List<AcctSeedERP__Sales_Order_Line__c> ForQuantityOnSalesOrder = [
            SELECT AcctSeedERP__Sales_Order__c, AcctSeedERP__Sales_Order__r.Name
            FROM AcctSeedERP__Sales_Order_Line__c
            WHERE
            AcctSeedERP__Sales_Order__r.AcctSeedERP__Status__c = 'Open'
            AND AcctSeedERP__Product__c = :ProductId
            ORDER BY AcctSeedERP__Sales_Order__r.Name ASC
        ];
        
        if (!ForQuantityOnSalesOrder.isEmpty()) {
            for (AcctSeedERP__Sales_Order_Line__c sol : ForQuantityOnSalesOrder) {
                QuantityOnSalesOrdersMap.put(
                    sol.AcctSeedERP__Sales_Order__c,
                    sol.AcctSeedERP__Sales_Order__r.Name
                );
            }
            
            QuantityOnSalesOrders = [
                SELECT
                AcctSeedERP__Product__c product,
                SUM(AcctSeedERP__Quantity_Needed__c) quantity,
                AcctSeedERP__Sales_Order__c salesorder
                FROM AcctSeedERP__Sales_Order_Line__c
                WHERE
                AcctSeedERP__Sales_Order__r.AcctSeedERP__Status__c = 'Open'
                AND AcctSeedERP__Product__c = :ProductId
                AND AcctSeedERP__Sales_Order__c IN :QuantityOnSalesOrdersMap.keyset()
                AND AcctSeedERP__Quantity_Needed__c > 0
                GROUP BY AcctSeedERP__Product__c, AcctSeedERP__Sales_Order__c
            ];
        }
        
        return QuantityOnSalesOrders;
    }
    
    public Integer getAllocatedOnSalesOrdersTotal() {
        AggregateResult agr = [
            SELECT
            SUM(AcctSeedERP__Quantity_Allocated__c) allocated,
            SUM(AcctSeedERP__Quantity_Shipped__c) shipped
            FROM AcctSeedERP__Sales_Order_Line__c
            WHERE AcctSeedERP__Product__c = :ProductId
        ];
        
        return RoundOffDecimal(
            agr.get('allocated') == null ? 0 : Integer.valueOf(agr.get('allocated')) - 
            Integer.valueOf(agr.get('shipped'))
        );
    }
    public map<id, string> AllocatedOnSalesOrdersMap { get; set; }
    public List<AggregateResult> getAllocatedOnSalesOrders() {
        List<AggregateResult> AllocatedOnSalesOrders = new List<AggregateResult>();
        
        List<AcctSeedERP__Sales_Order_Line__c> ForAllocatedOnSalesOrders = [
            SELECT AcctSeedERP__Sales_Order__c, AcctSeedERP__Sales_Order__r.Name
            FROM AcctSeedERP__Sales_Order_Line__c
            WHERE AcctSeedERP__Product__c = :ProductId
            ORDER BY AcctSeedERP__Sales_Order__r.Name ASC
        ];
        
        if (!ForAllocatedOnSalesOrders.isEmpty()) {
            for (AcctSeedERP__Sales_Order_Line__c sol : ForAllocatedOnSalesOrders) {
                AllocatedOnSalesOrdersMap.put(
                    sol.AcctSeedERP__Sales_Order__c,
                    sol.AcctSeedERP__Sales_Order__r.Name
                );
            }
            
            AllocatedOnSalesOrders = [
                SELECT
                AcctSeedERP__Product__c product,
                SUM(AcctSeedERP__Quantity_Allocated__c) allocated,
                SUM(AcctSeedERP__Quantity_Shipped__c) shipped,
                AcctSeedERP__Sales_Order__c salesorder
                FROM AcctSeedERP__Sales_Order_Line__c
                WHERE
                AcctSeedERP__Product__c = :ProductId
                AND AcctSeedERP__Sales_Order__c IN :AllocatedOnSalesOrdersMap.keyset()
                AND AcctSeedERP__Quantity_Allocated__c > 0
                GROUP BY AcctSeedERP__Product__c, AcctSeedERP__Sales_Order__c
                ORDER BY AcctSeedERP__Sales_Order__c ASC
            ];
            map<string, AggregateResult> agrMap = new map<string, AggregateResult>();
            
            for(AggregateResult agr : AllocatedOnSalesOrders){
                string key = (String)agr.get('salesorder') +';'+ (String)agr.get('product');
                
                Decimal remaining = MATH.ABS((Decimal)agr.get('allocated') - (Decimal)agr.get('shipped'));
                
                if(remaining > 0){ // only eligible records
                    agrMap.put(key, agr);
                    QuantityAllocatedOnSalesOrderMap.put((String)agr.get('salesorder'), (Integer)remaining);
                    
                }
            }
            
            AllocatedOnSalesOrders = agrMap.values();
            
        }
        
        return AllocatedOnSalesOrders;
    }
    
    public Integer getUnreceivedOnPurchaseOrdersTotal() {
        AggregateResult agr = [
            SELECT SUM(AcctSeedERP__Quantity_Unreceived__c) total
            FROM AcctSeedERP__Purchase_Order_Line__c
            WHERE AcctSeedERP__Product__c = :ProductId
        ];
        
        return RoundOffDecimal(agr.get('total') == null ? 0 : Integer.valueOf(agr.get('total')));
    }
    public map<id, string> UnreceivedOnPurchaseOrdersMap { get; set; }
    public List<AggregateResult> getUnreceivedOnPurchaseOrders() {
        List<AggregateResult> UnreceivedOnPurchaseOrders = new List<AggregateResult>();
        
        List<AcctSeedERP__Purchase_Order_Line__c> ForUnreceivedOnPurchaseOrders = [
            SELECT AcctSeedERP__Purchase_Order__c, AcctSeedERP__Purchase_Order__r.Name
            FROM AcctSeedERP__Purchase_Order_Line__c
            WHERE AcctSeedERP__Product__c = :ProductId
            ORDER BY AcctSeedERP__Purchase_Order__r.Name ASC
        ];
        
        if (!ForUnreceivedOnPurchaseOrders.isEmpty()) {
            for (
                AcctSeedERP__Purchase_Order_Line__c pol : ForUnreceivedOnPurchaseOrders
            ) {
                UnreceivedOnPurchaseOrdersMap.put(
                    pol.AcctSeedERP__Purchase_Order__c,
                    pol.AcctSeedERP__Purchase_Order__r.Name
                );
            }
            
            UnreceivedOnPurchaseOrders = [
                SELECT
                AcctSeedERP__Product__c product,
                SUM(AcctSeedERP__Quantity_Unreceived__c) unreceived,
                AcctSeedERP__Purchase_Order__c purchaseorder
                FROM AcctSeedERP__Purchase_Order_Line__c
                WHERE
                AcctSeedERP__Product__c = :ProductId
                AND AcctSeedERP__Purchase_Order__c IN :UnreceivedOnPurchaseOrdersMap.keyset()
                AND AcctSeedERP__Quantity_Unreceived__c > 0
                GROUP BY AcctSeedERP__Product__c, AcctSeedERP__Purchase_Order__c
                ORDER BY AcctSeedERP__Purchase_Order__c ASC
            ];
        }
        
        return UnreceivedOnPurchaseOrders;
    }
    
    public List<AcctSeedERP__Inventory_Balance__c> getInstockQuantity() {
        
        List<AcctSeedERP__Inventory_Balance__c> InstockQuantity = 
            new List<AcctSeedERP__Inventory_Balance__c>();

        AllocatedQuantityMap = new Map<string, decimal>();
        set<id> productIds = new set<id>();
        productIds.add(ProductId);

        AllocatedQuantityMap = InventoryCalculationHelper.CalculateInStock(productIds);
        
        String fields = AllFields.Fields(
            'AcctSeedERP__Inventory_Balance__c',
            new List<String>()
        );
        
        if (AllocatedQuantityMap.size() > 0) {
            set<string> inventoryBalancKeys = AllocatedQuantityMap.keyset();
            
            InstockQuantity = Database.query(
                'Select ' +
                fields +
                ' from AcctSeedERP__Inventory_Balance__c where ' +
                ' AcctSeedERP__Product__c=:ProductId and id in:inventoryBalancKeys order by Name'
            );
        }
        
        return InstockQuantity;
    }
    
    public Integer RoundOffDecimal(Integer num) {
        num = num == null ? 0 : num;
        
        return num;
    }
    
    public void KitInventoryCalculation() {

            Product2 prod = [Select Id, Kit_Available_Quantity__c from Product2 where id =: productId Limit 1];
        
            AvailableList = new list<integer>();
            AllocatedList = new list<integer>();
            InStockList = new list<integer>();
                
            AvailableList.add((Integer)prod.Kit_Available_Quantity__c);    
            AllocatedList.add(0);    
            InStockList.add((Integer)prod.Kit_Available_Quantity__c);
    }
}
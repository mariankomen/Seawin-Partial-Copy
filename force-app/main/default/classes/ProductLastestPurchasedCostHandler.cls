public class ProductLastestPurchasedCostHandler {
    
    public static void AfterCreation(list<AcctSeedERP__Purchase_Order_Line__c> preImage, list<AcctSeedERP__Purchase_Order_Line__c> postImage){
        
        
        Map<id, Decimal> ProductIdsMap = new Map<id, Decimal>();
        
        System.debug('pre image: ' + preImage);
        System.debug('post image: ' + postImage);
        
        integer i = 0;
        for (AcctSeedERP__Purchase_Order_Line__c pstImg : postImage) {
          
            if (pstImg.AcctSeedERP__Quantity_Received__c != preImage[i].AcctSeedERP__Quantity_Received__c) {
                ProductIdsMap.put(pstImg.AcctSeedERP__Product__c, pstImg.AcctSeedERP__Unit_Price__c);
            }
            i++;
        }
      
        List<Product2> productUpdateList = [select id, Last_Cost__c
                                            from Product2
                                            where id in: ProductIdsMap.keyset()];
        
        System.debug('productUpdateList: ' + productUpdateList);
        for(Product2 p : productUpdateList){
            Decimal lastPrice = ProductIdsMap.get(p.Id);
            System.debug('last cost before: ' + p.Last_Cost__c);
            p.Last_Cost__c = lastPrice;
            System.debug('last cost before: ' + p.Last_Cost__c);
        }
        
        update productUpdateList;   
    }
}
@isTest
public class PurchaseOrderShipmentHandlerTest {
    
    @testsetup static void createData(){
        
        TestUtility.CreateData();
    }
    
    @isTest
    public static void coverage(){
        PurchaseOrderShipmentHandler.coverage();
    }
}
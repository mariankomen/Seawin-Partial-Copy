public with sharing class CreateCreditOrderController {

    public Id soId {get; set;}

    public AcctSeedERP__Sales_Order__c sales_order {get; set;}
    public List<AcctSeedERP__Sales_Order_Line__c> so_lines {get; set;}
    public List<LinesWrapper> wrapper_lines {get; set;}
    public Boolean checkAllValues {get; set;}
    
    public CreateCreditOrderController() {
        checkAllValues = false;
        wrapper_lines = new List<LinesWrapper>();
        soId = ApexPages.currentPage().getParameters().get('id');

        sales_order = [SELECT Id,
                                Name,
                                GL_Account_Variable_1__c,
                                AcctSeedERP__Customer__c,
                                Manufacturer_Rep__c,
                                AcctSeedERP__Opportunity__c,
                                Referral_Sales_Rep__c,
                                Sales_Rep_O__c,
                                Specified_Rep__c
                        FROM AcctSeedERP__Sales_Order__c
                        WHERE Id=:soId];
        
        String sol_soql = 'SELECT ' + getSOLFields() + ' FROM AcctSeedERP__Sales_Order_Line__c WHERE AcctSeedERP__Sales_Order__c=:soId ORDER BY SortOrder__c';

        so_lines = (List<AcctSeedERP__Sales_Order_Line__c>)Database.query(sol_soql);

        for(AcctSeedERP__Sales_Order_Line__c line:so_lines){
            line.AcctSeedERP__Quantity_Ordered__c = line.AcctSeedERP__Quantity_Ordered__c * (-1);
            wrapper_lines.add(new LinesWrapper(line));
        }
        system.debug(JSON.serialize(wrapper_lines));
    }

    public void processCheckChange(){
        for(LinesWrapper lw:wrapper_lines){
            lw.selected = checkAllValues;
        }
    }


    public PageReference saveCreating(){
        
        Credit_Order__c credit_order = createCreditOrder();

        List<Credit_Order_Line__c> order_lines = new List<Credit_Order_Line__c>();

        for(LinesWrapper lw:wrapper_lines){
            if(lw.selected){
                AcctSeedERP__Sales_Order_Line__c line = lw.sol;

                Credit_Order_Line__c credit_line = new Credit_Order_Line__c();
                credit_line.Alternate_Image_URL__c = line.AlternateImageURL__c;
                credit_line.Comment__c = line.AcctSeedERP__Comment__c;
                credit_line.Credit_Card_Fee__c = line.Credit_Card_Fee__c;
                credit_line.Credit_Order__c = credit_order.Id;
                credit_line.Description__c = line.AcctSeedERP_Description__c;
                credit_line.GL_Account_Variable_1__c = line.AcctSeedERP__GL_Account_Variable_1__c;
                credit_line.Product__c = line.AcctSeedERP__Product__c;
                credit_line.Quantity_Ordered__c = line.AcctSeedERP__Quantity_Ordered__c;
                credit_line.Size__c = line.Size__c;
                credit_line.Sort_Order__c = line.SortOrder__c;
                credit_line.Unit_Price__c = line.AcctSeedERP__Unit_Price__c;
                credit_line.Sales_Order_Line__c = line.Id;
                credit_line.Sales_Order__c = line.AcctSeedERP__Sales_Order__c;
    
                order_lines.add(credit_line);
            }
            
        }
        insert order_lines;

        PageReference ref = new PageReference('/'+credit_order.Id);
        return ref;
    }

    public Credit_Order__c createCreditOrder(){
        Credit_Order__c order = new Credit_Order__c();
        order.Customer__c = sales_order.AcctSeedERP__Customer__c;
        order.GL_Account_Variable_1__c = sales_order.GL_Account_Variable_1__c;
        order.Manufacturer_Rep__c = sales_order.Manufacturer_Rep__c;
        order.Opportunity__c = sales_order.AcctSeedERP__Opportunity__c;
        order.Referral_Rep__c = sales_order.Referral_Sales_Rep__c;
        order.Sales_Order__c = sales_order.Id;
        order.Sales_Rep_Team__c = sales_order.Sales_Rep_O__c;
        order.Specified_Rep__c = sales_order.Specified_Rep__c;

        insert order;

        return order;
    }



    public String getSOLFields(){
        String fields = '';
        Schema.DescribeSObjectResult r = AcctSeedERP__Sales_Order_Line__c.sObjectType.getDescribe();

        for(String apiName : r.fields.getMap().keySet()){
            fields += apiName + ', ';
        }
        fields += 'AcctSeedERP__Product__r.Name, AcctSeedERP__Product__r.Allow_Product_Description_Change__c';
        //fields = fields.removeEnd(', ');
        return fields;
    }

    public void rerenderAction(){
        Integer i = 0;
    }
    public class LinesWrapper{
        public Boolean selected {get; set;}
        public AcctSeedERP__Sales_Order_Line__c sol {get; set;}

        public LinesWrapper(AcctSeedERP__Sales_Order_Line__c sol_item){
            selected = false;
            sol = sol_item;
        }
    }

}

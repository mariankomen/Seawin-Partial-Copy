public class CommissionFieldsReplicateHandler {

  public static void Replicate(List<AcctSeedERP__Sales_Order__c> data) {
    set<id> soIds = new Set<id>();
    for (AcctSeedERP__Sales_Order__c so : data) {
      soIds.add(so.id);
    }

    if (!soIds.isEmpty()) {
      List<AcctSeedERP__Sales_Order__c> orders = OneBigQuery(soIds);

      //Referral_Fee__c fee = Referral_Fee__c.getOrgDefaults();

      if (!orders.isEmpty()) {
        List<AcctSeedERP__Sales_Order__c> ordersList = new List<AcctSeedERP__Sales_Order__c>();

        for (AcctSeedERP__Sales_Order__c s : orders) {
          Boolean HasManRep = s.Manufacturer_Rep__c != null;
          Boolean HasReferral = s.referral_sales_rep__c != null;
          Boolean HasSpecified = s.specified_rep__c != null;

          if (s.Price_Level__c == null)
            continue;

          Integer priceLevel = Integer.ValueOf(s.Price_Level__c.split(' ')[1]);

          s.Commission_Rate_Sales_Rep__c = Assign_SalesRep_Commission(s, priceLevel, HasManRep);

          if (HasManRep) {
            s.commission_rate_manufacturer_rep__c = Assign_ManufacturerRep_Commission(s, priceLevel);
          }

          if (HasReferral)
            s.commission_rate_referral_sales_rep__c = Assign_ReferralRep_Commission(s, priceLevel);
            
          if (HasSpecified)
            s.commission_rate_specified_rep__c = Assign_SpecifiedRep_Commission(s, priceLevel);

          ordersList.add(s);
        }

        if (!OrdersList.isEmpty())
          update ordersList;
      }
    }
  }
  public static void CopyNewValues(List<AcctSeedERP__Sales_Order__c> od, List<AcctSeedERP__Sales_Order__c> nd) {

    set<id> soIds = new Set<id>();

    Boolean Sales_Rep_Changes = false;
    Boolean Referral_Sales_Rep_Changes = false;
    Boolean Manufacturer_Rep_Changes = false;
    Boolean Specified_Rep_Changes = false;

    Integer i = 0;
    for (AcctSeedERP__Sales_Order__c so : nd) {
      if (so.Sales_Rep_O__c != od[i].Sales_Rep_O__c) {
        Sales_Rep_Changes = true;
        soIds.add(so.id);
      }
      if (so.Referral_Sales_Rep__c != od[i].Referral_Sales_Rep__c) {
        Referral_Sales_Rep_Changes = true;
        soIds.add(so.id);
      }
      if (so.manufacturer_rep__c != od[i].manufacturer_rep__c) {
        Manufacturer_Rep_Changes = true;
        soIds.add(so.id);
      }
      if (so.specified_rep__c != od[i].specified_rep__c) {
        Specified_Rep_Changes = true;
        soIds.add(so.id);
      }
      i++;
    }

    if (!soIds.isEmpty()) {
      List<AcctSeedERP__Sales_Order__c> orders = OneBigQuery(soIds);

      //Referral_Fee__c fee = Referral_Fee__c.getOrgDefaults();

      if (!orders.isEmpty()) {
        List<AcctSeedERP__Sales_Order__c> ordersList = new List<AcctSeedERP__Sales_Order__c>();

        for (AcctSeedERP__Sales_Order__c s : orders) {
          Boolean HasManRep = s.Manufacturer_Rep__c != null;
          Boolean HasReferral = s.referral_sales_rep__c != null;
          Boolean HasSpecified = s.specified_rep__c != null;

          if (s.Price_Level__c == null)
            continue;

          Integer priceLevel = Integer.ValueOf(s.Price_Level__c.split(' ')[1]);

          if (Sales_Rep_Changes) {
            s.Commission_Rate_Sales_Rep__c = Assign_SalesRep_Commission(s, priceLevel, HasManRep);
          }

          if (Manufacturer_Rep_Changes) {
            if (HasManRep) {
              s.commission_rate_manufacturer_rep__c = Assign_ManufacturerRep_Commission(s, priceLevel);
            } else {
              s.commission_rate_manufacturer_rep__c = null;
            }
          }

          if (Referral_Sales_Rep_Changes) {
            if (HasReferral) {
              s.commission_rate_referral_sales_rep__c = Assign_ReferralRep_Commission(s, priceLevel);
            } else {
              s.commission_rate_referral_sales_rep__c = null;
            }
          }
          
          if (Specified_Rep_Changes) {
            if (HasSpecified) {
              s.commission_rate_Specified_rep__c = Assign_SpecifiedRep_Commission(s, priceLevel);
            } else {
              s.commission_rate_Specified_rep__c = null;
            }
          }

          if (Sales_Rep_Changes || Manufacturer_Rep_Changes || Referral_Sales_Rep_Changes
             || Specified_Rep_Changes)
            ordersList.add(s);
        }

        if (!OrdersList.isEmpty())
          update ordersList;
      }
    }
  }

  public static List<AcctSeedERP__Sales_Order__c> OneBigQuery(set<Id> soIds){

    List<AcctSeedERP__Sales_Order__c> orders = new List<AcctSeedERP__Sales_Order__c>();

    orders = [
        SELECT
          id,
          Commission_Rate_Sales_Rep__c,
          commission_rate_manufacturer_rep__c,
          commission_rate_referral_sales_rep__c,
          commission_rate_specified_rep__c,
          referral_sales_rep__c,
          Manufacturer_Rep__c,
          Specified_Rep__c,
          Price_Level__c,
          Manufacturer_Rep__r.Price_Level_1_12__c,
          Manufacturer_Rep__r.Price_Level_13_20__c,
          Manufacturer_Rep__r.Price_Level_21_26__c,
          Manufacturer_Rep__r.Price_Level_27_30__c,
          Specified_Rep__r.Price_Level_1_12__c,
          Specified_Rep__r.Price_Level_13_20__c,
          Specified_Rep__r.Price_Level_21_26__c,
          Specified_Rep__r.Price_Level_27_30__c,
          Sales_Rep_O__r.Price_Level_1_12__c,
          Sales_Rep_O__r.Price_Level_13_20__c,
          Sales_Rep_O__r.Price_Level_21_26__c,
          Sales_Rep_O__r.Price_Level_27_30__c,
          Sales_Rep_O__r.Man_Rep_Price_Level_1_12__c,
          Sales_Rep_O__r.Man_Rep_Price_Level_13_20__c,
          Sales_Rep_O__r.Man_Rep_Price_Level_21_26__c,
          Sales_Rep_O__r.Man_Rep_Price_Level_27_30__c,
          referral_sales_rep__r.Ref_Rep_Price_Level_1_12__c,
          referral_sales_rep__r.Ref_Rep_Price_Level_13_20__c,
          referral_sales_rep__r.Ref_Rep_Price_Level_21_26__c,
          referral_sales_rep__r.Ref_Rep_Price_Level_27_30__c
          FROM AcctSeedERP__Sales_Order__c
          WHERE id IN :soIds
        ];

      return orders;
  }

  public static Decimal Assign_SalesRep_Commission(AcctSeedERP__Sales_Order__c s, 
  Integer priceLevel, Boolean HasManRep){

    s.Commission_Rate_Sales_Rep__c = (priceLevel >= 1 &&
            priceLevel <= 12 &&
            HasManRep)
            ? s.Sales_Rep_O__r.Man_Rep_Price_Level_1_12__c
            : (priceLevel >= 13 &&
                priceLevel <= 20 &&
                HasManRep)
                ? s.Sales_Rep_O__r.Man_Rep_Price_Level_13_20__c
                : (priceLevel >= 21 &&
                    priceLevel <= 26 &&
                    HasManRep)
                    ? s.Sales_Rep_O__r.Man_Rep_Price_Level_21_26__c
                    : (priceLevel >= 27 &&
                        priceLevel <= 30 &&
                        HasManRep)
                        ? s.Sales_Rep_O__r.Man_Rep_Price_Level_27_30__c
                        : (priceLevel >= 1 &&
                            priceLevel <= 12)
                            ? s.Sales_Rep_O__r.Price_Level_1_12__c
                            : (priceLevel >= 13 &&
                                priceLevel <= 20)
                                ? s.Sales_Rep_O__r.Price_Level_13_20__c
                                : (priceLevel >= 21 &&
                                    priceLevel <= 26)
                                    ? s.Sales_Rep_O__r.Price_Level_21_26__c
                                    : s.Sales_Rep_O__r.Price_Level_27_30__c;

                                    return s.Commission_Rate_Sales_Rep__c;
  }

  public static Decimal Assign_ManufacturerRep_Commission(AcctSeedERP__Sales_Order__c s, Integer priceLevel){
    
    s.commission_rate_manufacturer_rep__c = (priceLevel >= 1 &&
              priceLevel <= 12)
              ? s.Manufacturer_Rep__r.Price_Level_1_12__c
              : (priceLevel >= 13 &&
                  priceLevel <= 20)
                  ? s.Manufacturer_Rep__r.Price_Level_13_20__c
                  : (priceLevel >= 21 &&
                      priceLevel <= 26)
                      ? s.Manufacturer_Rep__r.Price_Level_21_26__c
                      : s.Manufacturer_Rep__r.Price_Level_27_30__c;

                      return s.commission_rate_manufacturer_rep__c;
  }
    
  public static Decimal Assign_SpecifiedRep_Commission(AcctSeedERP__Sales_Order__c s, Integer priceLevel){
    
    s.commission_rate_Specified_rep__c = (priceLevel >= 1 &&
              priceLevel <= 12)
              ? s.Specified_Rep__r.Price_Level_1_12__c
              : (priceLevel >= 13 &&
                  priceLevel <= 20)
                  ? s.Specified_Rep__r.Price_Level_13_20__c
                  : (priceLevel >= 21 &&
                      priceLevel <= 26)
                      ? s.Specified_Rep__r.Price_Level_21_26__c
                      : s.Specified_Rep__r.Price_Level_27_30__c;

                      return s.commission_rate_Specified_rep__c;
  }

  public static Decimal Assign_ReferralRep_Commission(AcctSeedERP__Sales_Order__c s, Integer priceLevel){

    s.commission_rate_referral_sales_rep__c = (priceLevel >= 1 &&
                            priceLevel <= 12)
                            ? s.referral_sales_rep__r.Ref_Rep_Price_Level_1_12__c
                            : (priceLevel >= 13 &&
                                priceLevel <= 20)
                                ? s.referral_sales_rep__r.Ref_Rep_Price_Level_13_20__c
                                : (priceLevel >= 21 &&
                                    priceLevel <= 26)
                                    ? s.referral_sales_rep__r.Ref_Rep_Price_Level_21_26__c
                                    : s.referral_sales_rep__r.Ref_Rep_Price_Level_27_30__c;

                                    return s.commission_rate_referral_sales_rep__c;
  }
}
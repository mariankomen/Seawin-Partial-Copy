global without sharing class HospitalityDashboardUSAController extends MainSalesManagerDashboardUSACtrl {

    @RemoteAction
    @ReadOnly
    global static map<String, List<ValuesWrapper>> Monthly_Sales_Last_12_Months() {

        DateTime Full_Start_Date = Full_Start_Date();
        DateTime Full_End_Date = Full_End_Date();

        set<String> All_SalesReps = getAll_SalesReps();
        List<String> Months = Months();
        List<String> Last12MonthsList = Last12MonthsList();

        map<String, List<ValuesWrapper>> MonthlySalesMapLocal = new Map<string, List<ValuesWrapper>>();
        
        List<AggregateResult> MonthlySalesData = [select sales_rep_o__r.name name, calendar_month(CreatedDate) month,
        calendar_year(CreatedDate) year,
        sum(AcctSeederp__total__c) amount from AcctSeederp__sales_order__c
        where CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date
        and RecordType.name = 'Seawin USA Hospitality'
        and GL_Account_Variable_1__r.Name = 'Seawin USA'
        and Sales_rep_o__r.name in:All_SalesReps
        and AcctSeederp__total__c > 0
        group by Sales_rep_o__r.name,calendar_month(CreatedDate),
        calendar_year(CreatedDate)
        order by Sales_rep_o__r.name, calendar_year(CreatedDate),
        calendar_month(CreatedDate) asc];

        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        
        if (!MonthlySalesData.isEmpty()) {
            for (AggregateResult so : MonthlySalesData) {
                string key = (string) so.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                    Last12MonthsList.indexOf(Months[(Integer) so.get('month') - 1]),
                    Months[(Integer) so.get('month') - 1],
                    Months[(Integer) so.get('month') - 1],
                            (Decimal) so.get('amount'),
                            (Integer) so.get('year'),
                            null,
                            null
                        );
                
                if (MonthlySalesMapLocal.containskey(key)) {
                    
                    ValuesList = MonthlySalesMapLocal.get(key);
                    ValuesList.add(vw);
                } else {
                    
                    ValuesList.add(vw);
                }
                
                MonthlySalesMapLocal.put(key, ValuesList);
            }
        }
        if (MonthlySalesMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(MonthlySalesMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (MonthlySalesMapLocal.containskey(s)) {
                    sortedMap.put(s, MonthlySalesMapLocal.get(s));
                }
            }
            MonthlySalesMapLocal = sortedMap;
        }

        return MonthlySalesMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Current_Sales_Contest_QTD() {

        Set<string> Active_SalesReps = Active_SalesReps();

        map<string, List<ValuesWrapper>> ContestQMapLocal = new Map<string, List<ValuesWrapper>>();

        List<ValuesWrapper> ContestQList = new List<ValuesWrapper>();
        
        List<AggregateResult> ContestResult = [select sales_rep_o__r.name name,sum(AcctSeederp__total__c) amount,
        calendar_year(CreatedDate) year,calendar_month(CreatedDate) month
                                               from AcctSeederp__sales_order__c
                                              where CreatedDate = THIS_QUARTER
                                              and sales_rep_o__r.name in:Active_SalesReps
                                              and recordtype.name ='Seawin USA Hospitality'
                                              and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                              and AcctSeederp__total__c > 0
                                              group by Sales_rep_o__r.name, 
                                              calendar_year(CreatedDate),calendar_month(CreatedDate)
                                              order by Sales_rep_o__r.name,calendar_year(CreatedDate),
                                               calendar_month(CreatedDate) asc ];

        Period prd = [Select StartDate, EndDate From Period Where type = 'Quarter' and StartDate = 
        THIS_FISCAL_QUARTER];

        Integer QuarterStartMonth = prd.StartDate.month();
        Integer QuarterEndMonth = prd.EndDate.month();

        
        if (!ContestResult.isEmpty()) {

            Integer quarterIndex = 0;

            for (AggregateResult so : ContestResult) {

                ContestQList = new List<ValuesWrapper>();

                string key = (string) so.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;

                // Quarter data
                //if((Integer)so.get('month') >= QuarterStartMonth && (Integer)so.get('month') <= QuarterEndMonth){

                    ContestQList.add(
                            new ValuesWrapper(
                                quarterIndex,
                                null,
                                null,
                                ((Decimal) so.get('amount') == null)
                                ? 0
                                : (Decimal) so.get('amount'),
                                null,
                                null,
                                null
                            )
                        );

                    if(ContestQMapLocal.containsKey(key)){

                        ContestQList = ContestQMapLocal.get(key);

                        for(ValuesWrapper vw : ContestQList){

                            vw.amount += (Decimal) so.get('amount') == null
                            ? 0
                            : (Decimal) so.get('amount');
                        }

                        ContestQMapLocal.put(key, ContestQList);
                    }else{
                        quarterIndex++;
                    }

                    ContestQMapLocal.put(key, ContestQList);
                //}
            }
        }
        if (ContestQMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(ContestQMapLocal);

            map<string, List<ValuesWrapper>> sortedQMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (ContestQMapLocal.containskey(s)) {
                    sortedQMap.put(s, ContestQMapLocal.get(s));
                }
            }

            // Quarter data map
            ContestQMapLocal = sortedQMap;
            //SalesContestQTDKeys = sortedQMap.keyset();
        }
        
        return ContestQMapLocal;
    }
	
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Current_Sales_Contest_TM() {

        Date d = getTodayDate();

        Set<string> Active_SalesReps = Active_SalesReps();

        map<string, List<ValuesWrapper>> ContestTMMapLocal = new Map<string, List<ValuesWrapper>>();

        List<ValuesWrapper> ContestTMList = new List<ValuesWrapper>();

        
        List<AggregateResult> ContestResult = [select sales_rep_o__r.name name,sum(AcctSeederp__total__c) amount,
        calendar_year(CreatedDate) year,calendar_month(CreatedDate) month
                                               from AcctSeederp__sales_order__c
                                              where CreatedDate = THIS_MONTH
                                              and sales_rep_o__r.name in:Active_SalesReps
                                              and recordtype.name ='Seawin USA Hospitality'
                                              and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                              and AcctSeederp__total__c > 0
                                              group by Sales_rep_o__r.name, 
                                              calendar_year(CreatedDate),calendar_month(CreatedDate)
                                              order by Sales_rep_o__r.name,calendar_year(CreatedDate),
                                               calendar_month(CreatedDate) asc ];

        Period prd = [Select StartDate, EndDate From Period Where type = 'Quarter' and StartDate = 
        THIS_FISCAL_QUARTER];

        Integer QuarterStartMonth = prd.StartDate.month();
        Integer QuarterEndMonth = prd.EndDate.month();

        
        if (!ContestResult.isEmpty()) {

            Integer monthIndex = 0;

            for (AggregateResult so : ContestResult) {

                string key = (string) so.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;

                // Month data
                if((Integer)so.get('month') == d.month()){

                    ContestTMList.add(
                            new ValuesWrapper(
                                monthIndex,
                                null,
                                null,
                                ((Decimal) so.get('amount') == null)
                                ? 0
                                : (Decimal) so.get('amount'),
                                null,
                                null,
                                null
                            )
                        );

                    ContestTMMapLocal.put(key, ContestTMList);
                    monthIndex++;
                }
            }
        }
        if (ContestTMMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(ContestTMMapLocal);

            map<string, List<ValuesWrapper>> sortedTMMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (ContestTMMapLocal.containskey(s)) {
                    sortedTMMap.put(s, ContestTMMapLocal.get(s));
                }
            }
            
            // Month data map
            ContestTMMapLocal = sortedTMMap;
            //SalesContestTMKeys = sortedTMMap.keyset();
        }
        
        return ContestTMMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Current_Sales_Contest_YTD() {

        Set<string> Active_SalesReps = Active_SalesReps();

        map<string, List<ValuesWrapper>> ContestYMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ContestYList = new List<ValuesWrapper>();
        
        List<AggregateResult> ContestResult = [select sales_rep_o__r.name name,sum(AcctSeederp__total__c) amount,
        calendar_year(CreatedDate) year,calendar_month(CreatedDate) month
                                               from AcctSeederp__sales_order__c
                                              where CreatedDate = THIS_YEAR
                                              and sales_rep_o__r.name in:Active_SalesReps
                                              and recordtype.name ='Seawin USA Hospitality'
                                              and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                              and AcctSeederp__total__c > 0
                                              group by Sales_rep_o__r.name, 
                                              calendar_year(CreatedDate),calendar_month(CreatedDate)
                                              order by Sales_rep_o__r.name,calendar_year(CreatedDate),
                                               calendar_month(CreatedDate) asc ];

        Period prd = [Select StartDate, EndDate From Period Where type = 'Quarter' and StartDate = 
        THIS_FISCAL_QUARTER];

        Integer QuarterStartMonth = prd.StartDate.month();
        Integer QuarterEndMonth = prd.EndDate.month();

        
        if (!ContestResult.isEmpty()) {

            Integer yearIndex = 0;

            for (AggregateResult so : ContestResult) {

                ContestYList = new List<ValuesWrapper>();

                string key = (string) so.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;

                ContestYList.add(
                    new ValuesWrapper(
                        yearIndex,
                        null,
                        null,
                        ((Decimal) so.get('amount') == null)
                        ? 0
                        : (Decimal) so.get('amount'),
                        null,
                        null,
                        null
                    )
                );

                if(ContestYMapLocal.containsKey(key)){

                    ContestYList = ContestYMapLocal.get(key);

                    for(ValuesWrapper vw : ContestYList){

                        vw.amount += (Decimal) so.get('amount') == null
                        ? 0
                        : (Decimal) so.get('amount');
                    }
                }else{
                        
                        yearIndex++;
                }

                ContestYMapLocal.put(key, ContestYList);
                
            }
        }
        if (ContestYMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(ContestYMapLocal);

            map<string, List<ValuesWrapper>> sortedYMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (ContestYMapLocal.containskey(s)) {
                    sortedYMap.put(s, ContestYMapLocal.get(s));
                }
            }

            ContestYMapLocal = sortedYMap;
            //SalesContestYTDKeys = sortedYMap.keyset();
        }
        
        return ContestYMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static Decimal Team_Quota_YTD_Check() {

        Date d = getTodayDate();

        Set<string> All_SalesReps = getAll_SalesReps();
        
        List<AggregateResult> Aggregates = new List<AggregateResult>();

        String sdate_str = d.year() + '-01-01T00:00:00.000Z';
        DateTime YearStartDate = DateTime.ValueofGmt(sdate_str.replace('T', ' '));
        
        DateTime YearToDateDate = DateTime.now();
        
        Aggregates = [
            SELECT sum(acctseederp__total__c) sum, Sales_Rep_o__c salesrepid
            FROM acctseederp__sales_order__c
            WHERE
            CreatedDate >= :YearStartDate
            AND CreatedDate <= :YearToDateDate
            AND recordtype.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND Sales_Rep_o__r.name IN :All_SalesReps
            group by Sales_Rep_o__c
        ];

        set<id> salesrepIds = new set<id>();

        for(AggregateResult agr : Aggregates){

            salesrepIds.add((Id)agr.get('salesrepid'));
        }

        Decimal UptodateQuota = 0;
        
        if (!salesrepIds.isEmpty()) {
            for (Sales_rep__c s : [select id, name, Monthly_Quota__c, InActive_date__c, CreatedDate from Sales_rep__c
            where id in:salesrepIds]) {
                Decimal qamt = s.Monthly_Quota__c == null ? 0 : s.Monthly_Quota__c;
                UptodateQuota += CalculateUptoDateQuota(
                    qamt,
                    s.InActive_date__c,
                    s.CreatedDate
                );
            }
        }
        
        return UptodateQuota;
    }
    
    @RemoteAction
    @ReadOnly
    global static List<AggregateResult> Team_Quota_YTD() {

        Date d = getTodayDate();

        Set<string> All_SalesReps = getAll_SalesReps();
        
        List<AggregateResult> Aggregates = new List<AggregateResult>();
        
        Decimal UptodateQuota = 0;
            
        String sdate_str = d.year() + '-01-01T00:00:00.000Z';
        DateTime YearStartDate = DateTime.ValueofGmt(sdate_str.replace('T', ' '));
        
        DateTime YearToDateDate = DateTime.now();
        
        Aggregates = [
            SELECT sum(acctseederp__total__c) sum
            FROM acctseederp__sales_order__c
            WHERE
            CreatedDate >= :YearStartDate
            AND CreatedDate <= :YearToDateDate
            AND recordtype.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.name = 'Seawin USA'
            AND Sales_Rep_o__r.name IN :All_SalesReps
        ];
        
        return Aggregates;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, Decimal> Team_Quota_Percent() {

        Date d = getTodayDate();

        Set<string> All_SalesReps = getAll_SalesReps();

        map<string, Decimal> TeamQuotaPercentMapLocal = new Map<string, Decimal>();
        
        String sdate_str = d.year() + '-01-01T00:00:00.000Z';
        DateTime YearStartDate = DateTime.ValueofGmt(sdate_str.replace('T', ' '));
        
        DateTime YearToDateDate = DateTime.now();
        
        List<AggregateResult> Aggregates = [
            SELECT sum(acctseederp__total__c) sum, Sales_Rep_o__r.name name
            FROM acctseederp__sales_order__c
            WHERE
            CreatedDate >= :YearStartDate
            AND CreatedDate <= :YearToDateDate
            AND recordtype.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.name = 'Seawin USA'
            AND Sales_Rep_o__r.name IN :All_SalesReps
            AND acctseederp__total__c > 0
            GROUP BY Sales_Rep_o__r.name
        ];
        
        map<string, decimal> AmountMap = new Map<string, decimal>();

        set<string> salesrepnames = new set<string>();
        
        if (!Aggregates.isEmpty()) {
            for (AggregateResult ar : Aggregates) {
                AmountMap.put((String) ar.get('name'), (Decimal) ar.get('sum'));

                salesrepnames.add((String) ar.get('name'));
            }
        }
        
        if (AmountMap.size() > 0) {
            
            if (!salesrepnames.isEmpty()) {
                for (Sales_rep__c s : [select id, name, Monthly_Quota__c, InActive_date__c, CreatedDate from Sales_rep__c
                where name in:salesrepnames]) {
                    if (s.Monthly_Quota__c != null && s.Monthly_Quota__c != 0) {
                        Decimal q = CalculateUptoDateQuota(
                            s.Monthly_Quota__c,
                            s.InActive_date__c,
                            s.CreatedDate
                        );
                        
                        if (AmountMap.containsKey(s.Name)) {
                            Decimal amt = AmountMap.get(s.Name);
                            
                            Decimal prcnt = q > 0 ? (amt / q) * 100 : 0;
                            
                            TeamQuotaPercentMapLocal.put(s.Name, prcnt.setScale(2));
                        }
                    } else {
                        //Client requirement add all reps
                        TeamQuotaPercentMapLocal.put(s.Name, 0.0);
                    }
                }
                
                if (TeamQuotaPercentMapLocal.size() > 0) {
                    //Old Logic sorting based on percentage
                    List<String> sortedKeys = sortEngine(TeamQuotaPercentMapLocal);
                    
                    //New Logic for sorting based on Names
                    //List<String> sortedKeys = this.sortMapEngine(TeamQuotaPercentMapLocal);
                    
                    map<string, decimal> sortedMap = new Map<string, decimal>();
                    
                    for (string k : sortedKeys) {
                        if (TeamQuotaPercentMapLocal.containskey(k)) {
                            sortedMap.put(k, TeamQuotaPercentMapLocal.get(k));
                        }
                    }

                    TeamQuotaPercentMapLocal = sortedMap;
                    
                    // TeamQuotaPercentMap = sortedMap;
                    // TeamQuotaPercentKeys = TeamQuotaPercentMap.keyset();
                }
            }
        }

        return TeamQuotaPercentMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Sales_Forecast_Pipeline() {

        List<String> Next12MonthsList = Next12MonthsList();

        Date d = getTodayDate();

        Set<string> All_SalesReps = getAll_SalesReps();

        List<String> Months = Months();

        map<string, decimal> MissedOpptysMap = new Map<string, decimal>();
        
        Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
        Date Future_Date = Pipeline_Start_Date.addMonths(11);
        
        Date Pipeline_End_Date = Date.newInstance(
            Future_Date.year(),
            Future_Date.month(),
            Date.daysInMonth(Future_Date.year(), Future_Date.month())
        );
        
        List<AggregateResult> MissedForecasts = [select sales_rep_o__r.name name, Sum(ExpectedRevenue) amount from opportunity
                                                Where CloseDate <: Pipeline_Start_Date
                                                and RecordType.name = 'Seawin USA Hospitality'
                                                and GL_Account_Variable_1__r.name = 'Seawin USA'
                                                and sales_rep_o__r.name in:All_SalesReps
                                                and ForecastCategoryName = 'Pipeline'
                                                group by sales_rep_o__r.name];
        
        if (!MissedForecasts.isEmpty()) {
            for (aggregateresult agr : Missedforecasts) {
                MissedOpptysMap.put(
                    (String) agr.get('name'),
                    (decimal) agr.get('amount')
                );
            }
        }
        
        List<AggregateResult> forecasts = [select sales_rep_o__r.name name,calendar_month(CloseDate) month,calendar_year(closedate) year,
                                          Sum(ExpectedRevenue) amount from opportunity
                                          Where CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date
                                          and RecordType.name = 'Seawin USA Hospitality'
                                          and GL_Account_Variable_1__r.name = 'Seawin USA'
                                          and sales_rep_o__r.name in:All_SalesReps
                                          and ForecastCategoryName = 'Pipeline'
                                          group by sales_rep_o__r.name, calendar_month(closedate), calendar_year(closedate)
                                          order by calendar_year(closedate) asc];
        
        map<string, List<ValuesWrapper>> ForecastMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        if (!forecasts.isEmpty()) {
            for (AggregateResult a : forecasts) {
                string key = (String) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                Decimal missedAmount = MissedOpptysMap.containsKey(key)
                    ? MissedOpptysMap.get(key)
                    : 0;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                            Next12MonthsList.indexOf(Months[(Integer) a.get('month') - 1]),
                            Months[(Integer) a.get('month') - 1],
                            (String) a.get('name'),
                            (Decimal) a.get('amount'),
                            (Integer) a.get('year'),
                            null,
                            MissedAmount
                        );
                
                if (ForecastMapLocal.containsKey(key)) {
                    
                    ValuesList = ForecastMapLocal.get(key);
                    ValuesList.add(vw);
                } else {

                    ValuesList.add(vw);
                }
                
                ForecastMapLocal.put(key, ValuesList);
            }
        }
        if (ForecastMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(ForecastMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (ForecastMapLocal.containskey(s)) {
                    sortedMap.put(s, ForecastMapLocal.get(s));
                }
            }
            
            ForecastMapLocal = sortedMap;
            
            //ForecastKeys = ForecastMapLocal.keyset();
            //ForecastMap = ForecastMapLocal;
        }

        return ForecastMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Company_Total_Pipeline_Last_12_Months() {

        DateTime Full_End_Date = Full_End_Date();

        Date Only_Start_Date = Only_Start_Date();

        Set<string> All_SalesReps = getAll_SalesReps();

        Map<string, integer> Last12MonthsList_CombinedMap = Last12MonthsList_CombinedMap();
        
        List<AggregateResult> Open = [
            SELECT
            Sum(amount) amount,
            calendar_month(createddate) month,
            calendar_year(createddate) year
            FROM opportunity
            WHERE
            createddate <= :Full_End_Date
            AND Sales_Rep_o__r.Name IN :All_SalesReps
            AND ForecastCategoryName != 'Omitted'
            AND RecordType.Name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND amount > 0
            AND amount != NULL
            GROUP BY calendar_year(createddate), calendar_month(createddate)
            ORDER BY calendar_year(createddate), calendar_month(createddate) ASC
        ];
        
        // if Closed Date is 1 Oct 2019 - Will appear in Oct 2019.
        // if Closed Date is 15 Nov 2019 - Will appear in Nov 2019.
        
        map<string, List<ValuesWrapper>> CompanyTotalPipelineMapLocal = new Map<string, List<ValuesWrapper>>();
        
        String key = 'Company Total Pipeline Last 12 Months';
        
        map<Integer, Decimal> Open_MonthAmountMap = new Map<Integer, Decimal>();
        if (!Open.isEmpty()) {
            for (AggregateResult a : Open) {
                Integer m = (Integer) a.get('month');
                Integer y = (Integer) a.get('year');
                Decimal amt = (Decimal) a.get('amount');
                
                Integer MonthIndex = Last12MonthsList_CombinedMap.containsKey(
                    m +
                    '-' +
                    y
                )
                    ? Last12MonthsList_CombinedMap.get(m + '-' + y)
                    : 0;
                
                Open_MonthAmountMap.put(
                    MonthIndex,
                    Open_MonthAmountMap.containsKey(MonthIndex)
                    ? Open_MonthAmountMap.get(MonthIndex) + amt
                    : amt
                );
            }
        }
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        
        Decimal TotalAmount = 0;
        
        Decimal PipelineAmount = 0;
        
        for (Integer i = 0; i < 12; i++) {
            if (Open_MonthAmountMap.containsKey(i)) {
                PipelineAmount += Open_MonthAmountMap.get(i);
            }
            
            TotalAmount = PipelineAmount;
            
            if (TotalAmount > 0)
                ValuesList.add(
                    new ValuesWrapper(i, null, null, TotalAmount, 0, null, 0)
                );
        }
        
        if (!ValuesList.isEmpty())
            CompanyTotalPipelineMapLocal.put(key, ValuesList);
        
        //if (CompanyTotalPipelineMapLocal.size() > 0) {
            //TotalPipelineMapLocal = this.SortByValues(TotalPipelineMapLocal);
            
           // CompanyTotalPipelineKeys = CompanyTotalPipelineMapLocal.keyset();
           // CompanyTotalPipelineMap = CompanyTotalPipelineMapLocal;
        //}
        return CompanyTotalPipelineMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Sales_Reps_Total_Pipeline_Last_12_Months() {

        DateTime Full_End_Date = Full_End_Date();

        Date Only_Start_Date = Only_Start_Date();

        Set<string> All_SalesReps = getAll_SalesReps();

        Map<string, integer> Last12MonthsList_CombinedMap = Last12MonthsList_CombinedMap();
        
        List<AggregateResult> Open = [
            SELECT
            Sum(amount) amount,
            Sales_Rep_o__r.Name name,
            calendar_month(createddate) month,
            calendar_year(createddate) year
            FROM opportunity
            WHERE
            createddate <= :Full_End_Date
            AND Sales_Rep_o__r.Name IN :All_SalesReps
            AND ForecastCategoryName != 'Omitted'
            AND Recordtype.Name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND amount > 0
            AND amount != NULL
            GROUP BY
            Sales_Rep_o__r.Name,
            calendar_year(createddate),
            calendar_month(createddate)
            
            ORDER BY
            Sales_Rep_o__r.Name,
            calendar_year(createddate),
            calendar_month(createddate) ASC
        ];
        
        map<string, List<ValuesWrapper>> SalesRepTotalPipelineMapLocal = new Map<string, List<ValuesWrapper>>();
        map<string, map<Integer, Decimal>> Open_SalesAmountMap = new Map<string, map<Integer, Decimal>>();
        
        map<Integer, Decimal> MonthAmountMap = new Map<Integer, Decimal>();
        
        if (!Open.isEmpty()) {
            MonthAmountMap = new Map<Integer, Decimal>();
            for (AggregateResult a : Open) {
                String key = (String) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                Integer m = (Integer) a.get('month');
                Integer y = (Integer) a.get('year');
                Decimal amt = (Decimal) a.get('amount');
                
                Date dt = Date.newInstance(y, m, 1);
                
                Integer MonthIndex = dt >= Only_Start_Date
                    ? Last12MonthsList_CombinedMap.get(m + '-' + y)
                    : 0;
                
                if (Open_SalesAmountMap.containsKey(key)) {
                    map<integer, Decimal> maps = Open_SalesAmountMap.get(key);
                    
                    maps.put(
                        MonthIndex,
                        MonthAmountMap.containsKey(MonthIndex)
                        ? MonthAmountMap.get(MonthIndex) + amt
                        : amt
                    );
                    Open_SalesAmountMap.put(key, maps);
                } else {
                    MonthAmountMap = new Map<Integer, Decimal>();
                    
                    MonthAmountMap.put(
                        MonthIndex,
                        MonthAmountMap.containsKey(MonthIndex)
                        ? MonthAmountMap.get(MonthIndex) + amt
                        : amt
                    );
                    
                    Open_SalesAmountMap.put(key, MonthAmountMap);
                }
            }
        }
        
        Set<string> SalesRepKeys = new Set<string>(Open_SalesAmountMap.Keyset());
        
        for (String key : SalesRepKeys) {
            map<Integer, Decimal> SalesRepMap_Open = Open_SalesAmountMap.get(key);
            
            List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
            
            Decimal TotalAmount = 0;
            Decimal PipelineAmount = 0;
            
            for (Integer i = 0; i < 12; i++) {
                if (SalesRepMap_Open != null) {
                    if (SalesRepMap_Open.containsKey(i)) {
                        PipelineAmount += SalesRepMap_Open.get(i) == null
                            ? 0
                            : SalesRepMap_Open.get(i);
                    }
                }
                
                TotalAmount = PipelineAmount;
                
                if (TotalAmount > 0)
                    ValuesList.add(
                        new ValuesWrapper(i, null, null, TotalAmount, 0, null, 0)
                    );
            }
            
            SalesRepTotalPipelineMapLocal.put(key, ValuesList);
        }
        if (SalesRepTotalPipelineMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(SalesRepTotalPipelineMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (SalesRepTotalPipelineMapLocal.containskey(s)) {
                    sortedMap.put(s, SalesRepTotalPipelineMapLocal.get(s));
                }
            }
            SalesRepTotalPipelineMapLocal = sortedMap;
            
            //SalesRepTotalPipelineKeys = SalesRepTotalPipelineMapLocal.keyset();
            //SalesRepTotalPipelineMap = SalesRepTotalPipelineMapLocal;
        }

        return SalesRepTotalPipelineMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Pipeline_Last_12_Months_By_Lead_Source() {

        DateTime Full_End_Date = Full_End_Date();

        Date Only_Start_Date = Only_Start_Date();

        Set<string> All_SalesReps = getAll_SalesReps();

        Map<string, integer> Last12MonthsList_CombinedMap = Last12MonthsList_CombinedMap();
        
        List<AggregateResult> Open = [
            SELECT
            Sum(amount) amount,
            LeadSource,
            calendar_month(createddate) month,
            calendar_year(createddate) year
            FROM opportunity
            WHERE
            createddate <= :Full_End_Date
            AND Sales_Rep_o__r.Name IN :All_SalesReps
            AND ForecastCategoryName != 'Omitted'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND amount > 0
            AND amount != NULL
            GROUP BY
            LeadSource,
            calendar_year(createddate),
            calendar_month(createddate)
            
            ORDER BY
            LeadSource,
            calendar_year(createddate),
            calendar_month(createddate) ASC
        ];
        
        map<string, List<ValuesWrapper>> TotalPipelineByLeadSourceMapLocal = new Map<string, List<ValuesWrapper>>();
        map<string, map<Integer, Decimal>> Open_SalesAmountMap = new Map<string, map<Integer, Decimal>>();
        
        map<Integer, Decimal> MonthAmountMap = new Map<Integer, Decimal>();
        
        if (!Open.isEmpty()) {
            MonthAmountMap = new Map<Integer, Decimal>();
            for (AggregateResult a : Open) {
                String key = a.get('LeadSource') != null && 
                (String)a.get('LeadSource') != 'NA' && (String)a.get('LeadSource') != 'N/A' ? 
                (String) a.get('LeadSource') : 'N/A';
                key = String.isNotEmpty(key) && key != 'N/A' ? key.capitalize() : key;
                
                Integer m = (Integer) a.get('month');
                Integer y = (Integer) a.get('year');
                Decimal amt = (Decimal) a.get('amount');
                
                Date dt = Date.newInstance(y, m, 1);
                
                Integer MonthIndex = dt >= Only_Start_Date
                    ? Last12MonthsList_CombinedMap.get(m + '-' + y)
                    : 0;
                
                if (Open_SalesAmountMap.containsKey(key)) {
                    map<integer, Decimal> maps = Open_SalesAmountMap.get(key);
                    
                    maps.put(
                        MonthIndex,
                        MonthAmountMap.containsKey(MonthIndex)
                        ? MonthAmountMap.get(MonthIndex) + amt
                        : amt
                    );
                    Open_SalesAmountMap.put(key, maps);
                } else {
                    MonthAmountMap = new Map<Integer, Decimal>();
                    
                    MonthAmountMap.put(
                        MonthIndex,
                        MonthAmountMap.containsKey(MonthIndex)
                        ? MonthAmountMap.get(MonthIndex) + amt
                        : amt
                    );
                    
                    Open_SalesAmountMap.put(key, MonthAmountMap);
                }
            }
        }
        
        Set<string> SalesRepKeys = new Set<string>(Open_SalesAmountMap.Keyset());
        
        for (String key : SalesRepKeys) {
            map<Integer, Decimal> SalesRepMap_Open = Open_SalesAmountMap.get(key);
            
            List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
            
            Decimal TotalAmount = 0;
            Decimal PipelineAmount = 0;
            
            for (Integer i = 0; i < 12; i++) {
                if (SalesRepMap_Open != null) {
                    if (SalesRepMap_Open.containsKey(i)) {
                        PipelineAmount += SalesRepMap_Open.get(i) == null
                            ? 0
                            : SalesRepMap_Open.get(i);
                    }
                }
                
                TotalAmount = PipelineAmount;
                
                if (TotalAmount > 0)
                    ValuesList.add(
                        new ValuesWrapper(i, null, null, TotalAmount, 0, null, 0)
                    );
            }
            
            TotalPipelineByLeadSourceMapLocal.put(key, ValuesList);
        }
        if (TotalPipelineByLeadSourceMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(
                TotalPipelineByLeadSourceMapLocal
            );
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (TotalPipelineByLeadSourceMapLocal.containskey(s)) {
                    sortedMap.put(s, TotalPipelineByLeadSourceMapLocal.get(s));
                }
            }
            TotalPipelineByLeadSourceMapLocal = sortedMap;
            
            //TotalPipelineByLeadSourceKeys = TotalPipelineByLeadSourceMapLocal.keyset();
            //TotalPipelineByLeadSourceMap = TotalPipelineByLeadSourceMapLocal;
        }

        return TotalPipelineByLeadSourceMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Newly_Submitted_Opportunities() {

        Set<string> Active_SalesReps = Active_SalesReps();

        Date Only_Start_Date = Only_Start_Date();
        Date Only_End_Date = Only_End_Date();

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        
        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        List<Opportunity> submitted = [
            SELECT
            Id,
            Newly_Submitted_Quote_First_Date__c,
            sales_rep_o__r.name,
            (SELECT Status FROM Quotes ORDER BY CreatedDate ASC LIMIT 1)
            FROM Opportunity
            WHERE
            sales_rep_o__r.name IN :Active_SalesReps
            AND RecordType.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND Newly_Submitted_Quote_First_Date__c >= :Only_Start_Date
            AND Newly_Submitted_Quote_First_Date__c <= :Only_End_Date
            AND Parent_Opportunity__c = NULL
            AND (ForecastCategoryName = 'Pipeline'
                 OR StageName = 'Sleep'
                 OR StageName = 'Closed Won'
                 OR StageName = 'Closed Lost')
            AND (NOT Name LIKE :ChangeOrder)
            AND (NOT Name LIKE :MockupOne)
            AND (NOT Name LIKE :MockupTwo)
            AND (NOT Name LIKE :MockupThree)
            AND (NOT Name LIKE :MockupFour)
            ORDER BY Newly_Submitted_Quote_First_Date__c ASC
        ];
        
        map<string, List<ValuesWrapper>> NewlySubmittedOpportunitiesMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        map<string, integer> opportunitiesCount = new Map<string, integer>();
        set<string> checkValueWrapper = new Set<string>();
        opportunitiesCount = countOpportunitiesCount(submitted, 'month-year');
        
        if (!submitted.isEmpty()) {
            for (Opportunity a : submitted) {
                Date quoteSubmittedDate = Date.valueOf(
                    a.Newly_Submitted_Quote_First_Date__c
                );
                
                string key = 'Newly Submitted Opportunities Last 12 Months';
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                                Last12MonthsList_Horizontal.indexOf(
                                    Months[(Integer) quoteSubmittedDate.month() - 1]
                                ),
                                Months[(Integer) quoteSubmittedDate.month() - 1],
                                Months[(Integer) quoteSubmittedDate.month() - 1],
                                opportunitiesCount.get(
                                    key +
                                    quoteSubmittedDate.month() +
                                    quoteSubmittedDate.year()
                                ),
                                (Integer) quoteSubmittedDate.year(),
                                null,
                                null
                            );
                
                if (
                    checkValueWrapper.contains(
                        key +
                        quoteSubmittedDate.month() +
                        quoteSubmittedDate.year()
                    )
                ) {
                    // do nothing
                } else {
                    checkValueWrapper.add(
                        key +
                        quoteSubmittedDate.month() +
                        quoteSubmittedDate.year()
                    );
                    
                    if (NewlySubmittedOpportunitiesMapLocal.containsKey(key)) {
                        
                        ValuesList = NewlySubmittedOpportunitiesMapLocal.get(
                            key
                        );
                        ValuesList.add(vw);
                    } else {

                        ValuesList.add(vw);
                    }
                    
                    NewlySubmittedOpportunitiesMapLocal.put(key, ValuesList);
                }
            }
        }
        
        if (NewlySubmittedOpportunitiesMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(
                NewlySubmittedOpportunitiesMapLocal
            );
            //List<string> sortedKeys = this.sortedKeysIntegerParsingVersion(NewlySubmittedOpportunitiesMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (NewlySubmittedOpportunitiesMapLocal.containskey(s)) {
                    sortedMap.put(s, NewlySubmittedOpportunitiesMapLocal.get(s));
                }
            }
            
            NewlySubmittedOpportunitiesMapLocal = sortedMap;
            //NewlySubmittedOpportunitiesKeys = NewlySubmittedOpportunitiesMap.keyset();
        }

        return NewlySubmittedOpportunitiesMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Newly_Submitted_Opportunities_Last_Twelve_Months_By_Sales_Rep_Team() {

        Set<string> Active_SalesReps = Active_SalesReps();

        Date Only_Start_Date = Only_Start_Date();
        Date Only_End_Date = Only_End_Date();

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        
        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        List<Opportunity> submitted = [
            SELECT
            Id,
            Newly_Submitted_Quote_First_Date__c,
            sales_rep_o__r.name,
            (SELECT Status FROM Quotes ORDER BY CreatedDate ASC LIMIT 1)
            FROM Opportunity
            WHERE
            sales_rep_o__r.name IN :Active_SalesReps
            AND RecordType.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND Newly_Submitted_Quote_First_Date__c >= :Only_Start_Date
            AND Newly_Submitted_Quote_First_Date__c <= :Only_End_Date
            AND Parent_Opportunity__c = NULL
            AND (ForecastCategoryName = 'Pipeline'
                 OR StageName = 'Sleep'
                 OR StageName = 'Closed Won'
                 OR StageName = 'Closed Lost')
            AND (NOT Name LIKE :ChangeOrder)
            AND (NOT Name LIKE :MockupOne)
            AND (NOT Name LIKE :MockupTwo)
            AND (NOT Name LIKE :MockupThree)
            AND (NOT Name LIKE :MockupFour)
            ORDER BY sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c ASC
        ];
        
        map<string, List<ValuesWrapper>> NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal = 
        new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        map<string, integer> opportunitiesCount = new Map<string, integer>();
        set<string> checkValueWrapper = new Set<string>();
        opportunitiesCount = countOpportunitiesCount(submitted, 'repName');
        
        if (!submitted.isEmpty()) {
            for (Opportunity a : submitted) {
                string key = (String) a.sales_rep_o__r.name;
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                Date quoteSubmittedDate = Date.valueOf(
                    a.Newly_Submitted_Quote_First_Date__c
                );
				
				ValuesList = new List<ValuesWrapper>();                
                
                ValuesWrapper vw = new ValuesWrapper(
                                Last12MonthsList_Horizontal.indexOf(
                                    Months[(Integer) quoteSubmittedDate.month() - 1]
                                ),
                                Months[(Integer) quoteSubmittedDate.month() - 1],
                                Months[(Integer) quoteSubmittedDate.month() - 1],
                                opportunitiesCount.get(
                                    key +
                                    quoteSubmittedDate.month() +
                                    quoteSubmittedDate.year()
                                ),
                                (Integer) quoteSubmittedDate.year(),
                                null,
                                null
                            );
                
                if (
                    checkValueWrapper.contains(
                        key +
                        quoteSubmittedDate.month() +
                        quoteSubmittedDate.year()
                    )
                ) {
                    // do nothing
                } else {
                    checkValueWrapper.add(
                        key +
                        quoteSubmittedDate.month() +
                        quoteSubmittedDate.year()
                    );
                    
                    if (
                        NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal.containsKey(
                            key
                        )
                    ) {
                        ValuesList = NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal.get(
                            key
                        );
                        ValuesList.add(vw);
                    } else {

                        ValuesList.add(vw);
                    }
                    
                    NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal.put(
                            key,
                            ValuesList
                        );
                }
            }
        }
        
        if (
            NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal.size() >
            0
        ) {
            // sort the data
            List<string> sortedKeys = sortedKeys(
                NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal
            );
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (
                    NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal.containskey(
                        s
                    )
                ) {
                    sortedMap.put(
                        s,
                        NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal.get(
                            s
                        )
                    );
                }
            }
            
            NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal = sortedMap;
            //NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamKeys = NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMap.keyset();
        }

        return NewlySubmittedOpportunitiesLastTwelveMonthsBySalesRepTeamMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Newly_Submitted_Opportunities_Last_12_Months_By_Lead_Source() {

        Set<string> Active_SalesReps = Active_SalesReps();

        Date Only_Start_Date = Only_Start_Date();
        Date Only_End_Date = Only_End_Date();

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        
        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        List<Opportunity> submitted = [
            SELECT
            Id,
            Newly_Submitted_Quote_First_Date__c,
            LeadSource,
            sales_rep_o__r.name,
            (SELECT Status FROM Quotes ORDER BY CreatedDate ASC LIMIT 1)
            FROM Opportunity
            WHERE
            sales_rep_o__r.name IN :Active_SalesReps
            AND RecordType.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND Newly_Submitted_Quote_First_Date__c >= :Only_Start_Date
            AND Newly_Submitted_Quote_First_Date__c <= :Only_End_Date
            AND Parent_Opportunity__c = NULL
            AND (ForecastCategoryName = 'Pipeline'
                 OR StageName = 'Sleep'
                 OR StageName = 'Closed Won'
                 OR StageName = 'Closed Lost')
            AND (NOT Name LIKE :ChangeOrder)
            AND (NOT Name LIKE :MockupOne)
            AND (NOT Name LIKE :MockupTwo)
            AND (NOT Name LIKE :MockupThree)
            AND (NOT Name LIKE :MockupFour)
            ORDER BY LeadSource, Newly_Submitted_Quote_First_Date__c ASC
        ];
        
        map<string, List<ValuesWrapper>> newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        map<string, integer> opportunitiesCount = new Map<string, integer>();
        set<string> checkValueWrapper = new Set<string>();
        opportunitiesCount = countOpportunitiesCount(submitted, 'leadSource');
        
        if (!submitted.isEmpty()) {
            for (Opportunity a : submitted) {

                String key = a.LeadSource != null && 
                (String) a.LeadSource != 'NA' && (String) a.LeadSource != 'N/A' ? 
                (String) a.LeadSource : 'N/A';
                key = String.isNotEmpty(key) && key != 'N/A' ? key.capitalize() : key;
                
                Date quoteSubmittedDate = Date.valueOf(
                    a.Newly_Submitted_Quote_First_Date__c
                );
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                                Last12MonthsList_Horizontal.indexOf(
                                    Months[(Integer) quoteSubmittedDate.month() - 1]
                                ),
                                Months[(Integer) quoteSubmittedDate.month() - 1],
                                Months[(Integer) quoteSubmittedDate.month() - 1],
                                opportunitiesCount.get(
                                    key +
                                    quoteSubmittedDate.month() +
                                    quoteSubmittedDate.year()
                                ),
                                (Integer) quoteSubmittedDate.year(),
                                null,
                                null
                            );
                
                
                if (
                    checkValueWrapper.contains(
                        key +
                        quoteSubmittedDate.month() +
                        quoteSubmittedDate.year()
                    )
                ) {
                    // do nothing
                } else {
                    checkValueWrapper.add(
                        key +
                        quoteSubmittedDate.month() +
                        quoteSubmittedDate.year()
                    );
                    
                    if (
                        newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal.containsKey(
                            key
                        )
                    ) {
                        ValuesList = newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal.get(
                            key
                        );
                        ValuesList.add(vw);
                    } else {
                        
                        ValuesList.add(vw);
                    }
                    
                    newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal.put(
                            key,
                            ValuesList
                        );
                }
            }
        }
        
        if (
            newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal.size() > 0
        ) {
            // sort data
            List<string> sortedKeys = sortedKeys(
                newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal
            );
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (
                    newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal.containskey(
                        s
                    )
                ) {
                    sortedMap.put(
                        s,
                        newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal.get(
                            s
                        )
                    );
                }
            }
            
            newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal = sortedMap;
            // newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceKeys = newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMap.keyset();
        }
        
        return newlySubmittedOpportunitiesLastTwelveMonthsByLeadSourceMapLocal;
    }
	
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Lost_Opportunities() {

        Set<string> All_SalesReps = getAll_SalesReps();

        Date Only_Start_Date = Only_Start_Date();
        Date Only_End_Date = Only_End_Date();

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        
        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        List<AggregateResult> LostOpptysData = [select calendar_month(Closed_Date__c) month,calendar_year(Closed_Date__c) year,
                                               Count(id) ct from opportunity 
                                                Where Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date
                                               and RecordType.name = 'Seawin USA Hospitality'
                                               and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                               and sales_rep_o__r.name in:All_SalesReps
                                               and StageName = 'Closed Lost' AND Parent_Opportunity__c = NULL
                                               AND (NOT Name LIKE :ChangeOrder)
                                               AND (NOT Name LIKE :MockupOne)
                                               AND (NOT Name LIKE :MockupTwo)
                                               AND (NOT Name LIKE :MockupThree)
                                               AND (NOT Name LIKE :MockupFour)
                                               group by calendar_month(Closed_Date__c), calendar_year(Closed_Date__c)
                                               order by calendar_year(Closed_Date__c) asc];
        
        map<string, List<ValuesWrapper>> LostOpptyMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        string key = 'Lost Opportunities Last 12 Months';
        
        if (!LostOpptysData.isEmpty()) {
            for (AggregateResult a : LostOpptysData) {
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                            Last12MonthsList_Horizontal.indexOf(
                                Months[(Integer) a.get('month') - 1]
                            ),
                            Months[(Integer) a.get('month') - 1],
                            Months[(Integer) a.get('month') - 1],
                            (Decimal) a.get('ct'),
                            (Integer) a.get('year'),
                            null,
                            null
                        );
                
                if (LostOpptyMapLocal.containsKey(key)) {
                    
                    ValuesList = LostOpptyMapLocal.get(key);
                    ValuesList.add(vw);
                } else {

                    ValuesList.add(vw);
                }
                LostOpptyMapLocal.put(key, ValuesList);
            }
        }
        if (LostOpptyMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(LostOpptyMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (LostOpptyMapLocal.containskey(s)) {
                    sortedMap.put(s, LostOpptyMapLocal.get(s));
                }
            }
            
            LostOpptyMapLocal = sortedMap;
            
            //LostOpptysKeys = LostOpptyMapLocal.keyset();
            //LostOpptysMap = LostOpptyMapLocal;
        }

        return LostOpptyMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Lost_Opportunities_by_Sales_Rep_Team() {

        Set<string> All_SalesReps = getAll_SalesReps();

        Date Only_Start_Date = Only_Start_Date();
        Date Only_End_Date = Only_End_Date();

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        
        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        List<AggregateResult> LostOpptysBySalesRepTeamData = [select sales_rep_o__r.name name, 
                                                             calendar_month(Closed_Date__c) month,calendar_year(Closed_Date__c) year,
                                                             Count(id) ct from opportunity
                                                             Where Closed_Date__c >=: Only_Start_Date and 
                                                             Closed_Date__c <=: Only_End_Date
                                                             and RecordType.name = 'Seawin USA Hospitality'
                                                             and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                                             and sales_rep_o__r.name in:All_SalesReps
                                                             and StageName = 'Closed Lost' 
                                                             AND Parent_Opportunity__c = NULL
                                                             AND (NOT Name LIKE :ChangeOrder)
                                                             AND (NOT Name LIKE :MockupOne)
                                                             AND (NOT Name LIKE :MockupTwo)
                                                             AND (NOT Name LIKE :MockupThree)
                                                             AND (NOT Name LIKE :MockupFour)
                                                             group by sales_rep_o__r.name, calendar_month(Closed_Date__c), 
                                                             calendar_year(Closed_Date__c)
                                                             order by calendar_year(Closed_Date__c) asc];
        
        map<string, List<ValuesWrapper>> LostOpptyMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        if (!LostOpptysBySalesRepTeamData.isEmpty()) {
            for (AggregateResult a : LostOpptysBySalesRepTeamData) {
                string key = (String) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                            Last12MonthsList_Horizontal.indexOf(
                                Months[(Integer) a.get('month') - 1]
                            ),
                            Months[(Integer) a.get('month') - 1],
                            (String) a.get('name'),
                            (Decimal) a.get('ct'),
                            (Integer) a.get('year'),
                            null,
                            null
                        );
                
                if (LostOpptyMapLocal.containsKey(key)) {
                    
                    ValuesList = LostOpptyMapLocal.get(key);
                    ValuesList.add(vw);
                } else {

                    ValuesList.add(vw);
                }
                
                LostOpptyMapLocal.put(key, ValuesList);
            }
        }
        if (LostOpptyMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(LostOpptyMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (LostOpptyMapLocal.containskey(s)) {
                    sortedMap.put(s, LostOpptyMapLocal.get(s));
                }
            }
            
            LostOpptyMapLocal = sortedMap;
            
            //LostOpptysBySalesRepTeamKeys = LostOpptyMapLocal.keyset();
            //LostOpptysBySalesRepTeamMap = LostOpptyMapLocal;
        }

        return LostOpptyMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Loss_Reasons() {

        Set<string> All_SalesReps = getAll_SalesReps();

        Date Only_Start_Date = Only_Start_Date();
        Date Only_End_Date = Only_End_Date();

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        
        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        List<AggregateResult> LossReasonsData = [select Loss_Reason__c name, 
                                                             calendar_month(Closed_Date__c) month,
                                                             calendar_year(Closed_Date__c) year,
                                                             Count(id) ct from opportunity
                                                             Where Closed_Date__c >=: Only_Start_Date and 
                                                             Closed_Date__c <=: Only_End_Date
                                                             and RecordType.name = 'Seawin USA Hospitality'
                                                             and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                                             and sales_rep_o__r.name in:All_SalesReps
                                                             and StageName = 'Closed Lost' 
                                                             AND Parent_Opportunity__c = NULL
                                                             AND (NOT Name LIKE :ChangeOrder)
                                                             AND (NOT Name LIKE :MockupOne)
                                                             AND (NOT Name LIKE :MockupTwo)
                                                             AND (NOT Name LIKE :MockupThree)
                                                             AND (NOT Name LIKE :MockupFour)
                                                             group by Loss_Reason__c, calendar_month(Closed_Date__c), 
                                                             calendar_year(Closed_Date__c)
                                                             order by calendar_year(Closed_Date__c) asc];
        
        map<string, List<ValuesWrapper>> LossReasonMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        if (!LossReasonsData.isEmpty()) {
            for (AggregateResult a : LossReasonsData) {
                string key = (String) a.get('name') == null
                    ? 'N/A'
                    : (String) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                            Last12MonthsList_Horizontal.indexOf(
                                Months[(Integer) a.get('month') - 1]
                            ),
                            Months[(Integer) a.get('month') - 1],
                            (String) a.get('name'),
                            (Decimal) a.get('ct'),
                            (Integer) a.get('year'),
                            null,
                            null
                        );
                
                if (LossReasonMapLocal.containsKey(key)) {
                    
                    ValuesList = LossReasonMapLocal.get(key);
                    ValuesList.add(vw);
                } else {

                    ValuesList.add(vw);
                }
                
                LossReasonMapLocal.put(key, ValuesList);
            }
        }
        if (LossReasonMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(LossReasonMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (LossReasonMapLocal.containskey(s)) {
                    sortedMap.put(s, LossReasonMapLocal.get(s));
                }
            }
            
            LossReasonMapLocal = sortedMap;
            
            //LossReasonsKeys = LossReasonMapLocal.keyset();
            //LossReasonsMap = LossReasonMapLocal;
        }

        return LossReasonMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Sales_By_Lead_Source_Last_12_Months() {

        DateTime Full_Start_Date = Full_Start_Date();
        DateTime Full_End_Date = Full_End_Date();

        Set<string> All_SalesReps = getAll_SalesReps();

        List<String> Last12MonthsList = Last12MonthsList();

        List<String> Months = Months();
        
        List<AggregateResult> SalesByLeadSourceLastTwelveMonthsData = [select AcctSeedERP__Opportunity__r.Leadsource leadSource,
                                                                      calendar_month(CreatedDate) month,
                                                                      calendar_year(CreatedDate) year,
                                                                      sum(AcctSeederp__total__c) amount
                                                                      from AcctSeederp__sales_order__c
                                                                      where CreatedDate >=:Full_Start_Date and 
                                                                      CreatedDate <=:Full_End_Date
                                                                      and RecordType.name = 'Seawin USA Hospitality'
                                                                      and GL_Account_Variable_1__r.Name = 'Seawin USA'
                                                                      and Sales_rep_o__r.name in:All_SalesReps
                                                                      and AcctSeederp__total__c > 0
                                                                      group by AcctSeedERP__Opportunity__r.Leadsource ,
                                                                      calendar_month(CreatedDate),
                                                                      calendar_year(CreatedDate)
                                                                      order by calendar_year(CreatedDate) asc];
        
        map<string, List<ValuesWrapper>> SalesByLeadSourceLastTwelveMonthsMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        
        if (!SalesByLeadSourceLastTwelveMonthsData.isEmpty()) {
            for (AggregateResult so : SalesByLeadSourceLastTwelveMonthsData) {
  
                String key = so.get('leadSource') != null && 
                (string) so.get('leadSource') != 'NA' && (string) so.get('leadSource') != 'N/A' ? 
                (string) so.get('leadSource') : 'N/A';
                key = String.isNotEmpty(key) && key != 'N/A' ? key.capitalize() : key;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                    Last12MonthsList.indexOf(Months[(Integer) so.get('month') - 1]),
                    Months[(Integer) so.get('month') - 1],
                    Months[(Integer) so.get('month') - 1],
                            (Decimal) so.get('amount'),
                            (Integer) so.get('year'),
                            null,
                            null
                        );
                
                if (SalesByLeadSourceLastTwelveMonthsMapLocal.containskey(key)) {
                    
                    ValuesList = SalesByLeadSourceLastTwelveMonthsMapLocal.get(key);
                    ValuesList.add(vw);
                } else {
                    ValuesList.add(vw);
                }
                
                SalesByLeadSourceLastTwelveMonthsMapLocal.put(
                        key,
                        ValuesList
                    );
            }
        }
        if (SalesByLeadSourceLastTwelveMonthsMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(
                SalesByLeadSourceLastTwelveMonthsMapLocal
            );
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (SalesByLeadSourceLastTwelveMonthsMapLocal.containskey(s)) {
                    sortedMap.put(s, SalesByLeadSourceLastTwelveMonthsMapLocal.get(s));
                }
            }
            SalesByLeadSourceLastTwelveMonthsMapLocal = sortedMap;
            
            //SalesByLeadSourceLastTwelveMonthsKeys = SalesByLeadSourceLastTwelveMonthsMapLocal.keyset();
            //SalesByLeadSourceLastTwelveMonthsMap = SalesByLeadSourceLastTwelveMonthsMapLocal;
        }

        return SalesByLeadSourceLastTwelveMonthsMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Sales_Forecast_Pipeline_By_Lead_Source() {

        Set<string> All_SalesReps = getAll_SalesReps();

        List<String> Next12MonthsList = Next12MonthsList();

        List<String> Months = Months();

        Date d = getTodayDate();

        map<string, decimal> MissedOpptysMap = new Map<string, decimal>();
        
        Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
        Date Future_Date = Pipeline_Start_Date.addMonths(11);
        
        Date Pipeline_End_Date = Date.newInstance(
            Future_Date.year(),
            Future_Date.month(),
            Date.daysInMonth(Future_Date.year(), Future_Date.month())
        );
        
        List<AggregateResult> MissedForecasts = [select LeadSource leadSource, Sum(ExpectedRevenue) amount from opportunity
                                                Where CloseDate <: Pipeline_Start_Date
                                                and RecordType.name = 'Seawin USA Hospitality'
                                                and GL_Account_Variable_1__r.name = 'Seawin USA'
                                                and sales_rep_o__r.name in:All_SalesReps
                                                and ForecastCategoryName = 'Pipeline'
                                                group by LeadSource];
        
        if (!MissedForecasts.isEmpty()) {
            for (aggregateresult agr : Missedforecasts) {
                MissedOpptysMap.put(
                    (String) agr.get('leadSource'),
                    (decimal) agr.get('amount')
                );
            }
        }
        
        List<AggregateResult> forecasts = [select LeadSource leadSource,calendar_month(CloseDate) month,calendar_year(closedate) year,
                                          Sum(ExpectedRevenue) amount from opportunity
                                          Where CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date
                                          and RecordType.name = 'Seawin USA Hospitality'
                                          and GL_Account_Variable_1__r.name = 'Seawin USA'
                                          and sales_rep_o__r.name in:All_SalesReps
                                          and ForecastCategoryName = 'Pipeline'
                                          group by LeadSource, calendar_month(closedate), calendar_year(closedate)
                                          order by calendar_year(closedate) asc];
        
        map<string, List<ValuesWrapper>> SalesForecastPipelineByLeadSourceMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        if (!forecasts.isEmpty()) {
            for (AggregateResult a : forecasts) {
                String key = a.get('leadSource') != null && 
                (string) a.get('leadSource') != 'NA' && (string) a.get('leadSource') != 'N/A' ? 
                (string) a.get('leadSource') : 'N/A';
                key = String.isNotEmpty(key) && key != 'N/A' ? key.capitalize() : key;
                
                Decimal missedAmount = MissedOpptysMap.containsKey(key)
                    ? MissedOpptysMap.get(key)
                    : 0;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                    Next12MonthsList.indexOf(Months[(Integer) a.get('month') - 1]),
                    Months[(Integer) a.get('month') - 1],
                            (String) a.get('leadSource'),
                            (Decimal) a.get('amount'),
                            (Integer) a.get('year'),
                            null,
                            MissedAmount
                        );
                
                if (SalesForecastPipelineByLeadSourceMapLocal.containsKey(key)) {
                    
                    ValuesList = SalesForecastPipelineByLeadSourceMapLocal.get(
                        key
                    );
                    ValuesList.add(vw);
                } else {

                    ValuesList.add(vw);
                }
                
                SalesForecastPipelineByLeadSourceMapLocal.put(
                        key,
                        ValuesList
                    );
            }
        }
        if (SalesForecastPipelineByLeadSourceMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(
                SalesForecastPipelineByLeadSourceMapLocal
            );
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (SalesForecastPipelineByLeadSourceMapLocal.containskey(s)) {
                    sortedMap.put(s, SalesForecastPipelineByLeadSourceMapLocal.get(s));
                }
            }
            
            SalesForecastPipelineByLeadSourceMapLocal = sortedMap;
            
            //SalesForecastPipelineByLeadSourceKeys = SalesForecastPipelineByLeadSourceMapLocal.keyset();
            //SalesForecastPipelineByLeadSourceMap = SalesForecastPipelineByLeadSourceMapLocal;
        }

        return SalesForecastPipelineByLeadSourceMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Active_Opportunities_By_Stage() {

        Set<string> All_SalesReps = getAll_SalesReps();

        map<string, List<ValuesWrapper>> ActiveOpptyByStageMapLocal = new Map<string, List<ValuesWrapper>>();
        
        List<AggregateResult> ActiveOpptyData = [select sales_rep_o__r.name name, StageName stage, sum(amount) amount
                                                from Opportunity
                                                where ForecastCategoryName != 'Omitted' and ForecastCategoryName != 'Closed'
                                                and RecordType.name = 'Seawin USA Hospitality'
                                                and GL_Account_Variable_1__r.name = 'Seawin USA'
                                                and sales_rep_o__r.name in:All_SalesReps and amount != null and amount != 0
                                                group by Sales_Rep_O__r.name,stagename
                                                order by Sales_Rep_O__r.name,stagename];
        
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        map<string, Integer> UniqueMap = new Map<string, Integer>();
        
        Integer i = 0;
        if (!ActiveOpptyData.isEmpty()) {
            // Assing the sales rep the index from the graph
            for (AggregateResult a : ActiveOpptyData) {
                string key = (string) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                if (!UniqueMap.containsKey(key)) {
                    UniqueMap.put(key, i);
                    i++;
                }
            }
            /*
            List<string> sortedKeysList = new List<string>();
            if (UniqueMap.size() > 0) {
                set<string> uniqueMapKeys = UniqueMap.keySet();
                for (string key : uniqueMapKeys) {
                    sortedKeysList.add(key);
                }
                sortedKeysList.sort();
            }*/
            //ActiveOpptyByStageCategories.addAll(UniqueMap.keyset());
            //ActiveOpptyByStageCategories.addAll(sortedKeysList);
            
            for (AggregateResult a : ActiveOpptyData) {
                string key = (String) a.get('stage');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                            UniqueMap.get(((String) a.get('name')).capitalize()),
                            ((String) a.get('name')).capitalize(),
                            null,
                            (Decimal) a.get('amount'),
                            null,
                            null,
                            null
                        );
                
                if (ActiveOpptyByStageMapLocal.containskey(key)) {
                    
                    ValuesList = ActiveOpptyByStageMapLocal.get(key);
                    ValuesList.add(vw);
                } else {

                    ValuesList.add(vw);
                }
                
                ActiveOpptyByStageMapLocal.put(((String) a.get('stage')).capitalize(),
                        ValuesList
                    );
            }
        }
        
        if (ActiveOpptyByStageMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(ActiveOpptyByStageMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (ActiveOpptyByStageMapLocal.containskey(s)) {
                    sortedMap.put(s, ActiveOpptyByStageMapLocal.get(s));
                }
            }
            
            ActiveOpptyByStageMapLocal = sortedMap;
            //ActiveOpptyByStageKeys = ActiveOpptyByStageMap.Keyset();
        }

        return ActiveOpptyByStageMapLocal;
    }

    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Negotiation_WinRate() {

        Set<string> Active_SalesReps = Active_SalesReps();

        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        map<string, List<ValuesWrapper>> NegWinRateMapLocal = new Map<string, List<ValuesWrapper>>();
        
        // get records from opportunity history which were at negotiation stage
        
        set<id> eligibleIds = new Set<id>();
        
        for (OpportunityHistory hstry : [
            SELECT Id, OpportunityId, CreatedDate, StageName, Amount, CloseDate
            FROM OpportunityHistory
            WHERE
            StageName = 'Negotiation'
            AND Opportunity.RecordType.name = 'Seawin USA Hospitality'
            AND Opportunity.GL_Account_Variable_1__r.name = 'Seawin USA'
            AND Opportunity.sales_rep_o__r.name IN :Active_SalesReps
        ]) {
            eligibleIds.add(hstry.OpportunityId);
        }
        if (Test.isRunningTest()) {
            map<id, opportunity> testMap = new Map<id, opportunity>(
                [
                    SELECT id
                    FROM opportunity
                    WHERE
                    sales_rep_o__r.name IN :Active_SalesReps
                    AND (StageName = 'Closed Won'
                         OR StageName = 'Closed Lost')
                    LIMIT 5
                ]
            );
            
            eligibleIds.AddAll(testMap.keyset());
        }
        
        if (eligibleIds.size() > 0) {
            List<AggregateResult> totals = [
                SELECT count(id) ct, sales_rep_o__r.name name
                FROM opportunity
                WHERE
                RecordType.name = 'Seawin USA Hospitality'
                AND GL_Account_Variable_1__r.name = 'Seawin USA'
                AND (StageName = 'Closed Won'
                     OR StageName = 'Closed Lost')
                AND (NOT Name LIKE :ChangeOrder)
                AND (NOT Name LIKE :MockupOne)
                AND (NOT Name LIKE :MockupTwo)
                AND (NOT Name LIKE :MockupThree)
                AND (NOT Name LIKE :MockupFour)
                AND id IN :eligibleIds
                AND sales_rep_o__r.name IN :Active_SalesReps
                GROUP BY sales_rep_o__r.name
            ];
            
            List<AggregateResult> NegWinData = new List<AggregateResult>();
            map<string, decimal> TotalOpptysMap = new Map<string, decimal>();
            if (!totals.isEmpty()) {
                for (AggregateResult a : totals) {
                    string key = (string) a.get('name');
                    key = String.isNotEmpty(key) ? key.capitalize() : key;
                    
                    TotalOpptysMap.put(key, (decimal) a.get('ct'));
                }
                
                NegWinData = [
                    SELECT count(id) ct, sales_rep_o__r.name name
                    FROM opportunity
                    WHERE
                    RecordType.name = 'Seawin USA Hospitality'
                    AND GL_Account_Variable_1__r.name = 'Seawin USA'
                    AND StageName = 'Closed Won'
                    AND (NOT Name LIKE :ChangeOrder)
                    AND (NOT Name LIKE :MockupOne)
                    AND (NOT Name LIKE :MockupTwo)
                    AND (NOT Name LIKE :MockupThree)
                    AND (NOT Name LIKE :MockupFour)
                    AND id IN :eligibleIds
                    AND sales_rep_o__r.name IN :Active_SalesReps
                    GROUP BY Sales_Rep_O__r.name
                    ORDER BY Sales_Rep_O__r.name
                ];
            }
            
            List<ValuesWrapper> NegWinDataList = new List<ValuesWrapper>();
            map<string, Decimal> TotalMap = new Map<string, Decimal>();
            
            Integer i = 0;
            if (!NegWinData.isEmpty()) {
                for (AggregateResult a : NegWinData) {
                    string key = (String) a.get('name');
                    key = String.isNotEmpty(key) ? key.capitalize() : key;
                    
                    Decimal totalOpptys = TotalOpptysMap.get(key) == null
                        ? 0
                        : TotalOpptysMap.get(key);
                    Decimal ct = (Decimal) a.get('ct');
                    Decimal percent = totalOpptys != 0 ? (ct / totalOpptys) * 100 : 0;
                    
                    NegWinDataList = new List<ValuesWrapper>();
                    NegWinDataList.add(
                        new ValuesWrapper(
                            i,
                            null,
                            null,
                            percent.setScale(2),
                            null,
                            null,
                            null
                        )
                    );
                    
                    NegWinRateMapLocal.put(key, NegWinDataList);
                    i++;
                }
            }
            
            if (NegWinRateMapLocal.size() > 0) {
                List<string> sortedKeys = sortedKeys(NegWinRateMapLocal);
                map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
                
                for (string s : sortedKeys) {
                    if (NegWinRateMapLocal.containskey(s)) {
                        sortedMap.put(s, NegWinRateMapLocal.get(s));
                    }
                }
                NegWinRateMapLocal = sortedMap;
                
                //NegWinRateKeys = NegWinRateMapLocal.Keyset();
                //NegWinRateMap = NegWinRateMapLocal;
            }
        }

        return NegWinRateMapLocal;
    }

    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Win_Rate() {

        Set<string> Active_SalesReps = Active_SalesReps();

        String ChangeOrder = '%Change Order%';
        String MockupOne = '%Mock-Up%';
        String MockupTwo = '%Mock Up%';
        String MockupThree = '%Mock%';
        String MockupFour = '%Mockup%';
        
        map<string, List<ValuesWrapper>> WinRateMapLocal = new Map<string, List<ValuesWrapper>>();
        
        List<AggregateResult> totals = [
            SELECT count(id) ct, sales_rep_o__r.name name
            FROM opportunity
            WHERE
            RecordType.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.name = 'Seawin USA'
            AND (StageName = 'Closed Won'
                 OR StageName = 'Closed Lost')
            AND (NOT Name LIKE :ChangeOrder)
            AND (NOT Name LIKE :MockupOne)
            AND (NOT Name LIKE :MockupTwo)
            AND (NOT Name LIKE :MockupThree)
            AND (NOT Name LIKE :MockupFour)
            AND sales_rep_o__r.name IN :Active_SalesReps
            GROUP BY sales_rep_o__r.name
        ];
        
        List<AggregateResult> WinData = new List<AggregateResult>();
        map<string, decimal> TotalOpptysMap = new Map<string, decimal>();
        if (!totals.isEmpty()) {
            for (AggregateResult a : totals) {
                string key = (string) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                TotalOpptysMap.put(key, (decimal) a.get('ct'));
            }
            
            WinData = [
                SELECT count(id) ct, sales_rep_o__r.name name
                FROM opportunity
                WHERE
                RecordType.name = 'Seawin USA Hospitality'
                AND GL_Account_Variable_1__r.name = 'Seawin USA'
                AND StageName = 'Closed Won'
                AND (NOT Name LIKE :ChangeOrder)
                AND (NOT Name LIKE :MockupOne)
                AND (NOT Name LIKE :MockupTwo)
                AND (NOT Name LIKE :MockupThree)
                AND (NOT Name LIKE :MockupFour)
                AND sales_rep_o__r.name IN :Active_SalesReps
                GROUP BY Sales_Rep_O__r.name
                ORDER BY Sales_Rep_O__r.name
            ];
        }
        
        List<ValuesWrapper> WinDataList = new List<ValuesWrapper>();
        map<string, Decimal> TotalMap = new Map<string, Decimal>();
        
        Integer i = 0;
        if (!WinData.isEmpty()) {
            for (AggregateResult a : WinData) {
                string key = (String) a.get('name');
                key = String.isNotEmpty(key) ? key.capitalize() : key;
                
                Decimal totalOpptys = TotalOpptysMap.get(key) == null
                    ? 0
                    : TotalOpptysMap.get(key);
                Decimal ct = (Decimal) a.get('ct');
                Decimal percent = totalOpptys != 0 ? (ct / totalOpptys) * 100 : 0;
                
                WinDataList = new List<ValuesWrapper>();
                WinDataList.add(
                    new ValuesWrapper(
                        i,
                        null,
                        null,
                        percent.setScale(2),
                        null,
                        null,
                        null
                    )
                );
                
                WinRateMapLocal.put(key, WinDataList);
                i++;
            }
        }
        
        if (WinRateMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(WinRateMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (WinRateMapLocal.containskey(s)) {
                    sortedMap.put(s, WinRateMapLocal.get(s));
                }
            }
            WinRateMapLocal = sortedMap;
            
            //WinRateKeys = WinRateMapLocal.Keyset();
            //WinRateMap = WinRateMapLocal;
        }

        return WinRateMapLocal;
    }

    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Activity_Graph_Last_12_Months() {

        // dolphin

        DateTime Full_Start_Date = Full_Start_Date();
        DateTime Full_End_Date = Full_End_Date();

        map<string, set<string>> UserAndTeams_Map = new map<string, set<string>>();

        Set<string> Inside_Sales_Users = Inside_Sales_Users();

        List<Sales_rep__c> AllSalesRepsList = AllSalesRepsList();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();

        List<String> Months = Months();

        // enigma
        map<string, date> SalesRepDateMap = new Map<string, date>();
        for (sales_rep__c sr : AllSalesRepsList) {
            SalesRepDateMap.put(sr.name, sr.inactive_date__c);
        }
        
        //Team Logic Start
        set<String> userTeams = new Set<String>();
        
        for (Sales_Rep__c team : AllSalesRepsList) {
            Set<String> users = UserData_From_Teams(team.Team__c);
            for (string usr : users) {
                userTeams = new Set<String>();
                userTeams.add(team.name);
                
                if (UserAndTeams_Map.containsKey(usr)) {
                    userTeams.addAll(UserAndTeams_Map.get(usr));
                }
                UserAndTeams_Map.put(usr, userTeams);
            }
        }
        
        List<AggregateResult> ActivityData = [Select OwnerId ownerId, whatid oppId,
                                             calendar_month(CompletedDateTime) month, 
                                              calendar_year(CompletedDateTime) year 
                                              from task
                                             where what.type = 'Opportunity' and 
                                              CompletedDateTime >=:Full_Start_Date and 
                                              CompletedDateTime <=:Full_End_Date 
                                              and owner.Name in:Inside_Sales_Users
                                             group by OwnerId, whatid,calendar_year(CompletedDateTime),
                                              calendar_month(CompletedDateTime)
                                             order by OwnerId,whatid,calendar_year(CompletedDateTime),
                                              calendar_month(CompletedDateTime)];
        
        map<string, aggregateresult> TaskMap = new Map<string, aggregateResult>();
        map<id, opportunity> EligibleOpportunities = new Map<id, opportunity>();
        set<id> oppIds = new Set<id>();
        
        if (ActivityData.size() > 0 && ActivityData[0].get('oppId') != null) {
            // if there is data in the list
            for (AggregateResult a : ActivityData) {
                string key =
                    String.ValueOf(a.get('oppId')) +
                    ';' +
                    String.ValueOf(a.get('ownerId')) +
                    ';' +
                    String.ValueOf(a.get('month')) +
                    ';' +
                    String.ValueOf(a.get('year'));
                TaskMap.put(key, a);
                oppIds.add((Id) a.get('oppId'));
            }
            
            // All Opportunity
            EligibleOpportunities = new Map<id, opportunity>(
                [
                    SELECT id, Sales_Rep_O__r.name, Sales_Rep_O__r.Team__c, ForecastCategoryName
                    FROM opportunity
                    WHERE
                    ForecastCategoryName != 'Omitted'
                    AND RecordType.Name = 'Seawin USA Hospitality'
                    AND GL_Account_Variable_1__r.Name = 'Seawin USA'
                    AND id IN :oppIds
                ]
            );
            
            if (EligibleOpportunities.size() > 0) {
                for (string k : TaskMap.keyset()) {
                    string recordId = k.split(';')[0];
                    
                    AggregateResult a = TaskMap.get(k);
                    
                    Boolean RemoveIt = false;

                    Opportunity opp = new Opportunity();
                    
                    if (EligibleOpportunities.containsKey(recordId)) {

                        opp = EligibleOpportunities.get(recordId);

                        string salesrepName = EligibleOpportunities.get(recordId)
                            .Sales_Rep_O__r.name;
                        
                        Date InactiveDate = SalesRepDateMap.get(SalesRepName);
                        
                        if (InactiveDate != null) {
                            Date InactiveDateRevised = Date.newInstance(
                                InactiveDate.year(),
                                InactiveDate.month(),
                                1
                            );
                            
                            Date RecordDate = Date.newInstance(
                                (Integer) a.get('year'),
                                (Integer) a.get('month'),
                                1
                            );
                            
                            RemoveIt = RecordDate > InactiveDateRevised ? true : false;
                        }
                    }
                    
                    if (!EligibleOpportunities.containsKey(recordId) 
                    || RemoveIt 
                    || opp.ForecastCategoryName != 'Pipeline') {
                        TaskMap.remove(k);
                    }
                }
            }
        }
        
        map<string, List<ValuesWrapper>> ActivityGraphMapLocal = new Map<string, List<ValuesWrapper>>();
        map<string, Integer> ActivityGraphMapTemp = new Map<string, Integer>();
        if (TaskMap.size() > 0) {
            List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
            for (AggregateResult a : TaskMap.values()) {
                string ownerId = (String) a.get('OwnerId');
                
                string OppId = (string) a.get('oppId');
                string salesrepName = EligibleOpportunities.get(OppId)
                    .Sales_Rep_O__r.name;
                
                Integer year = (Integer) a.get('year');
                Integer month = (Integer) a.get('month');
                
                Boolean BelongsToTeam = CheckUser(
                    EligibleOpportunities.get(OppId).Sales_Rep_O__r.Team__c,
                    ownerId
                );
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                                    Last12MonthsList_Horizontal.indexOf(Months[month - 1]),
                                    Months[month - 1],
                                    salesrepName,
                                    1,
                                    year,
                                    null,
                                    null
                                );
                
                if (BelongsToTeam) {
                    if (ActivityGraphMapLocal.containsKey(salesrepName)) {
                        ValuesList = ActivityGraphMapLocal.get(
                            salesrepName
                        );
                        
                        Boolean IndexDoesNotExist = true;
                        
                        for (ValuesWrapper vwr : ValuesList) {
                            if (
                                vwr.valueindex == Last12MonthsList_Horizontal.indexOf(Months[month - 1])
                            ) {
                                // index exists then add 1 more
                                vwr.amount += 1;
                                IndexDoesNotExist = false;
                            }
                        }
                        
                        if (IndexDoesNotExist) {
                            ValuesList.add(vw);
                        }
                    } else {
                        
                        ValuesList.add(vw);
                        
                    }
                    ActivityGraphMapLocal.put(salesrepName, ValuesList);
                }
            }
        }
        
        if (ActivityGraphMapLocal.size() > 0) {
            map<string, List<ValuesWrapper>> ActivityGraphMapSorted = new Map<string, List<ValuesWrapper>>();
            List<string> sortedKeys = new List<String>();
            
            ActivityGraphMapLocal = SortByValues(ActivityGraphMapLocal);
            
            for (string key : ActivityGraphMapLocal.keySet()) {
                sortedKeys.add(key);
            }
            sortedKeys.sort();
            
            for (string key : sortedKeys) {
                ActivityGraphMapSorted.put(key, ActivityGraphMapLocal.get(key));
            }
            
            ActivityGraphMapLocal = ActivityGraphMapSorted;
            //ActivityGraphKeys = ActivityGraphMap.keyset();
        }

        return ActivityGraphMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Tasks_Completion() {

        Set<string> Active_Users = Active_Users();

        List<AggregateResult> aggregates = [
            SELECT count(id) ct, ActivityDate dt, owner.name name
            FROM task
            WHERE
            (ActivityDate < :Date.today()
             OR ActivityDate > :Date.today()
             OR ActivityDate = NULL)
            AND status = 'Open'
            AND owner.name IN :Active_Users
            GROUP BY owner.name, ActivityDate
            ORDER BY owner.name, activitydate ASC
        ];
        
        map<string, List<ValuesWrapper>> tasksCompletionMapLocal = new Map<string, List<ValuesWrapper>>();
        
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        
        map<string, Integer> UniqueMap = new Map<string, Integer>();
        
        Integer i = 0;
        if (!aggregates.isEmpty()) {
            // Assing the sales rep the index from the graph
            for (AggregateResult a : aggregates) {
                if (!UniqueMap.containsKey((string) a.get('name'))) {
                    UniqueMap.put((string) a.get('name'), i);
                    i++;
                }
            }
            //tasksCompletionCategories.addAll(UniqueMap.keyset());
            
            for (AggregateResult a : aggregates) {
                // find the index to place it right in the graph
                // Over Due, On Time, No Due Date
                Date dt = (Date) a.get('dt');
                
                String index = (dt == null)
                    ? 'No Due Date'
                    : (dt < Date.today()) ? 'Over Due' : 'On Time';
                
                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                                UniqueMap.get((String) a.get('name')),
                                (String) a.get('name'),
                                null,
                                (Decimal) a.get('ct'),
                                null,
                                null,
                                null
                            );
                
                if (tasksCompletionMapLocal.containsKey(index)) {
                    ValuesList = tasksCompletionMapLocal.get(index);
                    
                    Boolean indexMissing = true;
                    
                    for (ValuesWrapper w : ValuesList) {
                        if (w.valueindex == UniqueMap.get((String) a.get('name'))) {
                            indexMissing = false;
                            w.amount += (Decimal) a.get('ct');
                        }
                    }
                    if (indexMissing) {
                        ValuesList.add(vw);
                    }
                } else {
                    
                    if ((Decimal) a.get('ct') != 0) {
                        ValuesList.add(vw);
                    }
                }
                tasksCompletionMapLocal.put(index, ValuesList);
            }
        }
        
        if (tasksCompletionMapLocal.size() > 0) {
            List<string> sortedKeys = sortedKeys(tasksCompletionMapLocal);
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (tasksCompletionMapLocal.containskey(s)) {
                    sortedMap.put(s, tasksCompletionMapLocal.get(s));
                }
            }
            
            tasksCompletionMapLocal = sortedMap;
            //tasksCompletionKeys = tasksCompletionMap.keyset();
        }

        return tasksCompletionMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> Neglected_Opportunities() {

        List<String> Months = Months();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();

        Set<string> Active_SalesReps = Active_SalesReps();

        Date OnlyStartDate = Only_Start_Date();
        Date OnlyEndDate = Only_End_Date();

        Date d = getTodayDate();

        Date Last_Thirty_Days = date.today() - 30; // Today minus 30 days, will give us a date before 30 days
        
        List<Opportunity> NegData = [
            SELECT
            id,
            name,
            sales_Rep_o__r.name,
            LastModifiedDate,
            LastActivityDate,
            LastModifiedBy.Name,
            HasOverdueTask,
            HasOpenActivity
            FROM Opportunity
            WHERE
            Parent_Opportunity__c = NULL
            AND sales_Rep_o__r.name IN :Active_SalesReps
            AND RecordType.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND ForecastCategoryName = 'Pipeline'
            AND ((LastActivityDate < :Last_Thirty_Days and LastActivityDate >=:OnlyStartDate 
            and LastActivityDate <=:OnlyEndDate)
                 OR (LastActivityDate = NULL
                     AND (LastModifiedDate < :Last_Thirty_Days
                           AND LastModifiedBy.Name != 'Murtaza Ashraf' AND
                           LastModifiedBy.Name != 'Ashraf Murtaza'
                           and LastModifiedDate >=:OnlyStartDate and LastModifiedDate <=:OnlyEndDate)))
            ORDER BY sales_Rep_o__r.name
        ];
        
        map<id, opportunity> QualifiedOpsMap = new Map<id, opportunity>(NegData);
        
        if (!NegData.isEmpty()) {
            for (Opportunity o : NegData) {
                if (o.HasOverdueTask || o.HasOpenActivity) {
                    // remove all opptys which have an open tasks
                    
                    QualifiedOpsMap.remove(o.id);
                }
            }
        }

        // get all pipeline opportunities
        map<string, Integer> totalPipelineMap = new map<string, integer>();
        for(AggregateResult agr : [
            SELECT
            count(id) num,
            sales_rep_o__r.name name
            FROM Opportunity
            WHERE
            Parent_Opportunity__c = NULL
            AND sales_Rep_o__r.name IN :Active_SalesReps
            AND RecordType.name = 'Seawin USA Hospitality'
            AND GL_Account_Variable_1__r.Name = 'Seawin USA'
            AND ForecastCategoryName = 'Pipeline'
            group by sales_rep_o__r.name
            order by sales_rep_o__r.name asc]){

                totalPipelineMap.put((String)agr.get('name'), (integer)agr.get('num'));
        }
        
        map<string, List<ValuesWrapper>> NegOpptyMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValuesList = new List<ValuesWrapper>();
        
        if (QualifiedOpsMap.size() > 0) {

            for (Opportunity o : QualifiedOpsMap.values()) {

                DateTime modifyDate = o.LastModifiedDate;
                
                Date LMD = Date.newInstance(
                    modifyDate.year(),
                    modifyDate.month(),
                    modifyDate.day()
                );
                // shark
                Date LAD = o.LastActivityDate;

                Integer year = 0;
                Integer month = 0;
                
                Integer Modified_Neg_Days = LMD.daysBetween(d);
                Integer Activity_Neg_Days = LAD != null ? LAD.daysBetween(d) : 0;

                // In the code below we will keep the one with most Neg days out of the three above, means the oldest
                // For example if an opportunity has Modified_Neg_Days = 5
                // and Activity_Neg_Days = 2, then we will keep 5 as Neg days.

                Integer NegDays = 0;

                if (
                    Modified_Neg_Days > Activity_Neg_Days
                ) {
                    NegDays = Modified_Neg_Days;

                    year = modifyDate.year();
                    month = modifyDate.month();
                } else if (
                    Activity_Neg_Days > Modified_Neg_Days
                ) {
                    NegDays = Activity_Neg_Days;
                    year = LAD.year();
                    month = LAD.month();
                }else if(Activity_Neg_Days == Modified_Neg_Days){

                    NegDays = Activity_Neg_Days;
                    year = LAD.year();
                    month = LAD.month();
                }

                string salesrepName = o.Sales_Rep_O__r.name;

                ValuesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                                    Last12MonthsList_Horizontal.indexOf(Months[month - 1]),
                                    Months[month - 1],
                                    salesrepName,
                                    1,
                                    year,
                                    null,
                                    null
                                );
                
                if (NegOpptyMapLocal.containsKey(salesrepName)) {
                    ValuesList = NegOpptyMapLocal.get(
                        salesrepName
                    );
                    
                    Boolean IndexDoesNotExist = true;
                    
                    for (ValuesWrapper vwr : ValuesList) {
                        if (
                            vwr.valueindex == Last12MonthsList_Horizontal.indexOf(Months[month - 1])
                        ) {
                            // index exists then add 1 more
                            vwr.amount += 1;
                            IndexDoesNotExist = false;
                        }
                    }
                    
                    if (IndexDoesNotExist) {
                        ValuesList.add(vw);
                    }
                } else {
                    
                    ValuesList.add(vw);
                    
                }
                NegOpptyMapLocal.put(salesrepName, ValuesList);
            }
        }
        if (NegOpptyMapLocal.size() > 0) {

            for(string key : NegOpptyMapLocal.keyset()){

                List<ValuesWrapper> vws = NegOpptyMapLocal.get(key);

                for(ValuesWrapper vw : vws){
                    vw.misc = Decimal.valueOf(TotalPipelineMap.get(key));
                }

                vws = SortIndices(vws);

                NegOpptyMapLocal.put(key, vws);
            }
        }

        return NegOpptyMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> NewLeads() {

        Date d = getTodayDate();

        Set<string> Active_Users = Active_Users();
        List<String> Months = Months();
        Date MonthStart = getMonthStart();
        Date LastYearMonthStart = getLastYearMonthStart(); 
        String YearShort = getYearShort(); 
        String LastYearShort = getLastYearShort();
        String LastYear = getLastYear();
        String BigYear = getYear();

        map<string, List<ValuesWrapper>> NewLeadsMapLocal = new Map<string, List<ValuesWrapper>>();
        
        List<AggregateResult> NewLeadsData = [select Count(id) ct,Owner.name name, calendar_year(CreatedDate) year, 
        calendar_month(CreatedDate) month
        from Lead 
        where (CreatedDate = THIS_YEAR or CreatedDate = Last_Year)
        and Owner.name in:Active_Users and status = 'New'
        group by Owner.name,calendar_year(CreatedDate),calendar_month(CreatedDate)
        order by Owner.name,calendar_year(CreatedDate),
        calendar_month(CreatedDate)];
        
        map<string, Integer> UniqueMap = new Map<string, Integer>();
        
        Integer i = 0;
        if (!NewLeadsData.isEmpty()) {
            // Assing the sales rep the index from the graph
            for (AggregateResult a : NewLeadsData) {
                if (!UniqueMap.containsKey((string) a.get('name'))) {
                    UniqueMap.put((string) a.get('name'), i);
                    i++;
                }
            }
            //NewLeadsCategories.addAll(UniqueMap.keyset());
            for (AggregateResult a : NewLeadsData) {
                Integer year = (Integer) a.get('year');
                Integer month = (Integer) a.get('month');
                
                Integer SalesRepIndex = UniqueMap.get((String) a.get('name'));
                
                // this month or last year this month, so add the month data too
                Boolean isMonth = (month == MonthStart.Month() ||
                                   month == LastYearMonthStart.Month())
                    ? true
                    : false;
                
                // Find out the key
                String MonthKey = '';
                String YearKey = '';
                // Apr '20 , Apr '19, 2020, 2019 - Current Months and Years
                if (year == MonthStart.Year()) {
                    if (isMonth) {
                        // if current year month
                        Monthkey = Months[d.month() - 1] + ' \'' + YearShort;
                    }
                    YearKey = String.ValueOf(Year);
                } else if (Year == LastYearMonthStart.Year()) {
                    if (isMonth) {
                        // if current year month
                        Monthkey = Months[d.month() - 1] + ' \'' + LastYearShort;
                    }
                    YearKey = LastYear;
                }
                
                // contstruct the map
                if (NewLeadsMapLocal.containsKey(YearKey)) {
                    List<ValuesWrapper> YearExists = NewLeadsMapLocal.get(YearKey);
                    List<ValuesWrapper> MonthExists = new List<ValuesWrapper>();
                    if (isMonth) {
                        if (NewLeadsMapLocal.containsKey(MonthKey)) {
                            // if month exists
                            MonthExists = NewLeadsMapLocal.get(MonthKey);
                            Boolean SalesRepMissing = true;
                            
                            for (ValuesWrapper w : MonthExists) {
                                if (w.valueindex == UniqueMap.get((String) a.get('name'))) {
                                    SalesRepMissing = false;
                                    w.amount += (Decimal) a.get('ct');
                                }
                            }
                            if (SalesRepMissing) {
                                // if month exists but data for this sales rep is missing
                                MonthExists.add(
                                    new ValuesWrapper(
                                        UniqueMap.get((String) a.get('name')),
                                        (String) a.get('name'),
                                        MonthKey,
                                        (Decimal) a.get('ct'),
                                        month,
                                        null,
                                        null
                                    )
                                );
                            }
                        } else {
                            // if month does not exist at all
                            MonthExists.add(
                                new ValuesWrapper(
                                    UniqueMap.get((String) a.get('name')),
                                    (String) a.get('name'),
                                    MonthKey,
                                    (Decimal) a.get('ct'),
                                    month,
                                    null,
                                    null
                                )
                            );
                        }
                    }
                    
                    if (!YearExists.isEmpty()) {
                        Boolean SalesRepMissing = true;
                        
                        for (ValuesWrapper w : YearExists) {
                            if (w.valueindex == UniqueMap.get((String) a.get('name'))) {
                                SalesRepMissing = false;
                                w.amount += (Decimal) a.get('ct');
                            }
                        }
                        if (SalesRepMissing) {
                            // if year exists but the data for this sales rep is missing
                            YearExists.add(
                                new ValuesWrapper(
                                    UniqueMap.get((String) a.get('name')),
                                    (String) a.get('name'),
                                    YearKey,
                                    (Decimal) a.get('ct'),
                                    year,
                                    null,
                                    null
                                )
                            );
                        }
                    }
                    // finally add all to the main map
                    if (!YearExists.isEmpty()) {
                        NewLeadsMapLocal.put(YearKey, YearExists);
                    }
                    if (!MonthExists.isEmpty()) {
                        NewLeadsMapLocal.put(MonthKey, MonthExists);
                    }
                } else {
                    // totally new data
                    List<ValuesWrapper> NewLeadsDataList = new List<ValuesWrapper>();
                    if (isMonth) {
                        NewLeadsDataList.add(
                            new ValuesWrapper(
                                SalesRepIndex,
                                (String) a.get('name'),
                                MonthKey,
                                (Decimal) a.get('ct'),
                                month,
                                null,
                                null
                            )
                        );
                        NewLeadsMapLocal.put(MonthKey, NewLeadsDataList);
                    }
                    NewLeadsDataList.add(
                        new ValuesWrapper(
                            SalesRepIndex,
                            (String) a.get('name'),
                            YearKey,
                            (Decimal) a.get('ct'),
                            year,
                            null,
                            null
                        )
                    );
                    NewLeadsMapLocal.put(YearKey, NewLeadsDataList);
                }
            }
        }
        
        if (NewLeadsMapLocal.size() > 0) {
            List<string> ShouldExistKeys = new List<String>{
                Months[d.month() - 1] +
                    ' \'' +
                    YearShort,
                    Months[d.month() - 1] +
                    ' \'' +
                    LastYearShort,
                    BigYear,
                    LastYear
                    };
                        
            // check if any date period is missing, set it
            map<string, List<ValuesWrapper>> SortedMap = new Map<string, List<ValuesWrapper>>();
            for (String k : ShouldExistKeys) {
                if (NewLeadsMapLocal.containsKey(k)) {
                    SortedMap.put(k, NewLeadsMapLocal.get(k));
                } else {
                    SortedMap.put(k, new List<ValuesWrapper>());
                }
            }
            
            NewLeadsMapLocal = SortedMap;
            
            //NewLeadsKeys = NewLeadsMapLocal.keyset();
            //NewLeadsMap = NewLeadsMapLocal;
        }

        return NewLeadsMapLocal;
    }
    
    @RemoteAction
    @ReadOnly
    global static map<string, List<ValuesWrapper>> New_Customers_Last_12_Months_By_Type() {

        DateTime Full_Start_Date = Full_Start_Date();
        DateTime Full_End_Date = Full_End_Date();

        List<String> Last12MonthsList_Horizontal = Last12MonthsList_Horizontal();
        List<String> Months = Months();
        
        String Customer = 'Customer';
        String CustomerAndVendor = 'Customer And Vendor';
        
        List<AggregateResult> submitted = [
            SELECT
            calendar_month(createddate) month,
            calendar_year(createddate) year,
            Type typ,
            count(id) ct
            FROM Account
            WHERE
            createddate >= :Full_Start_Date
            AND createddate <= :Full_End_Date
            AND (AcctSeed__Accounting_Type__c = :Customer
                 OR AcctSeed__Accounting_Type__c = :CustomerAndVendor)
            AND AcctSeed__GL_Account_Variable_1__r.name = 'Seawin USA'
            GROUP BY Type, calendar_month(createddate), calendar_year(createddate)
            ORDER BY Type, calendar_year(createddate), calendar_month(createddate)
        ];
        
        map<string, List<ValuesWrapper>> NewCustomersLast12MonthsByTypeMapLocal = new Map<string, List<ValuesWrapper>>();
        List<ValuesWrapper> ValesList = new List<ValuesWrapper>();
        
        if (!submitted.isEmpty()) {
            Integer i = 0;
            for (AggregateResult a : submitted) {
                
                String key = a.get('typ') != null && 
                (String)a.get('typ') != 'NA' && (String)a.get('typ') != 'N/A' ? 
                (String) a.get('typ') : 'N/A';
                key = String.isNotEmpty(key) && key != 'N/A' ? key.capitalize() : key;
                
                ValesList = new List<ValuesWrapper>();
                
                ValuesWrapper vw = new ValuesWrapper(
                    Last12MonthsList_Horizontal.indexOf(
                        Months[(Integer) a.get('month') - 1]
                            ),
                            Months[(Integer) a.get('month') - 1],
                            Months[(Integer) a.get('month') - 1],
                            (Decimal) a.get('ct'),
                            (Integer) a.get('year'),
                            null,
                            null
                        );
                
                if (NewCustomersLast12MonthsByTypeMapLocal.containsKey(key)) {
                    
                    ValesList = NewCustomersLast12MonthsByTypeMapLocal.get(
                        key
                    );
                    ValesList.add(vw);
                } else {
                    
                    ValesList.add(vw);
                }
                NewCustomersLast12MonthsByTypeMapLocal.put(key, ValesList);
                i++;
            }
        }
        if (NewCustomersLast12MonthsByTypeMapLocal.size() > 0) {
            // sort the data
            List<string> sortedKeys = sortedKeys(
                NewCustomersLast12MonthsByTypeMapLocal
            );
            map<string, List<ValuesWrapper>> sortedMap = new Map<string, List<ValuesWrapper>>();
            
            for (string s : sortedKeys) {
                if (NewCustomersLast12MonthsByTypeMapLocal.containskey(s)) {
                    sortedMap.put(s, NewCustomersLast12MonthsByTypeMapLocal.get(s));
                }
            }
            
            NewCustomersLast12MonthsByTypeMapLocal = sortedMap;
            //NewCustomersLast12MonthsByTypeKeys = NewCustomersLast12MonthsByTypeMap.keyset();
        }

        return NewCustomersLast12MonthsByTypeMapLocal;
    }

    public HospitalityDashboardUSAController() {

    }
}
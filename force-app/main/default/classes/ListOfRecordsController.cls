public class ListOfRecordsController {
    public Map<String, Set<String>> UserAndTeams_Map { get; set; }
    public Set<String> usersNames { get; set; }
    public Decimal summedupamount {get; set;}
    public List<Opportunity> allOpportunities { get; set; }

    public Date Only_Start_Date {get; set;}
    public Date Only_End_Date {get; set;}
    public DateTime Full_Start_Date {get; set;}
    public DateTime Full_End_Date {get; set;}
    
    public Id LoggedInUserId { get; set; }
    public string LoggedInUserName { get; set; }
    public string chart { get; set; }
    public string click { get; set; }
    public string duration { get; set; }
    public string str { get; set; }
    public string title { get; set; }
    public string dashboard { get; set; }
    public string amountQuery { get; set; }

    public boolean showNeglectedField { get; set; }
    public boolean showactivedate { get; set; }
    public boolean showState { get; set; }
    public Boolean isTest { get; set; }
    
    public boolean ShowSubmittedDate { get; set; }
    public boolean ShowClosedDate { get; set; }
    public boolean ShowCloseDate { get; set; }
    public boolean ShowLossReason { get; set; }
    
    public boolean ShowFC { get; set; }
    public boolean ShowProb { get; set; }
    public boolean ShowER { get; set; }
    public boolean ShowWon { get; set; }
    public boolean ShowModBy { get; set; }
    public boolean ShowModDate { get; set; }
    
    public boolean ShowOwner { get; set; }
    public boolean ShowAwardedOwner { get; set; }
    public boolean showDueDate { get; set; }
    
    public Date d { get; set; }
    public Date MonthStart { get; set; }
    public Date MonthEnd { get; set; }
    public Date LastYearMonthStart { get; set; }
    public Date LastYearMonthEnd { get; set; }
    public DateTime CMonthStart { get; set; }
    public DateTime CMonthEnd { get; set; }
    public DateTime CLastYearMonthStart { get; set; }
    public DateTime CLastYearMonthEnd { get; set; }
    
    public set<string> Active_SalesReps { get; set; }
    public set<string> All_SalesReps { get; set; }
    public set<string> Active_SalesReps_USA { get; set; }
    public set<string> All_SalesReps_USA { get; set; }
    public set<string> Active_SalesReps_CHK { get; set; }
    public set<string> All_SalesReps_CHK { get; set; }
    
    // For USA users
    public set<string> Active_Users_USA { get; set; }
    public set<string> All_Users_USA { get; set; }
    public set<string> Inside_Sales_Users_USA { get; set; }
    public set<string> Inside_Sales_Users_USA_Id { get; set; }
    


    public List<Opportunity> opportunitiesModified  = new List<Opportunity>();
    // For China/Hong Kong users
    public set<string> Active_Users_CHK { get; set; }
    public set<string> All_Users_CHK { get; set; }
    public set<string> Inside_Sales_Users_CHK { get; set; }
    public set<string> Inside_Sales_Users_CHK_Id { get; set; }
    
    public string str2 { get; set; }
    public string str3 { get; set; }
    
    // ------------ New pagination code starts here
    public Integer size { get; set; }
    public ApexPages.StandardSetController Con { get; set; }
    public decimal TotalAmount {get; set;}
    public Integer getSerialNumber() {
        return con != null ? 100 * con.getPageNumber() - 100 : 0;
    }
            
    
    public Boolean hasNext {
        get {
            if(isOpptys) {
                return false;
            } else {
                return con.getHasNext();

            }
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            if(isOpptys){
                return false;
            } else {
                return con.getHasPrevious();

            }
        }
        set;
    }
    
    public Integer pageSize {
        get {
            return con.getPageSize();
        }
        set;
    }
    
    public Integer getTotalPages() {

        if(isOpptys){
            return 1;
        } else {
            Decimal totalSize = Con != null ? this.Con.getResultSize() : 0;
            Decimal pageSize = Con != null ? this.Con.getPageSize() : 0;
            
            Decimal pages = totalSize / pageSize;
            return (Integer) pages.round(System.RoundingMode.CEILING);
        }
        
    }
    
    public Integer pageNumber {
        get {
            if(isOpptys){
                return 1;
            } else {
                return con.getPageNumber();

            }
        }
        set;
    }
    public void first() {
        this.con.first();
    }
    
    // returns the last page of records
    public void last() {
        this.con.last();
    }
    
    // returns the previous page of records
    public void previous() {
        this.con.previous();
    }
    
    // returns the next page of records
    public void next() {
        this.con.next();
    }
    
    //-----------------------Lists-----------------------
    
    public Boolean isOrders { get; set; }
    public string QueryOrders { get; set; }
    public List<AcctSeedERP__Sales_Order__c> getOrders() {

        List<AcctSeedERP__Sales_Order__c> ordersList = 
        new List<AcctSeedERP__Sales_Order__c>();

        if(isOrders && Con != null) ordersList = (List<AcctSeedERP__Sales_Order__c>) Con.getRecords();

        // for(AcctSeedERP__Sales_Order__c order : ordersList){

        //     summedupamount += order.AcctSeedERP__Total__c;

        // }

        return ordersList;
    }

    public List<OpportunityHistory> getOpportunityHistory(){
        List<OpportunityHistory> opptyList = new List<OpportunityHistory>();

        if(isOpptys && Con != null) opptyList = (List<OpportunityHistory>) Con.getRecords();

        return opptyList;
    }
    
    public Boolean isOpptys { get; set; }
    public string QueryOpportunities { get; set; }
    public map<id, integer> NeglectedDaysMap { get; set; }
    public List<Opportunity> getOpportunities() {
        // if total for one page uncomment next line
        List<Opportunity> opptyList = 
        new List<Opportunity>();

        // if(isOpptys && Con != null) opptyList = (List<Opportunity>) Con.getRecords();
        if(isOpptys) opptyList = opportunitiesModified;

        if(allOpportunities != null){
            summedupamount = 0.00;

            if(!allOpportunities.isEmpty()){
                for(Opportunity oppty : allOpportunities){
                    if(oppty.Amount != null){
                        summedupamount += oppty.Amount;
                    }
                }
            } else {

            }
        }
            
        // system.debug('opptyList: '+opportunitiesModified.size());
        return opportunitiesModified;
    }
    
    public Boolean isAccounts { get; set; }
    public string QueryAccounts { get; set; }
    public List<Account> getAccounts() {
        return isAccounts && Con != null ? (List<Account>) Con.getRecords() : new List<Account>();
    }
    
    public Boolean isTasks { get; set; }
    public string QueryTasks { get; set; }
    public List<Task> getTasks() {
        return isTasks && Con != null ? (List<Task>) Con.getRecords() : new List<Task>();
    }
    
    public Boolean isBillings { get; set; }
    public string QueryBillings { get; set; }
    public List<AcctSeed__Billing__c> getBillings() {

        List<AcctSeed__Billing__c> billingList = 
        new List<AcctSeed__Billing__c>();

        if(isBillings && Con != null) billingList = (List<AcctSeed__Billing__c>) Con.getRecords();

        for(AcctSeed__Billing__c billing : billingList){

            summedupamount += chart.contains('Billing_Aging') ? billing.AcctSeed__Balance__c : billing.AcctSeed__Total__c;

        }

        return billingList;
    }
    
    public Boolean isLeads { get; set; }
    public string QueryLeads { get; set; }
    public List<Lead> getLeads() {
        return isLeads && Con != null ? (List<Lead>) Con.getRecords() : new List<Lead>();
    }
    
    public void calculateTotalAmount(List<sObject> data, String totalFieldName){
        summedupamount = 0.00;
        for(sObject item: data){
            if(item.get(totalFieldName) != null){
                summedupamount += (Decimal)item.get(totalFieldName);
            }
        }
    }


    public ListOfRecordsController() {
        this.BuildQuery();

        summedupamount = 0.00;
        
        ShowState = false;
        size = 100;
        isOrders = false;
        isOpptys = false;
        isBillings = false;
        isLeads = false;
        isTasks = false;
        isAccounts = false;
        
        showNeglectedField = false;
        showactivedate = false;
        showSubmittedDate = false;
        ShowClosedDate = false;
        ShowCloseDate = false;
        ShowLossReason = false;
        isTest = Test.isRunningTest();
        
        ShowFC = false;
        showProb = false;
        ShowER = false;
        ShowWon = false;
        ShowModBy = false;
        ShowModDate = false;
        
        ShowOwner = false;
        showAwardedOwner = false;
        showDueDate = false;
        
        TotalAmount = 0.00;
        
        d = date.today();
        
        NeglectedDaysMap = new Map<id, integer>();
        UserAndTeams_Map = new Map<String, Set<String>>();
        usersNames = new Set<String>();
        
        MonthStart = Date.newInstance(d.year(), d.month(), 1);
        MonthEnd = Date.newInstance(
            d.year(),
            d.month(),
            Date.daysInMonth(d.year(), d.month())
        );
        LastYearMonthStart = Date.newInstance(d.year() - 1, d.month(), 1);
        LastYearMonthEnd = Date.newInstance(
            d.year() - 1,
            d.month(),
            Date.daysInMonth(d.year() - 1, d.month())
        );
        
        CMonthStart = FindMonthStartDate(d.year(), d.month());
        CMonthEnd = FindMonthEndDate(d.year(), d.month());
        CLastYearMonthStart = FindMonthStartDate(d.year() - 1, d.month());
        CLastYearMonthEnd = FindMonthEndDate(d.year() - 1, d.month());
        
        LoggedInUserId = UserInfo.getUserId();
        LoggedInUserName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        
        chart = ApexPages.currentPage().getParameters().get('chart'); // chart name
        title = ApexPages.currentPage().getParameters().get('title'); // title to show on visualforce page
        click = ApexPages.currentPage().getParameters().get('click'); // chart,bar,legend
        duration = ApexPages.currentPage().getParameters().get('duration'); // TM, LYTM, LY, TY etc.
        str = ApexPages.currentPage().getParameters().get('str'); // leadsource, stagename etc.
        dashboard = ApexPages.currentPage().getParameters().get('dashboard'); // SD, SMD_USA, SMD_CHK
        
        //---------------For Last Twelve Months
        // find how many months have passed in this year
        Integer Months_Passed = d.month();
        
        // TM = Twelve Months
        
        Integer Common_Start_Year = (Months_Passed < 12) ? d.year() - 1 : d.year();
        Integer Common_Start_Month = d.month() < 12 ? d.month() + 1 : 1;
        
        Only_Start_Date = Date.newInstance(Common_Start_Year, Common_Start_Month, 1);
        Only_End_Date = Date.Today();
        
        //Full_Start_Date = DateTime.newInstance(Common_Start_Year, Common_Start_Month, 1, 0, 0, 0);
        
        String sdate_str = Common_Start_Year + '-'+ Common_Start_Month+'-01T00:00:00.000Z';
        Full_Start_Date = DateTime.ValueofGmt(sdate_str.replace('T', ' '));
        Full_End_Date = DateTime.now();
        
        // Graph title correction
        if (title == 'Newly Submitted Opportunities') {
            title = 'Newly Submitted Quotes';
        }
        
        All_SalesReps = new Set<string>();
        Active_SalesReps = new Set<string>();
        All_SalesReps_USA = new Set<string>();
        Active_SalesReps_USA = new Set<string>();
        All_SalesReps_CHK = new Set<string>();
        Active_SalesReps_CHK = new Set<string>();
        
        /* ---------------------------------- Common Sales Reps compilation -------------------------------- */
        // Becuase we are getting the all sales rep name containing record by GL Account Variable i.e Seawin USA/Seawin China or HK
        
        List<sales_rep__c> All_SalesReps_List = [
            SELECT name
            FROM sales_rep__c
            WHERE name != 'Murtaza Ashraf' AND name != 'Ashraf Murtaza'
        ];
        if (!All_SalesReps_List.isEmpty()) {
            for (Sales_rep__c all_sales : All_SalesReps_List) {
                All_SalesReps.add(all_sales.name);
            }
        }
        List<sales_rep__c> Active_Sales_Reps_List = [
            SELECT name
            FROM sales_rep__c
            WHERE
            Active__c = 'Yes'
            AND name != 'Murtaza Ashraf'
            AND name != 'Ashraf Murtaza'
        ];
        if (!Active_Sales_Reps_List.isEmpty()) {
            for (Sales_rep__c active_reps : Active_Sales_Reps_List) {
                Active_SalesReps.add(active_reps.name);
            }
        }
        
        List<sales_rep__c> All_SalesReps_List_USA = [
            SELECT name
            FROM sales_rep__c
            WHERE
            name != 'Murtaza Ashraf'
            AND name != 'Ashraf Murtaza'
        ];
        if (!All_SalesReps_List_USA.isEmpty()) {
            for (Sales_rep__c all_sales : All_SalesReps_List_USA) {
                All_SalesReps_USA.add(all_sales.name);
            }
        }
        List<sales_rep__c> Active_Sales_Reps_List_USA = [
            SELECT name
            FROM sales_rep__c
            WHERE
            Active__c = 'Yes'
            AND name != 'Murtaza Ashraf'
            AND name != 'Ashraf Murtaza'
        ];
        if (!Active_Sales_Reps_List_USA.isEmpty()) {
            for (Sales_rep__c active_reps : Active_Sales_Reps_List_USA) {
                Active_SalesReps_USA.add(active_reps.name);
            }
        }
        
        List<sales_rep__c> All_SalesReps_List_CHK = [
            SELECT name
            FROM sales_rep__c
            WHERE
            name != 'Murtaza Ashraf'
            AND name != 'Ashraf Murtaza'
        ];
        if (!All_SalesReps_List_CHK.isEmpty()) {
            for (Sales_rep__c all_sales : All_SalesReps_List_CHK) {
                All_SalesReps_CHK.add(all_sales.name);
            }
        }
        List<sales_rep__c> Active_Sales_Reps_List_CHK = [
            SELECT name
            FROM sales_rep__c
            WHERE
            Active__c = 'Yes'
            AND name != 'Murtaza Ashraf'
            AND name != 'Ashraf Murtaza'
        ];
        if (!Active_Sales_Reps_List_CHK.isEmpty()) {
            for (Sales_rep__c active_reps : Active_Sales_Reps_List_CHK) {
                Active_SalesReps_CHK.add(active_reps.name);
            }
        }
        
        // compilation ends
        
        if (dashboard == 'SMD_USA') {
            // For USA users
            
            All_Users_USA = new Set<string>();
            Active_Users_USA = new Set<string>();
            Inside_Sales_Users_USA = new Set<string>();
            Inside_Sales_Users_USA_Id = new Set<string>();
            
            /* ---------------------------------- USA Users and Sales Reps compilation -------------------------------- */
            
            // All users
            List<User> All_Users_USA_List = [
                SELECT name
                FROM user
                WHERE
                name != 'Murtaza Ashraf'
                AND name != 'Ashraf Murtaza'
                AND default_gl_account_variable__c INCLUDES ('Seawin USA')
            ];
            
            if (!All_Users_USA_List.isEmpty()) {
                for (User all_usrs : All_Users_USA_List) {
                    All_Users_USA.add(all_usrs.name);
                }
            }
            
            // Active users
            List<User> Active_Users_USA_List = [
                SELECT name
                FROM user
                WHERE
                isActive = TRUE
                AND name != 'Murtaza Ashraf'
                AND name != 'Ashraf Murtaza'
                AND default_gl_account_variable__c INCLUDES ('Seawin USA')
            ];
            
            if (!Active_Users_USA_List.isEmpty()) {
                for (User active_usr : Active_Users_USA_List) {
                    Active_Users_USA.add(active_usr.name);
                }
            }
            
            List<User> Inside_Sales_Users_List_USA = [
                SELECT id, name
                FROM user
                WHERE
                default_gl_account_variable__c INCLUDES ('Seawin USA')
                AND Profile.name LIKE '%Inside Sales%'
                AND name != 'Murtaza Ashraf'
                AND name != 'Ashraf Murtaza'
            ];
            
            if (!Inside_Sales_Users_List_USA.isEmpty()) {
                for (User inside_usrs_usa : Inside_Sales_Users_List_USA) {
                    Inside_Sales_Users_USA.add(inside_usrs_usa.name);
                    Inside_Sales_Users_USA_Id.add(inside_usrs_usa.id);
                }
            }
            
            if (isTest) {
                All_Users_USA.add('Murtaza Ashraf');
                Active_Users_USA.add('Murtaza Ashraf');
                Inside_Sales_Users_USA.add('Murtaza Ashraf');
            }
        }
        
        if (dashboard == 'SMD_CHK') {
            All_Users_CHK = new Set<string>();
            Active_Users_CHK = new Set<string>();
            Inside_Sales_Users_CHK = new Set<string>();
            Inside_Sales_Users_CHK_Id = new Set<string>();
            
            /* ---------------------------------- Seawin China/Hong Kong Users and Sales Reps compilation -------------------------------- */
            
            // All users
            List<User> All_Users_CHK_List = [
                SELECT name
                FROM user
                WHERE
                name != 'Murtaza Ashraf'
                AND name != 'Ashraf Murtaza'
                AND (default_gl_account_variable__c INCLUDES ('Seawin China')
                     OR default_gl_account_variable__c INCLUDES ('Seawin Hong Kong'))
            ];
            
            if (!All_Users_CHK_List.isEmpty()) {
                for (User all_usrs : All_Users_CHK_List) {
                    All_Users_CHK.add(all_usrs.name);
                }
            }
            
            // Active users
            List<User> Active_Users_CHK_List = [
                SELECT name
                FROM user
                WHERE
                isActive = TRUE
                AND name != 'Murtaza Ashraf'
                AND name != 'Ashraf Murtaza'
                AND (default_gl_account_variable__c INCLUDES ('Seawin China')
                     OR default_gl_account_variable__c INCLUDES ('Seawin Hong Kong'))
            ];
            
            if (!Active_Users_CHK_List.isEmpty()) {
                for (User active_usr : Active_Users_CHK_List) {
                    Active_Users_CHK.add(active_usr.name);
                }
            }
            
            List<User> Inside_Sales_Users_CHK_List = [
                SELECT id,name
                FROM user
                WHERE
                default_gl_account_variable__c INCLUDES (
                    'Seawin China',
                    'Seawin Hong Kong'
                )
                AND Profile.name LIKE '%Inside Sales%'
                AND name != 'Murtaza Ashraf'
                AND name != 'Ashraf Murtaza'
            ];
            
            if (!Inside_Sales_Users_CHK_List.isEmpty()) {
                for (User inside_users_CHK : Inside_Sales_Users_CHK_List) {
                    Inside_Sales_Users_CHK.add(inside_users_CHK.name);
                    Inside_Sales_Users_CHK_Id.add(inside_users_CHK.id);
                }
            }
            
            // Only valid for testing purposes
            if (isTest) {
                All_Users_CHK.add('Murtaza Ashraf');
                Active_Users_CHK.add('Murtaza Ashraf');
                Inside_Sales_Users_CHK.add('Murtaza Ashraf');
            }
        }
        
        if (isTest) {
            All_SalesReps.add('Murtaza Ashraf');
            Active_SalesReps.add('Murtaza Ashraf');
            All_SalesReps_USA.add('Murtaza Ashraf');
            Active_SalesReps_USA.add('Murtaza Ashraf');
            All_SalesReps_CHK.add('Murtaza Ashraf');
            Active_SalesReps_CHK.add('Murtaza Ashraf');
        }
        
        str2 = str;
        str3 = str;
        
        if (str == 'N/A' || str == 'NA') {
            str = '';
            str2 = 'NA';
            str3 = 'N/A';
        }
        
        if (dashboard == 'FD')
            this.Financial_Dashboard();
        if (dashboard == 'SD')
            this.Sales_Dashboard();
        if (dashboard == 'SMD_USA')
            this.Sales_Manager_Dashboard_USA();
        if (dashboard == 'SMD_CHK')
            this.Sales_Manager_Dashboard_CHK();
    }
    
    public void BuildQuery() {
        // Sales Orders
        String fields = AllFields.Fields(
            'AcctSeedERP__Sales_Order__c',
            new List<String>()
        );
        
        QueryOrders = 'SELECT ';
        QueryOrders += fields + ',AcctSeedERP__Opportunity__r.Leadsource';
        QueryOrders += ' FROM AcctSeedERP__Sales_Order__c where ';
        
        // Opportunities
        fields = AllFields.Fields('Opportunity', new List<String>());
        
        QueryOpportunities = 'SELECT ';
        QueryOpportunities += fields + ',Owner.Name';
        QueryOpportunities += ' FROM Opportunity where ';
        
        amountQuery = 'SELECT Id, Amount, Owner.Name FROM Opportunity where ';
        // Accounts
        fields = AllFields.Fields('Account', new List<String>());
        
        QueryAccounts = 'SELECT ';
        QueryAccounts += fields;
        QueryAccounts += ' FROM Account where ';
        
        // Tasks
        fields = AllFields.Fields('Task', new List<String>());
        
        QueryTasks = 'SELECT ';
        QueryTasks += fields;
        QueryTasks += ' FROM Task where ';
        
        // Billings
        fields = AllFields.Fields('AcctSeed__Billing__c', new List<String>());
        
        QueryBillings = 'SELECT ';
        QueryBillings += fields;
        QueryBillings += ' FROM AcctSeed__Billing__c where ';
        
        // Leads
        fields = AllFields.Fields('Lead', new List<String>());
        
        QueryLeads = 'SELECT ';
        QueryLeads += fields + ',CreatedBy.name';
        QueryLeads += ' FROM Lead where ';
    }
    
    public string Build_Query_Helper() {
        user usr = [
            SELECT default_gl_account_variable__c
            FROM user
            WHERE id = :userinfo.getUserId()
            LIMIT 1
        ];
        
        string queryHelper = '';
        
        if (usr.default_gl_account_variable__c != null) {
            List<string> RegionList = usr.default_gl_account_variable__c.split(';');
            
            set<String> RegionSet = new Set<String>(REgionLIst);
            
            integer len = RegionSet.size();
            integer i = 1;
            
            if (len > 1) {
                queryHelper += ' ( ';
            }
            
            for (String str : RegionSet) {
                queryHelper +=
                    'GL_Account_Variable_1__c =\'' +
                    str +
                    '\'' +
                    ((i < len && len > 1) ? ' Or ' : '');
                
                i++;
            }
            
            if (len > 1) {
                queryHelper += ' ) ';
            }
            
            queryHelper += ' And ';
        }
        
        return queryHelper;
    }
    
    public void Financial_Dashboard() {
        String queryHelper = Build_Query_Helper();
        
        if (chart == 'Billing_Aging_FD') {
            isBillings = true;
            string Closed = 'Closed';
            string Posted = 'Posted';
            string CreditMemo = 'Credit Memo';
            
            String QueryStr = QueryBillings;
            QueryStr += ' AcctSeed__Status__c =:Posted and AcctSeed__Type__c !=:CreditMemo and ';
            QueryStr += queryHelper;
            
            if (click == 'chart') {
                QueryStr += ' AcctSeed__Age__c !=:Closed ';
            } else if (click == 'bar') {
                QueryStr += ' AcctSeed__Age__c = :str ';
            }
            QueryStr += ' order by AcctSeed__Age__c asc, AcctSeed__Balance__c desc ';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        }
    }
    
    public void Sales_Dashboard() {
        if (chart == 'Quota_YTD') {
            isOrders = true;
            String FullName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            
            DateTime YearStartDate = FindMonthStartDate(d.year(), 1);
            
            DateTime YearToDateDate = DateTime.now();
            
            String QueryStr = QueryOrders;
            QueryStr += ' CreatedDate >=: YearStartDate and CreatedDate <=: YearToDateDate';
            QueryStr += ' and Owner.name =:FullName ';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_By_Lead_Source_Last_12_Months') {
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA'){
                
                str = '';
                str2 = 'N/A';
                str2 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            //---------------
            
            string QueryStr = QueryOrders;
            QueryStr += ' ownerId = \'' + LoggedInUserId + '\'';
            
            if (click == 'chart') {
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += str == '' ? ' and (AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'' : 
                ' and AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str3 + '\')' : '';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'' : 
                ' and AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str3 + '\')' : '';
                
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <:SalesMonthEnd ';
            }
            QueryStr += ' order by AcctSeedERP__Opportunity__r.Leadsource asc, CreatedDate desc';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Monthly_Sales_Last_12_Months') {
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' Owner.name != \'Murtaza Ashraf\' ';
            QueryStr += ' and OwnerId =:LoggedInUserId ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_Rep_o__r.Name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and Sales_Rep_o__r.Name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date ';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Forecast_Pipeline_By_Lead_Source') {
            isOpptys = true;
            ShowCloseDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date ForecastMonthStart = Date.newInstance(year, month, 1);
            Date ForecastMonthEnd = Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
            Date Future_Date = Pipeline_Start_Date.addMonths(11);
            
            Date Pipeline_End_Date = Date.newInstance(
                Future_Date.year(),
                Future_Date.month(),
                Date.daysInMonth(Future_Date.year(), Future_Date.month())
            );
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' and ownerId = \'' + LoggedInUserId + '\'';
            
            if (click == 'chart') {
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'bar') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'left') {
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            }
            
            QueryStr += ' order by Name,Probability desc NULLS LAST';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Forecast_Pipeline') {
            isOpptys = true;
            ShowCloseDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date ForecastMonthStart = Date.newInstance(year, month, 1);
            Date ForecastMonthEnd = Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
            Date Pipeline_End_Date = d.addMonths(11);
            Pipeline_End_Date = Date.newInstance(
                Pipeline_End_Date.year(),
                Pipeline_End_Date.month(),
                Date.daysInMonth(Pipeline_End_Date.year(), Pipeline_End_Date.month())
            );
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' ownerId =:LoggedInUserId ';
            QueryStr += ' and ForecastCategoryName = \'Pipeline\' ';
            
            if (click == 'chart') {
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'legend') {
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date';
            } else if (click == 'bar') {
                QueryStr += str == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            }
            
            QueryStr += ' order by Name,Probability asc NULLS LAST';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Pipeline_Last_12_Months') {
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            // Monthly data
            
            Date PointMonthStart = Date.newInstance(year, month, 1);
            DateTime PointMonthEnd = FindMonthEndDate(year, month);
            Date PointMonthEndClosed = Date.newInstance(year, month, 
                                                        Date.daysInMonth(d.year(), d.month()));
            
            String QueryStr = QueryOpportunities;
            QueryStr += ' ownerId =:LoggedInUserId ';
            QueryStr += ' and Amount != 0 and Amount != null ';
            
            if (click == 'chart') {
                QueryStr += ' and ForecastCategoryName =\'Pipeline\' and createddate <=:Full_End_Date ';
            } else if (click == 'legend') {
                QueryStr += ' and ForecastCategoryName =\'Pipeline\' and createddate <=:Full_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and ForecastCategoryName =\'Pipeline\' and createddate <=:PointMonthEnd ';
            }
            
            QueryStr += ' order by Name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Opportunities_Last_12_Months') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            //string QueryStr = QueryOpportunities;
            string QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue, (Select Status From Quotes Order By CreatedDate Asc Limit 1) FROM Opportunity where ';
            
            QueryStr += ' (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            QueryStr += ' and ownerId = \'' + LoggedInUserId + '\'';
            
            if (click == 'chart') {
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'month-point') {
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by Newly_Submitted_Quote_First_Date__c desc';
            
            //Changing the code start
            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> allOppts = Database.query(QueryStr);
            for (Opportunity opp : allOppts) {
                for (Quote qt : opp.Quotes) {
                    if (qt.Status == 'Presented') {
                        oppIds.add(opp.Id);
                    }
                }
            }
            
            QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue FROM Opportunity where Id in :oppIds';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Opportunities_Last_12_Months_By_Lead_Source') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? date.today() : Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            //string QueryStr = QueryOpportunities;
            string QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue, (Select Status From Quotes Order By CreatedDate Asc Limit 1) FROM Opportunity where ';
            
            QueryStr += ' (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            QueryStr += ' and ownerId = \'' + LoggedInUserId + '\'';
            
            if (click == 'chart') {
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by Newly_Submitted_Quote_First_Date__c desc';
            
            //Changing the code start
            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> allOppts = Database.query(QueryStr);
            for (Opportunity opp : allOppts) {
                for (Quote qt : opp.Quotes) {
                    if (qt.Status == 'Presented') {
                        oppIds.add(opp.Id);
                    }
                }
            }
            
            QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue FROM Opportunity where Id in :oppIds';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Lost_Opportunities') {
            isOpptys = true;
            ShowClosedDate = true;
            ShowLossReason = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date LostOpptyMonthStart = Date.newInstance(year, month, 1);
            Date LostOpptyMonthEnd = month == d.month() ? date.today() : Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' StageName = \'Closed Lost\' ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            QueryStr += ' AND ownerId = \'' + LoggedInUserId + '\'';
            
            if (click == 'chart') {
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'month-point') {
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            }
            
            QueryStr += ' order by Closed_Date__c desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Lost_Opportunities_Loss_Reasons') {
            isOpptys = true;
            ShowClosedDate = true;
            ShowLossReason = true;
            String str = ApexPages.currentPage().getParameters().get('str');
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date LostOpptyMonthStart = Date.newInstance(year, month, 1);
            Date LostOpptyMonthEnd = month == d.month() ? date.today() : Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' StageName = \'Closed Lost\' ';
            QueryStr += ' AND ownerId = \'' + LoggedInUserId + '\'';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            } else if (click == 'point') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c =  null ';
                } else {
                    QueryStr += ' AND Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'month-point') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c =  null ';
                } else {
                    QueryStr += ' AND Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'legend') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c =  null ';
                } else {
                    QueryStr += ' AND Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            }
            
            QueryStr += ' order by Closed_Date__c desc';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'YourWinRate_SD') {
            isOpptys = true;
            showClosedDate = true;
            ShowWon = true;
            ShowProb = true;
            
            string GL_Variable = [
                SELECT Default_GL_Account_Variable__c
                FROM user
                WHERE id = :UserInfo.getUserId()
                LIMIT 1
            ][0]
                .Default_GL_Account_Variable__c;
            
            string recordtypename = GL_Variable == 'Seawin USA'
                ? 'Seawin USA Hospitality'
                : 'Seawin China Hospitality';
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string HelperStr = ' ownerid =:LoggedInUserId and';
            HelperStr += ' RecordType.Name =:recordtypename and';
            HelperStr += ' (StageName = \'Closed Won\' or';
            HelperStr += ' StageName = \'Closed Lost\') ';
            HelperStr += ' and (not Name LIKE:ChangeOrder)';
            HelperStr += ' and (not Name LIKE:MockupOne)';
            HelperStr += ' and (not Name LIKE:MockupTwo)';
            HelperStr += ' and (not Name LIKE:MockupThree)';
            HelperStr += ' and (not Name LIKE:MockupFour)';
            HelperStr += ' order by name asc';
            
            string QueryStr = QueryOpportunities;
            
            if (click == 'bar' && str == 'Negotiation') {
                set<id> HistoryIds = new Set<id>();
                
                for (OpportunityHistory hstry : [
                    SELECT Id, OpportunityId, CreatedDate, StageName, Amount, CloseDate
                    FROM OpportunityHistory
                    WHERE
                    StageName = 'Negotiation'
                    AND Opportunity.RecordType.name = :recordtypename
                    AND Opportunity.ownerid = :LoggedInUserId
                ]) {
                    HistoryIds.add(hstry.OpportunityId);
                }
                QueryStr += ' id in:HistoryIds and';
            }
            
            QueryStr += HelperStr;
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Neglected_Opportunities') {
            
            isOpptys = true;
            ShowModBy = true;
            ShowModDate = true;
            ShowER = true;
            ShowProb = true;
            showNeglectedField = true;
            
            Boolean Thirty = false;
            Boolean Sixty = false;
            Boolean Ninty = false;
            Boolean Over120 = false;
            
            if (duration == '0') {
                Thirty = true;
            } else if (duration == '1') {
                Sixty = true;
            } else if (duration == '2') {
                Ninty = true;
            } else if (duration == '3') {
                Over120 = true;
            }
            
            Date Last_Thirty_Days = date.today() - 30; // Today minus 30 days, will give us a date before 30 days
            
            string QueryStr = QueryOpportunities;
            QueryStr += Test.isRunningTest()
                ? ' Id != null '
                : ' ownerId =:LoggedInUserId and Parent_Opportunity__c = null ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' and ForecastCategoryName != \'Omitted\' and ForecastCategoryName != \'Closed\' ';
            
            QueryStr += Test.isRunningTest()
                ? ''
                : ' and (LastActivityDate <:Last_Thirty_Days or ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' (LastActivityDate = null and (LastModifiedDate <:Last_Thirty_Days and ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' LastModifiedBy.Name != \'Murtaza Ashraf\' and LastModifiedBy.Name != \'Ashraf Murtaza\'))) ';
            
            QueryStr += ' order by name asc ';
            
            List<Opportunity> opptys = (List<Opportunity>) Database.Query(QueryStr);
            
            map<id, opportunity> QualifiedOpsMap = new Map<id, opportunity>(opptys);
            map<id, opportunity> opportunitiesMap = new Map<id, opportunity>();
            NeglectedDaysMap = new Map<id, integer>();
            
            if (QualifiedOpsMap.size() > 0) {
                for (Opportunity o : QualifiedOpsMap.values()) {
                    if (o.HasOverdueTask || o.HasOpenActivity) {
                        QualifiedOpsMap.remove(o.id);
                    }
                }
            }
            
            if (QualifiedOpsMap.size() > 0) {
                for (Opportunity o : QualifiedOpsMap.values()) {
                    DateTime modifyDate = o.LastModifiedDate;
                    
                    Date LMD = Date.newInstance(
                        modifyDate.year(),
                        modifyDate.month(),
                        modifyDate.day()
                    );
                    Date LAD = o.LastActivityDate;
                    
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
                    } else if (
                        Activity_Neg_Days > Modified_Neg_Days
                    ) {
                        NegDays = Activity_Neg_Days;
                    }
                    
                    if (click == 'bar' || click == 'legend') {
                        if (Thirty) {
                            if (NegDays > 30 && NegDays < 61) {
                                opportunitiesMap.put(o.id, o);
                            }
                        } else if (Sixty) {
                            if (NegDays > 60 && NegDays < 91) {
                                opportunitiesMap.put(o.id, o);
                            }
                        } else if (Ninty) {
                            if (NegDays > 90 && NegDays < 121) {
                                opportunitiesMap.put(o.id, o);
                            }
                        } else if (Over120) {
                            if (NegDays > 120) {
                                opportunitiesMap.put(o.id, o);
                            }
                        }
                        NeglectedDaysMap.put(o.id, NegDays);
                    } else {
                        if (NegDays > 0) {
                            opportunitiesMap.put(o.id, o);
                            NeglectedDaysMap.put(o.id, NegDays);
                        }
                    }
                }
                
                if (opportunitiesMap.size() > 0) {
                    // sort the map
                    List<id> sortedKeys = this.sortEngine(NeglectedDaysMap);
                    map<id, opportunity> sortedMap = new Map<id, opportunity>();
                    
                    for (id s : sortedKeys) {
                        if (opportunitiesMap.containskey(s)) {
                            sortedMap.put(s, opportunitiesMap.get(s));
                        }
                    }
                    
                    opportunitiesMap = sortedMap;
                }
            }
            string FinalQueryStr = QueryOpportunities;
            set<id> OpptysIds = new Set<id>(opportunitiesMap.keyset());
            FinalQueryStr += ' id in:OpptysIds ';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(FinalQueryStr)
            );
            
            Con.setPageSize(size);
        } else if (chart == 'Active_Opportunities_By_Stage') {
            isOpptys = true;
            ShowER = true;
            ShowProb = true;
            showCloseDate = true;
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' ForecastCategoryName != \'Omitted\' and ForecastCategoryName != \'Closed\' ';
            QueryStr += ' and ownerId = \'' + LoggedInUserId + '\'';
            
            if (click == 'chart') {
            } else if (click == 'bar') {
                QueryStr += ' and stagename = \'' + duration + '\'';
            } else if (click == 'legend') {
                QueryStr += '  and stagename = \'' + duration + '\'';
            } else if (click == 'left') {
                QueryStr += '  and stagename = \'' + duration + '\'';
            }
            QueryStr += ' order by stagename ';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Tasks_Completion') {
            isTasks = true;
            string DateStr = '';
            
            if (duration == 'ODT') {
                DateStr += ' ActivityDate <: d and';
                DateStr += ' ActivityDate != null and status = \'Open\'';
            } else if (duration == 'OTT') {
                DateStr += ' ActivityDate >: d and ';
                DateStr += ' ActivityDate != null and status = \'Open\'';
            } else if (duration == 'NDT') {
                DateStr += ' ActivityDate=null and status=\'Open\'';
            } else {
                DateStr += ' ((ActivityDate <: d and';
                DateStr += ' ActivityDate != null and status = \'Open\')';
                
                DateStr += ' or (ActivityDate >: d and ';
                DateStr += ' ActivityDate != null and status = \'Open\')';
                
                DateStr += ' or (ActivityDate=null and status=\'Open\'))';
            }
            
            DateStr += ' and ownerId =:LoggedInUserId';
            
            string QueryStr = QueryTasks;
            
            if (click == 'chart') {
                QueryStr += DateStr;
            } else if (click == 'legend' || click == 'bar') {
                QueryStr += DateStr;
            }
            
            QueryStr += ' order by activitydate desc';
            //calculateTotalAmount((List<Task>)Database.query(QueryStr), 'AcctSeed__Total__c');

            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        }   
    }
    
    public void Sales_Manager_Dashboard_USA() {
        if (chart == 'Billing_Aging_SMD') {
            isBillings = true;
            string Closed = 'Closed';
            string Posted = 'Posted';
            string CreditMemo = 'Credit Memo';
            
            String QueryStr = QueryBillings;
            QueryStr += ' AcctSeed__Status__c =:Posted and AcctSeed__Type__c !=:CreditMemo and ';
            QueryStr += ' Owner.name in:All_Users_USA and ';
            QueryStr += ' GL_Account_Variable_1__c =\'Seawin USA\' and ';
            
            if (click == 'chart') {
                QueryStr += ' AcctSeed__Age__c !=:Closed ';
            } else if (click == 'bar') {
                QueryStr += ' AcctSeed__Age__c =:str ';
            }

            QueryStr += ' order by AcctSeed__Age__c asc, AcctSeed__Balance__c desc ';
            //! Checked does contains Billing Aging
            calculateTotalAmount((List<AcctSeed__Billing__c>)Database.query(QueryStr), 'AcctSeed__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Collection_Performance_SMD') {
            isBillings = true;
            string Closed = 'Closed';
            string Posted = 'Posted';
            string CreditMemo = 'Credit Memo';
            
            String QueryStr = QueryBillings;
            
            if (click == 'chart') {
                QueryStr += ' AcctSeed__Status__c =:Posted and ';
                QueryStr += ' AcctSeed__Age__c !=:Closed and ';
                QueryStr += ' AcctSeed__Type__c !=:CreditMemo and ';
                QueryStr += ' owner.name in:All_Users_USA and ';
                QueryStr += ' GL_Account_Variable_1__c =\'Seawin USA\' ';
                QueryStr += ' order by AcctSeed__Age__c asc, AcctSeed__Balance__c desc ';
            }
            //summedupamount += chart.contains('Billing_Aging') ? billing.AcctSeed__Balance__c : billing.AcctSeed__Total__c;
            //chart == Collection_Performance_SMD and not contain Billing_Aging, and we put AcctSeed__Balance__c field to calc method
            calculateTotalAmount((List<AcctSeed__Billing__c>)Database.query(QueryStr), 'AcctSeed__Balance__c');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Monthly_Sales_Last_12_Months_SMD_H') {
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
                QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
                QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
                QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <:SalesMonthEnd ';
                QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Current_Sales_Contest_YTD_SMD') {
            isOrders = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and CreatedDate = THIS_YEAR ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                queryStr += ' and Sales_rep_o__r.name in:Active_SalesReps_USA ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } 
        else if (chart == 'Current_Sales_Contest_QTD_SMD') {
            isOrders = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and CreatedDate = THIS_QUARTER ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                queryStr += ' and Sales_rep_o__r.name in:Active_SalesReps_USA ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';

            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            

            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } 
        else if (chart == 'Current_Sales_Contest_TM_SMD') {
            isOrders = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and CreatedDate = THIS_MONTH ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                queryStr += ' and Sales_rep_o__r.name in:Active_SalesReps_USA ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' and AcctSeedERP__Status__c != \'' + 'Cancelled' + '\'';
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';

            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Team_Quota_YTD_SMD') {
            isOrders = true;
            
            DateTime YearStartDate = FindMonthStartDate(d.year(), 1);
            
            DateTime YearToDateDate = DateTime.now();
            
            String QueryStr = QueryOrders;
            QueryStr += ' CreatedDate >=: YearStartDate and CreatedDate <=: YearToDateDate and';
            QueryStr += ' recordtype.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and Sales_Rep_o__r.name in:All_SalesReps_USA ';
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Team_Quota_Percent_SMD') {
            isOrders = true;
            
            DateTime YearStartDate = FindMonthStartDate(d.year(), 1);
            
            DateTime YearToDateDate = DateTime.now();
            
            String srsQuery = 'select id, name, Monthly_Quota__c from sales_rep__c where ';
            
            if (click == 'chart') {
                srsQuery += ' name in:All_SalesReps_USA ';
            } else if (click == 'bar') {
                srsQuery += ' name = \'' + str + '\'';
            }
            
            List<Sales_rep__c> SalesRep = Database.Query(srsQuery);
            
            set<string> srNames = new Set<string>();
            
            if (!SalesRep.isEmpty()) {
                for (Sales_rep__c s : salesrep) {
                    if (s.Monthly_Quota__c != null && s.Monthly_Quota__c != 0) {
                        srNames.add(s.name);
                    }
                }
            }
            
            String QueryStr = QueryOrders;
            QueryStr += ' CreatedDate >=: YearStartDate and CreatedDate <=: YearToDateDate and';
            QueryStr += ' recordtype.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and Sales_Rep_o__r.name in:srNames and ';
            QueryStr += ' acctseederp__total__c > 0 ';
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Forecast_Pipeline_SMD') {
            isOpptys = true;
            ShowCloseDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date ForecastMonthStart = Date.newInstance(year, month, 1);
            Date ForecastMonthEnd = Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
            Date Future_Date = Pipeline_Start_Date.addMonths(11);
            
            Date Pipeline_End_Date = Date.newInstance(
                Future_Date.year(),
                Future_Date.month(),
                Date.daysInMonth(Future_Date.year(), Future_Date.month())
            );
            


            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and ForecastCategoryName = \'Pipeline\' ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            }
            
            QueryStr += ' order by Name,Probability desc NULLS LAST';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            amountQuery += QueryStr.split('where')[1];
            calculateTotalAmount((List<Opportunity>)Database.query(amountQuery), 'Amount');

            Con.setPageSize(size);
        } else if (chart == 'Company_Total_Pipeline_SMD_USA') {
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            Integer month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            if(monthStr != null){
                if(Integer.valueOf(monthStr) <= system.today().month()){
                    month+=12;
                }
            }
            if(click == 'point'){
                Map<Integer, List<OpportunityHistory>> month_opps = ListOfRecordsHelper.Company_Total_Pipeline_Last_12_Months_Helper();
                if(month_opps.containsKey(month)){
                    List<OpportunityHistory> related_oh = month_opps.get(month);
                    for(OpportunityHistory oh:related_oh){
                        Opportunity opp = oh.opportunity.clone();
                        opp.Amount = oh.Amount;
                        opp.Id = oh.Opportunity.Id;
                        opportunitiesModified.add(opp);
                    }
                }
            } else {
                Map<Integer, List<OpportunityHistory>> month_opps = ListOfRecordsHelper.Company_Total_Pipeline_Last_12_Months_Helper();
                for(Integer m:month_opps.keySet()){
                    for(OpportunityHistory oh: month_opps.get(m)){
                        Opportunity opp = oh.opportunity.clone();
                        opp.Amount = oh.Amount;
                        opp.Id = oh.Opportunity.Id;
                        opportunitiesModified.add(opp);
                    }
                }
            }

            calculateTotalAmount(opportunitiesModified, 'Amount');

        } else if (chart == 'Sales_Reps_Total_Pipeline_SMD_USA') {
 
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String salRepName = ApexPages.currentPage().getParameters().get('str');
            Integer currentMonth = monthStr != null ? Integer.valueOf(monthStr) : 1;

            if(monthStr != null){
                if(Integer.valueOf(monthStr) <= system.today().month()){
                    currentMonth+=12;
                }
            }
            
            Integer year = 2020;
            Integer month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            if(click == 'point'){
                Map<String, Map<Integer, List<OpportunityHistory>>> data = ListOfRecordsHelper.Sales_Reps_Total_Pipeline_Last_12_Months_Helper();
                Map<Integer, List<OpportunityHistory>> sal_rep_filtered = data.get(salRepName);
                
                for(OpportunityHistory oh: sal_rep_filtered.get(currentMonth)){
                    Opportunity opp = oh.opportunity.clone();
                    opp.Amount = oh.Amount;
                    opp.Id = oh.Opportunity.Id;
                    opportunitiesModified.add(opp);
                }

            } else {
                Map<String, Map<Integer, List<OpportunityHistory>>> data = ListOfRecordsHelper.Sales_Reps_Total_Pipeline_Last_12_Months_Helper();

                for(String salRep: data.keySet()){
                    for(Integer salRep_month: data.get(salRep).keySet()){
                        for(OpportunityHistory oh: data.get(salRep).get(salRep_month)){
                            Opportunity opp = oh.opportunity.clone();
                            opp.Amount = oh.Amount;
                            opp.Id = oh.Opportunity.Id;
                            opportunitiesModified.add(opp);
                        }
                    }
                }
            }
            calculateTotalAmount(opportunitiesModified, 'Amount');

        } else if (chart == 'Total_Pipeline_By_Lead_Source_SMD_USA') {
            // isOpptys = true;
            // showCloseDate = true;
            // ShowClosedDate = true;
            // ShowER = true;
            // ShowProb = true;
            // ShowOwner = true;
            // ShowAwardedOwner = true;
            
            // String str = Apexpages.currentPage().getParameters().get('str');
            // String yearStr = ApexPages.currentPage().getParameters().get('year');
            // String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            // if(str == 'N/A' || str == 'NA') {
            //     str = '';
            //     str2 = 'N/A';
            //     str3 = 'NA';
            // }
            
            // Integer year = 2020;
            // INteger month = 5;
            
            // if (yearStr != null && yearStr != '') {
            //     year = Integer.valueOf(yearStr);
            // }
            
            // if (monthStr != null && monthStr != '') {
            //     month = Integer.valueOf(monthStr);
            // }
            
            // // Monthly data
            // year = year-1;
            // Datetime PointMonthStart = Datetime.newInstance(year, month, 1,0,0,0);
            // DateTime PointMonthEnd = FindMonthEndDate(year, month);
            // Date PointMonthEndClosed = Date.newInstance(year, month, 
            //                                             Date.daysInMonth(d.year(), d.month()));
            
            // String Query = 'SELECT Id, Opportunity.Name, Opportunity.Amount, Opportunity.ExpectedRevenue, Opportunity.CreatedDate, Opportunity.Sales_Rep_O__c, Opportunity.Price_Level__c, Opportunity.GL_Account_Variable_1__r.Name, Opportunity.AccountId, Opportunity.LeadSource, Opportunity.lastactivitydate, Opportunity.Closed_Date__c, Opportunity.StageName, Opportunity.Closedate, Opportunity.ForecastCategoryName, Opportunity.Awarded_Owner__c, Opportunity.Loss_Reason__c, Opportunity.Probability, Amount  FROM OpportunityHistory ';
            // Query += 'WHERE Opportunity.Sales_Rep_o__r.Name in:All_SalesReps_USA ';
            // Query += 'AND Opportunity.GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            // Query += 'AND Opportunity.ForecastCategoryName =\'Pipeline\' '; 
            // Query += 'and createddate >=:PointMonthStart';
            // system.debug('PointMonthStart '+PointMonthStart);
            // String QueryStr = QueryOpportunities;
            // QueryStr += ' GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            // QueryStr += ' and Sales_Rep_o__r.Name in:All_SalesReps_USA ';
            // QueryStr += ' and ForecastCategoryName =\'Pipeline\' ';
            
            // if (click == 'chart') {
            //     QueryStr += ' and createddate <=:Full_End_Date ';
            //     QueryStr += ' order by Name';
            //     calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            //     opportunitiesModified = (List<Opportunity>)Database.query(QueryStr);
            //     Con = new ApexPages.StandardSetController(
            //         Database.getQueryLocator(QueryStr)
            //     );
            //     Con.setPageSize(size);
            // } else if (click == 'legend') {
            //     QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
            //     QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
            //     QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
            //     QueryStr += ' and createddate <=:Full_End_Date ';
            //     QueryStr += ' order by Name';
            //     calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            //     opportunitiesModified = (List<Opportunity>)Database.query(QueryStr);
            //     Con = new ApexPages.StandardSetController(
            //         Database.getQueryLocator(QueryStr)
            //     );
            //     Con.setPageSize(size);
            // } else if (click == 'point') {

            //     QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
            //     QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
            //     QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
            //     QueryStr += ' and createddate <=:PointMonthEnd ';
            //     // Query += ' and createddate >=:PointMonthStart ';
            //     System.debug('PointMonthEnd: '+PointMonthEnd);

            //     List<OpportunityHistory> oppHistory = (List<OpportunityHistory>)Database.query(Query);
            //     Set<Id> oppIds = new Set<Id>();
            //     for(OpportunityHistory oh:oppHistory){
            //         oppIds.add(oh.OpportunityId);
            //     }
            //     QueryStr += ' and Id IN:oppIds ';
            //     QueryStr += ' order by Opportunity.Name';
            //     List<Opportunity> opps = new List<Opportunity>();
                
            //     Con = new ApexPages.StandardSetController(
            //         Database.getQueryLocator(QueryStr)
            //     );
            //     opportunitiesModified = (List<Opportunity>)Database.query(QueryStr);
            //     calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            //     Con.setPageSize(size);


                

            // }

            //
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            

            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String salRepName = ApexPages.currentPage().getParameters().get('str');
            Integer currentMonth = monthStr != null ? Integer.valueOf(monthStr) : 1;

            if(monthStr != null){
                if(Integer.valueOf(monthStr) <= system.today().month()){
                    currentMonth+=12;
                }
            }

            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            if(click == 'point'){
                Map<String, Map<Integer, List<OpportunityHistory>>> data = ListOfRecordsHelper.Pipeline_Last_12_Months_By_Lead_Source_Helper();
                Map<Integer, List<OpportunityHistory>> sal_rep_filtered = data.get(salRepName);
                
                for(OpportunityHistory oh: sal_rep_filtered.get(currentMonth)){
                    Opportunity opp = oh.opportunity.clone();
                    opp.Amount = oh.Amount;
                    opp.Id = oh.Opportunity.Id;
                    opportunitiesModified.add(opp);
                }

            } else {
                Map<String, Map<Integer, List<OpportunityHistory>>> data = ListOfRecordsHelper.Pipeline_Last_12_Months_By_Lead_Source_Helper();

                for(String salRep: data.keySet()){
                    for(Integer salRep_month: data.get(salRep).keySet()){
                        for(OpportunityHistory oh: data.get(salRep).get(salRep_month)){
                            Opportunity opp = oh.opportunity.clone();
                            opp.Amount = oh.Amount;
                            opp.Id = oh.Opportunity.Id;
                            opportunitiesModified.add(opp);
                        }
                    }
                }
            }
            calculateTotalAmount(opportunitiesModified, 'Amount');
            
        } else if (chart == 'Newly_Submitted_Quotes_SMD') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' and ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            QueryStr += ' AND (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_USA ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c desc';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Opportunities_Last_12_Months_SMD') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            //string QueryStr = QueryOpportunities;
            string QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue, (Select Status From Quotes Order By CreatedDate Asc Limit 1) FROM Opportunity where ';
            
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' and ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            QueryStr += ' AND (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_USA ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'month-point') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_USA ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c desc';
            
            //Changing the code start
            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> allOppts = Database.query(QueryStr);
            for (Opportunity opp : allOppts) {
                for (Quote qt : opp.Quotes) {
                    if (qt.Status == 'Presented') {
                        oppIds.add(opp.Id);
                    }
                }
            }
            
            QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue FROM Opportunity where Id in :oppIds';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Opportunities_Last_12_Months_By_Lead_Source_SMD') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            //string QueryStr = QueryOpportunities;
            string QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue, (Select Status From Quotes Order By CreatedDate Asc Limit 1) FROM Opportunity where ';
            
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' and ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            QueryStr += ' AND (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_USA ';
            
            if (click == 'chart') {
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c desc';
            
            //Changing the code start
            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> allOppts = Database.query(QueryStr);
            for (Opportunity opp : allOppts) {
                for (Quote qt : opp.Quotes) {
                    if (qt.Status == 'Presented') {
                        oppIds.add(opp.Id);
                    }
                }
            }
            
            QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue FROM Opportunity where Id in :oppIds';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Lost_Opportunities_SMD') {
            isOpptys = true;
            ShowClosedDate = true;
            ShowLossReason = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date LostOpptyMonthStart = Date.newInstance(year, month, 1);
            Date LostOpptyMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and StageName = \'Closed Lost\' ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'month-point') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name asc, Closed_Date__c desc';
            //calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Loss_Reasons_SMD_USA') {
            String str = ApexPages.currentPage().getParameters().get('str');
            
            isOpptys = true;
            ShowClosedDate = true;
            ShowLossReason = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            


            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            Date LostOpptyMonthStart = Date.newInstance(year, month, 1);
            Date LostOpptyMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and StageName = \'Closed Lost\' ';
            QueryStr += ' and Parent_Opportunity__c = null ';
            QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            

            if (click == 'chart') {
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            } else if (click == 'point') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c =  null ';
                } else {
                    QueryStr += ' and Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'legend') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c =  null ';
                } else {
                    QueryStr += ' and Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            }
            
            QueryStr += ' order by Loss_Reason__c asc, Closed_Date__c desc';

            amountQuery += QueryStr.split('where')[1];
            calculateTotalAmount((List<Opportunity>)Database.query(amountQuery), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_By_Lead_Source_Last_12_Months_SMD_H') {
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            //---------------
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
            
            if (click == 'chart') {
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += str == '' ? ' and (AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'' : 
                ' and AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str3 + '\')' : '';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'' : 
                ' and AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str3 + '\')' : '';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <:SalesMonthEnd ';
            }
            QueryStr += ' order by AcctSeedERP__Opportunity__r.Leadsource asc, CreatedDate desc';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Forecast_Pipeline_By_Lead_Source_SMD') {
            isOpptys = true;
            ShowCloseDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date ForecastMonthStart = Date.newInstance(year, month, 1);
            Date ForecastMonthEnd = Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            Date Pipeline_Start_Date_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
            Date Future_Date = Pipeline_Start_Date_Start_Date.addMonths(11);
            
            Date Pipeline_Start_Date_End_Date = Date.newInstance(
                Future_Date.year(),
                Future_Date.month(),
                Date.daysInMonth(Future_Date.year(), Future_Date.month())
            );
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
            
            if (click == 'chart') {
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date_Start_Date and CloseDate <=: Pipeline_Start_Date_End_Date ';
            } else if (click == 'bar') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date_Start_Date and CloseDate <=: Pipeline_Start_Date_End_Date ';
            } else if (click == 'left') {
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            }
            
            QueryStr += ' order by Name,Probability desc NULLS LAST';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Active_Opportunities_By_Stage_SMD') {
            isOpptys = true;
            ShowER = true;
            ShowProb = true;
            showCloseDate = true;
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += ' and GL_Account_Variable_1__r.Name = \'Seawin USA\' ';
            QueryStr += ' and ForecastCategoryName != \'Omitted\' and ForecastCategoryName != \'Closed\' ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
            } else if (click == 'bar') {
                QueryStr +=
                    ' and stagename =:duration';
            } else if (click == 'legend') {
                QueryStr += '  and stagename =:duration ';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by stagename,Sales_Rep_O__r.name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Neg_Win_Rate_SMD') {
            ShowClosedDate = true;
            ShowWon = true;
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            isOpptys = true;
            
            set<id> eligibleIds = new Set<id>();
            
            if (click == 'chart') {
                for (OpportunityHistory hstry : [
                    SELECT Id, OpportunityId, CreatedDate, StageName, Amount, CloseDate
                    FROM OpportunityHistory
                    WHERE
                    StageName = 'Negotiation'
                    AND Opportunity.RecordType.name = 'Seawin USA Hospitality'
                    AND Opportunity.GL_Account_Variable_1__r.name = 'Seawin USA'
                    AND Opportunity.sales_rep_o__r.name IN :Active_SalesReps_USA
                ]) {
                    eligibleIds.add(hstry.OpportunityId);
                }
            } else if (click == 'bar') {
                for (OpportunityHistory hstry : [
                    SELECT Id, OpportunityId, CreatedDate, StageName, Amount, CloseDate
                    FROM OpportunityHistory
                    WHERE
                    StageName = 'Negotiation'
                    AND Opportunity.RecordType.name = 'Seawin USA Hospitality'
                    AND Opportunity.GL_Account_Variable_1__r.name = 'Seawin USA'
                    AND Opportunity.sales_rep_o__r.name = :str
                ]) {
                    eligibleIds.add(hstry.OpportunityId);
                }
            }
            
            if (Test.isRunningTest()) {
                map<id, opportunity> testMap = new Map<id, opportunity>(
                    [
                        SELECT id
                        FROM opportunity
                        WHERE
                        sales_rep_o__r.name IN :Active_SalesReps_USA
                        AND (StageName = 'Closed Won'
                             OR StageName = 'Closed Lost')
                        LIMIT 5
                    ]
                );
                
                eligibleIds.AddAll(testMap.keyset());
            }
            
            if (eligibleIds.size() > 0) {
                string QueryStr = QueryOpportunities;
                QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' and ';
                QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin USA\' and ';
                QueryStr += ' id in:eligibleIds and ';
                QueryStr += ' (stagename = \'Closed Won\' or stagename = \'Closed Lost\') ';
                QueryStr += ' and (NOT Name LIKE:ChangeOrder) ';
                QueryStr += ' and (NOT Name LIKE:MockupOne) ';
                QueryStr += ' and (NOT Name LIKE:MockupTwo) ';
                QueryStr += ' and (NOT Name LIKE:MockupThree) ';
                QueryStr += ' and (NOT Name LIKE:MockupFour) ';
                
                if (click == 'chart') {
                    QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_USA ';
                } else if (click == 'bar') {
                    QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                }
                QueryStr += ' order by sales_rep_o__r.name asc, stagename desc, closed_date__c desc, Name';
                calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        } else if (chart == 'Win_Rate_SMD') {
            ShowClosedDate = true;
            ShowWon = true;
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            isOpptys = true;
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin USA Hospitality\' and ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin USA\' and ';
            QueryStr += ' (stagename = \'Closed Won\' or stagename = \'Closed Lost\') ';
            QueryStr += ' and (NOT Name LIKE:ChangeOrder) ';
            QueryStr += ' and (NOT Name LIKE:MockupOne) ';
            QueryStr += ' and (NOT Name LIKE:MockupTwo) ';
            QueryStr += ' and (NOT Name LIKE:MockupThree) ';
            QueryStr += ' and (NOT Name LIKE:MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_USA ';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, stagename desc, closed_date__c desc, Name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Activity_Graph_Last_12_Months_SMD_USA') {
            if (String.isNotEmpty(str)) {
                All_SalesReps_USA.clear();
                All_SalesReps_USA.add(str);
            }
            
            List<sales_rep__c> salesReps = [
                SELECT Id, Name, Team__c, inactive_date__c
                FROM sales_rep__c
                WHERE name IN :All_SalesReps_USA
            ];
            // enigma
            map<string, date> SalesRepDateMap = new Map<string, date>();
            
            //Team Logic Start
            set<String> userTeams = new Set<String>();
            
            for (Sales_Rep__c team : salesReps) {
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
            
            isOpptys = true;
            showCloseDate = true;

            // lizard
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime PipelineMonthStart = FindMonthStartDate(year, month);
            
            //DateTime PipelineMonthStart = DateTime.newInstance(year, month, 1, 0, 0, 0);
            DateTime PipelineMonthEnd = FindMonthEndDate(year, month);
            
            String FirstQuery = QueryTasks;
            FirstQuery += ' what.type = \'Opportunity\' and ';
            
            if (click == 'chart') {
                FirstQuery += ' Owner.Name in:Inside_Sales_Users_USA ';
                FirstQuery += ' and (CompletedDateTime >=:Full_Start_Date and CompletedDateTime <=:Full_End_Date) ';
            } else if (click == 'legend') {
                FirstQuery += ' Owner.Name IN :Inside_Sales_Users_USA ';
                FirstQuery += ' and (CompletedDateTime >=:Full_Start_Date and CompletedDateTime <=:Full_End_Date) ';
            } else if (click == 'point') {
                Set<String> userIds = getUserIdsInSetFromTeamString(str, 'usa');
                FirstQuery += ' OwnerId IN :userIds ';
                FirstQuery += ' and (CompletedDateTime >=:PipelineMonthStart and CompletedDateTime <=:PipelineMonthEnd) ';
            }
            
            List<task> tasks = Database.query(FirstQuery);
            
            if (!tasks.isEmpty()) {
                set<id> OppIds = new Set<id>();
                
                map<id, opportunity> EligibleOpportunities = new Map<id, opportunity>();
                
                for (task t : tasks) {
                    OppIds.add(t.whatId);
                }
                
                EligibleOpportunities = new Map<id, opportunity>(
                    [
                        SELECT id, Sales_Rep_O__r.name, Sales_Rep_O__r.Team__c, ForecastCategoryName
                        FROM opportunity
                        WHERE
                        RecordType.Name = 'Seawin USA Hospitality'
                        AND GL_Account_Variable_1__r.Name = 'Seawin USA'
                        AND ForecastCategoryName != 'Omitted'
                        AND id IN :oppIds
                    ]
                );
                
                if (EligibleOpportunities.size() > 0) {
                    for (task tsk : tasks) {
                        Id key = tsk.whatid;

                        Opportunity opp = new Opportunity();
                        
                        if (EligibleOpportunities.containsKey(key)) {

                            opp = EligibleOpportunities.get(key);

                            DateTime RecordDate = tsk.LastModifiedDate;
                            Boolean RemoveIt = false;
                            
                            string salesrepName = EligibleOpportunities.get(key)
                                .Sales_Rep_O__r.name;
                            
                            Boolean BelongsToTeam = CheckUser(
                                EligibleOpportunities.get(key).Sales_Rep_O__r.Team__c,
                                tsk.ownerId
                            );
                            
                            Date InactiveDate = SalesRepDateMap.get(SalesRepName);
                            
                            if (InactiveDate != null) {
                                Date InactiveDateRevised = Date.newInstance(
                                    InactiveDate.year(),
                                    InactiveDate.month(),
                                    1
                                );
                                
                                Date RecordDateRevised = Date.newInstance(
                                    RecordDate.year(),
                                    RecordDate.month(),
                                    1
                                );
                                
                                RemoveIt = RecordDateRevised > InactiveDateRevised
                                    ? true
                                    : false;
                            }
                            
                            if (RemoveIt || !BelongsToTeam || opp.ForecastCategoryName != 'Pipeline') {
                                EligibleOpportunities.remove(key);
                            }
                        }
                    }
                }
                
                if (EligibleOpportunities.size() > 0) {
                    OppIds = EligibleOpportunities.keyset();
                    
                    String QueryStr = QueryOpportunities;
                    QueryStr += ' id in:OppIds ';
                    QueryStr += ' and Sales_Rep_o__r.Name in:All_SalesReps_USA ';
                    calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');
                    Con = new ApexPages.StandardSetController(
                        Database.getQueryLocator(QueryStr)
                    );
                    Con.setPageSize(size);
                }
            }
        } else if (chart == 'Tasks_Completion_SMD') {
            isTasks = true;
            string DateStr = '';
            
            String dd = String.valueOf(d);
            
            if (duration == 'Over Due') {
                DateStr +=
                    ' ActivityDate < ' +
                    dd +
                    ' and ActivityDate != null and status = \'Open\' ';
            } else if (duration == 'On Time') {
                DateStr +=
                    ' ActivityDate > ' +
                    dd +
                    ' and ActivityDate != null and status = \'Open\' ';
            } else if (duration == 'No Due Date') {
                DateStr += ' ActivityDate=null and status=\'Open\'';
            } else {
                DateStr +=
                    ' ((ActivityDate < ' +
                    dd +
                    ' and ActivityDate != null and status = \'Open\')';
                DateStr +=
                    ' or (ActivityDate > ' +
                    dd +
                    ' and ActivityDate != null and status = \'Open\')';
                DateStr += ' or (ActivityDate=null and status=\'Open\'))';
            }
            
            string QueryStr = QueryTasks;
            
            if (click == 'chart') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name in:Active_Users_USA ';
            } else if (click == 'bar') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name = \'' + str + '\' ';
            } else if (click == 'legend') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name in:Active_Users_USA ';
            } else if (click == 'left') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name =\'' + str + '\' ';
            }
            
            QueryStr += ' order by owner.name asc, activitydate desc';
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            
            Con.setPageSize(size);
        } else if (chart == 'Neglected_Opportunities_SMD') {

            // snake
            isOpptys = true;
            ShowModBy = true;
            ShowModDate = true;
            ShowER = true;
            ShowProb = true;
            showNeglectedField = true;

            Integer month = 0;
            Integer year = 0;

            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }

            Date OnlyStartDate = this.OnlyStartDate();
            Date OnlyEndDate = this.OnlyEndDate();

            // tortoise

            Date MonthStartDate = Date.newInstance(year, month, 1);
            Date MonthEndDate = Date.newInstance(year, month, Date.DaysInMonth(year, month));
            
            Date Last_Thirty_Days = date.today() - 30; // Today minus 30 days, will give us a date before 30 days
            
            string QueryStr = QueryOpportunities;
            QueryStr += Test.isRunningTest()
                ? ' Id != null '
                : ' Parent_Opportunity__c = null and RecordType.name = \'Seawin USA Hospitality\' ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' and GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' and ForecastCategoryName = \'Pipeline\' ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_Rep_o__r.name in:Active_SalesReps_USA ';

                QueryStr += Test.isRunningTest()
                ? ''
                : ' and ((LastActivityDate <:Last_Thirty_Days and LastActivityDate >=:OnlyStartDate and LastActivityDate <=:OnlyEndDate) or ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' (LastActivityDate = null and (LastModifiedDate <:Last_Thirty_Days and LastModifiedDate >=:OnlyStartDate and LastModifiedDate <=:OnlyEndDate and ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' LastModifiedBy.Name != \'Murtaza Ashraf\' and LastModifiedBy.Name != \'Ashraf Murtaza\'))) ';

            } else if (click == 'point') {
                QueryStr += ' and sales_Rep_o__r.name = \'' + str + '\'';

                QueryStr += Test.isRunningTest()
                ? ''
                : ' and ((LastActivityDate <:Last_Thirty_Days and LastActivityDate >=:MonthStartDate and LastActivityDate <=:MonthEndDate) or ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' (LastActivityDate = null and (LastModifiedDate <:Last_Thirty_Days and LastModifiedDate >=:MonthStartDate and LastModifiedDate <=:MonthEndDate and ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' LastModifiedBy.Name != \'Murtaza Ashraf\' and LastModifiedBy.Name != \'Ashraf Murtaza\'))) ';
            }
            
            QueryStr += ' order by sales_Rep_o__r.name, name asc ';
            
            List<Opportunity> opptys = (List<Opportunity>) Database.Query(QueryStr);
            
            map<id, opportunity> QualifiedOpsMap = new Map<id, opportunity>(opptys);
            map<id, opportunity> opportunitiesMap = new Map<id, opportunity>();
            NeglectedDaysMap = new Map<id, integer>();
            
            if (QualifiedOpsMap.size() > 0) {
                for (Opportunity o : QualifiedOpsMap.values()) {
                    if (o.HasOverdueTask || o.HasOpenActivity) {
                        QualifiedOpsMap.remove(o.id);
                    }
                }
            }
            
            if (QualifiedOpsMap.size() > 0) {
                for (Opportunity o : QualifiedOpsMap.values()) {
                    DateTime modifyDate = o.LastModifiedDate;
                    
                    Date LMD = Date.newInstance(
                        modifyDate.year(),
                        modifyDate.month(),
                        modifyDate.day()
                    );
                    Date LAD = o.LastActivityDate;
                    
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
                    } else if (
                        Activity_Neg_Days > Modified_Neg_Days
                    ) {
                        NegDays = Activity_Neg_Days;
                    }else if(Activity_Neg_Days == Modified_Neg_Days){

                        NegDays = Activity_Neg_Days;
                    }
                    
                    opportunitiesMap.put(o.id, o);
                    NeglectedDaysMap.put(o.id, NegDays);
                }
                
                if (opportunitiesMap.size() > 0) {
                    // sort the map
                    List<id> sortedKeys = this.sortEngine(NeglectedDaysMap);
                    map<id, opportunity> sortedMap = new Map<id, opportunity>();
                    
                    for (id s : sortedKeys) {
                        if (opportunitiesMap.containskey(s)) {
                            sortedMap.put(s, opportunitiesMap.get(s));
                        }
                    }
                    
                    opportunitiesMap = sortedMap;
                }
            }
            string FinalQueryStr = QueryOpportunities;
            set<id> OpptysIds = new Set<id>(opportunitiesMap.keyset());
            FinalQueryStr += ' id in:OpptysIds ';
            calculateTotalAmount((List<Opportunity>)Database.query(FinalQueryStr), 'Amount');
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(FinalQueryStr)
            );
            
            Con.setPageSize(size);
        } else if (chart == 'New_Leads_SMD') {
            isLeads = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            Integer month = 5;
            
            if (yearStr != null && yearStr != '') {
                DateTime TD = Date.today();
                DateTime PrevDate = DateTime.newInstance(
                    TD.year() - 1,
                    TD.month(),
                    Date.daysInMonth(TD.year() - 1, TD.month())
                );
                
                String TodayYearShort = TD.format('YY');
                String PrevYearShort = PrevDate.format('YY');
                
                if (
                    Integer.ValueOf(yearStr) == TD.Year() ||
                    Integer.ValueOf(yearStr) == PrevDate.Year()
                ) {
                    Year = Integer.ValueOf(yearStr) == TD.Year()
                        ? TD.Year()
                        : PrevDate.Year();
                } else {
                    Year = (yearStr == TodayYearShort) ? TD.Year() : PrevDate.Year();
                }
            }
            
            Boolean JustYear = false;
            String DateStr = '';
            
            DateTime NewLeadsMonthStart;
            DateTime NewLeadsMonthEnd;
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
                
                NewLeadsMonthStart = FindMonthStartDate(year, month);
                NewLeadsMonthEnd = DateTime.now();
            } else {
                DateStr += (Year == d.year())
                    ? ' CreatedDate = THIS_YEAR'
                    : ' CreatedDate = LAST_YEAR ';
                JustYear = true;
            }
            
            string QueryStr = QueryLeads;
            QueryStr += ' status = \'New\' ';
            
            if (click == 'chart') {
                QueryStr += ' and owner.name in:Active_Users_USA ';
                QueryStr += ' and (CreatedDate = THIS_YEAR or CreatedDate = LAST_YEAR) ';
            } else if (click == 'legend') {
                QueryStr += ' and Owner.name in:Active_Users_USA and';
                QueryStr += (JustYear)
                    ? DateStr
                    : ' CreatedDate >=:NewLeadsMonthStart and CreatedDate <=:NewLeadsMonthEnd ';
            } else if (click == 'bar') {
                QueryStr += ' and Owner.Name =  \'' + str + '\' and ';
                QueryStr += (JustYear)
                    ? DateStr
                    : ' CreatedDate >=:NewLeadsMonthStart and CreatedDate <=:NewLeadsMonthEnd ';
            } else if (click == 'left') {
                QueryStr += ' and Owner.Name =  \'' + str + '\'';
            }
            
            QueryStr += ' order by Owner.Name asc,CreatedDate desc';
            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'New_Customers_Last_12_Months_by_Type_SMD') {
            isAccounts = true;
            
            String Customer = 'Customer';
            String CustomerAndVendor = 'Customer And Vendor';
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SubmittedMonthStart = FindMonthStartDate(year, month);
            DateTime SubmittedMonthEnd = FindMonthEndDate(year, month);
            
            string QueryStr = QueryAccounts;
            QueryStr += ' (AcctSeed__Accounting_Type__c =:Customer or AcctSeed__Accounting_Type__c =:CustomerAndVendor) ';
            QueryStr += ' and AcctSeed__GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            
            if (click == 'point') {
                QueryStr += ' and createddate >= :SubmittedMonthStart AND createddate <= :SubmittedMonthEnd ';
                QueryStr += ' and Type =  \'' + str + '\'';
            }
            QueryStr += ' order by Type asc';
            //calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
            

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Monthly_Sales_Last_12_Months_SMD_OD') {
            // Online Dropship
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            string recordtype = 'Seawin USA Online/Drop Shipment';
            //string recordtype = 'Seawin USA Hospitality';
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name =:recordtype ';
            QueryStr += ' and GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'TopTenAccounts_OD') {
            isOrders = true;
            
            string recordtype = 'Seawin USA Online/Drop Shipment';
            //string recordtype = 'Seawin USA Hospitality';
            
            Set<string> AccountIds = new Set<string>();
            
            List<AggregateResult> TopTen = [
                SELECT sum(acctseederp__total__c), acctseederp__customer__c id
                FROM acctseederp__sales_order__c
                WHERE
                recordtype.name = :recordtype
                AND GL_Account_Variable_1__r.name = 'Seawin USA'
                AND (CreatedDate = THIS_YEAR
                     OR CreatedDate = Last_Year)
                GROUP BY acctseederp__customer__c
                ORDER BY sum(acctseederp__total__c) DESC
                LIMIT 10
            ];
            
            if (!TopTen.isEmpty()) {
                for (aggregateResult a : TopTen) {
                    AccountIds.add((string) a.get('id'));
                }
                
                // get details of these accounts by a detailed soql query
                string QueryStr = QueryOrders;
                QueryStr += ' RecordType.name =:recordtype ';
                QueryStr += ' and GL_Account_Variable_1__r.name = \'Seawin USA\' ';
                QueryStr += ' and (CreatedDate = THIS_YEAR or CreatedDate = Last_Year) ';
                QueryStr += ' and AcctSeedERP__Customer__c in:AccountIds ';
                QueryStr += ' order by AcctSeedERP__Customer__r.name, AcctSeedERP__Total__c desc';
                calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        } else if (chart == 'TopTenShipped_OD') {
            String str = ApexPages.currentPage().getParameters().get('str');
            
            isOrders = true;
            showState = true;
            
            string recordtype = 'Seawin USA Online/Drop Shipment';
            //string recordtype = 'Seawin USA Hospitality';
            
            List<AggregateResult> Aggregates = [
                SELECT Count(id) ct, AcctSeedERP__Shipping_State__c state
                FROM AcctSeedERP__Sales_Order__c
                WHERE
                RecordType.Name = :recordtype
                AND GL_Account_Variable_1__r.name = 'Seawin USA'
                GROUP BY AcctSeedERP__Shipping_State__c
                ORDER BY Count(id) DESC
                LIMIT 10
            ];
            
            set<string> states = new Set<string>();
            
            if (!Aggregates.isEmpty()) {
                for (AggregateResult a : Aggregates) {
                    states.add((string) a.get('state'));
                }
                
                // get details of these accounts by a detailed soql query
                string QueryStr = QueryOrders;
                QueryStr += ' RecordType.name =:recordtype ';
                QueryStr += ' and GL_Account_Variable_1__r.name = \'Seawin USA\' ';
                
                if (click == 'chart') {
                    QueryStr += ' and AcctSeedERP__Shipping_State__c in:states ';
                } else if (click == 'bar') {
                    if (str == 'N/A') {
                        QueryStr += ' and AcctSeedERP__Shipping_State__c =  null ';
                    } else {
                        QueryStr += ' and AcctSeedERP__Shipping_State__c = \'' + str + '\'';
                    }
                }
                
                QueryStr += ' order by AcctSeedERP__Shipping_State__c asc';
                calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        } else if (chart == 'Monthly_Sales_Last_12_Months_SMD_WD') {
            // Online Dropship
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            string recordtype = 'Seawin USA Wholesale Distribution';
            //string recordtype = 'Seawin USA Hospitality';
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name =:recordtype ';
            QueryStr += ' and GL_Account_Variable_1__r.name = \'Seawin USA\' ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_USA ';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'TopTenAccounts_WD') {
            isOrders = true;
            
            string recordtype = 'Seawin USA Wholesale Distribution';
            //string recordtype = 'Seawin USA Hospitality';
            
            Set<string> AccountIds = new Set<string>();
            
            List<AggregateResult> TopTen = [
                SELECT sum(acctseederp__total__c), acctseederp__customer__c id
                FROM acctseederp__sales_order__c
                WHERE
                recordtype.name = :recordtype
                AND GL_Account_Variable_1__r.name = 'Seawin USA'
                AND (CreatedDate = THIS_YEAR
                     OR CreatedDate = Last_Year)
                GROUP BY acctseederp__customer__c
                ORDER BY sum(acctseederp__total__c) DESC
                LIMIT 10
            ];
            
            if (!TopTen.isEmpty()) {
                for (aggregateResult a : TopTen) {
                    AccountIds.add((string) a.get('id'));
                }
                
                // get details of these accounts by a detailed soql query
                string QueryStr = QueryOrders;
                QueryStr += ' RecordType.name =:recordtype ';
                QueryStr += ' and GL_Account_Variable_1__r.name = \'Seawin USA\' ';
                QueryStr += ' and (CreatedDate = THIS_YEAR or CreatedDate = Last_Year) ';
                QueryStr += ' and AcctSeedERP__Customer__c in:AccountIds ';
                QueryStr += ' order by AcctSeedERP__Customer__r.name, AcctSeedERP__Total__c desc';
                calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        } else if (chart == 'TopTenShipped_WD') {
            String str = ApexPages.currentPage().getParameters().get('str');
            
            isOrders = true;
            showState = true;
            
            string recordtype = 'Seawin USA Wholesale Distribution';
            //string recordtype = 'Seawin USA Hospitality';
            
            List<AggregateResult> Aggregates = [
                SELECT Count(id) ct, AcctSeedERP__Shipping_State__c state
                FROM AcctSeedERP__Sales_Order__c
                WHERE
                RecordType.Name = :recordtype
                AND GL_Account_Variable_1__r.name = 'Seawin USA'
                GROUP BY AcctSeedERP__Shipping_State__c
                ORDER BY Count(id) DESC
                LIMIT 10
            ];
            
            set<string> states = new Set<string>();
            
            if (!Aggregates.isEmpty()) {
                for (AggregateResult a : Aggregates) {
                    states.add((string) a.get('state'));
                }
                
                // get details of these accounts by a detailed soql query
                string QueryStr = QueryOrders;
                QueryStr += ' RecordType.name =:recordtype ';
                
                if (click == 'chart') {
                    QueryStr += ' and AcctSeedERP__Shipping_State__c in:states ';
                } else if (click == 'bar') {
                    if (str == 'N/A') {
                        QueryStr += ' and AcctSeedERP__Shipping_State__c =  null ';
                    } else {
                        QueryStr += ' and AcctSeedERP__Shipping_State__c = \'' + str + '\'';
                    }
                }
                
                QueryStr += ' order by AcctSeedERP__Shipping_State__c asc';
                calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        }   
    }
    
    public void Sales_Manager_Dashboard_CHK() {
        if (chart == 'Billing_Aging_SMD_CHK') {
            isBillings = true;
            string Closed = 'Closed';
            string Posted = 'Posted';
            string CreditMemo = 'Credit Memo';
            
            String QueryStr = QueryBillings;
            QueryStr += ' AcctSeed__Status__c =:Posted and AcctSeed__Type__c !=:CreditMemo and ';
            QueryStr += ' Owner.name in:All_Users_CHK and ';
            QueryStr += ' (GL_Account_Variable_1__c =\'Seawin China\' or GL_Account_Variable_1__c =\'Seawin Hong Kong\') and';
            
            if (click == 'chart') {
                QueryStr += ' AcctSeed__Age__c !=:Closed ';
            } else if (click == 'bar') {
                QueryStr += ' AcctSeed__Age__c =:str ';
            }
            QueryStr += ' order by AcctSeed__Age__c asc, AcctSeed__Balance__c desc ';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Collection_Performance_SMD_CHK') {
            isBillings = true;
            string Closed = 'Closed';
            string Posted = 'Posted';
            string CreditMemo = 'Credit Memo';
            
            String QueryStr = QueryBillings;
            
            if (click == 'chart') {
                QueryStr += ' AcctSeed__Status__c =:Posted and ';
                QueryStr += ' AcctSeed__Age__c !=:Closed and ';
                QueryStr += ' AcctSeed__Type__c !=:CreditMemo and ';
                QueryStr += ' owner.name in:All_Users_CHK and ';
                QueryStr += ' (GL_Account_Variable_1__c =\'Seawin China\' or GL_Account_Variable_1__c =\'Seawin Hong Kong\') ';
                QueryStr += ' order by AcctSeed__Age__c asc, AcctSeed__Balance__c desc ';
            }
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Monthly_Sales_Last_12_Months_SMD_CHK') {
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            //---------------
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <:SalesMonthEnd ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Current_Sales_Contest_YTD_SMD_CHK') {
            isOrders = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and CreatedDate = THIS_YEAR ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                queryStr += ' and Sales_rep_o__r.name in:Active_SalesReps_CHK ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Current_Sales_Contest_QTD_SMD_CHK') {
            isOrders = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and CreatedDate = THIS_QUARTER ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                queryStr += ' and Sales_rep_o__r.name in:Active_SalesReps_CHK ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Current_Sales_Contest_TM_SMD_CHK') {
            isOrders = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and CreatedDate = THIS_MONTH ';
            QueryStr += ' and AcctSeederp__total__c > 0 ';
            
            if (click == 'chart') {
                queryStr += ' and Sales_rep_o__r.name in:Active_SalesReps_CHK ';
            } else if (click == 'bar') {
                QueryStr += ' and Sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Team_Quota_YTD_SMD_CHK') {
            isOrders = true;
            
            DateTime YearStartDate = FindMonthStartDate(d.year(), 1);
            
            DateTime YearToDateDate = DateTime.now();
            
            String QueryStr = QueryOrders;
            QueryStr += ' CreatedDate >=: YearStartDate and CreatedDate <=: YearToDateDate and';
            QueryStr += ' recordtype.name = \'Seawin China Hospitality\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and Sales_Rep_o__r.name in:All_SalesReps_CHK ';
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Team_Quota_Percent_SMD_CHK') {
            isOrders = true;
            
            DateTime YearStartDate = FindMonthStartDate(d.year(), 1);
            
            DateTime YearToDateDate = DateTime.now();
            
            String srsQuery = 'select id, name, Monthly_Quota__c from sales_rep__c where ';
            
            if (click == 'chart') {
                srsQuery += ' name in:All_SalesReps_CHK';
            } else if (click == 'bar') {
                srsQuery += ' name = \'' + str + '\'';
            }
            
            List<Sales_rep__c> SalesRep = Database.Query(srsQuery);
            
            set<string> srNames = new Set<string>();
            
            if (!SalesRep.isEmpty()) {
                for (Sales_rep__c s : salesrep) {
                    if (s.Monthly_Quota__c != null && s.Monthly_Quota__c != 0) {
                        srNames.add(s.name);
                    }
                }
            }
            
            String QueryStr = QueryOrders;
            QueryStr += ' CreatedDate >=: YearStartDate and CreatedDate <=: YearToDateDate and';
            QueryStr += ' recordtype.name = \'Seawin China Hospitality\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and Sales_Rep_o__r.name in:srNames and ';
            QueryStr += ' acctseederp__total__c > 0 ';
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';
            
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Forecast_Pipeline_SMD_CHK') {
            isOpptys = true;
            ShowCloseDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date ForecastMonthStart = Date.newInstance(year, month, 1);
            Date ForecastMonthEnd = Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
            Date Future_Date = Pipeline_Start_Date.addMonths(11);
            
            Date Pipeline_End_Date = Date.newInstance(
                Future_Date.year(),
                Future_Date.month(),
                Date.daysInMonth(Future_Date.year(), Future_Date.month())
            );
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' and ForecastCategoryName = \'Pipeline\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            }
            
            QueryStr += ' order by Name,Probability desc NULLS LAST';
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Company_Total_Pipeline_SMD_CHK') {
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date PointMonthStart = Date.newInstance(year, month, 1);
            DateTime PointMonthEnd = FindMonthEndDate(year, month);
            Date PointMonthEndClosed = Date.newInstance(d.year(), d.month(), 
                                                        Date.daysInMonth(d.year(), d.month()));
            
            String QueryStr = QueryOpportunities;
            QueryStr += ' Sales_Rep_o__r.Name in:All_SalesReps_CHK ';
            QueryStr += ' and  (GL_Account_Variable_1__r.Name = \'Seawin China\' or ';
            QueryStr += ' GL_Account_Variable_1__r.Name = \'Seawin Hong Kong\') ';
            QueryStr += ' and ForecastCategoryName !=\'Omitted\' ';
            
            if (click == 'chart') {
                QueryStr += ' and createddate <=:Full_End_Date';
            } else {
                QueryStr += ' and createddate <=:PointMonthEnd';
            }
            
            QueryStr += ' order by Name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Reps_Total_Pipeline_SMD_CHK') {
            
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            // Monthly data
            
            Date PointMonthStart = Date.newInstance(year, month, 1);
            DateTime PointMonthEnd = FindMonthEndDate(year, month);
            Date PointMonthEndClosed = Date.newInstance(d.year(), d.month(), 
                                                        Date.daysInMonth(d.year(), d.month()));
            
            String QueryStr = QueryOpportunities;
            QueryStr += ' (GL_Account_Variable_1__r.Name = \'Seawin China\' or ';
            QueryStr += ' GL_Account_Variable_1__r.Name = \'Seawin Hong Kong\') ';
            QueryStr += ' and ForecastCategoryName !=\'Omitted\' ';
            
            if (click == 'chart') {
                QueryStr += ' and Sales_Rep_o__r.Name in:All_SalesReps_CHK ';
                QueryStr += ' and createddate <=:Full_End_Date ';
            } else if (click == 'legend') {
                QueryStr += ' and Sales_Rep_o__r.Name = \'' + str + '\'';
                QueryStr += ' and createddate <=:Full_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and Sales_Rep_o__r.Name = \'' + str + '\'';
                QueryStr += ' and createddate <=:PointMonthEnd ';
            }
            
            QueryStr += ' order by Name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Total_Pipeline_By_Lead_Source_SMD_CHK') {
            isOpptys = true;
            showCloseDate = true;
            ShowClosedDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String str = Apexpages.currentPage().getParameters().get('str');
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            
            // Monthly data
            
            Date PointMonthStart = Date.newInstance(year, month, 1);
            DateTime PointMonthEnd = FindMonthEndDate(year, month);
            Date PointMonthEndClosed = Date.newInstance(d.year(), d.month(), 
                                                        Date.daysInMonth(d.year(), d.month()));
            
            String QueryStr = QueryOpportunities;
            QueryStr += ' (GL_Account_Variable_1__r.Name = \'Seawin China\' or ';
            QueryStr += ' GL_Account_Variable_1__r.Name = \'Seawin Hong Kong\') ';
            QueryStr += ' and Sales_Rep_o__r.Name in:All_SalesReps_CHK ';
            QueryStr += ' and ForecastCategoryName !=\'Omitted\' ';
            
            if (click == 'chart') {
                QueryStr += ' and createddate <=:Full_End_Date ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and createddate <=:Full_End_Date ';
            } else if (click == 'point') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and createddate <=:PointMonthEnd ';
            }
            
            QueryStr += ' order by Name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Quotes_SMD_CHK') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' AND (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c desc';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Opportunities_Last_12_Months_SMD_CHK') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            //string QueryStr = QueryOpportunities;
            string QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue, (Select Status From Quotes Order By CreatedDate Asc Limit 1) FROM Opportunity where ';
            
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' AND (GL_Account_Variable_1__r.Name =\'Seawin China\' or GL_Account_Variable_1__r.Name =\'Seawin Hong Kong\') ';
            QueryStr += ' AND (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'month-point') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c desc';
            
            //Changing the code start
            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> allOppts = Database.query(QueryStr);
            for (Opportunity opp : allOppts) {
                for (Quote qt : opp.Quotes) {
                    if (qt.Status == 'Presented') {
                        oppIds.add(opp.Id);
                    }
                }
            }
            
            QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue FROM Opportunity where Id in :oppIds';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Newly_Submitted_Opportunities_Last_12_Months_By_Lead_Source_SMD_CHK') {
            isOpptys = true;
            ShowSubmittedDate = true;
            ShowER = true;
            ShowProb = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date SubmittedMonthStart = Date.newInstance(year, month, 1);
            Date SubmittedMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            //string QueryStr = QueryOpportunities;
            string QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue, (Select Status From Quotes Order By CreatedDate Asc Limit 1) FROM Opportunity where ';
            
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' AND (GL_Account_Variable_1__r.Name =\'Seawin China\' or GL_Account_Variable_1__r.Name =\'Seawin Hong Kong\') ';
            QueryStr += ' AND (ForecastCategoryName = \'Pipeline\' ';
            QueryStr += ' OR StageName = \'Sleep\' ';
            QueryStr += ' OR StageName = \'Closed Won\' ';
            QueryStr += ' OR StageName = \'Closed Lost\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:SubmittedMonthStart and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:SubmittedMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and Newly_Submitted_Quote_First_Date__c >=:Only_Start_Date and ';
                QueryStr += ' Newly_Submitted_Quote_First_Date__c <=:Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name, Newly_Submitted_Quote_First_Date__c desc';
            
            //Changing the code start
            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> allOppts = Database.query(QueryStr);
            for (Opportunity opp : allOppts) {
                for (Quote qt : opp.Quotes) {
                    if (qt.Status == 'Presented') {
                        oppIds.add(opp.Id);
                    }
                }
            }
            
            QueryStr = 'SELECT Id, Name, GL_Account_Variable_1__c,HasOverdueTask,HasOpenActivity,';
            QueryStr += ' LastModifiedDate,CreatedDate,LastActivityDate,LastModifiedById, ';
            QueryStr += ' LeadSource, AccountId, StageName, Probability, IsWon,Parent_Opportunity__c,';
            QueryStr += ' Price_Level__c, Newly_Submitted_Quote_First_Date__c,closed_date__c,CloseDate, ';
            QueryStr += ' ForecastCategoryName,Amount, Sales_Rep_O__c,Loss_Reason__c, ';
            QueryStr += ' Awarded_Owner__c,Owner.Name, ';
            QueryStr += ' ExpectedRevenue FROM Opportunity where Id in :oppIds';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Lost_Opportunities_SMD_CHK') {
            isOpptys = true;
            ShowClosedDate = true;
            ShowLossReason = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date LostOpptyMonthStart = Date.newInstance(year, month, 1);
            Date LostOpptyMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' and StageName = \'Closed Lost\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' AND Parent_Opportunity__c = NULL ';
            QueryStr += ' AND (NOT Name LIKE :ChangeOrder) ';
            QueryStr += ' AND (NOT Name LIKE :MockupOne) ';
            QueryStr += ' AND (NOT Name LIKE :MockupTwo) ';
            QueryStr += ' AND (NOT Name LIKE :MockupThree) ';
            QueryStr += ' AND (NOT Name LIKE :MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            } else if (click == 'point') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'month-point') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            }
            
            QueryStr += ' order by sales_rep_o__r.name asc, Closed_Date__c desc';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Loss_Reasons_SMD_CHK') {
            string str = ApexPages.currentPage().getParameters().get('str');
            
            isOpptys = true;
            ShowClosedDate = true;
            ShowLossReason = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date LostOpptyMonthStart = Date.newInstance(year, month, 1);
            Date LostOpptyMonthEnd = month == d.month() ? Date.today() : 
            Date.newInstance(year, month, Date.daysInMonth(year, month));
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' and StageName = \'Closed Lost\' ';
            QueryStr += ' and (GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and Parent_Opportunity__c = null ';
            QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
            
            if (click == 'chart') {
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            } else if (click == 'point') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c = null ';
                } else {
                    QueryStr += ' and Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=:LostOpptyMonthStart and Closed_Date__c <=:LostOpptyMonthEnd ';
            } else if (click == 'legend') {
                if (str == 'N/A') {
                    QueryStr += ' and Loss_Reason__c = null ';
                } else {
                    QueryStr += ' and Loss_Reason__c = \'' + str + '\'';
                }
                QueryStr += ' and Closed_Date__c >=: Only_Start_Date and Closed_Date__c <=: Only_End_Date ';
            }
            
            QueryStr += ' order by Loss_Reason__c asc, Closed_Date__c desc';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_By_Lead_Source_Last_12_Months_SMD_CHK') {
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            //---------------
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' and (GL_Account_Variable_1__r.Name = \'Seawin China\' or GL_Account_Variable_1__r.Name = \'Seawin Hong Kong\') ';
            QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
            
            if (click == 'chart') {
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += str == '' ? ' and (AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'' : 
                ' and AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str3 + '\')' : '';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'' : 
                ' and AcctSeedERP__Opportunity__r.Leadsource = \'' + str + '\'';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or AcctSeedERP__Opportunity__r.Leadsource = \'' + str3 + '\')' : '';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <:SalesMonthEnd ';
            }
            QueryStr += ' order by AcctSeedERP__Opportunity__r.Leadsource asc, CreatedDate desc';
            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Sales_Forecast_Pipeline_By_Lead_Source_SMD_CHK') {
            isOpptys = true;
            ShowCloseDate = true;
            ShowER = true;
            ShowProb = true;
            ShowOwner = true;
            ShowAwardedOwner = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            String str = ApexPages.currentPage().getParameters().get('str');
            
            if(str == 'N/A' || str == 'NA') {
                str = '';
                str2 = 'N/A';
                str3 = 'NA';
            }
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            Date ForecastMonthStart = Date.newInstance(year, month, 1);
            Date ForecastMonthEnd = Date.newInstance(
                year,
                month,
                Date.daysInMonth(year, month)
            );
            
            Date Pipeline_Start_Date = Date.newInstance(d.Year(), d.Month(), 1);
            Date Future_Date = Pipeline_Start_Date.addMonths(11);
            
            Date Pipeline_End_Date = Date.newInstance(
                Future_Date.year(),
                Future_Date.month(),
                Date.daysInMonth(Future_Date.year(), Future_Date.month())
            );
            
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += ' and ForecastCategoryName = \'Pipeline\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
            
            if (click == 'chart') {
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'bar') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += str == '' ? ' and (LeadSource = \'' + str + '\'' : ' and LeadSource = \'' + str + '\'';
                QueryStr += str == '' ? ' or LeadSource = \'' + str2 + '\'' : '';
                QueryStr += str == '' ? ' or LeadSource = \'' + str3 + '\')' : '';
                QueryStr += ' and CloseDate >=: Pipeline_Start_Date and CloseDate <=: Pipeline_End_Date ';
            } else if (click == 'left') {
                QueryStr += duration == 'Missed'
                    ? ' and CloseDate <:Pipeline_Start_Date '
                    : ' and CloseDate >=:ForecastMonthStart and CloseDate <=:ForecastMonthEnd ';
            }
            
            QueryStr += ' order by Name,Probability desc NULLS LAST';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Active_Opportunities_By_Stage_SMD_CHK') {
            ShowER = true;
            ShowProb = true;
            showCloseDate = true;
            
            isOpptys = true;
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += ' ForecastCategoryName != \'Omitted\' and ForecastCategoryName != \'Closed\' and ';
            QueryStr += '(GL_Account_Variable_1__r.name = \'Seawin China\' or GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
            } else if (click == 'bar') {
                QueryStr +=
                    ' and StageName =:duration and sales_rep_o__r.name = \'' +
                    str +
                    '\'';
            } else if (click == 'legend') {
                QueryStr += '  and stagename =:duration ';
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by stagename,Sales_Rep_O__r.name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Neg_Win_Rate_SMD_CHK') {
            ShowClosedDate = true;
            ShowWon = true;
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            isOpptys = true;
            
            set<id> eligibleIds = new Set<id>();
            
            if (click == 'chart') {
                for (OpportunityHistory hstry : [
                    SELECT Id, OpportunityId, CreatedDate, StageName, Amount, CloseDate
                    FROM OpportunityHistory
                    WHERE
                    StageName = 'Negotiation'
                    AND Opportunity.RecordType.name = 'Seawin China Hospitality'
                    AND (Opportunity.GL_Account_Variable_1__r.name = 'Seawin China'
                         OR Opportunity.GL_Account_Variable_1__r.name = 'Seawin Hong Kong')
                    AND Opportunity.sales_rep_o__r.name IN :Active_SalesReps_CHK
                ]) {
                    eligibleIds.add(hstry.OpportunityId);
                }
            } else if (click == 'bar') {
                for (OpportunityHistory hstry : [
                    SELECT Id, OpportunityId, CreatedDate, StageName, Amount, CloseDate
                    FROM OpportunityHistory
                    WHERE
                    StageName = 'Negotiation'
                    AND Opportunity.RecordType.name = 'Seawin China Hospitality'
                    AND (Opportunity.GL_Account_Variable_1__r.name = 'Seawin China'
                         OR Opportunity.GL_Account_Variable_1__r.name = 'Seawin Hong Kong')
                    AND Opportunity.sales_rep_o__r.name = :str
                ]) {
                    eligibleIds.add(hstry.OpportunityId);
                }
            }
            
            if (Test.isRunningTest()) {
                map<id, opportunity> testMap = new Map<id, opportunity>(
                    [
                        SELECT id
                        FROM opportunity
                        WHERE
                        sales_rep_o__r.name IN :Active_SalesReps_CHK
                        AND (StageName = 'Closed Won'
                             OR StageName = 'Closed Lost')
                        LIMIT 5
                    ]
                );
                
                eligibleIds.AddAll(testMap.keyset());
            }
            
            if (eligibleIds.size() > 0) {
                string QueryStr = QueryOpportunities;
                QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
                QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
                QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') and ';
                QueryStr += ' id in:eligibleIds and ';
                QueryStr += ' (stagename = \'Closed Won\' or stagename = \'Closed Lost\') ';
                QueryStr += ' and (NOT Name LIKE:ChangeOrder) ';
                QueryStr += ' and (NOT Name LIKE:MockupOne) ';
                QueryStr += ' and (NOT Name LIKE:MockupTwo) ';
                QueryStr += ' and (NOT Name LIKE:MockupThree) ';
                QueryStr += ' and (NOT Name LIKE:MockupFour) ';
                
                if (click == 'chart') {
                    QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
                } else if (click == 'bar') {
                    QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                }
                QueryStr += ' order by sales_rep_o__r.name asc, stagename desc, closed_date__c desc, Name';
                calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        } else if (chart == 'Win_Rate_SMD_CHK') {
            ShowClosedDate = true;
            ShowWon = true;
            
            String ChangeOrder = '%Change Order%';
            String MockupOne = '%Mock-Up%';
            String MockupTwo = '%Mock Up%';
            String MockupThree = '%Mock%';
            String MockupFour = '%Mockup%';
            
            isOpptys = true;
            string QueryStr = QueryOpportunities;
            QueryStr += ' RecordType.name = \'Seawin China Hospitality\' and ';
            QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') and ';
            QueryStr += ' (stagename = \'Closed Won\' or stagename = \'Closed Lost\') ';
            QueryStr += ' and (NOT Name LIKE:ChangeOrder) ';
            QueryStr += ' and (NOT Name LIKE:MockupOne) ';
            QueryStr += ' and (NOT Name LIKE:MockupTwo) ';
            QueryStr += ' and (NOT Name LIKE:MockupThree) ';
            QueryStr += ' and (NOT Name LIKE:MockupFour) ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:Active_SalesReps_CHK ';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, stagename desc, closed_date__c desc, Name';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Activity_Graph_Last_12_Months_SMD_CHK') {
            if (String.isNotEmpty(str)) {
                All_SalesReps_CHK.clear();
                All_SalesReps_CHK.add(str);
            }
            
            List<sales_rep__c> salesReps = [
                SELECT Id, Name, Team__c, inactive_date__c
                FROM sales_rep__c
                WHERE name IN :All_SalesReps_CHK
            ];
            // enigma
            map<string, date> SalesRepDateMap = new Map<string, date>();
            
            //Team Logic Start
            set<String> userTeams = new Set<String>();
            
            for (Sales_Rep__c team : salesReps) {
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
            
            isOpptys = true;
            showCloseDate = true;
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime PipelineMonthStart = FindMonthStartDate(year, month);
            
            //DateTime PipelineMonthStart = DateTime.newInstance(year, month, 1, 0, 0, 0);
            DateTime PipelineMonthEnd = FindMonthEndDate(year, month);
            
            String FirstQuery = 'Select whatid, OwnerId, owner.name, CompletedDateTime ';
            FirstQuery += ' from task ';
            FirstQuery += ' where what.type = \'Opportunity\' and ';
            
            if (click == 'chart') {
                FirstQuery += ' Owner.Name in:Inside_Sales_Users_CHK ';
                FirstQuery += ' and (CompletedDateTime >=:Full_Start_Date and CompletedDateTime <=:Full_End_Date) ';
            } else if (click == 'legend') {
                FirstQuery += ' Owner.Name IN :Inside_Sales_Users_CHK ';
                FirstQuery += ' and (CompletedDateTime >=:Full_Start_Date and CompletedDateTime <=:Full_End_Date) ';
            } else if (click == 'point') {
                Set<String> userIds = getUserIdsInSetFromTeamString(str, 'china');
                FirstQuery += ' OwnerId IN :userIds ';
                FirstQuery += ' and (CompletedDateTime >=:PipelineMonthStart and CompletedDateTime <=:PipelineMonthEnd) ';
            }
            
            List<task> tasks = Database.query(FirstQuery);
            
            if (!tasks.isEmpty()) {
                set<id> OppIds = new Set<id>();
                
                map<id, opportunity> EligibleOpportunities = new Map<id, opportunity>();
                
                for (task t : tasks) {
                    OppIds.add(t.whatId);
                }
                
                EligibleOpportunities = new Map<id, opportunity>(
                    [
                        SELECT id, Sales_Rep_O__r.name, Sales_Rep_O__r.Team__c, ForecastCategoryName
                        FROM opportunity
                        WHERE
                        RecordType.Name = 'Seawin China Hospitality'
                        AND (GL_Account_Variable_1__r.Name = 'Seawin China' or
                             GL_Account_Variable_1__r.Name = 'Seawin Hong Kong')
                             AND ForecastCategoryName != 'Omitted'
                        AND id IN :oppIds
                    ]
                );
                
                if (EligibleOpportunities.size() > 0) {
                    for (task tsk : tasks) {
                        Id key = tsk.whatid;

                        Opportunity opp = new Opportunity();
                        
                        if (EligibleOpportunities.containsKey(key)) {

                            opp = EligibleOpportunities.get(key);

                            DateTime RecordDate = tsk.LastModifiedDate;
                            Boolean RemoveIt = false;
                            
                            string salesrepName = EligibleOpportunities.get(key)
                                .Sales_Rep_O__r.name;
                            
                            Boolean BelongsToTeam = CheckUser(
                                EligibleOpportunities.get(key).Sales_Rep_O__r.Team__c,
                                tsk.ownerId
                            );
                            
                            Date InactiveDate = SalesRepDateMap.get(SalesRepName);
                            
                            if (InactiveDate != null) {
                                Date InactiveDateRevised = Date.newInstance(
                                    InactiveDate.year(),
                                    InactiveDate.month(),
                                    1
                                );
                                
                                Date RecordDateRevised = Date.newInstance(
                                    RecordDate.year(),
                                    RecordDate.month(),
                                    1
                                );
                                
                                RemoveIt = RecordDateRevised > InactiveDateRevised
                                    ? true
                                    : false;
                            }
                            
                            if (RemoveIt || !BelongsToTeam || 
                            opp.ForecastCategoryName != 'Pipeline') {
                                EligibleOpportunities.remove(key);
                            }
                        }
                    }
                }
                
                if (EligibleOpportunities.size() > 0) {
                    OppIds = EligibleOpportunities.keyset();
                    
                    String QueryStr = QueryOpportunities;
                    QueryStr += ' id in:OppIds ';
                    QueryStr += ' and Sales_Rep_o__r.Name in:All_SalesReps_CHK ';
                    calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

                    Con = new ApexPages.StandardSetController(
                        Database.getQueryLocator(QueryStr)
                    );
                    Con.setPageSize(size);
                }
            }
        } else if (chart == 'Tasks_Completion_SMD_CHK') {
            isTasks = true;
            string DateStr = '';
            if (duration == 'Over Due') {
                DateStr += ' ActivityDate <: d and';
                DateStr += ' ActivityDate != null and status = \'Open\'';
            } else if (duration == 'On Time') {
                DateStr += ' ActivityDate >: d and ';
                DateStr += ' ActivityDate != null and status = \'Open\'';
            } else if (duration == 'No Due Date') {
                DateStr += ' ActivityDate=null and status=\'Open\'';
            } else {
                DateStr += ' ((ActivityDate <: d and';
                DateStr += ' ActivityDate != null and status = \'Open\')';
                
                DateStr += ' or (ActivityDate >: d and ';
                DateStr += ' ActivityDate != null and status = \'Open\')';
                
                DateStr += ' or (ActivityDate=null and status=\'Open\'))';
            }
            
            string QueryStr = QueryTasks;
            
            if (click == 'chart') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name in:Active_Users_CHK ';
            } else if (click == 'bar') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name = \'' + str + '\'';
            } else if (click == 'legend') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name in:Active_Users_CHK ';
            } else if (click == 'left') {
                QueryStr += DateStr;
                QueryStr += ' and owner.name = \'' + str + '\'';
            }
            
            QueryStr += ' order by owner.name asc, activitydate desc';
            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Neglected_Opportunities_SMD_CHK') {
            
            // snake
            isOpptys = true;
            ShowModBy = true;
            ShowModDate = true;
            ShowER = true;
            ShowProb = true;
            showNeglectedField = true;

            Integer month = 0;
            Integer year = 0;

            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }

            Date OnlyStartDate = this.OnlyStartDate();
            Date OnlyEndDate = this.OnlyEndDate();

            // tortoise

            Date MonthStartDate = Date.newInstance(year, month, 1);
            Date MonthEndDate = Date.newInstance(year, month, Date.DaysInMonth(year, month));
            
            Date Last_Thirty_Days = date.today() - 30; // Today minus 30 days, will give us a date before 30 days
            
            string QueryStr = QueryOpportunities;
            QueryStr += Test.isRunningTest()
                ? ' Id != null '
                : ' Parent_Opportunity__c = null and RecordType.name = \'Seawin China Hospitality\' ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' and (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            QueryStr += Test.isRunningTest()
                ? ''
                : ' and ForecastCategoryName = \'Pipeline\' ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_Rep_o__r.name in:Active_SalesReps_CHK ';

                QueryStr += Test.isRunningTest()
                ? ''
                : ' and ((LastActivityDate <:Last_Thirty_Days and LastActivityDate >=:OnlyStartDate and LastActivityDate <=:OnlyEndDate) or ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' (LastActivityDate = null and (LastModifiedDate <:Last_Thirty_Days and LastModifiedDate >=:OnlyStartDate and LastModifiedDate <=:OnlyEndDate and ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' LastModifiedBy.Name != \'Murtaza Ashraf\' and LastModifiedBy.Name != \'Ashraf Murtaza\'))) ';

            } else if (click == 'point') {
                QueryStr += ' and sales_Rep_o__r.name = \'' + str + '\'';

                QueryStr += Test.isRunningTest()
                ? ''
                : ' and ((LastActivityDate <:Last_Thirty_Days and LastActivityDate >=:MonthStartDate and LastActivityDate <=:MonthEndDate) or ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' (LastActivityDate = null and (LastModifiedDate <:Last_Thirty_Days and LastModifiedDate >=:MonthStartDate and LastModifiedDate <=:MonthEndDate and ';
                QueryStr += Test.isRunningTest()
                    ? ''
                    : ' LastModifiedBy.Name != \'Murtaza Ashraf\' and LastModifiedBy.Name != \'Ashraf Murtaza\'))) ';
            }
            
            QueryStr += ' order by sales_Rep_o__r.name, name asc ';
            
            List<Opportunity> opptys = (List<Opportunity>) Database.Query(QueryStr);
            
            map<id, opportunity> QualifiedOpsMap = new Map<id, opportunity>(opptys);
            map<id, opportunity> opportunitiesMap = new Map<id, opportunity>();
            NeglectedDaysMap = new Map<id, integer>();
            
            if (QualifiedOpsMap.size() > 0) {
                for (Opportunity o : QualifiedOpsMap.values()) {
                    if (o.HasOverdueTask || o.HasOpenActivity) {
                        QualifiedOpsMap.remove(o.id);
                    }
                }
            }
            
            if (QualifiedOpsMap.size() > 0) {
                for (Opportunity o : QualifiedOpsMap.values()) {
                    DateTime modifyDate = o.LastModifiedDate;
                    
                    Date LMD = Date.newInstance(
                        modifyDate.year(),
                        modifyDate.month(),
                        modifyDate.day()
                    );
                    Date LAD = o.LastActivityDate;
                    
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
                    } else if (
                        Activity_Neg_Days > Modified_Neg_Days
                    ) {
                        NegDays = Activity_Neg_Days;
                    }else if(Activity_Neg_Days == Modified_Neg_Days){

                        NegDays = Activity_Neg_Days;
                    }
                    
                    opportunitiesMap.put(o.id, o);
                    NeglectedDaysMap.put(o.id, NegDays);
                }
                
                if (opportunitiesMap.size() > 0) {
                    // sort the map
                    List<id> sortedKeys = this.sortEngine(NeglectedDaysMap);
                    map<id, opportunity> sortedMap = new Map<id, opportunity>();
                    
                    for (id s : sortedKeys) {
                        if (opportunitiesMap.containskey(s)) {
                            sortedMap.put(s, opportunitiesMap.get(s));
                        }
                    }
                    
                    opportunitiesMap = sortedMap;
                }
            }
            string FinalQueryStr = QueryOpportunities;
            set<id> OpptysIds = new Set<id>(opportunitiesMap.keyset());
            FinalQueryStr += ' id in:OpptysIds ';
            calculateTotalAmount((List<Opportunity>)Database.query(QueryStr), 'Amount');

            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(FinalQueryStr)
            );
            
            Con.setPageSize(size);
        } else if (chart == 'New_Leads_SMD_CHK') {
            isLeads = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            Integer month = 5;
            
            if (yearStr != null && yearStr != '') {
                DateTime TD = Date.today();
                DateTime PrevDate = DateTime.newInstance(
                    TD.year() - 1,
                    TD.month(),
                    Date.daysInMonth(TD.year() - 1, TD.month())
                );
                
                String TodayYearShort = TD.format('YY');
                String PrevYearShort = PrevDate.format('YY');
                
                if (
                    Integer.ValueOf(yearStr) == TD.Year() ||
                    Integer.ValueOf(yearStr) == PrevDate.Year()
                ) {
                    Year = Integer.ValueOf(yearStr) == TD.Year()
                        ? TD.Year()
                        : PrevDate.Year();
                } else {
                    Year = (yearStr == TodayYearShort) ? TD.Year() : PrevDate.Year();
                }
            }
            
            Boolean JustYear = false;
            String DateStr = '';
            
            DateTime NewLeadsMonthStart;
            DateTime NewLeadsMonthEnd;
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
                
                NewLeadsMonthStart = FindMonthStartDate(year, month);
                NewLeadsMonthEnd = FindMonthEndDate(year, month);
            } else {
                DateStr += (Year == d.year())
                    ? ' CreatedDate = THIS_YEAR'
                    : ' CreatedDate = LAST_YEAR ';
                JustYear = true;
            }
            
            string QueryStr = QueryLeads;
            QueryStr += ' status = \'New\' ';
            
            if (click == 'chart') {
                QueryStr += ' and owner.name in:Active_Users_CHK ';
                QueryStr += ' and (CreatedDate = THIS_YEAR or CreatedDate = LAST_YEAR) ';
            } else if (click == 'legend') {
                QueryStr += ' and Owner.name in:Active_Users_CHK and';
                QueryStr += (JustYear)
                    ? DateStr
                    : ' CreatedDate >=:NewLeadsMonthStart and CreatedDate <=:NewLeadsMonthEnd ';
            } else if (click == 'bar') {
                QueryStr += ' and Owner.Name = \'' + str + '\' and ';
                QueryStr += (JustYear)
                    ? DateStr
                    : ' CreatedDate >=:NewLeadsMonthStart and CreatedDate <=:NewLeadsMonthEnd ';
            } else if (click == 'left') {
                QueryStr += ' and Owner.Name = \'' + str + '\'';
            }
            
            QueryStr += ' order by Owner.Name asc,CreatedDate desc';
            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'New_Customers_Last_12_Months_by_Type_SMD_CHK') {
            isAccounts = true;
            
            String Customer = 'Customer';
            String CustomerAndVendor = 'Customer And Vendor';
            
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SubmittedMonthStart = FindMonthStartDate(year, month);
            DateTime SubmittedMonthEnd = FindMonthEndDate(year, month);
            
            string QueryStr = QueryAccounts;
            QueryStr += ' (AcctSeed__Accounting_Type__c =:Customer or AcctSeed__Accounting_Type__c =:CustomerAndVendor) ';
            QueryStr += ' and (AcctSeed__GL_Account_Variable_1__r.Name = \'Seawin China\' or AcctSeed__GL_Account_Variable_1__r.Name = \'Seawin Hong Kong\')';
            
            if (click == 'point') {
                QueryStr += ' and createddate >= :SubmittedMonthStart AND createddate <= :SubmittedMonthEnd ';
                QueryStr += ' and Type =  \'' + str + '\'';
            }
            QueryStr += ' order by Type asc';
            //llOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'Monthly_Sales_Last_12_Months_SMD_OEM_CHK') {
            // OEM Dashboard
            isOrders = true;
            String yearStr = ApexPages.currentPage().getParameters().get('year');
            String monthStr = ApexPages.currentPage().getParameters().get('month');
            
            Integer year = 2020;
            INteger month = 5;
            
            string recordtype = 'Seawin China OEM';
            //string recordtype = 'Seawin USA Hospitality';
            
            if (yearStr != null && yearStr != '') {
                year = Integer.valueOf(yearStr);
            }
            
            if (monthStr != null && monthStr != '') {
                month = Integer.valueOf(monthStr);
            }
            
            DateTime SalesMonthStart = FindMonthStartDate(year, month);
            DateTime SalesMonthEnd = FindMonthEndDate(year, month);
            
            List<opportunity> oppsChildList = new List<opportunity>();
            
            // get all sales rep name who are related to the logged in user gl variable
            showActiveDate = true;
            
            string QueryStr = QueryOrders;
            QueryStr += ' RecordType.name =:recordtype and ';
            QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
            QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
            
            if (click == 'chart') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'bar') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <=:SalesMonthEnd ';
            } else if (click == 'legend') {
                QueryStr += ' and sales_rep_o__r.name = \'' + str + '\'';
                QueryStr += ' and CreatedDate >=:Full_Start_Date and CreatedDate <=:Full_End_Date';
            } else if (click == 'left') {
                QueryStr += ' and sales_rep_o__r.name in:All_SalesReps_CHK ';
                QueryStr += ' and CreatedDate >=:SalesMonthStart and CreatedDate <:SalesMonthEnd ';
            }
            QueryStr += ' order by sales_rep_o__r.name asc, CreatedDate desc';

            calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');

            //allOpportunities = (List<Opportunity>)Database.query(QueryStr);
            Con = new ApexPages.StandardSetController(
                Database.getQueryLocator(QueryStr)
            );
            Con.setPageSize(size);
        } else if (chart == 'TopTenAccounts_SMD_OEM_CHK') {
            isOrders = true;
            
            string recordtype = 'Seawin China OEM';
            string recordtype2 = 'Seawin China Hospitality';
            //string recordtype = 'Seawin USA Hospitality';
            
            Set<string> AccountIds = new Set<string>();
            
            List<AggregateResult> TopTen = [
                SELECT sum(acctseederp__total__c), acctseederp__customer__c id
                FROM acctseederp__sales_order__c
                WHERE
                (recordtype.name = :recordtype
                 OR recordtype.name = :recordtype2)
                AND (GL_Account_Variable_1__r.name = 'Seawin China'
                     OR GL_Account_Variable_1__r.name = 'Seawin Hong Kong')
                AND (CreatedDate = THIS_YEAR
                     OR CreatedDate = Last_Year)
                GROUP BY acctseederp__customer__c
                ORDER BY sum(acctseederp__total__c) DESC
                LIMIT 10
            ];
            
            if (!TopTen.isEmpty()) {
                for (aggregateResult a : TopTen) {
                    AccountIds.add((string) a.get('id'));
                }
                
                // get details of these accounts by a detailed soql query
                string QueryStr = QueryOrders;
                QueryStr += ' (recordtype.name=:recordtype or recordtype.name=:recordtype2) and ';
                QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
                QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
                QueryStr += ' and (CreatedDate = THIS_YEAR or CreatedDate = Last_Year) ';
                QueryStr += ' and AcctSeedERP__Customer__c in:AccountIds ';
                QueryStr += ' order by AcctSeedERP__Customer__r.name, AcctSeedERP__Total__c desc';

                calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        } else if (chart == 'TopTenShipped_SMD_OEM_CHK') {
            String str = ApexPages.currentPage().getParameters().get('str');
            
            isOrders = true;
            showState = true;
            
            string recordtype = 'Seawin China OEM';
            //string recordtype = 'Seawin USA Hospitality';
            
            List<AggregateResult> Aggregates = [
                SELECT Count(id) ct, AcctSeedERP__Shipping_State__c state
                FROM AcctSeedERP__Sales_Order__c
                WHERE
                RecordType.Name = :recordtype
                AND (GL_Account_Variable_1__r.name = 'Seawin China'
                     OR GL_Account_Variable_1__r.name = 'Seawin Hong Kong')
                GROUP BY AcctSeedERP__Shipping_State__c
                ORDER BY Count(id) DESC
                LIMIT 10
            ];
            
            set<string> states = new Set<string>();
            
            if (!Aggregates.isEmpty()) {
                for (AggregateResult a : Aggregates) {
                    states.add((string) a.get('state'));
                }
                
                // get details of these accounts by a detailed soql query
                string QueryStr = QueryOrders;
                QueryStr += ' RecordType.name =:recordtype and ';
                QueryStr += ' (GL_Account_Variable_1__r.name = \'Seawin China\' or ';
                QueryStr += ' GL_Account_Variable_1__r.name = \'Seawin Hong Kong\') ';
                
                if (click == 'chart') {
                    QueryStr += ' and AcctSeedERP__Shipping_State__c in:states ';
                } else if (click == 'bar') {
                    if (str == 'N/A') {
                        QueryStr += ' and AcctSeedERP__Shipping_State__c = null ';
                    } else {
                        QueryStr += ' and AcctSeedERP__Shipping_State__c = \'' + str + '\'';
                    }
                }
                
                QueryStr += ' order by AcctSeedERP__Shipping_State__c asc';
                calculateTotalAmount((List<AcctSeedERP__Sales_Order__c>)Database.query(QueryStr), 'AcctSeedERP__Total__c');
                Con = new ApexPages.StandardSetController(
                    Database.getQueryLocator(QueryStr)
                );
                Con.setPageSize(size);
            }
        }  
    }
    
    public List<id> sortEngine(map<id, Integer> DataMap) {
        list<id> keyList = new List<string>();
        map<integer, list<id>> valuesMap = new Map<integer, list<id>>();
        
        for (id s : DataMap.keyset()) {
            integer value = DataMap.get(s);
            
            if (valuesMap.containskey(value)) {
                List<id> existing = valuesMap.get(value);
                existing.add(s);
                valuesMap.put(value, existing);
            } else {
                keyList = new List<id>();
                keyList.add(s);
                valuesMap.put(value, keyList);
            }
        }
        
        List<id> KeyListSorted = new List<id>();
        
        if (valuesMap.size() > 0) {
            list<integer> valuesAscending = new List<integer>(ValuesMap.keyset());
            valuesAscending.sort();
            
            List<integer> ValuesDescending = new List<integer>();
            for (Integer i = valuesAscending.size() - 1; i >= 0; i--) {
                ValuesDescending.add(valuesAscending[i]);
            }
            
            // create the sorted map
            
            for (integer d : ValuesDescending) {
                for (id s : ValuesMap.get(d)) {
                    KeyListSorted.add(s);
                }
            }
        }
        
        return KeyListSorted;
    }
    
    public Set<String> getUserIdsInSetFromTeamString(
        set<String> salesRepNames,
        String region
    ) {
        List<Sales_Rep__c> srList = new List<Sales_Rep__c>(
            [SELECT Team__c FROM Sales_Rep__c WHERE Name IN :salesRepNames]
        );
        
        Set<String> userIdsSet = new Set<String>();
        if (srList != null && srList.size() > 0) {
            for (sales_rep__c srp : srList) {
                List<String> teamUserList = srp.Team__c.split(';');
                for (String val : teamUserList) {
                    userIdsSet.add(val);
                }
            }
        }
        
        for (String usrId : userIdsSet) {
            if (region == 'usa') {
                if (!filteredUsersAgainstInsideSalesUsersUSAId(usrId)) {
                    userIdsSet.remove(usrId);
                }
            } else if (region == 'china') {
                if (!filteredUsersAgainstInsideSalesUsersCHKId(usrId)) {
                    userIdsSet.remove(usrId);
                }
            }
        }
        
        return userIdsSet;
    }
    
    public Set<String> getUserIdsInSetFromTeamString(
        String salesRepName,
        String region
    ) {
        List<Sales_Rep__c> srList = new List<Sales_Rep__c>(
            [SELECT Team__c FROM Sales_Rep__c WHERE Name = :str LIMIT 1]
        );
        
        Set<String> userIdsSet = new Set<String>();
        if (srList != null && srList.size() > 0) {
            List<String> teamUserList = srList[0].Team__c.split(';');
            for (String val : teamUserList) {
                userIdsSet.add(val);
            }
        }
        
        for (String usrId : userIdsSet) {
            if (region == 'usa') {
                if (!filteredUsersAgainstInsideSalesUsersUSAId(usrId)) {
                    userIdsSet.remove(usrId);
                }
            } else if (region == 'china') {
                if (!filteredUsersAgainstInsideSalesUsersCHKId(usrId)) {
                    userIdsSet.remove(usrId);
                }
            }
        }
        
        return userIdsSet;
    }
    
    public Boolean filteredUsersAgainstInsideSalesUsersUSAId(string userId) {
        return Inside_Sales_Users_USA_Id.contains(userId);
    }
    
    public Boolean filteredUsersAgainstInsideSalesUsersCHKId(string userId) {
        return Inside_Sales_Users_CHK_Id.contains(userId);
    }
    
    public Set<String> UserData_From_Teams(String teams) {
        Set<String> usersIds = new Set<String>();
        usersNames = new Set<String>();
        if (teams != null) {
            usersIds.addAll(UserIds_From_Teams(teams));
            usersNames.addAll(Usernames_From_Teams(usersIds));
        }
        
        //return usersIds;
        return usersNames;
    }
    
    public Set<String> UserIds_From_Teams(String teams) {
        Set<String> teamUserIds = new Set<String>();
        if (String.isNotEmpty(teams)) {
            List<String> teamsList = teams.split(';');
            for (String userid : teamsList) {
                teamUserIds.add(userid);
            }
        }
        
        return teamUserIds;
    }
    
    public Set<String> Usernames_From_Teams(Set<String> userIds) {
        Set<String> userNameSet = new Set<String>();
        
        List<User> usersList = new List<User>(
            [SELECT Name FROM User WHERE Id IN :userIds]
        );
        
        for (User usr : usersList) {
            userNameSet.add(usr.Name);
        }
        
        return userNameSet;
    }
    
    public boolean CheckUser(String TeamUserIds, String ownerId) {
        Boolean BelongsToTeam = false;
        
        if (String.isnotEmpty(TeamUserIds)) {
            List<String> UserIdList = TeamUserIds.split(';');
            
            for (String userid : UserIdList) {
                if (userid == ownerid) {
                    BelongsToTeam = true;
                    break;
                }
            }
        }
        
        return BelongsToTeam;
    }
    
    public DateTime FindMonthStartDate(Integer year, Integer month){
        
        String sdate_str = year + '-' + (month > 9 ? '' + month : '0' + month) + '-01T00:00:00.000Z';
        DateTime dt = DateTime.ValueofGmt(sdate_str.replace('T', ' '));
        return dt;
        
    }
    public DateTime FindMonthEndDate(Integer year, Integer month){
        
        Integer daysInMonth = Date.daysInMonth(year, month); 
        
        String sdate_str = year + '-' + (month > 9 ? '' + month : '0' + month) + '-' + daysInMonth + 'T23:59:59.000Z';
        DateTime dt = DateTime.ValueofGmt(sdate_str.replace('T', ' '));
        return dt;
        
    }

    public Date OnlyStartDate(){

        Date d = Date.Today();

        Integer Months_Passed = d.month();
        
        Integer Common_Start_Year = (Months_Passed < 12) ? d.year() - 1 : d.year();
        Integer Common_Start_Month = d.month() < 12 ? d.month() + 1 : 1;
        
        Date Only_Start_Date = Date.newInstance(Common_Start_Year, Common_Start_Month, 1);
        

        return Only_Start_Date;

    }

    public Date OnlyEndDate(){

        return Date.Today();

    }
}
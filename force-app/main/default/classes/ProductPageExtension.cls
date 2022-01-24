public class ProductPageExtension {
    public Integer noOfRecords { get; set; }
    public Integer size { get; set; }
    public String searchText { get; set; }
    public String selectedSearchVal { get; set; }
    public Product2 prod2 { get; set; }
    public string queryStr { get; set; }
    public String sortOrder { get; set; }
    public Boolean ProductNameSortASC { get; set; }
    public Boolean ProductNameSortDESC { get; set; }
    public string fields { get; set; }
    
    public Boolean ShowActiveProductsOnly { get; set; }
    public string selectedFamily { get; set; }
    public string selectedCategory { get; set; }
    public List<SelectOption> CategoryPicklist { get; set; }
    public string selectedSubCategory { get; set; }
    public List<SelectOption> SubCategoryPicklist { get; set; }
    
    // For sorting purposes
    public String sortWith { get; set; }
    public string sortProcess { get; set; }
    public string sortField { get; set; }
    public boolean ProductNameSortUp { get; set; }
    public boolean ProductNameSortDown { get; set; }
    public boolean ProductCodeSortUp { get; set; }
    public boolean ProductCodeSortDown { get; set; }
    public boolean SizeSortUp { get; set; }
    public boolean SizeSortDown { get; set; }
    public map<id, product2> CurrentProductsMap {get; set;}
    public map<id, product2> CategoryUpdateProductsMap {get; set;}
    
    public string communityUrl {

        get{

            User usr = [select contactId,username from user where id =:userinfo.getuserid() Limit 1];

            return usr.contactId == null  ? '' : '/sales';
        }
    }
    
    public List<SelectOption> getFamilyPicklist() {
        Map<String, List<String>> ValuesMap = PicklistValuesController.getFieldDependencies(
            'Product2',
            'Category__c',
            'Sub_Category__c'
        );
        
        List<SelectOption> FamilyOptions = new List<SelectOption>();
        FamilyOptions.add(new SelectOption('', '-None-'));
        
        for (string key : ValuesMap.keyset()) {
            FamilyOptions.add(new SelectOption(key, key));
        }
        
        return FamilyOptions;
    }
    public void CategoryPicklistMethod() {
        CategoryPicklist = new List<SelectOption>();
        
        if (selectedFamily != null) {
            Map<String, List<String>> ValuesMap = PicklistValuesController.getFieldDependencies(
                'Product2',
                'Category__c',
                'Sub_Category__c'
            );
            
            for (string key : ValuesMap.get(selectedFamily)) {
                CategoryPicklist.add(new SelectOption(key, key));
            }
        }
    }
    
    public void SubCategoryPicklistMethod() {
        SubCategoryPicklist = new List<SelectOption>();
        
        if (selectedCategory != null) {
            Map<String, List<String>> ValuesMap = PicklistValuesController.getFieldDependencies(
                'Product2',
                'Sub_Category__c',
                'Complementary_Category__c'
            );
            
            for (string key : ValuesMap.get(selectedCategory)) {
                SubCategoryPicklist.add(new SelectOption(key, key));
            }
        }
    }
    
    // Added on 27 January 2021
    public string objectId { get; set; }
    public String section {
        get {
            if (section == null) {
                section = ApexPages.currentPage().getParameters().get('section');
            }
            return section;
        }
        set;
    }
    public Boolean IsAddScreen { get; set; }
    
    public string strTabName { get; set; }
    
    public Integer HighestSort { get; set; }
    public Id agl { get; set; }
    
    public List<productSelection> prods { get; set; }
    
    public map<id, list<decimal>> ibMap { get; set; }
    
    public map<id, string> ProductsWithImage { get; set; }
    public map<id, string> OliAlternateImgURL { get; set; }
    
    public boolean DropShipMessage { get; set; }
    public boolean preventAddLines { get; set; }
    
    public String docURL { get; set; }
    
    public Boolean AddProductPermission { get; set; }
    
    public void alternateImages() {
        String prodID = Apexpages.currentPage().getParameters().get('prodID');
        String docId = Apexpages.currentPage().getParameters().get('docId');

        docURL = communityUrl + '/servlet/servlet.FileDownload?file=' + docId;
        
        OliAlternateImgURL.put(prodID, docURL);
    }

    public String getStrTabName() {
        if (section == 'oli') {
            return 'Opportunity';
        } else if (section == 'qli') {
            return 'Quote';
        } else if (section == 'opo') {
            return 'Opportunity';
        } else if (section == 'opq') {
            return 'Quote';
        } else if (section == 'sli') {
            return 'acctseederp__sales_order__c';
        } else if (section == 'pli') {
            return 'acctseederp__purchase_order__c';
        }
        return null;
    }
    
    public Id OppId { get; set; }
    public Id QuoteId { get; set; }
    public Id soId { get; set; }
    public Id poId { get; set; }
    
    public map<id, pricebookentry> ProductsPrice { get; set; }
    
    public id priceboookid {get{
        
        return Test.isRunningTest() ? Test.getStandardPricebookId() : [select id, name from Pricebook2 where isStandard = true limit 1][0].id;
    }}
    
    public Boolean productAdded {
        get {
            if (productAdded != true) {
                productAdded = false;
            }
            return productAdded;
        }
        set;
    }
    
    public Boolean CheckPermission(String ObjectName) {
        String desireUserId = UserInfo.getUserId();
        
        User u = [SELECT profileId, ContactId FROM user WHERE id = :desireUserId LIMIT 1];
        String profileId = u.profileId;
        
        LIST<ObjectPermissions> ObjPermissionList = new List<ObjectPermissions>();
        
        ObjPermissionList = [
            SELECT Id, SObjectType, PermissionsCreate
            FROM ObjectPermissions
            WHERE
            SObjectType = :ObjectName
            AND parentid IN (
                SELECT id
                FROM permissionset
                WHERE PermissionSet.Profile.Id = :profileId
            )
            LIMIT 1
        ];
        
        return u.ContactId == null ? ObjPermissionList[0].PermissionsCreate : true;
    }
    
    public List<SelectOption> getItems() {
        List<Product2> prodCategoriesList = new List<Product2>();
        prodCategoriesList = [SELECT id, name, Category__c FROM product2];
        
        List<SelectOption> options = new List<SelectOption>();
        
        for (Product2 p : prodCategoriesList) {
            if (p.Category__c != null)
                options.add(new SelectOption(p.Id, p.Category__c));
        }
        
        return options;
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if (setCon == null) {
                size = 15;
                queryStr = 'select ' + fields;
                queryStr += ' from Product2 ';
                queryStr += ' where IsActive = true ';
                
                if (DropShipMessage) {
                    queryStr += ' AND Product2.AcctSeed__Inventory_Product__c = false ';
                }
                
                queryStr += ' order by Name';
                setCon = new ApexPages.StandardSetController(
                    Database.getQueryLocator(queryStr)
                );
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }
    
    public List<productSelection> getProducts() {
        CurrentProductsMap = new map<id, product2>();
        
        prods = new List<productSelection>();
        
        List<Product2> ProductsInGetProducts = (List<Product2>) setCon.getRecords()
            .deepClone(true, true, true);
        
        map<id, product2> ProductsInGetProductsMap = new Map<id, product2>(
            ProductsInGetProducts
        );
        
        ibMap = InventoryCalculationHelper.Calculate(ProductsInGetProductsMap.keyset());
        
        for (Product2 p : ProductsInGetProducts) {
            CurrentProductsMap.put(p.id, p);
            prods.add(new productSelection(p, false));
        }
        
        for (PriceBookEntry pbe : [
            SELECT id, unitprice, product2id
            FROM pricebookentry
            WHERE product2id IN :ProductsInGetProductsMap.keyset()
            and pricebook2Id=:priceboookid
        ]) {
            productsprice.put(pbe.Product2Id, pbe);
        }
        
        return prods;
    }
    
    public ProductPageExtension() {
        ShowActiveProductsOnly = true;
        AddProductPermission = true;
        selectedSearchVal = 'all';
        sortOrder = 'ASC';
        ProductNameSortASC = true;
        ProductNameSortDESC = false;
        prod2 = new Product2();
        IsAddScreen = false;
        String ObjectError = '';
        
        CurrentProductsMap = new map<id, product2>();
        CategoryUpdateProductsMap = new map<id, product2>();

        ibMap = new Map<id, list<decimal>>();
        prods = new List<productSelection>();
        ProductsWithImage = new Map<id, string>();
        OliAlternateImgURL = new Map<id, string>();
        ProductsPrice = new Map<id, pricebookentry>();
        
        ProductNameSortUp = true;
        ProductNameSortDown = false;
        ProductCodeSortUp = true;
        ProductCodeSortDown = false;
        SizeSortUp = true;
        SizeSortDown = false;
        sortWith = '';
        sortProcess = 'ASC';
        
        DropShipMessage = false;
        preventAddLines = false;
        
        CategoryPicklist = new List<SelectOption>();
        
        fields = AllFields.Fields('Product2', new List<String>());
        
        objectId = ApexPages.currentPage().getParameters().get('id');
        
        //section = ApexPages.currentPage().getParameters().get('section');
        
        if (String.isNotEmpty(section)) {
            IsAddScreen = true;
        }
        
        if (section == 'oli' || section == 'opo') {
            AddProductPermission = this.CheckPermission(
                section == 'oli' ? 'Product2' : 'Optional_Products_Opportunity__c'
            );
            
            OppId = objectId;
            // get the highest sort
            HighestSort = Integer.ValueOf(
                [
                    SELECT max(sortorder__c)
                    FROM Optional_Products_Opportunity__c
                    WHERE Opportunity__c = :OppId
                ][0]
                .get('expr0')
            );
            
            list<Opportunity> olist = [
                SELECT GL_Account_Variable_1__c
                FROM Opportunity
                WHERE id = :OppId
                LIMIT 1
            ];
            
            if (!olist.isEmpty()) {
                agl = olist[0].GL_Account_Variable_1__c;
            }
        } else if (section == 'opq' || section == 'qli') {
            AddProductPermission = this.CheckPermission(
                section == 'qli' ? 'Product2' : 'Optional_Products_Opportunity__c'
            );
            
            QuoteId = objectId;
            
            // get the highest sort
            
            HighestSort = Integer.ValueOf(
                [
                    SELECT max(sortorder__c)
                    FROM Optional_Products_Quote__c
                    WHERE Quote__c = :QuoteId
                ][0]
                .get('expr0')
            );
            
            Quote opId = [
                SELECT opportunityId
                FROM quote
                WHERE id = :quoteId
                LIMIT 1
            ];
            
            list<Opportunity> olist = [
                SELECT GL_Account_Variable_1__c
                FROM Opportunity
                WHERE id = :opId.opportunityId
                LIMIT 1
            ];
            
            if (!olist.isEmpty()) {
                agl = olist[0].GL_Account_Variable_1__c;
            }
        } else if (section == 'sli') {
            AddProductPermission = this.CheckPermission(
                'AcctSeedERP__Sales_Order_Line__c'
            );
            
            soId = objectId;
            
            // check if the sales order has been closed
            if (soId != null) {
                AcctSeedERP__Sales_Order__c order = [
                    SELECT AcctSeedERP__Status__c
                    FROM AcctSeedERP__Sales_Order__c
                    WHERE id = :soId
                    LIMIT 1
                ];
                
                if (order.AcctSeedERP__Status__c == 'Closed') {
                    preventAddLines = true;
                }
            }
            
            // get the highest sort
            HighestSort = Integer.ValueOf(
                [
                    SELECT max(sortorder__c)
                    FROM AcctSeedErP__sales_order_line__c
                    WHERE AcctSeedERP__Sales_order__c = :soId
                ][0]
                .get('expr0')
            );
            
            list<AcctSeedERP__Sales_Order__c> slist = [
                SELECT GL_Account_Variable_1__c
                FROM AcctSeedERP__Sales_Order__c
                WHERE id = :soId
                LIMIT 1
            ];
            
            if (!slist.isEmpty()) {
                agl = slist[0].GL_Account_Variable_1__c;
            }
        } else if (section == 'pli') {
            poId = objectId;
            
            // get the highest sort
            HighestSort = Integer.ValueOf(
                [
                    SELECT max(sort_order__c)
                    FROM AcctSeedErP__Purchase_order_line__c
                    WHERE AcctSeedERP__Purchase_order__c = :poId
                ][0]
                .get('expr0')
            );
            
            list<AcctSeedERP__Purchase_order__c> plist = [
                SELECT GL_Account_Variable_1__c, AcctSeedERP__Type__c
                FROM AcctSeedERP__Purchase_order__c
                WHERE id = :poId
                LIMIT 1
            ];
            
            if (!plist.isEmpty()) {
                agl = plist[0].GL_Account_Variable_1__c;
                
                if (plist[0].AcctSeedERP__Type__c == 'Drop Shipment') {
                    DropShipMessage = true;
                }
            }
        }
        
        // Check Permission and show error message
        if (!AddProductPermission) {
            ObjectError = 'Insufficient Privileges, you are not allowed to add products. ';
            ObjectError += 'Please contact your adminstrator.';
            
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.FATAL, ObjectError)
            );
        }
        
        queryStr = 'select ' + fields;
        queryStr += ' from Product2 ';
        
        if (DropShipMessage) {
            queryStr += ' where Product2.AcctSeed__Inventory_Product__c = false ';
        }
    }
    
    public void FetchProducts(String queryStr) {
        size = 15;
        setCon = new ApexPages.StandardSetController(
            Database.getQueryLocator(queryStr)
        );
        setCon.setPageSize(size);
        noOfRecords = setCon.getResultSize();
    }
    
    public PageReference searchbyFamily() {
        selectedCategory = null;
        selectedSubCategory = null;
        SubCategoryPicklist = new List<SelectOption>();
        CategoryPicklistMethod();
        searchByName();
        
        return null;
    }
    
    public PageReference searchbyCategory() {
        selectedSubCategory = null;
        SubCategoryPicklistMethod();
        searchByName();
        
        return null;
    }
    public PageReference searchbySubCategory() {
        searchByName();
        
        return null;
    }
    
    public PageReference searchByName() {
        // String category = prod2.Category__c;
        String category = selectedFamily;
        // String subCategory = prod2.Sub_Category__c;
        String subCategory = selectedCategory;
        // String complementaryCategory = prod2.Complementary_Category__c;
        String complementaryCategory = selectedSubCategory;
        Boolean isActive = ShowActiveProductsOnly;
        
        String fieldname = '';
        if (selectedSearchVal == 'all' || selectedSearchVal == null) {
            fieldname = 'all';
        } else {
            fieldname = selectedSearchVal;
        }
        if (searchText != null)
            searchText = String.escapeSingleQuotes(searchText.trim());
        
        queryStr = 'select ' + fields;
        queryStr += ' from Product2 ';
        queryStr += ' where ';
        if (DropShipMessage) {
            queryStr += ' Product2.AcctSeed__Inventory_Product__c = false AND ';
        }
        queryStr += ' (';
        if (fieldname != 'all')
            queryStr = queryStr + fieldname + ' like \'%' + searchText + '%\')';
        else {
            Integer i = 1;
            for (SelectOption field : SearchValList) {
                if (field.getLabel() == 'None') {
                    i++;
                    continue;
                } else if (field.getLabel() == 'All') {
                    i++;
                    continue;
                } else {
                    queryStr =
                        queryStr +
                        field.getValue() +
                        ' like \'%' +
                        searchText +
                        '%\'';
                    if (i != SearchValList.size())
                        queryStr = queryStr + ' OR ';
                    i++;
                }
            }
            queryStr = queryStr + ')';
        }
        /*
if (category != null)
queryStr = queryStr + ' and category__c =\'' + category + '\'';
if (subCategory != null)
queryStr = queryStr + ' and Sub_Category__c =\'' + subCategory + '\'';
if (complementaryCategory != null)
queryStr =
queryStr +
' and Complementary_Category__c =\'' + complementaryCategory + '\'';
*/
        
        if (category != null) {
            queryStr = queryStr + ' and category__c =\'' + category + '\'';
            
            if (subCategory != null) {
                queryStr = queryStr + ' and Sub_Category__c =\'' + subCategory + '\'';
                
                if (complementaryCategory != null) {
                    queryStr =
                        queryStr +
                        ' and Complementary_Category__c =\'' +
                        complementaryCategory +
                        '\'';
                } else {
                    queryStr = queryStr + ' and Complementary_Category__c =\'\'';
                }
            } else {
                queryStr = queryStr + ' and Sub_Category__c =\'\'';
                queryStr = queryStr + ' and Complementary_Category__c =\'\'';
            }
        }
        
        queryStr = queryStr + ' and IsActive = ' + isActive;
        
        //queryStr = queryStr + ' order by Name ';
        
        queryStr = ((String.isEmpty(sortWith))
                    ? queryStr + ' order by Name '
                    : queryStr +
                    ' order by ' +
                    sortField +
                    ' ' +
                    sortProcess +
                    ' NULLS LAST ');
        
        this.FetchProducts(queryStr);
        return null;
    }
    
    public LIST<SelectOption> SearchValList {
        get {
            SearchValList = new List<SelectOption>();
            SearchValList.add(new SelectOption('', 'None'));
            SearchValList.add(new SelectOption('all', 'All'));
            
            String type = 'Product2';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ProductSchema = schemaMap.get(type);
            Map<String, Schema.SObjectField> fieldMap = ProductSchema.getDescribe()
                .fields.getMap();
            
            for (String fieldName : fieldMap.keySet()) {
                String LabelIs = fieldMap.get(fieldName).getDescribe().getLabel();
                String APIIs = fieldMap.get(fieldName).getDescribe().getName();
                
                if (
                    APIIs == 'Name' ||
                    APIIs == 'ProductCode' ||
                    APIIs == 'Description' ||
                    APIIs == 'Size__c' ||
                    APIIs == 'Category__c' ||
                    APIIs == 'Type__c' ||
                    APIIs == 'AcctSeed__Inventory_Type__c'
                ) {
                    SearchValList.add(new SelectOption(APIIs, LabelIs));
                }
            }
            
            return SearchValList;
        }
        set;
    }
    
    public pageReference refresh() {
        setCon = null;
        this.FetchProducts(queryStr);
        //Products = setCon.getRecords();
        setCon.setPageNumber(1);
        return null;
    }
    
    public PageReference GoBack() {
        PageReference page = new PageReference('/' + objectId);
        page.setRedirect(true);
        
        return page;
    }
    
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    public void first() {
        CategoryUpdateProductsMap = new map<id, product2>();
        setCon.first();
    }
    
    public void last() {
        CategoryUpdateProductsMap = new map<id, product2>();
        setCon.last();
    }
    
    public void previous() {
        CategoryUpdateProductsMap = new map<id, product2>();
        setCon.previous();
    }
    
    public void next() {
        CategoryUpdateProductsMap = new map<id, product2>();
        setCon.next();
    }
    
    public void setSort(String field, String process) {
        sortProcess = process;
        sortField = field;
        
        this.searchByName();
    }
    public void resetSort(String typeIs) {
        if (typeIs == 'Product Name') {
            ProductCodeSortUp = true;
            ProductCodeSortDown = false;
            SizeSortUp = true;
            SizeSortDown = false;
        } else if (typeIs == 'Product Code') {
            ProductNameSortUp = true;
            ProductNameSortDown = false;
            SizeSortUp = true;
            SizeSortDown = false;
        } else if (typeIs == 'Size') {
            ProductCodeSortUp = true;
            ProductCodeSortDown = false;
            ProductNameSortUp = true;
            ProductNameSortDown = false;
        }
    }
    public void checkSort() {
        sortWith = ApexPages.currentPage().getParameters().get('sort');
        if (sortWith == 'Product Name') {
            if (ProductNameSortUp == true)
                sortProcess = 'ASC';
            
            if (sortProcess == 'DESC') {
                sortProcess = 'ASC';
                ProductNameSortUp = true;
                ProductNameSortDown = false;
                setSort('Product2.Name', 'ASC');
            } else if (sortProcess == 'ASC') {
                sortProcess = 'DESC';
                ProductNameSortUp = false;
                ProductNameSortDown = true;
                setSort('Product2.Name', 'DESC');
            }
            resetSort('Product Name');
        } else if (sortWith == 'Product Code') {
            if (ProductCodeSortUp == true)
                sortProcess = 'ASC';
            
            if (sortProcess == 'DESC') {
                sortProcess = 'ASC';
                ProductCodeSortUp = true;
                ProductCodeSortDown = false;
                setSort('ProductCode', 'ASC');
            } else if (sortProcess == 'ASC') {
                sortProcess = 'DESC';
                ProductCodeSortUp = false;
                ProductCodeSortDown = true;
                setSort('ProductCode', 'DESC');
            }
            resetSort('Product Code');
        } else if (sortWith == 'Size') {
            if (SizeSortUp == true)
                sortProcess = 'ASC';
            
            if (sortProcess == 'DESC') {
                sortProcess = 'ASC';
                SizeSortUp = true;
                SizeSortDown = false;
                setSort('Product2.Size__c', 'ASC');
            } else if (sortProcess == 'ASC') {
                sortProcess = 'DESC';
                SizeSortUp = false;
                SizeSortDown = true;
                setSort('Product2.Size__c', 'DESC');
            }
            resetSort('Size');
        }
    }
    
    public PageReference createNew() {
        String url = '/setup/ui/recordtypeselect.jsp?ent=Product2&retURL=/apex/ProductPage?save_new=1&sfdc.override=1';
        url =
            url +
            '&nooverride=1&save_new_url=/01t/e?retURL=/apex/ProductPage?save_new=1&sfdc.override=1';
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
    }
    
    public PageReference IfSingleProduct() {
        if (prods.size() == 1) {
            PageReference pr = Page.customMultiLine;
            pr.setRedirect(false);
            return pr;
        }
        
        return null;
    }
    public PageReference gotoCustomMultiLine() {
        for (productSelection ps : prods) {
            if (ps.isSelected) {
                productAdded = true;
                break;
            } else {
                productAdded = false;
            }
        }
        
        if (productAdded == false) {
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.severity.FATAL,
                    'No products have been selected.'
                )
            );
            return null;
        }
        
        PageReference pr = Page.customMultiLine;
        //pr.getParameters().put('id', objectid);
        //pr.getParameters().put('section', section);
        pr.setRedirect(false);
        return pr;
    }
    
    public OpportunityLineItem[] OLI {
        get {
            if (Oli == null && section == 'oli') {
                Oli = new List<OpportunityLineItem>{};
                    for (productSelection ps : prods) {

                        OpportunityLineItem line = new OpportunityLineItem(
                            OpportunityId = OppId,
                            UnitPrice = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).UnitPrice : 0.00,
                            Product2Id = ps.prod.id,
                            Item_Description__c = ps.prod.Description,
                            Size__c = ps.prod.Size__c,
                            PricebookEntryId = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).id : null,
                            AcctSeed__GL_Account_Variable_1__c = agl,
                            Allow_Custom_Image__c = ps.prod.Allow_Custom_Image__c,
                            Allow_Product_Description_Change__c = ps.prod.Allow_Product_Description_Change__c
                        );
                        if (prods.size() == 1) {
                            Oli.add(
                                line
                            );
                        } else {
                            if (ps.isSelected) {
                                Oli.add(
                                    line
                                );
                                
                            }
                        }
                        
                        // For custom image
                        if(ps.IsSelected || prods.size() == 1){
                            
                            //Add names to Id map to display on page
                            ProductsWithImage.put(
                                ps.prod.id,
                                String.IsBlank(ps.prod.ProductImageURL__c)
                                ? 'NA'
                                : ps.prod.ProductImageURL__c
                            );
                        }
                    }
            }
            return Oli;
        }
        set;
    }
    
    public Optional_Products_Opportunity__c[] OPO {
        get {
            if (OPO == null && section == 'opo') {
                OPO = new List<Optional_Products_Opportunity__c>{};
                    
                    for (productSelection ps : prods) {

                        Optional_Products_Opportunity__c line = new Optional_Products_Opportunity__c(
                            Opportunity__c = OppId,
                            UnitPrice__c = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).UnitPrice : 0.00,
                            Product__c = ps.prod.id,
                            Item_Description__c = ps.prod.Description,
                            Size__c = ps.prod.Size__c,
                            PriceBookEntryId__c = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).id : null,
                            GL_Account_Variable_1__c = agl,
                            Allow_Product_Description_Change__c = ps.prod.Allow_Product_Description_Change__c
                        );
                        if (prods.size() == 1) {
							line.sortorder__c = HighestSort != null ? ++HighestSort : 1;
                            OPO.add(
                                line
                            );
                        } else {
                            if (ps.isSelected) {
 								line.sortorder__c = HighestSort != null ? ++HighestSort : 1;
                                OPO.add(
                                    line
                                );
                            }
                        }
                        
                        // For custom image
                        if(ps.IsSelected || prods.size() == 1){
                            
                            //Add names to Id map to display on page
                            ProductsWithImage.put(
                                ps.prod.id,
                                String.IsBlank(ps.prod.ProductImageURL__c)
                                ? 'NA'
                                : ps.prod.ProductImageURL__c
                            );
                        }
                    }
            }
            return OPO;
        }
        set;
    }
    
    public QuoteLineItem[] QLI {
        get {
            if (Qli == null && section == 'qli') {
                Qli = new List<QuoteLineItem>{};
                    
                    for (productSelection ps : prods) {

                        QuoteLineItem line = new QuoteLineItem(
                            QuoteId = QuoteId,
                            UnitPrice = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).UnitPrice : 0.00,
                            Product2Id = ps.prod.id,
                            PricebookEntryId = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).id : null,
                            Item_Description__c = ps.prod.Description,
                            Size__c = ps.prod.Size__c,
                            Allow_Product_Description_Change__c = ps.prod.Allow_Product_Description_Change__c
                        );
                        if (prods.size() == 1) {
                            Qli.add(
                                line
                            );
                        } else {
                            if (ps.isSelected) {
                                Qli.add(
                                    line
                                );
                            }
                        }
                        
                        // For custom image
                        if(ps.IsSelected || prods.size() == 1){
                            
                            //Add names to Id map to display on page
                            ProductsWithImage.put(
                                ps.prod.id,
                                String.IsBlank(ps.prod.ProductImageURL__c)
                                ? 'NA'
                                : ps.prod.ProductImageURL__c
                            );
                        }
                    }
            }
            return Qli;
        }
        set;
    }
    
    public Optional_Products_Quote__c[] OPQ {
        get {
            if (OPq == null && section == 'opq') {
                OPq = new List<Optional_Products_Quote__c>{};
                    
                    for (productSelection ps : prods) {

                        Optional_Products_Quote__c line = new Optional_Products_Quote__c(
                            Quote__c = QuoteId,
                            UnitPrice__c = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).UnitPrice : 0.00,
                            Product__c = ps.prod.id,
                            Item_Description__c = ps.prod.Description,
                            Size__c = ps.prod.Size__c,
                            PriceBookEntryId__c = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).id : null,
                            GL_Account_Variable_1__c = agl
                        );
                        if (prods.size() == 1) {
							line.sortorder__c = HighestSort != null ? ++HighestSort : 1;
                            OPq.add(
                                line
                            );
                        } else {
                            if (ps.isSelected) {
								line.sortorder__c = HighestSort != null ? ++HighestSort : 1;
                                OPq.add(
                                    line
                                );
                            }
                        }
                        
                        // For custom image
                        if(ps.IsSelected || prods.size() == 1){
                            
                            //Add names to Id map to display on page
                            ProductsWithImage.put(
                                ps.prod.id,
                                String.IsBlank(ps.prod.ProductImageURL__c)
                                ? 'NA'
                                : ps.prod.ProductImageURL__c
                            );
                            
                        }
                    }
            }
            return OPq;
        }
        set;
    }
    
    public acctseederp__sales_order_line__c[] SLI {
        get {
            if (SLI == null && section == 'sli') {
                SLI = new List<acctseederp__sales_order_line__c>{};
                    for (productSelection ps : prods) {

                        acctseederp__sales_order_line__c line = new acctseederp__sales_order_line__c(
                            acctseederp__sales_order__c = soId,
                            acctseederp__product__c = ps.prod.id,
                            acctseederp__Unit_Price__c = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).UnitPrice : 0.00,
                            acctseederp_Description__c = ps.prod.Description,
                            Item_Description__c = ps.prod.Description,
                            Size__c = ps.prod.Size__c,
                            AcctSeedERP__GL_Account_Variable_1__c = agl,
                            Allow_Product_Description_Change__c = ps.prod.Allow_Product_Description_Change__c
                        );
                        if (prods.size() == 1) {
                            line.sortorder__c = HighestSort != null ? ++HighestSort : 1;
                            SLI.add(
                                line
                            );
                        } else {
                            if (ps.isSelected) {
                                line.sortorder__c = HighestSort != null ? ++HighestSort : 1;
                                SLI.add(
                                    line
                                );
                            }
                        }
                        
                        // For custom image
                        if(ps.IsSelected || prods.size() == 1){
                            
                            //Add names to Id map to display on page
                            ProductsWithImage.put(
                                ps.prod.id,
                                String.IsBlank(ps.prod.ProductImageURL__c)
                                ? 'NA'
                                : ps.prod.ProductImageURL__c
                            );
                            
                        }
                    }
            }
            return SLI;
        }
        set;
    }
    
    public acctseederp__purchase_order_line__c[] PLI {
        get {
            if (PLI == null && section == 'pli') {
                PLI = new List<acctseederp__purchase_order_line__c>{};
                    
                    for (productSelection ps : prods) {
                        acctseederp__purchase_order_line__c line = new acctseederp__purchase_order_line__c(
                            acctseederp__purchase_order__c = poId,
                            acctseederp__product__c = ps.prod.id,
                            // acctseederp__Unit_Price__c = ps.prod.UnitPrice,
                            acctseederp__Unit_Price__c = ProductsPrice.containsKey(ps.prod.id) ? ProductsPrice.get(ps.prod.id).UnitPrice : 0.00,
                            Description__c = ps.prod.Description,
                            Size__c = ps.prod.Size__c,
                            AcctSeedERP__GL_Account_Variable_1__c = agl,
                            Allow_Product_Description_Change__c = ps.prod.Allow_Product_Description_Change__c
                        );
                        if (prods.size() == 1) {
                            line.sort_order__c = HighestSort != null ? ++HighestSort : 1;
                            PLI.add(
                                line
                            );
                        } else {
                            if (ps.isSelected) {
                                line.sort_order__c = HighestSort != null ? ++HighestSort : 1;
                                PLI.add(
                                    line
                                );
                            }
                        }
                        // For custom image
                        if(ps.IsSelected || prods.size() == 1){
                            
                            //Add names to Id map to display on page
                            ProductsWithImage.put(
                                ps.prod.id,
                                String.IsBlank(ps.prod.ProductImageURL__c)
                                ? 'NA'
                                : ps.prod.ProductImageURL__c
                            );
                            
                        }
                    }
            }
            return PLI;
        }
        set;
    }
    
    public pageReference saveOP() {
        try {
            
            return InsertProducts('saveOP');
            
        } catch (DMLException e) {
            return null;
        }
    }
    public pageReference saveMoreOP() {
        try {
            
            return InsertProducts('saveMoreOP');
            
        } catch (DMLException e) {
            
            return null;
        }
    }
    
    public PageReference InsertProducts(String typeOfSave){
        
        List<SObject> ObjectList = new List<SObject>();
        List<SObject> UpdateObjectList = new List<SObject>();
        
        system.debug('Custom Image Map: ' + OliAlternateImgURL);
        
        Boolean ShowKitError = false;
        
        if (section == 'oli') {
            
            ObjectList = OLI;
        } else if (section == 'opo') {
            
            ObjectList = OPO;
        } else if (section == 'qli') {
            
            ObjectList = QLI;
        } else if (section == 'opq') {
            
            ObjectList = OPQ;
        } else if (section == 'sli') {
            
            ObjectList = SLI;
        } else if (section == 'pli') {
            
            ObjectList = PLI;
        }
        
        map<string, decimal> KitQuantityAvailableMap = new map<string, decimal>();
        
        for (sobject obj : ObjectList) {
            
            String productId = section == 'oli' ? (String)obj.get('Product2Id') : section == 'opo' ? 
                (String)obj.get('Product__c') : section == 'qli' ? 
                    (String)obj.get('Product2Id') : section == 'opq' ? 
                        (String)obj.get('Product__c') : section == 'sli' ? 
                            (String)obj.get('AcctSeedERP__Product__c') : section == 'pli' ? 
                                (String)obj.get('AcctSeedERP__Product__c') : null;
            
            Decimal quantity = section == 'oli' ? (Decimal)obj.get('Quantity') : section == 'opo' ? 
                (Decimal)obj.get('Quantity__c') : section == 'qli' ? 
                    (Decimal)obj.get('Quantity') : section == 'opq' ? 
                        (Decimal)obj.get('Quantity__c') : section == 'sli' ? 
                            (Decimal)obj.get('AcctSeedERP__Quantity_Ordered__c') : section == 'pli' ? 
                                (Decimal)obj.get('AcctSeedERP__Quantity__c') : 0.00;
            
            if(productId != null){
                
                if (OliAlternateImgURL.size() > 0 && section == 'oli') {
                    if (OliAlternateImgURL.containsKey(productId)) {
                        
                        obj.put('AlternateImageURL__c', OliAlternateImgURL.get(productId));
                    }
                }
            }
            UpdateObjectList.add(obj);
        }
        
        insert UpdateObjectList;
        
        return typeOfSave == 'saveOP' ? gotoParent() : gotoParentMore();
    }
    public pageReference gotoParent() {
        if (section == 'oli' || section == 'opo') {
            PageReference pr = new PageReference('/' + OppId);
            return pr;
        } else if (section == 'qli' || section == 'opq') {
            PageReference pr = new PageReference('/' + QuoteId);
            return pr;
        } else if (section == 'sli') {
            PageReference pr = new PageReference('/' + soId);
            return pr;
        } else if (section == 'pli') {
            PageReference pr = new PageReference('/' + poId);
            return pr;
        }
        
        return null;
    }
    
    public pageReference gotoParentMore() {
        if (section == 'oli' || section == 'opo') {
            PageReference pr = new PageReference(
                '/apex/ProductPage?id=' +
                OppId +
                '&section=' +
                section
            );
            pr.setRedirect(true);
            return pr;
        } else if (section == 'qli' || section == 'opq') {
            PageReference pr = new PageReference(
                '/apex/ProductPage?id=' +
                QuoteId +
                '&section=' +
                section
            );
            pr.setRedirect(true);
            return pr;
        } else if (section == 'sli') {
            PageReference pr = new PageReference(
                '/apex/ProductPage?id=' +
                soId +
                '&section=' +
                section
            );
            pr.setRedirect(true);
            return pr;
        } else if (section == 'pli') {
            PageReference pr = new PageReference(
                '/apex/ProductPage?id=' +
                poId +
                '&section=' +
                section
            );
            pr.setRedirect(true);
            return pr;
        }
        
        return null;
    }

    public PageReference AddProductCategoryServer(){

        String productId = ApexPages.currentPage().getParameters().get('CategoryProductId');

        if(CurrentProductsMap.containsKey(productId)) 
            CategoryUpdateProductsMap.put(productId, CurrentProductsMap.get(productId));


        return null;

    }

    public PageReference SaveProductCategory(){

        try{

            if(CategoryUpdateProductsMap.size() > 0) 
                update CategoryUpdateProductsMap.values();

        }catch(Exception ex){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error, 
            'Error occured. Categories could not be updated.'));

        }

        FetchProducts(queryStr);
 
        return null;
    }
    
    public class productSelection {
        public boolean isSelected { get; set; }
        public Product2 prod { get; set; }
        
        public productSelection(Product2 p, boolean i) {
            this.prod = p;
            isSelected = i;
        }
    }
}
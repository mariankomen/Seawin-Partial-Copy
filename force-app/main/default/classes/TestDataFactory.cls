@isTest
public class TestDataFactory {
    
    // public static List<Account> createAccounts(){

    // }

    public static User createUser(Id profile_id){

        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName = orgId + dateString + RandomId; 

        User test_user = new User(  firstname = 'ABC', 
                                    lastName = 'XYZ', 
                                    email = uniqueName + '@test' + orgId + '.org', 
                                    Username = uniqueName + '@test' + orgId + '.org', 
                                    EmailEncodingKey = 'ISO-8859-1', 
                                    Alias = uniqueName.substring(18, 23), 
                                    TimeZoneSidKey = 'America/Los_Angeles', 
                                    LocaleSidKey = 'en_US', 
                                    LanguageLocaleKey = 'en_US', 
                                    ProfileId = profile_id
                                ); 
        
        insert test_user;
        return test_user;
    }

    public static AcctSeed__GL_Account__c createGlAccount(){
        AcctSeed__GL_Account__c gl = new AcctSeed__GL_Account__c();
        
        gl.name = 'GL Account First';
        gl.AcctSeed__type__c = 'Expense';
        gl.AcctSeed__Sub_Type_1__c = 'Facilities';
        gl.AcctSeed__Sub_Type_1__c = 'Rent';
        
        insert gl;
        return gl;
    }

    public static void createSalesRep(Id userId){
        Sales_rep__c sr = new Sales_rep__c();
        sr.Active__c = 'Yes';
        sr.Name = 'John Doe';
        sr.User__c = userId;
        sr.Receive_Commission__c = 'After each payment';
        insert sr;
    }
}

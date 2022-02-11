public with sharing class Billing_Payment_Controller {


    public Id recordId {get; set; }
    public AcctSeed__Billing__c record_info {get; set; }
    public String senderEmail {get {return UserInfo.getUserEmail();} set;}
    public Boolean ccMe {get; set;}
    public String ccAddresses {get; set;}
    public String contact_em {get; set;}

    public String recieverEmail {get; set;}

    public String emailSubject {get; set;}
    public String emailBody {get; set;}


    public Billing_Payment_Controller(ApexPages.StandardController std){
        recordId = (Id)std.getId();
        ccMe = false;
        record_info = [select Name, CreatedDate, AcctSeedERP__Sales_Order__c,Acctseed__Opportunity__c, AcctSeed__Customer__c, 
                AcctSeed__Opportunity__r.Amount,
                AcctSeedERP__Sales_Order__r.AcctSeedERP__Total__c,
                AcctSeed__Discount_Amount__c,AcctSeed__Cash_Application_Adjustment_Amount__c,AcctSeed__Sales_Tax2__c,
                AcctSeedERP__Sales_Order__r.Paid_amount__c, GL_Variable_Company__c,
                AcctSeed__Balance__c,AcctSeed__Total__c,AcctSeed__Received_Amount__c,
                AcctSeedERP__Sales_Order__r.Gl_Account_Variable_1__r.name,
                AcctSeed__Customer__r.Name, AcctSeed__Customer__r.AcctSeed__Billing_Terms_Name__c,
                AcctSeedERP__Sales_Order__r.Billing_Terms_Name__c, 
                AcctSeed__Opportunity__r.Billing_Terms_Name__c,
                GL_Account_Variable_1__c, Billing_Deposit__c  , AcctSeed__Billing_Contact__c, AcctSeed__Billing_Contact__r.Name
                from AcctSeed__Billing__c where id=:recordId];
        String emailDate = Date.newinstance(record_info.CreatedDate.year(), record_info.CreatedDate.month(), record_info.CreatedDate.day()).format();
        emailSubject = 'Seawin Global LLC - Billing #' + record_info.Name;
        emailBody = 'To the Attention of: '+record_info.AcctSeed__Billing_Contact__r.Name+'\n\n'
                    +'Attached is your billing #'+record_info.Name+' dated '+emailDate+'. The current balance on this billing is $'+record_info.AcctSeed__Balance__c+'\n\n'
                    +'Thank you for your business.';
    }

    public PageReference savePDF(){
        String newReceiver = [SELECT Id, Email FROM Contact WHERE Id=:record_info.AcctSeed__Billing_Contact__c].Email;


        PageReference pdf = Page.Billing_Payment_PDF;
        pdf.getParameters().put('id',recordId);

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S';
        contentVersion.PathOnClient = record_info.AcctSeed__Customer__r.Name + '_Inv#_'+ record_info.Name + '.pdf';
        contentVersion.Title = record_info.AcctSeed__Customer__r.Name + '_Inv#_'+ record_info.Name + '.pdf';

        Id pdfId = null;
        if(!Test.isRunningTest()) {
            contentVersion.VersionData = pdf.getContentAsPDF();
            
        } else {
            contentVersion.VersionData = Blob.valueOf('test');
        }
        insert contentVersion;
        ContentVersion contentVersionRetrived = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.id];
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentVersionRetrived.ContentDocumentId;
        contentDocumentLink.LinkedEntityId = recordId;
        contentDocumentLink.ShareType = 'I';
        insert contentDocumentLink;
        pdfId = contentDocumentLink.Id;
        

        return new PageReference('/'+recordId);
    }

    public void sendPDF(){
        String newReceiver = [SELECT Id, Email FROM Contact WHERE Id=:record_info.AcctSeed__Billing_Contact__c].Email;
        
        List<String> toAddresses = new List<String>{newReceiver};
        if(ccAddresses != null && ccAddresses.length() > 0){
            toAddresses.addAll(ccAddresses.split(','));
        }
        if(ccMe != false){
            toAddresses.add(UserInfo.getUserEmail());
        }
        system.debug('toAddresses: '+toAddresses);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('SeaWin Support');
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailBody);
        mail.setUseSignature(false);
        PageReference pdf = Page.Billing_Payment_PDF;
        pdf.getParameters().put('id',recordId);

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.PathOnClient = record_info.AcctSeed__Customer__r.Name + '_Inv#_'+ record_info.Name + '.pdf';
        contentVersion.Title = record_info.AcctSeed__Customer__r.Name + '_Inv#_'+ record_info.Name + '.pdf';
        if(!Test.isRunningTest()){
            contentVersion.VersionData = pdf.getContentAsPDF();
            List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
            emailAttachment.setContentType('application/pdf');
            emailAttachment.setFileName(record_info.AcctSeed__Customer__r.Name + '_Inv#_'+ record_info.Name);
            emailAttachment.setBody(pdf.getContentAsPDF());
            emailAttachments.add(emailAttachment);

            mail.setFileAttachments(emailAttachments);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } else {
            contentVersion.VersionData = Blob.valueOf('test');
            List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
            emailAttachment.setContentType('application/pdf');
            emailAttachment.setFileName(record_info.AcctSeed__Customer__r.Name + '_Inv#_'+ record_info.Name);
            emailAttachment.setBody(Blob.valueOf('test'));
            emailAttachments.add(emailAttachment);

            mail.setFileAttachments(emailAttachments);
            
        }


        
    }

    public PageReference back(){
        Pagereference back = new Pagereference('/'+recordId);
        return back;
    }




}

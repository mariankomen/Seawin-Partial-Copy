/*****************************************************************************************************
*   @class           : CommissionPDFSchedule
*   @description     : Public class which uses in monthly sending commission pdf
*   @author          : Marian Lyzhychka ©Peeklogic
*****************************************************************************************************/
public with sharing class CommissionPDFSchedule Implements Schedulable{
    
    public void execute(SchedulableContext sc){

        sendCommissionPDF();
    }


    /*****************************************************************************************************
    *   @method       : sortCommissionsByReps
    *   @description  : Send SalesOrderCommissionsPDF as pdf to email
    *   @return       : void
    *   @author       : Marian Lyzhychka ©Peeklogic
    *****************************************************************************************************/
    public void sendCommissionPDF(){
        PageReference report = Page.SalesOrderCommissionsPDF;
        Blob reportPdf;
        try{
            reportPdf = report.getContentAsPDF();
        }catch(Exception e){
            reportPdf = Blob.valueOf(e.getMessage());
        }

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new String[]{ 'testsalesforce840@gmail.com' });
        message.setSubject('Sales Order Commission PDF - ' + system.today().format());
        message.setHtmlBody('Here\'s a pdf for the unpaid Sales Order Commissions (When SO is fully paid). Date: '+system.today().format() );

        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('SalesOrderCommissions-' + system.today().format() + '.pdf');
        attachment.setInline(false);
        attachment.setBody(reportPdf);
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
        
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ message });
        }
    }
}

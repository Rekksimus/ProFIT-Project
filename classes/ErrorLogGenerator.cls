public with sharing class ErrorLogGenerator {
    public static void InsError(Datetime errdate, String errdetail,String processname) {
        Error_Log__c a = new Error_Log__c();
        a.Log_Date_Tile__c = errdate;
        a.Log_Details__c = errdetail;
        a.Process_Name__c = processname;
        insert a;
    }
}
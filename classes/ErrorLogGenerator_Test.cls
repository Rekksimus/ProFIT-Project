@isTest
private class ErrorLogGenerator_Test {
    @IsTest
    static void testError(){
        
        Test.startTest();
        DateTime logDate = datetime.newInstance(2021, 6, 21, 19, 30, 0);
        String logDetails = 'Error Test';
        String name = 'Test Error Name';
        ErrorLogGenerator.InsError(logDate, logDetails, name);

        Test.stopTest();
        Error_Log__c eLog = [Select Id, Log_Date_Tile__c, Log_Details__c, Process_Name__c from Error_Log__c];
        System.assertEquals('Test Error Name', eLog.Process_Name__c);
    }
}
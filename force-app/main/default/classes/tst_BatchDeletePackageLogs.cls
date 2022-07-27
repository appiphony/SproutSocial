@isTest
public with sharing class tst_BatchDeletePackageLogs {
    
    @isTest
    static void testDeleteBatch(){
        List<Package_Log__c> logs = new List<Package_Log__c>();
        for(integer i = 1; i < 50; i++){
            Package_Log__c log = new Package_Log__c();
            log.Dump__c = 'log# ' + String.valueOf(i);
            logs.add(log);
        }

        insert logs;

        Test.startTest();

        BatchDeletePackageLogs obj = new BatchDeletePackageLogs();
        Database.executeBatch(obj);
        Test.stopTest();

        List<AggregateResult> numPackageLogsList = [SELECT count(Id) packageLogCount FROM Package_Log__c];

        System.assertEquals(0,numPackageLogsList[0].get('packageLogCount'));
    }
}

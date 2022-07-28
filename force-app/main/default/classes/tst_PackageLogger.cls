@isTest
public with sharing class tst_PackageLogger {

    @isTest
    static void tst_PackageLoggerCreateCustom() {
        Map<String, Object> setupData = new Map<String, Object>();

        setupData.put('Steps_Completed__c', '{"C-PACKAGE-LOG-CONFIG-STEP" : 1}');
        setupData.put('Retention_Type__c', 'errorsOnly');
        setupData.put('Retention_Value__c', '3');

        System.debug(JSON.serialize(setupData));

        //List<Setup_MetaData__mdt> data = [SELECT Id, Steps_Completed__c, label, Retention_Value__c, Retention_Type__c FROM Setup_MetaData__mdt WHERE label = 'Default' WITH SECURITY_ENFORCED];
        
        metadataCRUD.saveSetupConfigData(setupData, 'Setup_MetaData.Default');

        List<Setup_MetaData__mdt> data = [SELECT Id, Steps_Completed__c, label, Retention_Value__c, Retention_Type__c FROM Setup_MetaData__mdt WHERE label = 'Default' WITH SECURITY_ENFORCED];
        System.debug(data[0].Retention_Value__c);
    }

    @isTest
    static void tst_PackageLoggerCreateFromError() {
        String dump = 'Dump test';

        Test.startTest();
        try {
            Object parsedJson = JSON.deserializeUntyped('bad json');
        } catch (Exception e) {
            packageLogger.create(e, 'test');
        }
        Test.stopTest();

        List<Package_Log__c> logs = [SELECT Id, Message__c FROM Package_Log__c];

        System.debug(logs[0].Id);

        System.assertEquals(1, logs.size());
    }

    @isTest
    static void tst_PackageLoggerDeleteLast() {
        Test.startTest();
        Setup_MetaData__mdt logSetup = new Setup_MetaData__mdt();
        Map<String,Object> fields =  (Map<String,Object>) JSON.deserializeUntyped(JSON.serializePretty(logSetup));
        fields.put(Setup_MetaData__mdt.Label.getDescribe().getName(), 'Default');
        fields.put(Setup_MetaData__mdt.Retention_Type__c.getDescribe().getName(), 'errorsOnly');
        fields.put(Setup_MetaData__mdt.Retention_Value__c.getDescribe().getName(), '2');
        logSetup = (Setup_MetaData__mdt) JSON.deserialize(JSON.serialize(fields), Setup_MetaData__mdt.class);
        packageLogger.setupConfigMetadata.add(logSetup);

        System.debug(logSetup.get('Retention_Value__c'));

        for(integer i = 0; i < 5; i++){
            packageLogger.create('mes', 'error', 'here', 'dump');
        }

        List<AggregateResult> numPackageLogsList = [SELECT count(Id) packageLogCount FROM Package_Log__c];

        System.assertEquals(4, numPackageLogsList[0].get('packageLogCount'));

    }


}

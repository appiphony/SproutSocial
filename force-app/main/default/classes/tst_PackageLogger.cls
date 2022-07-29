@isTest
public with sharing class tst_PackageLogger {

    @isTest
    static void tst_PackageLoggerCreateCustom() {
        Test.startTest();
        Setup_MetaData__mdt logSetup = new Setup_MetaData__mdt();
        Map<String,Object> fields =  (Map<String,Object>) JSON.deserializeUntyped(JSON.serializePretty(logSetup));
        fields.put(Setup_MetaData__mdt.Label.getDescribe().getName(), 'Default');
        fields.put(Setup_MetaData__mdt.Retention_Type__c.getDescribe().getName(), 'errorsOnly');
        fields.put(Setup_MetaData__mdt.Retention_Value__c.getDescribe().getName(), '10');
        logSetup = (Setup_MetaData__mdt) JSON.deserialize(JSON.serialize(fields), Setup_MetaData__mdt.class);

        if(packageLogger.setupConfigMetadata.isEmpty()) {
            packageLogger.setupConfigMetadata.add(logSetup);
        } else {
            packageLogger.setupConfigMetadata[0] = logSetup;
        }

        Profile p = [SELECT Id 
                     FROM Profile 
                     WHERE Name='Standard User'
                    ];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUser = new User(Alias = 'testUser', Email='standarduser@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = p.Id,
                                 TimeZoneSidKey='America/Los_Angeles',
                                 UserName=uniqueUserName
                            );
        insert testUser;
        PermissionSet permSet = [SELECT Id, Label 
                                 FROM PermissionSet 
                                 WHERE Label = 'Sprout Integration Admin'
                                ];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permset.Id, AssigneeId = testUser.Id);
        insert psa;

        System.runAs(testUser) {
            for(integer i = 0; i < 5; i++) {
                packageLogger.create('mes', 'error', 'here', 'dump');
            }
        }
        Test.stopTest();

        List<AggregateResult> numPackageLogsList = [SELECT count(Id) packageLogCount FROM Package_Log__c];

        System.assertEquals(5, numPackageLogsList[0].get('packageLogCount'));    
    }

    @isTest
    static void tst_PackageLoggerCreateFromError() {
        String dump = 'Dump test';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUser = new User(Alias = 'testUser', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles',
                            UserName=uniqueUserName);
        insert testUser;
        PermissionSet permSet = [SELECT Id, Label FROM PermissionSet WHERE Label = 'Sprout Integration Admin'];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permset.Id, AssigneeId = testUser.Id);
        insert psa;

        Test.startTest();
        System.runAs(testUser) {
            try {
                Object parsedJson = JSON.deserializeUntyped('bad json');
            } catch (Exception e) {
                packageLogger.create(e, 'test');
            }
        }
        Test.stopTest();

        List<Package_Log__c> logs = [SELECT Id, Message__c FROM Package_Log__c];


        System.assertEquals(1, logs.size());
    }

    @isTest
    static void tst_PackageLoggerDeleteLast() {
        Setup_MetaData__mdt logSetup = new Setup_MetaData__mdt();
        Map<String,Object> fields =  (Map<String,Object>) JSON.deserializeUntyped(JSON.serializePretty(logSetup));
        //fields.put(Setup_MetaData__mdt.Steps_Completed__c.getDescribe().getName(), '{\"C-PACKAGE-LOG-CONFIG-STEP\"}');
        fields.put(Setup_MetaData__mdt.Label.getDescribe().getName(), 'Default');
        fields.put(Setup_MetaData__mdt.Retention_Type__c.getDescribe().getName(), 'errorsOnly');
        fields.put(Setup_MetaData__mdt.Retention_Value__c.getDescribe().getName(), '3');
        logSetup = (Setup_MetaData__mdt) JSON.deserialize(JSON.serialize(fields), Setup_MetaData__mdt.class);

        if(packageLogger.setupConfigMetadata.isEmpty()) {
            packageLogger.setupConfigMetadata.add(logSetup);
        } else {
            packageLogger.setupConfigMetadata[0] = logSetup;
        }
        
        Test.startTest();
    
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User testUser = new User(Alias = 'testUser', Email='standarduser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles',
                            UserName=uniqueUserName);
        insert testUser;
        PermissionSet permSet = [SELECT Id, Label FROM PermissionSet WHERE Label = 'Sprout Integration Admin'];
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permset.Id, AssigneeId = testUser.Id);
        insert psa;

        System.runAs(testUser) {
            for(integer i = 0; i < 5; i++) {
                packageLogger.create('mes', 'error', 'here', 'dump');
            }
        }

        List<AggregateResult> numPackageLogsList = [SELECT count(Id) packageLogCount FROM Package_Log__c];

        System.assertEquals(3, numPackageLogsList[0].get('packageLogCount'));

    }


}

@isTest
public with sharing class tst_SetupAssistant {
    @isTest 
    static public void testSetupAssistant() {
        Test.startTest();
        setupAssistant con = new SetupAssistant();
        Test.stopTest();

        System.assertEquals(constants.NAMESPACE, con.namespace);
    }

    @isTest
    static void testSetupAssistant_saveData() {
        Test.startTest();

        Setup_MetaData__mdt setupMetaData = new Setup_MetaData__mdt();
        Map<String, Object> fields = (Map<String, Object>) JSON.deserializeUntyped(JSON.serializePretty(setupMetaData));
        fields.put(Setup_MetaData__mdt.Label.getDescribe().getName(), 'Default');
        fields.put(Setup_MetaData__mdt.Steps_Completed__c.getDescribe().getName(), '{\"C-FLOW-CONFIG-STEP\" : \"1\"}');
        fields.put(Setup_MetaData__mdt.Retention_Type__c.getDescribe().getName(), 'errorsOnly');
        fields.put(Setup_MetaData__mdt.Retention_Value__c.getDescribe().getName(), '3');
        setupMetaData = (Setup_MetaData__mdt) JSON.deserialize(JSON.serialize(fields), Setup_MetaData__mdt.class);

        if(setupAssistant.setupConfigMetadata.isEmpty()) {
            setupAssistant.setupConfigMetadata.add(setupMetaData);
        } else {
            setupAssistant.setupConfigMetadata[0] = setupMetaData;
        }

        Map<String, Object> saveData = new Map<String, Object>();
        saveData.put('Steps_Completed__c', '{\"C-PACKAGE-LOG-CONFIG-STEP\" : \"1\"}');
        saveData.put('Retention_Type__c', 'errorsOnly');
        saveData.put('Retention_Value__c', '5');
        saveData.put('Label', 'Default');

        setupAssistant.saveData(saveData);


    }

    @isTest
    static void testSetupAssistant_getData() {
        Test.startTest();
        setupAssistant.saveData(new Map<String, Object>());

        Setup_MetaData__mdt setupMetaData = new Setup_MetaData__mdt();
        Map<String, Object> fields = (Map<String, Object>) JSON.deserializeUntyped(JSON.serializePretty(setupMetaData));
        fields.put(Setup_MetaData__mdt.Label.getDescribe().getName(), 'Default');
        fields.put(Setup_MetaData__mdt.Retention_Type__c.getDescribe().getName(), 'errorsOnly');
        fields.put(Setup_MetaData__mdt.Retention_Value__c.getDescribe().getName(), '3');
        fields.put(Setup_MetaData__mdt.Steps_Completed__c.getDescribe().getName(), '{}');
        setupMetaData = (Setup_MetaData__mdt) JSON.deserialize(JSON.serialize(fields), Setup_MetaData__mdt.class);

        setupAssistant.setupConfigMetadata.add(setupMetaData);


        String response = setupAssistant.getData();
        Test.stopTest();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        System.assert((Boolean)responseMap.get('isSuccess'), responseMap.get('error'));

        Map<String, Object> resultsMap = (Map<String, Object>)responseMap.get('results');
        System.assert(resultsMap.containsKey('setupData'), '`data` not found');
    }

    /*
    @isTest
    static void testGetPackageVersion(){
        setupAssistant.getPackageVersion();
    }
    */
}

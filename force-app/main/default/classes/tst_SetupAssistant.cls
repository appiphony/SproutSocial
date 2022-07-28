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

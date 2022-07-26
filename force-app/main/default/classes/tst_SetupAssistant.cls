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
        setupAssistant.saveData(new Map<String, Object>());

        Test.startTest();
        String response = setupAssistant.getData();
        Test.stopTest();

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        System.assert((Boolean)responseMap.get('isSuccess'), responseMap.get('error'));

        Map<String, Object> resultsMap = (Map<String, Object>)responseMap.get('results');
        System.assert(resultsMap.containsKey('setupData'), '`data` not found');
    }
}

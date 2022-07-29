public with sharing class SetupAssistant {
    public String namespace { get; set; }

    public setupAssistant() {
        namespace = constants.NAMESPACE;
    }

    @testVisible static List<Setup_MetaData__mdt> setupConfigMetadata { 
        get {
            if (setupConfigMetadata == null)
                setupConfigMetadata = [SELECT Steps_Completed__c, Retention_Type__c, Retention_Value__c  
                                       FROM Setup_MetaData__mdt
                                       WITH SECURITY_ENFORCED]; 
            return setupConfigMetadata;
        } set; }

    @AuraEnabled
    public static String getPackageVersion() {
        responseData rd = new responseData();
        
        try {
            rd.put('major', System.requestVersion().major());
            rd.put('minor', System.requestVersion().minor());
        } catch(Exception e) {
            rd.addError(e);
        }
        
        return rd.getJsonString();
    }

    @AuraEnabled
    public static String getData() {
        responseData rd = new responseData();

        try {
            //checkAccess();

            List<AggregateResult> numPackageLogsList = [SELECT count(Id) packageLogCount FROM Package_Log__c];

            rd.put('setupData', getSetupData());
            rd.put('currentLogRecordCount', numPackageLogsList[0].get('packageLogCount'));
        } catch (Exception e) {
            rd.addError(e);
        }

        return rd.getJsonString();
    }

    @AuraEnabled
    public static String saveData(Map<String, Object> setupData) {
        responseData rd = new responseData();

        try {
            //checkAccess();            
            if (setupData != null) {
                List<Setup_MetaData__mdt> data = [SELECT Id, Steps_Completed__c, label, Retention_Value__c, Retention_Type__c FROM Setup_MetaData__mdt WHERE label = 'Default' WITH SECURITY_ENFORCED];
                if(Test.isRunningTest()){
                    data = setupConfigMetadata;
                }
                
                if (!data.isEmpty()){
                    
                    Setup_MetaData__mdt dataObj = (Setup_MetaData__mdt)utilities.getSobjectByMap(setupData, constants.NAMESPACE_API + 'Setup_MetaData__mdt');
                    if (!String.isEmpty(dataObj.Steps_Completed__c) && !String.isEmpty(data[0].Steps_Completed__c)) {
                        Map<String, Object> stepsCompleted = (Map<String, Object>)JSON.deserializeUntyped(data[0].Steps_Completed__c);
                        Map<String, Object> newStepsCompleted = (Map<String, Object>)JSON.deserializeUntyped(dataObj.Steps_Completed__c);
                        newStepsCompleted.putAll(stepsCompleted);
                        setupData.put('Steps_Completed__c', json.serialize(newStepsCompleted));
                    }
                }
                metadataCRUD.saveSetupConfigData(setupData, 'Setup_MetaData.Default');
            }
            

            return getData();
        } catch (Exception e) {
            packageLogger.Create(e.getMessage(), 'error', 'SetupAssistant Line number: ' + String.valueOf(e.getLineNumber()), e.getStackTraceString());
            rd.addError(e);
        }
        
        return rd.getJsonString();
    }

    public static Setup_MetaData__mdt getSetupData() {

        //checkAccess();
        
        Set<String> fields = new Set<String> {
            'Id',
            'Steps_Completed__c',
            'Retention_Value__c',
            'Retention_Type__c'
        };

        String query = 'SELECT ' + String.join(new List<String>(fields), ',') + ' FROM ' + constants.NAMESPACE_API + 'Setup_MetaData__mdt WHERE label = \'Default\' WITH SECURITY_ENFORCED';
        List<Setup_MetaData__mdt> data = Database.query(query);
        Setup_MetaData__mdt setupData = new Setup_MetaData__mdt();

        if (!data.isEmpty()) {
            setupData = data[0];
        }

        setupData.label = 'Default';

        if(String.isEmpty(setupData.Steps_Completed__c)) {
            setupData.Steps_Completed__c = '{}';
        }

        return setupData;
    }

    //public static void saveSetupData(Account setupData) {
        //checkAccess();
        
        /*List<Setup_Data__c> data = [SELECT Id, Steps_Completed__c 
                                    FROM Setup_Data__c 
                                    WHERE Name = 'Default'];
                                    

        if (!data.isEmpty()) {
            // override id
            setupData.Id = data[0].Id;

            // merge completed steps
            if (String.isNotEmpty(setupData.Steps_Completed__c) && String.isNotEmpty(data[0].Steps_Completed__c)) {
                Map<String, Object> stepsCompleted = (Map<String, Object>)JSON.deserializeUntyped(data[0].Steps_Completed__c);
                Map<String, Object> newStepsCompleted = (Map<String, Object>)JSON.deserializeUntyped(setupData.Steps_Completed__c);
                newStepsCompleted.putAll(stepsCompleted);
                setupData.Steps_Completed__c = JSON.serialize(newStepsCompleted);
            }
        }

        // override name
        setupData.Name = 'Default';

        upsert setupData;*/
    //}

    /*private static void checkAccess() {
        Set<String> dataReadFields = new Set<String>();
        Set<String> dataUpdateFields = new Set<String>();

        
        for (Schema.SObjectField field : Setup_MetaData__mdt.sObjectType.getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (fieldDescribe.isCustom()) {
                if (fieldDescribe.isAccessible()) {
                    dataReadFields.add(fieldDescribe.getName());
                }
                if (fieldDescribe.isUpdateable()) {
                    dataUpdateFields.add(fieldDescribe.getName());
                }
            }
        }

        dataReadFields.add('Name');
        dataUpdateFields.add('Name');

        Set<String> settingsReadFields = new Set<String>();
        Set<String> settingsUpdateFields = new Set<String>();

        
        for (Schema.SObjectField field : Setup_Settings__c.sObjectType.getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (fieldDescribe.isCustom()) {
                if (fieldDescribe.isAccessible()) {
                    settingsReadFields.add(fieldDescribe.getName());
                }
                if (fieldDescribe.isUpdateable()) {
                    settingsUpdateFields.add(fieldDescribe.getName());
                }
            }
        }
        

        settingsReadFields.add('Name');
        settingsUpdateFields.add('Name');

        DmlManager.checkAccess(new Map<String, Map<String, Set<String>>> {
            'Setup_MetaData__mdt' => new Map<String, Set<String>> {
                'Read' => dataReadFields,
                'Create' => dataUpdateFields,
                'Update' => dataUpdateFields
            }
        });
        
        
        
    }
    */
}

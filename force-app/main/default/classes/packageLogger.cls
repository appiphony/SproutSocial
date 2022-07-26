public with sharing class packageLogger {
    public static void create(String message, String type, String location, String dump) {

        try {
            dmlManager.checkAccess(new Map<String, Map<String, Set<String>>> {
                'Package_Log__c' => new Map<String, Set<String>> {
                    'Read' => new Set<String> {
                        'Dump__c', 'Location__c', 'Message__c', 'Type__c'
                    },
                    'Create' => new Set<String> {
                        'Dump__c', 'Location__c', 'Message__c', 'Type__c'
                    },
                    'Update' => new Set<String> {
                        'Dump__c', 'Location__c', 'Message__c', 'Type__c'
                    }
                }
            });
        } catch (Exception e) {
            return;
        }
        
        Set<String> fields = new Set<String> {
            'Id',
            'Retention_Value__c',
            'Retention_Type__c'
        };

        String query = 'SELECT ' + String.join(new List<String>(fields), ',') + ' FROM ' + constants.NAMESPACE_API + 'Setup_MetaData__mdt WHERE label = \'Default\' WITH SECURITY_ENFORCED';
        List<Setup_MetaData__mdt> data = Database.query(query);
        Setup_MetaData__mdt setupData = new Setup_MetaData__mdt();

        List<AggregateResult> numPackageLogsList = [SELECT count(Id) packageLogCount FROM Package_Log__c];

        if (!data.isEmpty()) {
            setupData = data[0];
        }

        if(numPackageLogsList[0].get('packageLogCount') == setupData.get('Retention_Value__c')) {
            delete [SELECT Id 
                    FROM Package_Log__c
                    ORDER BY CreatedDate asc 
                    LIMIT 1];
        }

        insert new Package_Log__c(
            Dump__c = dump.left(131072),
            Location__c = location,
            Message__c = message,
            Type__c = type
        );
    }

    public static void create(Exception e, Object self){
        packageLogger.create(e, self, null);
    }

    public static void create(Exception e, Object self, String dump){
        String classString = String.valueOf(self);
        String location = classString.left(classString.indexOf(':')) + ':' + String.valueOf(e.getLineNumber());

        if (null == dump){
            dump = e.getStackTraceString();
        }

        packageLogger.create(
            e.getMessage(),
            e.getTypeName(),
            location,
            dump
        );
    }

    public class StrikeException extends Exception {
        public override String getStackTraceString() {
            return super.getCause().getStackTraceString();
        }
    }

    public packageLogger() {
        
    }
}

public with sharing class WorkflowPathsListViewCreateController {

    @AuraEnabled
    public static Map<String, String> getObjectOptions() {
        try {
            List<SObjectType> typesToRetrieve = new List<SObjectType> {
                    Meeting__c.getSObjectType(),
                    MeetingLocation__c.getSObjectType(),
                    MeetingMember__c.getSObjectType(),
                    MeetingTopic__c.getSObjectType(),
                    MeetingProduct__c.getSObjectType(),
                    MeetingExpense__c.getSObjectType(),
                    MeetingBudget2__c.getSObjectType(),
                    MeetingExpenseAllocation__c.getSObjectType(),
                    MeetingExpenseBudgetAllocation__c.getSObjectType()
            };

            return constructObjectOptions(typesToRetrieve);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ObjectInfo getObjectInfo(String sobjectTypeName) {
        Map<String, SObjectType> objectTypesByNames = Schema.getGlobalDescribe();
        if (!objectTypesByNames.containsKey(sobjectTypeName)) throw new AuraHandledException('No object found');

        try {
            SObjectType objectType = objectTypesByNames.get(sobjectTypeName);
            DescribeSObjectResult describeResult = objectType.getDescribe();

            Map<String, SObjectField> objectFieldsByNames = describeResult.fields.getMap();
            Map<String, RecordTypeInfo> recordTypeInfosByDevNames = describeResult.getRecordTypeInfosByDeveloperName();

            return new ObjectInfo(objectFieldsByNames, recordTypeInfosByDevNames);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    private static Map<String, String> constructObjectOptions(List<SObjectType> types) {
        Map<String, String> result = new Map<String, String>();
        for (SObjectType objectType : types) {
            DescribeSObjectResult describe = objectType.getDescribe();
            result.put(describe.getName(), describe.getLabel());
        }

        return result;
    }

    public class ObjectInfo {

        @AuraEnabled
        public Map<String, String> controllingFieldOptions;

        @AuraEnabled
        public Map<String, String> recordTypeOptions;

        public ObjectInfo(Map<String, SObjectField> objectFieldsByNames, Map<String, RecordTypeInfo> recordTypeInfosByDevNames) {
            this.controllingFieldOptions = this.filterControllingFields(objectFieldsByNames);
            this.recordTypeOptions = this.filterRecordTypes(recordTypeInfosByDevNames);
        }

        private Map<String, String> filterControllingFields(Map<String, SObjectField> objectFieldsByNames) {
            Map<String, String> result = new Map<String, String>();
            for (SObjectField field : objectFieldsByNames.values()) {
                DescribeFieldResult fieldDescribe = field.getDescribe();
                if (fieldDescribe.getType() == DisplayType.PICKLIST) {
                    result.put(fieldDescribe.getName(), fieldDescribe.getLabel());
                }
            }

            return result;
        }

        private Map<String, String> filterRecordTypes(Map<String, RecordTypeInfo> recordTypeInfosByDevNames) {
            Map<String, String> result = new Map<String, String>();
            for (RecordTypeInfo info : recordTypeInfosByDevNames.values()) {
                String devName = info.getDeveloperName();
                if (devName != 'Master') {
                    result.put(devName, info.getName());
                }
            }

            return result;
        }
    }
}
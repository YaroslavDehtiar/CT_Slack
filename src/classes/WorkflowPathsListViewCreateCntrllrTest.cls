@IsTest
private class WorkflowPathsListViewCreateCntrllrTest {

    private static final String MASTER_RECORD_TYPE = 'Master';

    @IsTest
    static void getObjectOptionsTest() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        Map<String, String> expectedResult = new Map<String, String> {
                Meeting__c.getSObjectType().getDescribe().getName() => Meeting__c.getSObjectType().getDescribe().getLabel(),
                MeetingLocation__c.getSObjectType().getDescribe().getName() => MeetingLocation__c.getSObjectType().getDescribe().getLabel(),
                MeetingMember__c.getSObjectType().getDescribe().getName() => MeetingMember__c.getSObjectType().getDescribe().getLabel(),
                MeetingTopic__c.getSObjectType().getDescribe().getName() => MeetingTopic__c.getSObjectType().getDescribe().getLabel(),
                MeetingProduct__c.getSObjectType().getDescribe().getName() => MeetingProduct__c.getSObjectType().getDescribe().getLabel(),
                MeetingExpense__c.getSObjectType().getDescribe().getName() => MeetingExpense__c.getSObjectType().getDescribe().getLabel(),
                MeetingBudget2__c.getSObjectType().getDescribe().getName() => MeetingBudget2__c.getSObjectType().getDescribe().getLabel(),
                MeetingExpenseAllocation__c.getSObjectType().getDescribe().getName() => MeetingExpenseAllocation__c.getSObjectType().getDescribe().getLabel(),
                MeetingExpenseBudgetAllocation__c.getSObjectType().getDescribe().getName() => MeetingExpenseBudgetAllocation__c.getSObjectType().getDescribe().getLabel()

        };

        //When
        Test.startTest();
        Map<String, String> actualResult = WorkflowPathsListViewCreateController.getObjectOptions();
        Test.stopTest();

        //Then
        System.assertEquals(expectedResult, actualResult);
    }

    @IsTest
    static void getObjectInfoTest() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        DescribeSObjectResult result = Meeting__c.getSObjectType().getDescribe();
        Map<String, String> controllingFields = new Map<String, String>();
        for (SObjectField field : result.fields.getMap().values()) {
            DescribeFieldResult fieldResult = field.getDescribe();
            if (fieldResult.getType() == DisplayType.PICKLIST) {
                controllingFields.put(fieldResult.getName(), fieldResult.getLabel());
            }
        }

        Map<String, String> recordTypes = new Map<String, String>();
        for (RecordTypeInfo info : result.recordTypeInfos) {
            if (info.getDeveloperName() != MASTER_RECORD_TYPE) {
                recordTypes.put(info.getDeveloperName(), info.getName());
            }
        }

        //When
        Test.startTest();
        WorkflowPathsListViewCreateController.ObjectInfo info = WorkflowPathsListViewCreateController.getObjectInfo(result.getName());
        Test.stopTest();

        //Then
        System.assertEquals(controllingFields, info.controllingFieldOptions);
        System.assertEquals(recordTypes, info.recordTypeOptions);

    }
}
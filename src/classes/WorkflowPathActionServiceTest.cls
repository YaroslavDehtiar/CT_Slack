@IsTest
private class WorkflowPathActionServiceTest {

    @IsTest
    static void testPublishPlatformEventWithWorkflowObjectRecord() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        String eventName = DataChangeEvent__e.getSObjectType().getDescribe().getName();

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        Map<String, Object> params = new Map<String, Object>{
                DataChangeEvent__e.Category__c.getDescribe().getName() => 'MeetingStatusChanged',
                DataChangeEvent__e.EntityName__c.getDescribe().getName() => 'Meeting',
                DataChangeEvent__e.ChangeType__c.getDescribe().getName() => 'ChangeType',
                DataChangeEvent__e.RecordID__c.getDescribe().getName() => '$value.Id',
                DataChangeEvent__e.Data__c.getDescribe().getName() => '$value'
        };

        WorkflowPathActionService service = new WorkflowPathActionService();

        //When
        Test.startTest();
        ActionResult actionResult = service.publishPlatformEvent(meeting.Id, eventName, params);
        Test.stopTest();

        //Then
        System.assert(actionResult.isSuccess);
    }

    @IsTest
    static void testPublishPlatformEventWithWorkflowObjectField() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        String eventName = DataChangeEvent__e.getSObjectType().getDescribe().getName();

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        Map<String, Object> params = new Map<String, Object>{
                DataChangeEvent__e.Category__c.getDescribe().getName() => 'MeetingStatusChanged',
                DataChangeEvent__e.EntityName__c.getDescribe().getName() => 'Meeting',
                DataChangeEvent__e.ChangeType__c.getDescribe().getName() => 'ChangeType',
                DataChangeEvent__e.RecordID__c.getDescribe().getName() => '$value.Id',
                DataChangeEvent__e.Data__c.getDescribe().getName() => '$value.Name'
        };

        WorkflowPathActionService service = new WorkflowPathActionService();

        //When
        Test.startTest();
        ActionResult actionResult = service.publishPlatformEvent(meeting.Id, eventName, params);
        Test.stopTest();

        //Then
        System.assert(actionResult.isSuccess);
    }

    @IsTest
    static void testPublishPlatformEvent() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        String eventName = DataChangeEvent__e.getSObjectType().getDescribe().getName();

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        Map<String, Object> params = new Map<String, Object>{
                DataChangeEvent__e.Category__c.getDescribe().getName() => 'MeetingStatusChanged',
                DataChangeEvent__e.EntityName__c.getDescribe().getName() => 'Meeting',
                DataChangeEvent__e.ChangeType__c.getDescribe().getName() => 'ChangeType',
                DataChangeEvent__e.RecordID__c.getDescribe().getName() => meeting.Id
        };

        WorkflowPathActionService service = new WorkflowPathActionService();

        //When
        Test.startTest();
        ActionResult actionResult = service.publishPlatformEvent(meeting.Id, eventName, params);
        Test.stopTest();

        //Then
        System.assert(actionResult.isSuccess);
    }

    @IsTest
    static void testPublishPlatformEventWithError() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        String eventName = DataChangeEvent__e.getSObjectType().getDescribe().getName();

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        Map<String, Object> params = new Map<String, Object>{
                DataChangeEvent__e.Category__c.getDescribe().getName() => 'MeetingStatusChanged',
                DataChangeEvent__e.EntityName__c.getDescribe().getName() => 'Meeting',
                DataChangeEvent__e.ChangeType__c.getDescribe().getName() => 'ChangeType'
        };

        WorkflowPathActionService service = new WorkflowPathActionService();

        //When
        Test.startTest();
        ActionResult actionResult = service.publishPlatformEvent(meeting.Id, eventName, params);
        Test.stopTest();

        //Then
        System.assert(!actionResult.isSuccess);
        System.assert(!actionResult.getErrors().isEmpty());
    }
}
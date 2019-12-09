@IsTest
private class WorkflowPathControllerTest {
    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();

    @IsTest
    static void testGenericRecordUpdate() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        //When
        Test.startTest();
        WorkflowPathController.updateRecord(meeting.Id, 'Name', 'TestWorkflowUpdate');
        Test.stopTest();

        //Then
        meeting = (Meeting__c) DataLayer.querySingle([SELECT Name FROM Meeting__c]);
        System.assertEquals('TestWorkflowUpdate', meeting.Name);
    }

    @IsTest
    static void testGenericRecordUpdateWithWrongField() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        Exception actualException;

        //When
        Test.startTest();
        try {
            WorkflowPathController.updateRecord(meeting.Id, 'qwerty', 'TestWorkflowUpdate');
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        //Then
        TestUtils.assertNotNull(actualException);
    }

    @IsTest
    static void testGenericRecordUpdateForDMLException() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);

        Exception actualException;

        //When
        Test.startTest();
        try {
            WorkflowPathController.updateRecord(meeting.Id, 'Name', 'TooLongNameTooLongNameTooLongNameTooLongNameTooLongNameTooLongNameTooLongNameTooLongName');
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        //Then
        TestUtils.assertNotNull(actualException);
    }

    @IsTest
    static void testGetPathAssociation() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);
        TestUtils.Stub workflowPathService = stubFactory.stub();

        workflowPathService.when('getPathAssociationsByRecordIds', new Set<Id>{
                meetingId
        })
                .thenReturn(new Map<Id, WorkflowPathAssociation>{
                meetingId => new WorkflowPathAssociation(meetingId, null, null)
        });
        WorkflowPathController.workflowPathService = (WorkflowPathService) mockFactory.mock(WorkflowPathService.class, workflowPathService);
        //When
        Test.startTest();
        WorkflowPathAssociation workflowPathAssociation= WorkflowPathController.getPathAssociation(meetingId);
        Test.stopTest();

        //Then
        System.assertEquals(meetingId, workflowPathAssociation.getRecordId());
    }

    @IsTest
    static void testExceptionOnGettingPathAssociation() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);
        TestUtils.Stub workflowPathService = stubFactory.stub();

        workflowPathService.when('getPathAssociationsByRecordIds', new Set<Id>{
                meetingId
        })
                .thenReturn(null);
        WorkflowPathController.workflowPathService = (WorkflowPathService) mockFactory.mock(WorkflowPathService.class, workflowPathService);

        Exception actualException;

        //When
        Test.startTest();
        try {
        WorkflowPathController.getPathAssociation(meetingId);
        } catch (Exception e) {
            actualException = e;
        }
        Test.stopTest();

        //Then
        TestUtils.assertNotNull(actualException);
    }

    @IsTest
    static void testPublishPlatformEvent() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);

        Map<String, Object> params = new Map<String, Object>{
                'OCE__Category__c' => 'MeetingStatusChanged',
                'OCE__EntityName__c' => 'Meeting__c',
                'OCE__RecordID__c' => '$value.Id',
                'OCE__Data__c' => '$value.Name'
        };
        TestUtils.Stub serviceStub = stubFactory.stub();

        serviceStub.when('publishPlatformEvent', meetingId, 'Test__e', params)
                .thenReturn(new ActionResult());
        WorkflowPathController.workflowPathActionService = (WorkflowPathActionService) mockFactory.mock(WorkflowPathActionService.class, serviceStub);
        //When
        Test.startTest();
        ActionResult actionResult = WorkflowPathController.publishPlatformEvent(meetingId, 'Test__e', (Object)params);
        Test.stopTest();

        //Then
        System.assert(actionResult.isSuccess);
    }

    @IsTest
    static void testPublishPlatformEventThrowException() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);
        Boolean isExceptionThrown = false;

        Map<String, Object> params = new Map<String, Object>{
                'OCE__Category__c' => 'MeetingStatusChanged',
                'OCE__EntityName__c' => 'Meeting__c',
                'OCE__RecordID__c' => '$value.Id',
                'OCE__Data__c' => '$value.Name'
        };
        TestUtils.Stub serviceStub = stubFactory.stub();

        serviceStub.when('publishPlatformEvent', meetingId, 'Test__e', params)
                .thenReturn(new ActionResult());
        WorkflowPathController.workflowPathActionService = (WorkflowPathActionService) mockFactory.mock(WorkflowPathActionService.class, serviceStub);

        //When
        Test.startTest();
        try {
            WorkflowPathController.publishPlatformEvent(meetingId, 'Test__e', 'params');
        } catch (Exception e){
            isExceptionThrown = true;
        }
        Test.stopTest();

        //Then
        System.assert(isExceptionThrown);
    }
}
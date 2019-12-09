@IsTest
private class WorkflowPathPermissionsHandlerTest {

    static {
        TestUtils.addTriggerHandler(
                WorkflowPathPermissionsHandler.class.getName(),
                Meeting__c.SObjectType.getDescribe().getName()
        );
    }

    @IsTest
    static void testInsertAllowed() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final Integer COUNT_OF_MEETINGS = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(true, false, false)
                );

        //When
        Test.startTest();
        insert testMeetings;
        Test.stopTest();

        //Then
        System.assertEquals(COUNT_OF_MEETINGS, getMeetings().size());
    }


    @IsTest
    static void testInsertNotAllowed() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String ERROR_MESSAGE = String.format(
                Label.Workflows_SObjectCanNotBeCreated,
                new String[]{ Meeting__c.getSObjectType().getDescribe().label }
        );

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(false, false, false)
                );

        //When
        Test.startTest();
        Database.SaveResult[] saveResults = Database.insert(testMeetings, false);
        Test.stopTest();
        //Then
        System.assertEquals(0, getMeetings().size());

        for(Database.SaveResult saveResult: saveResults){
            System.assertEquals(ERROR_MESSAGE, saveResult.getErrors().get(0).getMessage());
        }

    }

    @IsTest
    static void testInsertWithDifferentPermissions() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final Integer COUNT_OF_MEETINGS = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        List<CrudPermissions> crudPermissionsList = new List<CrudPermissions>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);

            CrudPermissions crudPermissions;
            if(i < COUNT_OF_MEETINGS/2){
                crudPermissions = new CrudPermissions(true, false, false);
            }else {
                crudPermissions = new CrudPermissions(false, false, false);
            }
            crudPermissionsList.add(crudPermissions);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(crudPermissionsList)
                );

        //When
        Test.startTest();
        Database.insert(testMeetings, false);
        Test.stopTest();

        //Then
        System.assertEquals(COUNT_OF_MEETINGS/2, getMeetings().size());
    }

    @IsTest
    static void testUpdateAllowed() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String NEW_MEETING_NAME = 'new Name';
        final Integer COUNT_OF_MEETINGS = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            meeting.Name = 'Name';
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(true, true, false)
                );

        insert testMeetings;

        for (Meeting__c meeting: testMeetings) {
            meeting.Name = NEW_MEETING_NAME;
        }

        //When
        Test.startTest();
        update testMeetings;
        Test.stopTest();

        //Then
        List<Meeting__c> meetings = [SELECT Id, Name FROM Meeting__c WHERE Name = :NEW_MEETING_NAME];
        System.assertEquals(COUNT_OF_MEETINGS, meetings.size());
    }


    @IsTest
    static void testUpdateNotAllowed() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String MEETING_NAME = 'Name';
        final Integer COUNT_OF_MEETINGS = 10;
        final String ERROR_MESSAGE = String.format(
                Label.Workflows_SObjectCanNotBeEdited,
                new String[]{ Meeting__c.getSObjectType().getDescribe().label }
        );

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            meeting.Name = MEETING_NAME;
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(true, false, false)
                );

        insert testMeetings;

        for (Meeting__c meeting: testMeetings) {
            meeting.Name = 'new Name';
        }

        //When
        Test.startTest();
        Database.SaveResult[] saveResults = Database.update(testMeetings, false);
        Test.stopTest();

        //Then
        List<Meeting__c> meetings = [SELECT Id, Name FROM Meeting__c WHERE Name = :MEETING_NAME];
        System.assertEquals(COUNT_OF_MEETINGS, meetings.size());

        for(Database.SaveResult saveResult: saveResults){
            System.assertEquals(ERROR_MESSAGE, saveResult.getErrors().get(0).getMessage());
        }
    }

    @IsTest
    static void testUpdateWithDifferentPermissions() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String NEW_MEETING_NAME = 'new Name';
        final Integer COUNT_OF_MEETINGS = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        List<CrudPermissions> crudPermissionsList = new List<CrudPermissions>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            meeting.Name = 'Name';
            testMeetings.add(meeting);

            CrudPermissions crudPermissions;
            if(i < COUNT_OF_MEETINGS/2){
                crudPermissions = new CrudPermissions(true, true, false);
            }else {
                crudPermissions = new CrudPermissions(true, false, false);
            }
            crudPermissionsList.add(crudPermissions);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(crudPermissionsList)
                );

        insert testMeetings;

        for (Meeting__c meeting: testMeetings) {
            meeting.Name = NEW_MEETING_NAME;
        }

        //When
        Test.startTest();
        Database.update(testMeetings, false);
        Test.stopTest();

        //Then
        List<Meeting__c> meetings = [SELECT Id, Name FROM Meeting__c WHERE Name = :NEW_MEETING_NAME];
        System.assertEquals(COUNT_OF_MEETINGS/2, meetings.size());

    }

    @IsTest
    static void testDeleteAllowed() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService = (WorkflowPathService) Test.createStub(WorkflowPathService.class,
                new WorkflowPathServiceStubProvider(true, false, true));

        insert testMeetings;

        //When
        Test.startTest();
        delete testMeetings;
        Test.stopTest();

        //Then
        System.assertEquals(0, getMeetings().size());
    }

    @IsTest
    static void testDeleteNotAllowed() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final Integer COUNT_OF_MEETINGS = 10;
        final String ERROR_MESSAGE = String.format(
                Label.Workflows_SObjectCanNotBeDeleted,
                new String[]{ Meeting__c.getSObjectType().getDescribe().label }
        );
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }
        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(true, false, false)
                );

        insert testMeetings;
        //When
        Test.startTest();
        Database.DeleteResult[] deleteResults = Database.delete(testMeetings, false);
        Test.stopTest();

        //Then
        System.assertEquals(COUNT_OF_MEETINGS, getMeetings().size());

        for(Database.DeleteResult deleteResult: deleteResults){
            System.assertEquals(ERROR_MESSAGE, deleteResult.getErrors().get(0).getMessage());
        }
    }

    @IsTest
    static void testDeleteWithDifferentPermissions() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        Integer COUNT_OF_MEETINGS = 10;
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        List<CrudPermissions> crudPermissionsList = new List<CrudPermissions>();

        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);

            CrudPermissions crudPermissions;
            if(i < COUNT_OF_MEETINGS/2){
                crudPermissions = new CrudPermissions(true, false, true);
            }else {
                crudPermissions = new CrudPermissions(true, false, false);
            }
            crudPermissionsList.add(crudPermissions);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(crudPermissionsList)
                );

        insert testMeetings;

        //When
        Test.startTest();
        Database.delete(testMeetings, false);
        Test.stopTest();

        //Then
        System.assertEquals(COUNT_OF_MEETINGS/2, getMeetings().size());
    }


    @IsTest
    static void testInsertIsNotObjectControlledByWorkflowPath() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final Integer COUNT_OF_MEETINGS = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(false, false, false, false)
                );

        //When
        Test.startTest();
        insert testMeetings;
        Test.stopTest();

        //Then
        System.assertEquals(COUNT_OF_MEETINGS, getMeetings().size());
    }

    @IsTest
    static void testUpdateIsNotObjectControlledByWorkflowPath() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String NEW_MEETING_NAME = 'new Name';
        final Integer COUNT_OF_MEETINGS = 10;

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            meeting.Name = 'Name';
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(false, false, false, false)
                );

        insert testMeetings;

        for (Meeting__c meeting: testMeetings) {
            meeting.Name = NEW_MEETING_NAME;
        }

        //When
        Test.startTest();
        update testMeetings;
        Test.stopTest();

        //Then
        List<Meeting__c> meetings = [SELECT Id, Name FROM Meeting__c WHERE Name = :NEW_MEETING_NAME];
        System.assertEquals(COUNT_OF_MEETINGS, meetings.size());
    }

    @IsTest
    static void testDeleteIsNotObjectControlledByWorkflowPath() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(false, false, false, false)
                );

        insert testMeetings;

        //When
        Test.startTest();
        delete testMeetings;
        Test.stopTest();

        //Then
        System.assertEquals(0, getMeetings().size());
    }

    @IsTest
    static void testInsertRecordWithoutAnyPermissions() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String ERROR_MESSAGE = String.format(
                Label.Workflows_InvalidWorkFlowPathConfiguration,
                new String[]{ Meeting__c.getSObjectType().getDescribe().label }
        );

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < 10; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(new List<CrudPermissions>(), true)
                );

        //When
        Test.startTest();
        Database.SaveResult[] saveResults = Database.insert(testMeetings, false);
        Test.stopTest();
        //Then
        System.assertEquals(0, getMeetings().size());

        for(Database.SaveResult saveResult: saveResults){
            System.assertEquals(ERROR_MESSAGE, saveResult.getErrors().get(0).getMessage());
        }

    }

    @IsTest
    static void testUpdateRecordWithoutAnyPermissions() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final String MEETING_NAME = 'Name';
        final Integer COUNT_OF_MEETINGS = 10;
        final String ERROR_MESSAGE = String.format(
                Label.Workflows_InvalidWorkFlowPathConfiguration,
                new String[]{ Meeting__c.getSObjectType().getDescribe().label }
        );

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            meeting.Name = MEETING_NAME;
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(true, false, false)
                );

        insert testMeetings;

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(new List<CrudPermissions>())
                );

        for (Meeting__c meeting: testMeetings) {
            meeting.Name = 'new Name';
        }

        //When
        Test.startTest();
        Database.SaveResult[] saveResults = Database.update(testMeetings, false);
        Test.stopTest();

        //Then
        List<Meeting__c> meetings = [SELECT Id, Name FROM Meeting__c WHERE Name = :MEETING_NAME];
        System.assertEquals(COUNT_OF_MEETINGS, meetings.size());

        for(Database.SaveResult saveResult: saveResults){
            System.assertEquals(ERROR_MESSAGE, saveResult.getErrors().get(0).getMessage());
        }
    }

    @IsTest
    static void testDeleteRecordWithoutAnyPermissions() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        final Integer COUNT_OF_MEETINGS = 10;
        final String ERROR_MESSAGE = String.format(
                Label.Workflows_InvalidWorkFlowPathConfiguration,
                new String[]{ Meeting__c.getSObjectType().getDescribe().label }
        );

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(true, false, false)
                );

        insert testMeetings;

        WorkflowPathPermissionsHandler.workflowPathService =
                (WorkflowPathService) Test.createStub(
                        WorkflowPathService.class,
                        new WorkflowPathServiceStubProvider(new List<CrudPermissions>())
                );

        //When
        Test.startTest();
        Database.DeleteResult[] deleteResults = Database.delete(testMeetings, false);
        Test.stopTest();

        //Then
        System.assertEquals(COUNT_OF_MEETINGS, getMeetings().size());

        for(Database.DeleteResult deleteResult: deleteResults){
            System.assertEquals(ERROR_MESSAGE, deleteResult.getErrors().get(0).getMessage());
        }
    }

    private static List<Meeting__c> getMeetings() {
        return [SELECT Id,Name FROM Meeting__c];
    }

    public class WorkflowPathServiceStubProvider implements System.StubProvider {

        private Boolean creatable;
        private Boolean editable;
        private Boolean deletable;
        private Boolean isObjectControlledByWorkflowPath;
        private List<CrudPermissions> crudPermissions;

        public WorkflowPathServiceStubProvider(List<CrudPermissions> workflowPathAbilities) {
            this(workflowPathAbilities, true);
        }

        public WorkflowPathServiceStubProvider(List<CrudPermissions> workflowPathAbilities, Boolean isObjectControlledByWorkflowPath) {
            this.crudPermissions = workflowPathAbilities;
            this.isObjectControlledByWorkflowPath = isObjectControlledByWorkflowPath;
        }

        public WorkflowPathServiceStubProvider(Boolean creatable, Boolean editable, Boolean deletable) {
            this(creatable, editable, deletable, true);
        }

        public WorkflowPathServiceStubProvider(Boolean creatable, Boolean editable, Boolean deletable, Boolean isObjectControlledByWorkflowPath) {
            this.creatable = creatable;
            this.editable = editable;
            this.deletable = deletable;
            this.isObjectControlledByWorkflowPath = isObjectControlledByWorkflowPath;
        }

        public Object handleMethodCall(Object stubbedObject,
                String stubbedMethodName,
                System.Type returnType,
                List<System.Type> listOfParamTypes,
                List<String> listOfParamNames,
                List<Object> listOfArgs) {

            if (stubbedMethodName == 'getCrudPermissions') {
                return this.createTestAbilities((Set<Id>) listOfArgs.get(0));
            } else if (stubbedMethodName == 'isObjectControlledByWorkflowPath') {
                return this.isObjectControlledByWorkflowPath;
            }

            return null;
        }

        public Map<Id, CrudPermissions> createTestAbilities(Set<Id> recordIds){
            Map<Id, CrudPermissions> crudPermissionsByRecordIds = new Map<Id, CrudPermissions>();
            if(this.crudPermissions != null) {
                Integer i = 0;
                for (Id recordId : recordIds) {
                    if(this.crudPermissions.size() <= i) {
                        break;
                    }
                    crudPermissionsByRecordIds.put(
                            recordId,
                            this.crudPermissions.get(i)
                    );
                    i++;
                }
            } else {
                for (Id recordId : recordIds) {
                    crudPermissionsByRecordIds.put(
                            recordId,
                            new CrudPermissions(this.creatable, this.editable, this.deletable)
                    );
                }
            }
            return crudPermissionsByRecordIds;
        }

    }
}
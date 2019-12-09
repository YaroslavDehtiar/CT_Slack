@IsTest
private class WorkflowPathAssociationHandlerTest {
    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();
    private static final String STATUS_ACTIVE = 'Active';
    private static final SObjectType MEETING_SOBJECT_TYPE = Schema.Meeting__c.SObjectType;
    private static final String REC_TYPE_NAME_SPEAKER = PackageUtilities.addNamespacePrefixToName('Speaker_Meeting');
    private static final String MEETING_REC_TYPE_NAME_SPEAKER = MEETING_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_SPEAKER;

    static {
        TestUtils.addTriggerHandler(
                WorkflowPathAssociationHandler.class.getName(),
                Meeting__c.SObjectType.getDescribe().getName()
        );
    }
    @IsTest
    static void testInsertAssociations() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }
        final Integer COUNT_OF_MEETINGS = 10;
        //Given
        TestUtils.Stub workflowPathServiceStub = stubFactory.stub();
        List<MeetingWorkFlowConfiguration__mdt> configurations = new List<MeetingWorkFlowConfiguration__mdt>{
                new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_SPEAKER)
        };
        TestUtils.Stub workflowPathStub = stubFactory.stub();
        Set<String> objectRecordTypeCombinations = new Set<String>{
                MEETING_REC_TYPE_NAME_SPEAKER, REC_TYPE_NAME_SPEAKER
        };
        workflowPathStub.when('getActiveByObjectRecordTypeNames', objectRecordTypeCombinations).thenReturn(configurations);
        WorkflowPathAssociationService service = new WorkflowPathAssociationService();
        service.workflowDao =
                (MeetingWorkFlowConfigurationDao)
                        mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathStub);
        WorkflowPathAssociationHandler.service = service;
        workflowPathServiceStub.when('isObjectControlledByWorkflowPath', Meeting__c.SObjectType.getDescribe().getName())
                .thenReturn(true);
        WorkflowPathAssociationHandler.workflowPathService =
                (WorkflowPathService)
                        mockFactory.mock(WorkflowPathService.class, workflowPathServiceStub);

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        //When
        Test.startTest();
        DataLayer.insertAll(testMeetings);
        Test.stopTest();

        //Then
        Map<Id, Meeting__c> meetings = getMeetings();
        List<ObjectWorkflowPathAssociation__c> associations = getObjectRecordTypes();

        String sobjectName = meetings.values()[0].getSObjectType().getDescribe().getName();

        System.assertEquals(COUNT_OF_MEETINGS, meetings.values().size());
        System.assertEquals(COUNT_OF_MEETINGS, associations.size());

        for (ObjectWorkflowPathAssociation__c item : associations) {
            System.assert(meetings.get(Id.valueOf(item.ObjectRecordID__c)) != null);
            System.assert(item.ObjectName__c == sobjectName);
        }
    }

    @IsTest
    static void testInsertAssociationsWhenObjectNotControlledByWorkflowPath() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }
        final Integer COUNT_OF_MEETINGS = 10;
        //Given
        TestUtils.Stub workflowPathServiceStub = stubFactory.stub();
        workflowPathServiceStub.when('isObjectControlledByWorkflowPath', Meeting__c.SObjectType.getDescribe().getName())
                .thenReturn(false);
        WorkflowPathAssociationHandler.workflowPathService =
                (WorkflowPathService)
                        mockFactory.mock(WorkflowPathService.class, workflowPathServiceStub);

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        for (Integer i = 0; i < COUNT_OF_MEETINGS; i++) {
            Meeting__c meeting = TestUtils.createMeeting(false);
            testMeetings.add(meeting);
        }

        //When
        Test.startTest();
        DataLayer.insertAll(testMeetings);
        Test.stopTest();

        //Then
        Map<Id, Meeting__c> meetings = getMeetings();
        List<ObjectWorkflowPathAssociation__c> associations = getObjectRecordTypes();

        System.assertEquals(COUNT_OF_MEETINGS, meetings.values().size());
        System.assertEquals(0, associations.size());
    }


    private static List<ObjectWorkflowPathAssociation__c> getObjectRecordTypes() {
        return [
                SELECT
                        Id
                        , ObjectRecordID__c
                        , ObjectName__c
                FROM ObjectWorkflowPathAssociation__c
        ];
    }

    private static Map<Id, Meeting__c> getMeetings() {
        return new Map<Id, Meeting__c>([
                SELECT
                        Id
                FROM Meeting__c
        ]);
    }
}
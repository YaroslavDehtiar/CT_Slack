@IsTest
private class WorkflowPathsListViewControllerTest {

    private static String PATH_OBJECT_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.getName();
    private static String SPEAKER_MEETING_LABEL = 'Speaker Meeting';
    private static String SPEAKER_MEETING_NAME = 'Speaker_Meeting';
    private static String PATH_CONTROLLING_FIELD_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.ControllingField__c.getName();
    private static String MEETING_STATUS_FIELD_NAME = SObjectType.Meeting__c.fields.Status__c.getName();
    private static String PATH_STATUS_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.Status__c.getName();
    private static String STATUS_ACTIVE = 'Active';
    private static String STATUS_INACTIVE = 'Inactive';
    private static String PATH_RECORD_TYPE_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.MeetingRecordTypeName__c.getName();
    private static String CONTEXT_TYPE_OBJECT_NAME = SObjectType.ContextType__mdt.getName();
    private static SObjectType MEETING_SOBJECT_TYPE = Schema.Meeting__c.SObjectType;
    private static String PATH_RECORD_TYPE_NAME = 'Meeting__c-Speaker_Meeting';

    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();
    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();


    @IsTest
    static void getWorkflowPathsTest() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        List<MeetingWorkFlowConfiguration__mdt> configurations = prepareConfigurations(5);
        WorkflowPathsListViewController.meetingPathDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(
                MeetingWorkFlowConfigurationDao.class,
                stubFactory.stub()
                        .when('getAllWithContextType')
                        .thenReturn(configurations)
        );

        //When
        Test.startTest();
        WorkflowPathsListViewController.WorkflowPaths actualPaths = WorkflowPathsListViewController.getWorkflowPaths();
        Test.stopTest();

        //Then
        System.assertEquals(5, actualPaths.paths.size());
        for (Integer i = 0; i < actualPaths.paths.size(); i++) {
            System.assertEquals(configurations.get(i).Id, actualPaths.paths.get(i).id);
            System.assertEquals(SPEAKER_MEETING_LABEL, actualPaths.paths.get(i).label);
            System.assertEquals(String.valueOf(i), actualPaths.paths.get(i).contextType);
            System.assertEquals('Speaker_Meeting', actualPaths.paths.get(i).recordTypeName);
            System.assertEquals(STATUS_ACTIVE, actualPaths.paths.get(i).activeStatus);
            System.assertEquals('Deployed', actualPaths.paths.get(i).deploymentStatus);
        }
    }

    @IsTest
    static void getWorkflowPathsTestNoConfigurations() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        WorkflowPathsListViewController.meetingPathDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(
                MeetingWorkFlowConfigurationDao.class,
                stubFactory.stub()
                        .when('getAllWithContextType')
                        .thenReturn(new List<MeetingWorkFlowConfiguration__mdt>())
        );

        //When
        Test.startTest();
        WorkflowPathsListViewController.WorkflowPaths actualPaths = WorkflowPathsListViewController.getWorkflowPaths();
        Test.stopTest();

        //Then
        System.assertEquals(0, actualPaths.paths.size());

    }

    @IsTest
    static void getWorkflowPathsTestInactive() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        List<MeetingWorkFlowConfiguration__mdt> configurations = prepareConfigurations(1, STATUS_INACTIVE, 'Speaker_Meeting');
        WorkflowPathsListViewController.meetingPathDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(
                MeetingWorkFlowConfigurationDao.class,
                stubFactory.stub()
                        .when('getAllWithContextType')
                        .thenReturn(configurations)
        );

        //When
        Test.startTest();
        WorkflowPathsListViewController.WorkflowPaths actualPaths = WorkflowPathsListViewController.getWorkflowPaths();
        Test.stopTest();

        //Then
        System.assertEquals(1, actualPaths.paths.size());
        for (Integer i = 0; i < actualPaths.paths.size(); i++) {
            System.assertEquals(configurations.get(i).Id, actualPaths.paths.get(i).id);
            System.assertEquals(SPEAKER_MEETING_LABEL, actualPaths.paths.get(i).label);
            System.assertEquals(String.valueOf(i), actualPaths.paths.get(i).contextType);
            System.assertEquals('Speaker_Meeting', actualPaths.paths.get(i).recordTypeName);
            System.assertEquals(STATUS_INACTIVE, actualPaths.paths.get(i).activeStatus);
        }
    }

    @IsTest
    static void getWorkflowPathsTestException() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) return;

        //Given
        WorkflowPathsListViewController.meetingPathDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(
                MeetingWorkFlowConfigurationDao.class,
                stubFactory.stub()
                        .when('getAllWithContextType')
                        .thenReturn(null)
        );
        Exception actualException;

        //When
        Test.startTest();
        try {
            WorkflowPathsListViewController.WorkflowPaths actualPaths = WorkflowPathsListViewController.getWorkflowPaths();
        } catch (AuraHandledException e) {
            actualException = e;
        }
        Test.stopTest();

        //Then
        TestUtils.assertNotNull(actualException);
    }

    private static List<MeetingWorkFlowConfiguration__mdt> prepareConfigurations(Integer amount) {
        List<MeetingWorkFlowConfiguration__mdt> result = new List<MeetingWorkFlowConfiguration__mdt>();
        for (Integer i = 0; i < amount; i++) {
            result.add((MeetingWorkFlowConfiguration__mdt) JSON.deserialize(
                    getJSONCustomMetadataRecordWithRelationships(String.valueOf(i), STATUS_ACTIVE, PATH_RECORD_TYPE_NAME),
                    MeetingWorkFlowConfiguration__mdt.class
            ));
        }

        return result;
    }

    private static List<MeetingWorkFlowConfiguration__mdt> prepareConfigurations(Integer amount, String status, String recordTypeName) {
        List<MeetingWorkFlowConfiguration__mdt> result = new List<MeetingWorkFlowConfiguration__mdt>();
        for (Integer i = 0; i < amount; i++) {
            result.add((MeetingWorkFlowConfiguration__mdt) JSON.deserialize(
                    getJSONCustomMetadataRecordWithRelationships(String.valueOf(i), status, recordTypeName),
                    MeetingWorkFlowConfiguration__mdt.class
            ));
        }

        return result;
    }

    private static String getJSONCustomMetadataRecordWithRelationships(String contextTypeLabel, String status, String recordTypeName) {
         String contextTypesRelationshipName = PackageUtilities.addNamespacePrefixToObjectField('ContextType__r');
        return JSON.serialize(new Map<String, Object>{
                'attributes' => new Map<String, Object>{
                        'type' => PATH_OBJECT_NAME
                },
                'Id' => IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType),
                'Label' => SPEAKER_MEETING_LABEL,
                'MasterLabel' => SPEAKER_MEETING_LABEL,
                'DeveloperName' => SPEAKER_MEETING_NAME,
                'QualifiedApiName' => SPEAKER_MEETING_NAME,
                PATH_CONTROLLING_FIELD_FIELD_NAME => MEETING_STATUS_FIELD_NAME,
                PATH_STATUS_FIELD_NAME => status,
                PATH_RECORD_TYPE_FIELD_NAME => recordTypeName,
                contextTypesRelationshipName => new Map<String, Object>{
                        'attributes' => new Map<String, Object>{
                                'type' => CONTEXT_TYPE_OBJECT_NAME
                        },
                        'Id' => IdUtils.generate(ContextType__mdt.SObjectType),
                        'QualifiedApiName' => MEETING_SOBJECT_TYPE.getDescribe().getName(),
                        'MasterLabel' => contextTypeLabel
                }
        });
    }
}
@IsTest
private class WorkflowPathTest {

    private static final SObjectType MEETING_SOBJECT_TYPE = Schema.Meeting__c.SObjectType;
    private static final String MEETING_STATUS_FIELD_NAME = SObjectType.Meeting__c.fields.Status__c.getName();

    private static final String PATH_OBJECT_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.getName();
    private static final String PATH_CONTROLLING_FIELD_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.ControllingField__c.getName();
    private static final String PATH_STATUS_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.Status__c.getName();
    private static final String PATH_RECORD_TYPE_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.MeetingRecordTypeName__c.getName();

    private static final String CONTEXT_TYPE_OBJECT_NAME = SObjectType.ContextType__mdt.getName();
    private static final String PATH_NODE_OBJECT_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.getName();
    private static final String PATH_NODE_PATH_REF_FIELD_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.MeetingWorkFlowConfiguration__c.getName();
    private static final String PATH_NODE_CONTROLLING_FIELD_VALUE_FIELD_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.MeetingStatus__c.getName();

    private static final String REC_TYPE_NAME_SPEAKER = 'Speaker_Meeting';

    private static final String MEETING_REC_TYPE_NAME_SPEAKER = MEETING_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_SPEAKER;

    private static final String SPEAKER_MEETING_LABEL = 'Speaker Meeting';
    private static final String SPEAKER_MEETING_NAME = 'Speaker_Meeting';
    private static final String STATUS_ACTIVE = 'Active';

    private static final String STATUS_DRAFT = 'Draft';
    private static final String STATUS_PENDING_APPROVAL = 'PendingApproval';
    private static final String STATUS_APPROVED = 'Approved';


    @IsTest
    static void testCreateWorkflowPathWithoutNodes() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();
        Id configurationId = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType);
        Id contextTypeId = IdUtils.generate(ContextType__mdt.SObjectType);
        MeetingWorkFlowConfiguration__mdt configuration = new MeetingWorkFlowConfiguration__mdt(
                Id = configurationId
                , MasterLabel = SPEAKER_MEETING_LABEL
                , DeveloperName = SPEAKER_MEETING_NAME
                , ControllingField__c = MEETING_STATUS_FIELD_NAME
                , Status__c = STATUS_ACTIVE
                , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_SPEAKER
                , ContextType__c = contextTypeId
        );

        //When
        Test.startTest();
        WorkflowPath workflowPath = new WorkflowPath(configuration);
        Test.stopTest();

        //Then
        System.assertEquals(REC_TYPE_NAME_SPEAKER, workflowPath.getRecordType());
        System.assertEquals(meetingObjectName, workflowPath.getObjectName());
        System.assertEquals(MEETING_STATUS_FIELD_NAME, workflowPath.getControllingField());
        System.assertEquals(SPEAKER_MEETING_LABEL, workflowPath.getLabel());
        System.assertEquals(SPEAKER_MEETING_NAME, workflowPath.getName());
        System.assertEquals(configurationId, workflowPath.getId());
        System.assertEquals(STATUS_ACTIVE, workflowPath.getStatus());
        System.assertEquals(0, workflowPath.getNodes().size());

        System.assert(workflowPath.getObjectRecordType() != null);
        System.assert(workflowPath.getRecordType() != null);
        System.assert(workflowPath.isLegacy());
    }

    @IsTest
    static void testCreateWorkflowPathWithContextType() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();
        String bodyConfig = getJSONCustomMetadataRecordWithRelationships(REC_TYPE_NAME_SPEAKER);
        MeetingWorkFlowConfiguration__mdt configuration = (MeetingWorkFlowConfiguration__mdt) JSON.deserialize(bodyConfig, MeetingWorkFlowConfiguration__mdt.class);

        //When
        Test.startTest();
        WorkflowPath workflowPath = new WorkflowPath(configuration);
        Test.stopTest();

        //Then
        System.assert(workflowPath.isActive());
        System.assertEquals(SPEAKER_MEETING_LABEL, workflowPath.getLabel());
        System.assertEquals(SPEAKER_MEETING_NAME, workflowPath.getName());
        System.assertEquals(MEETING_STATUS_FIELD_NAME, workflowPath.getControllingField());
        System.assertEquals(meetingObjectName, workflowPath.getObjectName());
        System.assertEquals(REC_TYPE_NAME_SPEAKER, workflowPath.getRecordType());
        System.assert(workflowPath.getContextType() != null);
    }

    @IsTest
    static void testCreateWorkflowPathWithWorkflowNodes() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();
        String bodyConfig = getJSONCustomMetadataRecordWithChildren(REC_TYPE_NAME_SPEAKER);
        MeetingWorkFlowConfiguration__mdt configuration = (MeetingWorkFlowConfiguration__mdt) JSON.deserialize(bodyConfig, MeetingWorkFlowConfiguration__mdt.class);

        //When
        Test.startTest();
        WorkflowPath workflowPath = new WorkflowPath(configuration);
        Test.stopTest();

        //Then
        System.assert(workflowPath.isActive());
        System.assertEquals(SPEAKER_MEETING_LABEL, workflowPath.getLabel());
        System.assertEquals(SPEAKER_MEETING_NAME, workflowPath.getName());
        System.assertEquals(MEETING_STATUS_FIELD_NAME, workflowPath.getControllingField());
        System.assertEquals(meetingObjectName, workflowPath.getObjectName());
        System.assertEquals(REC_TYPE_NAME_SPEAKER, workflowPath.getRecordType());
        System.assertEquals(3, workflowPath.getNodes().size());
    }

    @IsTest
    static void testDefaultMeetingStatusControllingField() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();
        String bodyConfig = getJSONCustomMetadataRecordWithChildren(REC_TYPE_NAME_SPEAKER);
        MeetingWorkFlowConfiguration__mdt configuration = (MeetingWorkFlowConfiguration__mdt) JSON.deserialize(bodyConfig, MeetingWorkFlowConfiguration__mdt.class);
        configuration.ControllingField__c = null;

        //When
        Test.startTest();
        WorkflowPath workflowPath = new WorkflowPath(configuration);
        Test.stopTest();

        //Then
        System.assertEquals(MEETING_STATUS_FIELD_NAME, workflowPath.getControllingField());
    }


    private static String getJSONCustomMetadataRecordWithRelationships(String recordType) {
        final String contextTypesRelationshipName = PackageUtilities.addNamespacePrefixToObjectField('ContextType__r');
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
                PATH_STATUS_FIELD_NAME => STATUS_ACTIVE,
                PATH_RECORD_TYPE_FIELD_NAME => recordType,
                contextTypesRelationshipName => new Map<String, Object>{
                        'attributes' => new Map<String, Object>{
                                'type' => CONTEXT_TYPE_OBJECT_NAME
                        },
                        'Id' => IdUtils.generate(ContextType__mdt.SObjectType),
                        'QualifiedApiName' => MEETING_SOBJECT_TYPE.getDescribe().getName()
                }
        });
    }

    private static String getJSONCustomMetadataRecordWithChildren(String recordType) {
        final String nodesRelationshipName = PackageUtilities.addNamespacePrefixToObjectField('MeetingWorkFlowNodeConfigurations__r');
        final Id configId = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType);
        return JSON.serialize(new Map<String, Object>{
                'attributes' => new Map<String, Object>{
                        'type' => PATH_OBJECT_NAME
                },
                'Id' => configId,
                'Label' => SPEAKER_MEETING_LABEL,
                'MasterLabel' => SPEAKER_MEETING_LABEL,
                'DeveloperName' => SPEAKER_MEETING_NAME,
                'QualifiedApiName' => SPEAKER_MEETING_NAME,
                PATH_CONTROLLING_FIELD_FIELD_NAME => MEETING_STATUS_FIELD_NAME,
                PATH_STATUS_FIELD_NAME => STATUS_ACTIVE,
                PATH_RECORD_TYPE_FIELD_NAME => recordType,
                nodesRelationshipName => new Map<String, Object>{
                        'totalSize' => 3,
                        'records' => new List<Map<String, Object>>{
                                new Map<String, Object>{
                                        'attributes' => new Map<String, Object>{
                                                'type' => PATH_NODE_OBJECT_NAME
                                        },
                                        'Id' => IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType),
                                        'Label' => STATUS_DRAFT,
                                        'MasterLabel' => STATUS_DRAFT,
                                        'DeveloperName' => STATUS_DRAFT,
                                        PATH_NODE_PATH_REF_FIELD_NAME => configId,
                                        PATH_NODE_CONTROLLING_FIELD_VALUE_FIELD_NAME => STATUS_DRAFT
                                },
                                new Map<String, Object>{
                                        'attributes' => new Map<String, Object>{
                                                'type' => PATH_NODE_OBJECT_NAME
                                        },
                                        'Id' => IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType),
                                        'Label' => STATUS_PENDING_APPROVAL,
                                        'MasterLabel' => STATUS_PENDING_APPROVAL,
                                        'DeveloperName' => STATUS_PENDING_APPROVAL,
                                        PATH_NODE_PATH_REF_FIELD_NAME => configId,
                                        PATH_NODE_CONTROLLING_FIELD_VALUE_FIELD_NAME => STATUS_PENDING_APPROVAL
                                },
                                new Map<String, Object>{
                                        'attributes' => new Map<String, Object>{
                                                'type' => PATH_NODE_OBJECT_NAME
                                        },
                                        'Id' => IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType),
                                        'Label' => STATUS_APPROVED,
                                        'MasterLabel' => STATUS_APPROVED,
                                        'DeveloperName' => STATUS_APPROVED,
                                        PATH_NODE_PATH_REF_FIELD_NAME => configId,
                                        PATH_NODE_CONTROLLING_FIELD_VALUE_FIELD_NAME => STATUS_APPROVED
                                }

                        }
                }
        });
    }
}
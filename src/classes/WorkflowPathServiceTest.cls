@IsTest
private class WorkflowPathServiceTest {

    private static final String MEETING_OBJECT_NAME = SObjectType.Meeting__c.getName();
    private static final String MEETING_LOCATION_OBJECT_NAME = SObjectType.MeetingLocation__c.getName();
    private static final String MEETING_MEMBER_OBJECT_NAME = SObjectType.MeetingMember__c.getName();


    private static final String PATH_OBJECT_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.getName();
    private static final String PATH_CONTROLLING_FIELD_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.ControllingField__c.getName();
    private static final String PATH_RECORD_TYPE_FIELD_NAME = SObjectType.MeetingWorkFlowConfiguration__mdt.fields.MeetingRecordTypeName__c.getName();

    private static final String SPEAKER_MEETING_LABEL = 'Speaker Meeting';
    private static final String SPEAKER_MEETING_NAME = 'Speaker_Meeting';
    private static final String HCP_SPONSORSHIP_RECORD_TYPE_NAME = 'HCP_Sponsorship';

    private static final String MEETING_STATUS_FIELD_NAME = SObjectType.Meeting__c.fields.Status__c.getName();

    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();

    @IsTest
    static void testNoContextTypeControlled() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        Map<String, ContextType__mdt> contextTypes = new Map<String, ContextType__mdt>();
        Set<String> objectTypes = new Set<String> { MEETING_OBJECT_NAME, MEETING_LOCATION_OBJECT_NAME };

        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getByObjectNames', new Set<String> { MEETING_OBJECT_NAME, MEETING_LOCATION_OBJECT_NAME })
                .thenReturn(contextTypes);

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        // When
        Test.startTest();
        Map<String, Boolean> isControlledIndicatorByObjectName = service.isObjectsControlledByWorkflowPath(objectTypes);
        Test.stopTest();

        // Then
        System.assert(BooleanUtils.negate(isControlledIndicatorByObjectName.get(MEETING_OBJECT_NAME)));
        System.assert(BooleanUtils.negate(isControlledIndicatorByObjectName.get(MEETING_LOCATION_OBJECT_NAME)));
    }

    @IsTest
    static void testIsMeetingControlled() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt meetingContextType = new ContextType__mdt(
                Object__c = MEETING_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        Map<String, ContextType__mdt> contextTypes = new Map<String, ContextType__mdt> {
                MEETING_OBJECT_NAME => meetingContextType
        };

        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub.when('getByObjectNames', new Set<String> { MEETING_OBJECT_NAME }).thenReturn(contextTypes);

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        // When
        Test.startTest();
        Boolean isMeetingControlled = service.isObjectControlledByWorkflowPath(MEETING_OBJECT_NAME);
        Test.stopTest();

        // Then
        System.assert(isMeetingControlled);
    }

    @IsTest
    static void testIsMeetingAndMeetingLocationControlled() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt meetingContextType = new ContextType__mdt(
                Object__c = MEETING_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        ContextType__mdt meetingLocationContextType = new ContextType__mdt(
                Object__c = MEETING_LOCATION_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        Map<String, ContextType__mdt> contextTypes = new Map<String, ContextType__mdt> {
                MEETING_OBJECT_NAME => meetingContextType,
                MEETING_LOCATION_OBJECT_NAME => meetingLocationContextType
        };
        Set<String> objectTypes = new Set<String> { MEETING_OBJECT_NAME, MEETING_LOCATION_OBJECT_NAME };

        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getByObjectNames', new Set<String> { MEETING_OBJECT_NAME, MEETING_LOCATION_OBJECT_NAME })
                .thenReturn(contextTypes);

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        // When
        Test.startTest();
        Map<String, Boolean> isControlledIndicatorByObjectName = service.isObjectsControlledByWorkflowPath(objectTypes);
        Test.stopTest();

        // Then
        System.assert(isControlledIndicatorByObjectName.get(MEETING_OBJECT_NAME));
        System.assert(isControlledIndicatorByObjectName.get(MEETING_LOCATION_OBJECT_NAME));
    }

    @IsTest
    static void testIsMeetingControlledAndMeetingLocationNotControlled() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt meetingContextType = new ContextType__mdt(
                Object__c = MEETING_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        ContextType__mdt meetingLocationContextType = new ContextType__mdt(
                Object__c = MEETING_LOCATION_OBJECT_NAME,
                IsControlledByWorkflowPath__c = false
        );
        Map<String, ContextType__mdt> contextTypes = new Map<String, ContextType__mdt> {
                MEETING_OBJECT_NAME => meetingContextType,
                MEETING_LOCATION_OBJECT_NAME => meetingLocationContextType
        };
        Set<String> objectTypes = new Set<String> { MEETING_OBJECT_NAME, MEETING_LOCATION_OBJECT_NAME };

        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getByObjectNames', new Set<String> { MEETING_OBJECT_NAME, MEETING_LOCATION_OBJECT_NAME })
                .thenReturn(contextTypes);

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        // When
        Test.startTest();
        Map<String, Boolean> isControlledIndicatorByObjectName = service.isObjectsControlledByWorkflowPath(objectTypes);
        Test.stopTest();

        // Then
        System.assert(isControlledIndicatorByObjectName.get(MEETING_OBJECT_NAME));
        System.assert(BooleanUtils.negate(isControlledIndicatorByObjectName.get(MEETING_LOCATION_OBJECT_NAME)));
    }

    @IsTest
    static void testPathsAssociatedWithMeetingsWithTheSamePath() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt meetingContextType = new ContextType__mdt(
                Id = IdUtils.generate(ContextType__mdt.getSObjectType()),
                Object__c = MEETING_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        MeetingWorkFlowConfiguration__mdt mdtPath = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.getSObjectType()),
                ContextType__c = meetingContextType.Id,
                ContextType__r = meetingContextType,
                MeetingRecordTypeName__c = SPEAKER_MEETING_NAME,
                ControllingField__c = MEETING_STATUS_FIELD_NAME
        );
        List<MeetingWorkFlowConfiguration__mdt> mdtPaths = new List<MeetingWorkFlowConfiguration__mdt> { mdtPath };
        Meeting__c localMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType())
        );
        Meeting__c remoteMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType())
        );
        Set<Id> meetingIds = new Set<Id> { localMeeting.Id, remoteMeeting.Id };
        List<ObjectWorkflowPathAssociation__c> objectWorkflowPathAssociations = new List<ObjectWorkflowPathAssociation__c> {
                new ObjectWorkflowPathAssociation__c( ObjectRecordID__c = localMeeting.Id, WorkflowPathId__c = mdtPath.Id ),
                new ObjectWorkflowPathAssociation__c( ObjectRecordID__c = remoteMeeting.Id, WorkflowPathId__c = mdtPath.Id )
        };

        TestUtils.Stub objectWorkflowPathAssociationDaoStub = stubFactory.stub();
        objectWorkflowPathAssociationDaoStub
                .when('getByObjectRecordIds', meetingIds)
                .thenReturn(objectWorkflowPathAssociations);

        TestUtils.Stub workflowDaoStub = stubFactory.stub();
        workflowDaoStub
                .when('getWithContextTypeAndNodesByIds', new Set<Id> { mdtPath.Id })
                .thenReturn(mdtPaths);


        WorkflowPathService service = new WorkflowPathService();
        service.associationDao = (ObjectWorkflowPathAssociationDao) mockFactory.mock(ObjectWorkflowPathAssociationDao.class, objectWorkflowPathAssociationDaoStub);
        service.workflowDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowDaoStub);

        // When
        Test.startTest();
        Map<Id, WorkflowPath> workflowPathsByRecordIds = service.getPathsByRecordIds(meetingIds);
        Test.stopTest();

        // Then
        System.assertEquals(2, workflowPathsByRecordIds.size());
        System.assertNotEquals(null, workflowPathsByRecordIds.get(localMeeting.Id));
        System.assertNotEquals(null, workflowPathsByRecordIds.get(remoteMeeting.Id));
        System.assertEquals(mdtPath.Id, workflowPathsByRecordIds.get(localMeeting.Id).getId());
        System.assertEquals(mdtPath.Id, workflowPathsByRecordIds.get(remoteMeeting.Id).getId());
    }

    @IsTest
    static void testPathsAssociatedWithMeetingsWithDifferentPaths() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt meetingContextType = new ContextType__mdt(
                Id = IdUtils.generate(ContextType__mdt.getSObjectType()),
                Object__c = MEETING_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        MeetingWorkFlowConfiguration__mdt mdtSpeakerMeetingPath = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.getSObjectType()),
                ContextType__c = meetingContextType.Id,
                ContextType__r = meetingContextType,
                MeetingRecordTypeName__c = SPEAKER_MEETING_NAME,
                ControllingField__c = MEETING_STATUS_FIELD_NAME
        );
        MeetingWorkFlowConfiguration__mdt mdtHcpSponsorshipPath = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.getSObjectType()),
                ContextType__c = meetingContextType.Id,
                ContextType__r = meetingContextType,
                MeetingRecordTypeName__c = HCP_SPONSORSHIP_RECORD_TYPE_NAME,
                ControllingField__c = MEETING_STATUS_FIELD_NAME
        );
        List<MeetingWorkFlowConfiguration__mdt> mdtPaths = new List<MeetingWorkFlowConfiguration__mdt> { mdtSpeakerMeetingPath, mdtHcpSponsorshipPath };
        Meeting__c speakerMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType())
        );
        Meeting__c hcpSponsorshipMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType())
        );
        Set<Id> meetingIds = new Set<Id> { speakerMeeting.Id, hcpSponsorshipMeeting.Id };
        List<ObjectWorkflowPathAssociation__c> objectWorkflowPathAssociations = new List<ObjectWorkflowPathAssociation__c> {
                new ObjectWorkflowPathAssociation__c( ObjectRecordID__c = speakerMeeting.Id, WorkflowPathId__c = mdtSpeakerMeetingPath.Id ),
                new ObjectWorkflowPathAssociation__c( ObjectRecordID__c = hcpSponsorshipMeeting.Id, WorkflowPathId__c = mdtHcpSponsorshipPath.Id )
        };

        TestUtils.Stub objectWorkflowPathAssociationDaoStub = stubFactory.stub();
        objectWorkflowPathAssociationDaoStub
                .when('getByObjectRecordIds', meetingIds)
                .thenReturn(objectWorkflowPathAssociations);

        TestUtils.Stub workflowDaoStub = stubFactory.stub();
        workflowDaoStub
                .when('getWithContextTypeAndNodesByIds', new Set<Id> { mdtSpeakerMeetingPath.Id, mdtHcpSponsorshipPath.Id })
                .thenReturn(mdtPaths);


        WorkflowPathService service = new WorkflowPathService();
        service.associationDao = (ObjectWorkflowPathAssociationDao) mockFactory.mock(ObjectWorkflowPathAssociationDao.class, objectWorkflowPathAssociationDaoStub);
        service.workflowDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowDaoStub);

        // When
        Test.startTest();
        Map<Id, WorkflowPath> workflowPathsByRecordIds = service.getPathsByRecordIds(meetingIds);
        Test.stopTest();

        // Then
        System.assertEquals(2, workflowPathsByRecordIds.size());
        System.assertNotEquals(null, workflowPathsByRecordIds.get(speakerMeeting.Id));
        System.assertNotEquals(null, workflowPathsByRecordIds.get(hcpSponsorshipMeeting.Id));
        System.assertEquals(mdtSpeakerMeetingPath.Id, workflowPathsByRecordIds.get(speakerMeeting.Id).getId());
        System.assertEquals(mdtHcpSponsorshipPath.Id, workflowPathsByRecordIds.get(hcpSponsorshipMeeting.Id).getId());
    }

    @IsTest
    static void testLegacyMeetingsCrudPermissions() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt meetingContextType = new ContextType__mdt(
                Object__c = MEETING_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );
        Map<String, ContextType__mdt> contextTypes = new Map<String, ContextType__mdt> {
                MEETING_OBJECT_NAME => meetingContextType
        };

        MeetingWorkFlowNodeConfiguration__mdt draftNode = new MeetingWorkFlowNodeConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.getSObjectType()),
                MeetingStatus__c = 'Draft',
                EditMeeting__c = true,
                DeleteMeeting__c = true
        );
        MeetingWorkFlowNodeConfiguration__mdt pendingApprovalNode = new MeetingWorkFlowNodeConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.getSObjectType()),
                MeetingStatus__c = 'PendingApproval',
                EditMeeting__c = false,
                DeleteMeeting__c = false
        );
        List<MeetingWorkFlowNodeConfiguration__mdt> mdtNodes = new List<MeetingWorkFlowNodeConfiguration__mdt> {
                draftNode, pendingApprovalNode
        };
        Map<String, Object> workflowPathValueByFieldNames = new Map<String, Object> {
                'attributes' => new Map<String, Object>{
                        'type' => PATH_OBJECT_NAME
                },
                'Label' => SPEAKER_MEETING_LABEL,
                'MasterLabel' => SPEAKER_MEETING_LABEL,
                'DeveloperName' => SPEAKER_MEETING_NAME,
                'QualifiedApiName' => SPEAKER_MEETING_NAME,
                'Id' => IdUtils.generate(MeetingWorkFlowConfiguration__mdt.getSObjectType()),
                PATH_RECORD_TYPE_FIELD_NAME => SPEAKER_MEETING_NAME,
                PATH_CONTROLLING_FIELD_FIELD_NAME => MEETING_STATUS_FIELD_NAME,
                PackageUtilities.addNamespacePrefixToObjectField('MeetingWorkFlowNodeConfigurations__r') => new Map<String, Object> {
                        'totalSize' => 3,
                        'records' => mdtNodes
                }
        };
        MeetingWorkFlowConfiguration__mdt mdtPath = createWorkflowPath(workflowPathValueByFieldNames);
        List<MeetingWorkFlowConfiguration__mdt> mdtPaths = new List<MeetingWorkFlowConfiguration__mdt> { mdtPath };
        Meeting__c localMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType()),
                Status__c = 'Draft'
        );
        Meeting__c remoteMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType()),
                Status__c = 'PendingApproval'
        );
        Set<Id> meetingIds = new Set<Id> { localMeeting.Id, remoteMeeting.Id };
        List<Meeting__c> meetings = new List<Meeting__c> { localMeeting, remoteMeeting };
        List<ObjectWorkflowPathAssociation__c> objectWorkflowPathAssociations = new List<ObjectWorkflowPathAssociation__c> {
                new ObjectWorkflowPathAssociation__c( ObjectRecordID__c = localMeeting.Id, WorkflowPathId__c = mdtPath.Id ),
                new ObjectWorkflowPathAssociation__c( ObjectRecordID__c = remoteMeeting.Id, WorkflowPathId__c = mdtPath.Id )
        };

        TestUtils.Stub objectWorkflowPathAssociationDaoStub = stubFactory.stub()
                .when('getByObjectRecordIds', meetingIds)
                .thenReturn(objectWorkflowPathAssociations);
        TestUtils.Stub workflowDaoStub = stubFactory.stub()
                .when('getWithContextTypeAndNodesByIds', new Set<Id>())
                .thenReturn(new List<MeetingWorkFlowConfiguration__mdt>());
        TestUtils.Stub contextTypeDaoStub = stubFactory.stub()
                .when('getByObjectNames', new Set<String> { MEETING_OBJECT_NAME })
                .thenReturn(new Map<String, ContextType__mdt> { MEETING_OBJECT_NAME => meetingContextType });
        Map<String, List<Id>> recordIdsByObjectNames = new Map<String, List<Id>> {
                MEETING_OBJECT_NAME => new List<Id> { localMeeting.Id, remoteMeeting.Id }
        };
        Map<String, Set<String>> controllingFieldsByObjectNames = new Map<String, Set<String>> {
                MEETING_OBJECT_NAME => new Set<String> { MEETING_STATUS_FIELD_NAME }
        };
        TestUtils.Stub sobjectDaoStub = stubFactory.stub()
                .when('getByObjectNameToIdsMap', recordIdsByObjectNames, controllingFieldsByObjectNames)
                .thenReturn(meetings);

        CrudPermissions grantedPermissions = CrudPermissions.all();
        CrudPermissions strictPermissions = new CrudPermissions(false, false, false);
        Map<Id, CrudPermissions> meetingCrudPermissionsByIds = new Map<Id, CrudPermissions> {
                localMeeting.Id => grantedPermissions,
                remoteMeeting.Id => strictPermissions
        };
        Map<Id, WorkflowPath> pathsByIds = new Map<Id, WorkflowPath> {
                mdtPath.Id => new WorkflowPath(mdtPath)
        };
        TestUtils.Stub workflowPathAdapterStub = stubFactory.stub()
                .when('getPathsByIds', new Set<Id>{ mdtPath.Id })
                .thenReturn(pathsByIds)

                .when('getActionsByPathNodeIds', new Set<Id> { draftNode.Id, pendingApprovalNode.Id })
                .thenReturn(new Map<Id, List<Action>> {
                        draftNode.Id => new List<Action>(),
                        pendingApprovalNode.Id => new List<Action>()
                })

                .when('getCrudPermissionsByRecordIds', meetingIds)
                .thenReturn(meetingCrudPermissionsByIds);

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);
        service.associationDao = (ObjectWorkflowPathAssociationDao) mockFactory.mock(ObjectWorkflowPathAssociationDao.class, objectWorkflowPathAssociationDaoStub);
        service.workflowDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowDaoStub);
        service.sobjectDao = (SObjectDao) mockFactory.mock(SObjectDao.class, sobjectDaoStub);
        service.workflowPathAdapter = (WorkflowPathMeetingAdapter) mockFactory.mock(WorkflowPathMeetingAdapter.class, workflowPathAdapterStub);

        // When
        Test.startTest();
        Map<Id, CrudPermissions> crudPermissionsByMeetingIds = service.getCrudPermissions(meetingIds);
        Test.stopTest();

        CrudPermissions localMeetingPermissions = crudPermissionsByMeetingIds.get(localMeeting.Id);
        CrudPermissions remoteMeetingPermissions = crudPermissionsByMeetingIds.get(remoteMeeting.Id);

        System.assertNotEquals(null, localMeetingPermissions);
        System.assertNotEquals(null, remoteMeetingPermissions);
        System.assertEquals(grantedPermissions, localMeetingPermissions);
        System.assertEquals(strictPermissions, remoteMeetingPermissions);
    }

    @IsTest
    static void testLegacyMeetingsCrudPermissionsForPrototype() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt contextType = new ContextType__mdt(
                Object__c = MEETING_MEMBER_OBJECT_NAME,
                IsControlledByWorkflowPath__c = true
        );

        Meeting__c localMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType()),
                Status__c = 'Draft'
        );
        Meeting__c remoteMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType()),
                Status__c = 'PendingApproval'
        );
        MeetingMember__c localSpeaker = TestUtils.createMeetingSpeaker('test', localMeeting.Id, false);
        MeetingMember__c remoteSpeaker = TestUtils.createMeetingSpeaker('test', remoteMeeting.Id, false);
        WorkflowObjectPrototype localPrototype = new WorkflowObjectPrototype(localSpeaker, 'Speaker', localMeeting.Id);
        WorkflowObjectPrototype remotePrototype = new WorkflowObjectPrototype(remoteSpeaker, 'Speaker', remoteMeeting.Id);
        List<WorkflowObjectPrototype> prototypes = new List<WorkflowObjectPrototype> {
                localPrototype, remotePrototype
        };

        TestUtils.Stub contextTypeDaoStub = stubFactory.stub()
                .when('getByObjectNames', new Set<String> { MEETING_MEMBER_OBJECT_NAME })
                .thenReturn(new Map<String, ContextType__mdt> { MEETING_MEMBER_OBJECT_NAME => contextType
                });


        CrudPermissions grantedPermissions = CrudPermissions.all();
        CrudPermissions strictPermissions = new CrudPermissions(false, false, false);
        Map<WorkflowObjectPrototype, CrudPermissions> meetingMemberCrudPermissionsByPrototypes = new Map<WorkflowObjectPrototype, CrudPermissions> {
                localPrototype => grantedPermissions,
                remotePrototype => strictPermissions
        };

        TestUtils.Stub workflowPathAdapterStub = stubFactory.stub()
                .when('getCrudPermissionsByPrototypes', prototypes)
                .thenReturn(meetingMemberCrudPermissionsByPrototypes);

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);
        service.workflowPathAdapter = (WorkflowPathMeetingAdapter) mockFactory.mock(WorkflowPathMeetingAdapter.class, workflowPathAdapterStub);

        // When
        Test.startTest();
        Map<WorkflowObjectPrototype, CrudPermissions> crudPermissionsByMeetingIds = service.getCrudPermissions(prototypes);
        Test.stopTest();

        CrudPermissions localMeetingPermissions = crudPermissionsByMeetingIds.get(localPrototype);
        CrudPermissions remoteMeetingPermissions = crudPermissionsByMeetingIds.get(remotePrototype);

        System.assertNotEquals(null, localMeetingPermissions);
        System.assertNotEquals(null, remoteMeetingPermissions);
        System.assertEquals(grantedPermissions, localMeetingPermissions);
        System.assertEquals(strictPermissions, remoteMeetingPermissions);
    }

    @IsTest
    static void testLegacyMeetingsCrudPermissionsForPrototypeNotControlled() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        ContextType__mdt contextType = new ContextType__mdt(
                Object__c = MEETING_MEMBER_OBJECT_NAME,
                IsControlledByWorkflowPath__c = false
        );

        Meeting__c localMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType()),
                Status__c = 'Draft'
        );
        Meeting__c remoteMeeting = new Meeting__c(
                Id = IdUtils.generate(Meeting__c.getSObjectType()),
                Status__c = 'PendingApproval'
        );
        MeetingMember__c localSpeaker = TestUtils.createMeetingSpeaker('test', localMeeting.Id, false);
        MeetingMember__c remoteSpeaker = TestUtils.createMeetingSpeaker('test', remoteMeeting.Id, false);
        WorkflowObjectPrototype localPrototype = new WorkflowObjectPrototype(localSpeaker, 'Speaker', localMeeting.Id);
        WorkflowObjectPrototype remotePrototype = new WorkflowObjectPrototype(remoteSpeaker, 'Speaker', remoteMeeting.Id);
        List<WorkflowObjectPrototype> prototypes = new List<WorkflowObjectPrototype> {
                localPrototype, remotePrototype
        };

        TestUtils.Stub contextTypeDaoStub = stubFactory.stub()
                .when('getByObjectNames', new Set<String> { MEETING_MEMBER_OBJECT_NAME })
                .thenReturn(
                        new Map<String, ContextType__mdt> { MEETING_MEMBER_OBJECT_NAME => contextType}
                );


        TestUtils.Stub workflowPathAdapterStub = stubFactory.stub()
                .when('getCrudPermissionsByPrototypes', new List<WorkflowObjectPrototype>())
                .thenReturn(new Map<WorkflowObjectPrototype, CrudPermissions>());

        WorkflowPathService service = new WorkflowPathService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);
        service.workflowPathAdapter = (WorkflowPathMeetingAdapter) mockFactory.mock(WorkflowPathMeetingAdapter.class, workflowPathAdapterStub);

        // When
        Test.startTest();
        Map<WorkflowObjectPrototype, CrudPermissions> crudPermissionsByMeetingIds = service.getCrudPermissions(prototypes);
        Test.stopTest();

        CrudPermissions localMeetingPermissions = crudPermissionsByMeetingIds.get(localPrototype);
        CrudPermissions remoteMeetingPermissions = crudPermissionsByMeetingIds.get(remotePrototype);

        System.assertNotEquals(null, localMeetingPermissions);
        System.assertNotEquals(null, remoteMeetingPermissions);
        System.assertEquals(CrudPermissions.all(), localMeetingPermissions);
        System.assertEquals(CrudPermissions.all(), remoteMeetingPermissions);
    }

    private static MeetingWorkFlowConfiguration__mdt createWorkflowPath(Map<String, Object> workflowPathValueByFieldNames) {
        return (MeetingWorkFlowConfiguration__mdt) JSON.deserialize(JSON.serialize(workflowPathValueByFieldNames), MeetingWorkFlowConfiguration__mdt.class);
    }

    @IsTest
    static void testTranslateActionList() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        CustomLabelResolverService.receiver = new TestContentReceiver(new List<String> {
                'Add', 'Cancel'
        });
        List<Action> actions = new List<Action>{
                new Action(IdUtils.generate(Action__mdt.SObjectType), 'Add__c', 'Add__c', 'AddBtn'),
                new Action(IdUtils.generate(Action__mdt.SObjectType), 'Cancel__c', 'Cancel__c', 'CancelBtn')
        };

        //When
        Test.startTest();
        WorkflowPathService.translateActionLabels(actions);
        Test.stopTest();

        // Then
        System.assertEquals('Add', actions[0].getLabel());
        System.assertEquals('Cancel', actions[1].getLabel());
    }

    @IsTest
    static void testTranslateActionMap() {
        // check test level
        if (TestConfigurationDao.isNotLowScope()) { return; }

        //Given
        CustomLabelResolverService.receiver = new TestContentReceiver(new List<String> {
                'Add', 'Cancel'
        });
        Id nodeId = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType);
        Map<Id, List<Action>> actionsByNodes = new Map<Id, List<Action>>{
                nodeId =>
                        new List<Action>{
                                new Action(IdUtils.generate(Action__mdt.SObjectType), 'Add__c', 'Add__c', 'AddBtn'),
                                new Action(IdUtils.generate(Action__mdt.SObjectType), 'Cancel__c', 'Cancel__c', 'CancelBtn')
                        }
        };

        //When
        Test.startTest();
        WorkflowPathService.translateActionLabels(actionsByNodes);
        Test.stopTest();

        // Then
        System.assertEquals('Add', actionsByNodes.get(nodeId)[0].getLabel());
        System.assertEquals('Cancel', actionsByNodes.get(nodeId)[1].getLabel());
    }

    private class TestContentReceiver extends CustomLabelResolverService.VisualforceContentReceiver {

        private List<String> labelNames = new List<String>();

        private TestContentReceiver(List<String> labelNames) {
            this.labelNames = labelNames;
        }

        protected override String getPageAsString(List<String> labelNames) {
            return 'customlabelentrypoint[' + String.join(this.labelNames, '___') + ']customlabelexitpoint';
        }

    }

}
@IsTest
private class WorkflowPathMeetingAdapterTest {

    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();

    private static final String ADD_SPEAKER_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddSpeaker__c.getName();
    private static final String EDIT_SPEAKER_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditSpeaker__c.getName();
    private static final String DELETE_SPEAKER_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteSpeaker__c.getName();

    private static final String ADD_ACT_EXPENSE_ALLOC_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddActualExpenseAllocation__c.getName();
    private static final String EDIT_ACT_EXPENSE_ALLOC_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditActualExpenseAllocation__c.getName();
    private static final String DELETE_ACT_EXPENSE_ALLOC_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteActualExpenseAllocation__c.getName();

    private static final String EDIT_MEETING_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditMeeting__c.getName();
    private static final String DELETE_MEETING_PERM_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteMeeting__c.getName();


    @IsTest
    static void testGetActionsByPathNodeIds() {

        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }
        // Given

        Id nextWorkflowNodeApprovedId = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType);
        Id nextWorkflowNodeRejectedId = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType);
        Id workflowNodeId = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType);
        Id lastWorkflowNodeId = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType);
        MeetingWorkFlowNodeConfiguration__mdt nextWorkflowNodeApproved = new MeetingWorkFlowNodeConfiguration__mdt(MeetingStatus__c = 'Approved');
        MeetingWorkFlowNodeConfiguration__mdt nextWorkflowNodeRejected = new MeetingWorkFlowNodeConfiguration__mdt(MeetingStatus__c = 'Rejected');
        MeetingWorkFlowNodeConfiguration__mdt workflowNode = new MeetingWorkFlowNodeConfiguration__mdt(MeetingStatus__c = 'Draft');
        MeetingWorkFlowNodeConfiguration__mdt closedWorkflowNode = new MeetingWorkFlowNodeConfiguration__mdt(MeetingStatus__c = 'Closed');
        MeetingWorkFlowActionConfiguration__mdt workFlowApproveActionConfiguration = new MeetingWorkFlowActionConfiguration__mdt(
                MasterLabel = 'TestLabel_1',
                NextWorkFlowNode__r = nextWorkflowNodeApproved,
                NextWorkFlowNode__c = nextWorkflowNodeApprovedId,
                MeetingWorkFlowNode__c = workflowNodeId
        );
        MeetingWorkFlowActionConfiguration__mdt workFlowRejectActionConfiguration = new MeetingWorkFlowActionConfiguration__mdt(
                MasterLabel = 'TestLabel_1',
                NextWorkFlowNode__r = nextWorkflowNodeRejected,
                NextWorkFlowNode__c = nextWorkflowNodeRejectedId,
                MeetingWorkFlowNode__c = workflowNodeId
        );
        MeetingWorkFlowActionConfiguration__mdt finishingActionConfiguration = new MeetingWorkFlowActionConfiguration__mdt(
                MasterLabel = 'TestLabel_2',
                NextWorkFlowNode__r = closedWorkflowNode,
                NextWorkFlowNode__c = lastWorkflowNodeId,
                MeetingWorkFlowNode__c = nextWorkflowNodeApprovedId
        );

        TestUtils.Stub actionsDaoStub = stubFactory.stub();
        actionsDaoStub.when('getWithNextNodeByCurrentNodeIds', new Set<Id>{
                workflowNodeId, nextWorkflowNodeApprovedId
        }).thenReturn(new List<MeetingWorkFlowActionConfiguration__mdt>{
                workFlowApproveActionConfiguration, workFlowRejectActionConfiguration, finishingActionConfiguration
        });
        WorkflowPathMeetingAdapter workflowPathMeetingAdapter = new WorkflowPathMeetingAdapter();
        workflowPathMeetingAdapter.actionsDao = (MeetingWorkFlowActionConfigurationDao) mockFactory.mock(MeetingWorkFlowActionConfigurationDao.class, actionsDaoStub);

        // When
        Test.startTest();

        Map<Id, List<Action>> actionsByNode = workflowPathMeetingAdapter.getActionsByPathNodeIds(new Set<Id>{
                workflowNodeId, nextWorkflowNodeApprovedId
        });
        Test.stopTest();

        // Then
        System.assertEquals(2, actionsByNode.keySet().size());
        System.assertEquals(2, actionsByNode.get(workflowNodeId).size());
        System.assertEquals(1, actionsByNode.get(nextWorkflowNodeApprovedId).size());
        System.assertEquals('Closed', ((RecordUpdateAction) actionsByNode.get(nextWorkflowNodeApprovedId).get(0)).getNewValue());

    }


    @IsTest
    static void testGetCrudPermissionsByMeetingAndMembersRecordIds() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }
        //Given

        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);
        Id meetingMemberId = IdUtils.generate(MeetingMember__c.SObjectType);

        RecordType speakerRecordType = RecordTypeUtils.getRecordTypeByDeveloperName(SObjectType.MeetingMember__c.getName(), 'Speaker');
        MeetingMember__c meetingMember = new MeetingMember__c(
                Id = meetingMemberId,
                Meeting__c = meetingId,
                RecordType = speakerRecordType,
                RecordTypeId = speakerRecordType.Id
        );

        Set<String> actionNames = new Set<String>{
                EDIT_SPEAKER_PERM_NAME,
                EDIT_MEETING_PERM_NAME,
                DELETE_SPEAKER_PERM_NAME,
                DELETE_MEETING_PERM_NAME,
                ADD_SPEAKER_PERM_NAME
        };
        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds = new Map<String, Map<String, Boolean>>{
                String.valueOf(meetingId) => new Map<String, Boolean>{
                        ADD_SPEAKER_PERM_NAME => false,
                        DELETE_MEETING_PERM_NAME => false,
                        DELETE_SPEAKER_PERM_NAME => false,
                        EDIT_MEETING_PERM_NAME => false,
                        EDIT_SPEAKER_PERM_NAME => false
                }
        };

        TestUtils.Stub workflowService = stubFactory.stub();
        TestUtils.Stub sObjectDao = stubFactory.stub();

        sObjectDao.when('getByObjectNameToIdsMap', new Map<String, List<Id>>{
                String.valueOf(MeetingMember__c.SObjectType) => new List<Id>{
                        meetingMemberId
                }
        }, new Map<String, Set<String>>{
                String.valueOf(MeetingMember__c.SObjectType) => new Set<String>{
                        String.valueOf(Meeting__c.SObjectType), 'RecordType.DeveloperName'
                }
        }
        ).thenReturn(new List<MeetingMember__c>{
                meetingMember
        });
        workflowService.when('getMeetingsActionsAvailability', new List<Id>{
                meetingId
        }, UserInfo.getUserId(), actionNames).thenReturn(actionPermissionsByMeetingIds);

        WorkflowPathMeetingAdapter workflowPathMeetingAdapter = new WorkflowPathMeetingAdapter();
        workflowPathMeetingAdapter.meetingWorkflowService = (MeetingWorkFlowService) mockFactory.mock(MeetingWorkFlowService.class, workflowService);
        workflowPathMeetingAdapter.sObjectDao = (SObjectDao) mockFactory.mock(SObjectDao.class, sObjectDao);


        //When
        Test.startTest();
        Map<Id, CrudPermissions> crudPermissionsByIds = workflowPathMeetingAdapter.getCrudPermissionsByRecordIds(new Set<Id>{
                meetingId, meetingMemberId
        });
        Test.stopTest();

        //Then
        CrudPermissions meetingPermissions = crudPermissionsByIds.get(meetingId);
        CrudPermissions meetingMemberPermissions = crudPermissionsByIds.get(meetingMemberId);
        System.assert(meetingPermissions != null);
        System.assert(meetingPermissions.isCreatable());
        System.assert(meetingPermissions.isNotDeletable());
        System.assert(meetingPermissions.isNotEditable());
        System.assert(meetingPermissions.isReadable());

        System.assert(meetingMemberPermissions != null);
        System.assert(meetingMemberPermissions.isNotCreatable());
        System.assert(meetingMemberPermissions.isNotDeletable());
        System.assert(meetingMemberPermissions.isNotEditable());
        System.assert(meetingMemberPermissions.isReadable());
    }

    @IsTest
    static void testGetCrudPermissionsByMMRecordIds() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }
        //Given

        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);
        Id meetingMemberId = IdUtils.generate(MeetingMember__c.SObjectType);

        RecordType speakerRecordType = RecordTypeUtils.getRecordTypeByDeveloperName(SObjectType.MeetingMember__c.getName(), 'Speaker');
        MeetingMember__c meetingMember = new MeetingMember__c(
                Id = meetingMemberId,
                Meeting__c = meetingId,
                RecordType = speakerRecordType,
                RecordTypeId = speakerRecordType.Id
        );

        Set<String> actionNames = new Set<String>{
                EDIT_SPEAKER_PERM_NAME,
                DELETE_SPEAKER_PERM_NAME,
                ADD_SPEAKER_PERM_NAME
        };
        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds = new Map<String, Map<String, Boolean>>{
                String.valueOf(meetingId) => new Map<String, Boolean>{
                        ADD_SPEAKER_PERM_NAME => false,
                        DELETE_SPEAKER_PERM_NAME => false,
                        EDIT_SPEAKER_PERM_NAME => false
                }
        };

        TestUtils.Stub workflowService = stubFactory.stub();
        TestUtils.Stub sObjectDao = stubFactory.stub();

        sObjectDao.when('getByObjectNameToIdsMap', new Map<String, List<Id>>{
                String.valueOf(MeetingMember__c.SObjectType) => new List<Id>{
                        meetingMemberId
                }
        }, new Map<String, Set<String>>{
                String.valueOf(MeetingMember__c.SObjectType) => new Set<String>{
                        String.valueOf(Meeting__c.SObjectType), 'RecordType.DeveloperName'
                }
        }
        ).thenReturn(new List<MeetingMember__c>{
                meetingMember
        });
        workflowService.when('getMeetingsActionsAvailability', new List<Id>{
                meetingId
        }, UserInfo.getUserId(), actionNames).thenReturn(actionPermissionsByMeetingIds);

        WorkflowPathMeetingAdapter workflowPathMeetingAdapter = new WorkflowPathMeetingAdapter();
        workflowPathMeetingAdapter.meetingWorkflowService = (MeetingWorkFlowService) mockFactory.mock(MeetingWorkFlowService.class, workflowService);
        workflowPathMeetingAdapter.sObjectDao = (SObjectDao) mockFactory.mock(SObjectDao.class, sObjectDao);


        //When
        Test.startTest();
        Map<Id, CrudPermissions> crudPermissionsByIds = workflowPathMeetingAdapter.getCrudPermissionsByRecordIds(new Set<Id>{
                meetingMemberId
        });
        Test.stopTest();

        //Then
        CrudPermissions meetingMemberPermissions = crudPermissionsByIds.get(meetingMemberId);

        System.assert(meetingMemberPermissions != null);
        System.assert(meetingMemberPermissions.isNotCreatable());
        System.assert(meetingMemberPermissions.isNotDeletable());
        System.assert(meetingMemberPermissions.isNotEditable());
        System.assert(meetingMemberPermissions.isReadable());
    }

    @IsTest
    static void testGetCrudPermissionsByAllocationRecordIds() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);
        MeetingMember__c meetingMember = TestUtils.createMeetingMember('Member', meeting.Id, true);
        MeetingExpense__c meetingExpense = TestUtils.createMeetingExpense(true, 'Actual', meeting.Id);
        MeetingExpenseAllocation__c meetingExpenseAllocation = TestUtils.createMeetingExpenseAllocation(true, meetingExpense.Id, meetingMember.Id);
        meetingExpenseAllocation = [
                SELECT Id, MeetingExpense__c, MeetingExpense__r.Meeting__c, MeetingMember__c, MeetingExpenseType__c
                FROM MeetingExpenseAllocation__c
                WHERE Id = :meetingExpenseAllocation.Id
        ];
        meetingMember = [
                SELECT
                        Id, RecordType.DeveloperName, Meeting__c
                FROM MeetingMember__c
                WHERE Id = :meetingMember.Id
        ];

        Set<String> actionNames = new Set<String>{
                EDIT_SPEAKER_PERM_NAME,
                DELETE_SPEAKER_PERM_NAME,
                ADD_SPEAKER_PERM_NAME,
                DELETE_ACT_EXPENSE_ALLOC_PERM_NAME,
                ADD_ACT_EXPENSE_ALLOC_PERM_NAME,
                EDIT_ACT_EXPENSE_ALLOC_PERM_NAME
        };
        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds = new Map<String, Map<String, Boolean>>{
                String.valueOf(meeting.Id) => new Map<String, Boolean>{
                        ADD_SPEAKER_PERM_NAME => false,
                        DELETE_SPEAKER_PERM_NAME => false,
                        EDIT_SPEAKER_PERM_NAME => false,
                        DELETE_ACT_EXPENSE_ALLOC_PERM_NAME => false,
                        ADD_ACT_EXPENSE_ALLOC_PERM_NAME => false,
                        EDIT_ACT_EXPENSE_ALLOC_PERM_NAME => false
                }
        };

        TestUtils.Stub workflowService = stubFactory.stub();
        workflowService.when('getMeetingsActionsAvailability', new List<Id>{
                meeting.Id
        }, UserInfo.getUserId(), actionNames).thenReturn(actionPermissionsByMeetingIds);

        WorkflowPathMeetingAdapter workflowPathMeetingAdapter = new WorkflowPathMeetingAdapter();
        workflowPathMeetingAdapter.meetingWorkflowService = (MeetingWorkFlowService) mockFactory.mock(MeetingWorkFlowService.class, workflowService);

        //When
        Test.startTest();
        Map<Id, CrudPermissions> crudPermissionsByIds = workflowPathMeetingAdapter.getCrudPermissionsByRecordIds(new Set<Id>{
                meetingMember.Id, meetingExpenseAllocation.Id
        });
        Test.stopTest();

        //Then
        CrudPermissions meetingMemberPermissions = crudPermissionsByIds.get(meetingMember.Id);
        CrudPermissions allocationPermissions = crudPermissionsByIds.get(meetingExpenseAllocation.Id);

        System.assert(meetingMemberPermissions != null);
        System.assert(meetingMemberPermissions.isNotCreatable());
        System.assert(meetingMemberPermissions.isNotDeletable());
        System.assert(meetingMemberPermissions.isNotEditable());
        System.assert(meetingMemberPermissions.isReadable());
        System.assert(allocationPermissions != null);
        System.assert(allocationPermissions.isNotCreatable());
        System.assert(allocationPermissions.isNotDeletable());
        System.assert(allocationPermissions.isNotEditable());
        System.assert(allocationPermissions.isReadable());
    }

    @IsTest
    static void testGetCrudPermissionsByMembersRecordPrototypes() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Id meetingId = IdUtils.generate(Meeting__c.SObjectType);
        Id meetingMemberId = IdUtils.generate(MeetingMember__c.SObjectType);
        List<RecordType> recordTypes = [SELECT DeveloperName FROM RecordType WHERE SobjectType = 'MeetingMember__c' AND DeveloperName = 'Speaker' LIMIT 1];
        MeetingMember__c meetingMember = new MeetingMember__c(Meeting__c = meetingId, Id = meetingMemberId);
        if (!recordTypes.isEmpty()) {
            meetingMember.RecordType = recordTypes.get(0);
        }

        Set<String> actionNames = new Set<String>{
            ADD_SPEAKER_PERM_NAME,
            DELETE_SPEAKER_PERM_NAME,
            EDIT_SPEAKER_PERM_NAME
        };
        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds = new Map<String, Map<String, Boolean>>{
            String.valueOf(meetingId) => new Map<String, Boolean>{
                ADD_SPEAKER_PERM_NAME => false,
                DELETE_SPEAKER_PERM_NAME => false,
                EDIT_SPEAKER_PERM_NAME => false
            }
        };

        TestUtils.Stub workflowService = stubFactory.stub();

        workflowService.when('getMeetingsActionsAvailability', new List<Id>{
            meetingId
        }, UserInfo.getUserId(), actionNames).thenReturn(actionPermissionsByMeetingIds);

        WorkflowPathMeetingAdapter workflowPathMeetingAdapter = new WorkflowPathMeetingAdapter();
        workflowPathMeetingAdapter.meetingWorkflowService = (MeetingWorkFlowService) mockFactory.mock(MeetingWorkFlowService.class, workflowService);

        WorkflowObjectPrototype meetingMemberObjectPrototype =  new WorkflowObjectPrototype(meetingMember, 'Speaker', meetingId);
        //When
        Test.startTest();
        Map<WorkflowObjectPrototype, CrudPermissions> crudPermissionsByPrototypes = workflowPathMeetingAdapter.getCrudPermissionsByPrototypes(
            new List<WorkflowObjectPrototype> {meetingMemberObjectPrototype}
        );
        Test.stopTest();

        //Then
        CrudPermissions meetingMemberPermissions = crudPermissionsByPrototypes.get(meetingMemberObjectPrototype);

        System.assert(meetingMemberPermissions!= null);
        System.assert(meetingMemberPermissions.isNotCreatable());
        System.assert(meetingMemberPermissions.isNotDeletable());
        System.assert(meetingMemberPermissions.isNotEditable());
        System.assert(meetingMemberPermissions.isReadable());
    }

    @IsTest
    static void testGetCrudPermissionsByAllocationPrototype() {

        // check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        Meeting__c meeting = TestUtils.createMeeting(true);
        MeetingMember__c meetingMember = TestUtils.createMeetingMember('Member', meeting.Id, true);
        MeetingExpense__c meetingExpense = TestUtils.createMeetingExpense(true, 'Actual', meeting.Id);
        MeetingExpenseAllocation__c meetingExpenseAllocation = TestUtils.createMeetingExpenseAllocation(true, meetingExpense.Id, meetingMember.Id);
        meetingExpenseAllocation = [SELECT Id, MeetingExpense__c, MeetingExpense__r.Meeting__c, MeetingMember__c, MeetingExpenseType__c FROM MeetingExpenseAllocation__c WHERE Id =: meetingExpenseAllocation.Id];
        meetingMember = [SELECT Id, RecordType.DeveloperName, Meeting__c FROM MeetingMember__c WHERE Id =: meetingMember.Id];

        Set<String> actionNames = new Set<String>{
            ADD_SPEAKER_PERM_NAME,
            DELETE_SPEAKER_PERM_NAME,
            EDIT_SPEAKER_PERM_NAME,
            DELETE_ACT_EXPENSE_ALLOC_PERM_NAME,
            ADD_ACT_EXPENSE_ALLOC_PERM_NAME,
            EDIT_ACT_EXPENSE_ALLOC_PERM_NAME
        };
        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds = new Map<String, Map<String, Boolean>>{
            String.valueOf(meeting.Id) => new Map<String, Boolean>{
                ADD_SPEAKER_PERM_NAME => false,
                DELETE_SPEAKER_PERM_NAME => true,
                EDIT_SPEAKER_PERM_NAME => false,
                DELETE_ACT_EXPENSE_ALLOC_PERM_NAME => false,
                ADD_ACT_EXPENSE_ALLOC_PERM_NAME => false,
                EDIT_ACT_EXPENSE_ALLOC_PERM_NAME => true
            }
        };

        TestUtils.Stub workflowService = stubFactory.stub();
        workflowService.when('getMeetingsActionsAvailability', new List<Id>{
            meeting.Id
        }, UserInfo.getUserId(), actionNames).thenReturn(actionPermissionsByMeetingIds);

        WorkflowPathMeetingAdapter workflowPathMeetingAdapter = new WorkflowPathMeetingAdapter();
        workflowPathMeetingAdapter.meetingWorkflowService = (MeetingWorkFlowService) mockFactory.mock(MeetingWorkFlowService.class, workflowService);

        WorkflowObjectPrototype meetingMemberObjectPrototype =  new WorkflowObjectPrototype(meetingMember, 'Speaker', meeting.Id);
        WorkflowObjectPrototype allocationObjectPrototype =  new WorkflowObjectPrototype(meetingExpenseAllocation, 'Actual', meeting.Id);

        //When
        Test.startTest();
        Map<WorkflowObjectPrototype, CrudPermissions> crudPermissionsByPrototypes = workflowPathMeetingAdapter.getCrudPermissionsByPrototypes(new List<WorkflowObjectPrototype> {
            meetingMemberObjectPrototype, allocationObjectPrototype
        });
        Test.stopTest();

        //Then
        CrudPermissions meetingMemberPermissions = crudPermissionsByPrototypes.get(meetingMemberObjectPrototype);
        CrudPermissions allocationPermissions = crudPermissionsByPrototypes.get(allocationObjectPrototype);

        System.assert(meetingMemberPermissions!= null);
        System.assert(meetingMemberPermissions.isNotCreatable());
        System.assert(meetingMemberPermissions.isDeletable());
        System.assert(meetingMemberPermissions.isNotEditable());
        System.assert(meetingMemberPermissions.isReadable());
        System.assert(allocationPermissions!= null);
        System.assert(allocationPermissions.isNotCreatable());
        System.assert(allocationPermissions.isNotDeletable());
        System.assert(allocationPermissions.isEditable());
        System.assert(allocationPermissions.isReadable());
    }


}
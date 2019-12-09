public inherited sharing class WorkflowPathMeetingAdapter {

    private static final String CREATE_PERMISSION_NAME = 'Add';
    private static final String EDIT_PERMISSION_NAME = 'Edit';
    private static final String DELETE_PERMISSION_NAME = 'Delete';

    private static final String MEETING_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditMeeting__c.getName();
    private static final String MEETING_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteMeeting__c.getName();

    private static final String ATTENDEE_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddAttendee__c.getName();
    private static final String ATTENDEE_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditAttendee__c.getName();
    private static final String ATTENDEE_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteAttendee__c.getName();

    private static final String NON_PROFILED_ATTENDEE_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddAttendee__c.getName();
    private static final String NON_PROFILED_ATTENDEE_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditAttendee__c.getName();
    private static final String NON_PROFILED_ATTENDEE_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteAttendee__c.getName();

    private static final String SPEAKER_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddSpeaker__c.getName();
    private static final String SPEAKER_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditSpeaker__c.getName();
    private static final String SPEAKER_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteSpeaker__c.getName();

    private static final String COLLEAGUE_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddColleague__c.getName();
    private static final String COLLEAGUE_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditColleague__c.getName();
    private static final String COLLEAGUE_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteColleague__c.getName();

    private static final String LOCATION_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddLocation__c.getName();
    private static final String LOCATION_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditLocation__c.getName();
    private static final String LOCATION_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteLocation__c.getName();

    private static final String TOPIC_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddTopic__c.getName();
    private static final String TOPIC_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditTopic__c.getName();
    private static final String TOPIC_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteTopic__c.getName();

    private static final String BUDGET_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddMeetingBudget__c.getName();
    private static final String BUDGET_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditMeetingBudget__c.getName();
    private static final String BUDGET_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteMeetingBudget__c.getName();

    private static final String PRODUCT_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteMeetingProduct__c.getName();

    private static final String ACTUAL_EXPENSE_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddActualExpenseAllocation__c.getName();
    private static final String ACTUAL_EXPENSE_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditActualExpenseAllocation__c.getName();
    private static final String ACTUAL_EXPENSE_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteActualExpenseAllocation__c.getName();

    private static final String ESTIMATED_EXPENSE_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddEstimatedExpenseAllocation__c.getName();
    private static final String ESTIMATED_EXPENSE_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditEstimatedExpenseAllocation__c.getName();
    private static final String ESTIMATED_EXPENSE_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteEstimatedExpenseAllocation__c.getName();

    private static final String ACTUAL_EXPENSE_ALLOCATION_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddActualExpenseAllocation__c.getName();
    private static final String ACTUAL_EXPENSE_ALLOCATION_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditActualExpenseAllocation__c.getName();
    private static final String ACTUAL_EXPENSE_ALLOCATION_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteActualExpenseAllocation__c.getName();

    private static final String ESTIMATED_EXPENSE_ALLOCATION_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddEstimatedExpenseAllocation__c.getName();
    private static final String ESTIMATED_EXPENSE_ALLOCATION_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditEstimatedExpenseAllocation__c.getName();
    private static final String ESTIMATED_EXPENSE_ALLOCATION_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteEstimatedExpenseAllocation__c.getName();

    private static final String EXPENSE_BUDGET_ALLOCATION_ADD_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.AddMeetingExpenseBudgetAllocation__c.getName();
    private static final String EXPENSE_BUDGET_ALLOCATION_EDIT_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.EditMeetingExpenseBudgetAllocation__c.getName();
    private static final String EXPENSE_BUDGET_ALLOCATION_DELETE_ACTION_NAME = SObjectType.MeetingWorkFlowNodeConfiguration__mdt.fields.DeleteMeetingExpenseBudgetAllocation__c.getName();


    private final static Map<SObjectType, String> meetingRelationshipNamesByObjectTypes = new Map<SObjectType, String> {
            MeetingLocation__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('Meeting__c'),
            MeetingMember__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('Meeting__c'),
            MeetingTopic__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('Meeting__c'),
            MeetingProduct__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('Meeting__c'),
            MeetingExpense__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('Meeting__c'),
            MeetingBudget2__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('Meeting__c'),
            MeetingExpenseAllocation__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('MeetingExpense__r.Meeting__c'),
            MeetingExpenseBudgetAllocation__c.getSObjectType() => PackageUtilities.addNamespacePrefixToFieldPath('MeetingExpense__r.Meeting__c')
    };
    private static Map<RecordActionPermission, String> actionNamesByRecordActionPermissions = new Map<RecordActionPermission, String>();


    @TestVisible
    private MeetingWorkFlowConfigurationDao workflowPathDao = new MeetingWorkFlowConfigurationDao();
    @TestVisible
    private ObjectWorkflowPathAssociationDao associationDao = new ObjectWorkflowPathAssociationDao();
    @TestVisible
    private MeetingWorkFlowActionConfigurationDao actionsDao = new MeetingWorkFlowActionConfigurationDao();
    @TestVisible
    private SObjectDao sobjectDao = new SObjectDao();
    @TestVisible
    private MeetingWorkFlowService meetingWorkflowService = new MeetingWorkFlowService();

    public Map<Id, WorkflowPath> getPathsByIds(Set<Id> ids) {
        List<MeetingWorkFlowConfiguration__mdt> mdtPaths = this.workflowPathDao.getLegacyWithNodesByIds(ids);
        Map<Id, MeetingWorkFlowConfiguration__mdt> mdtPathsByIds = new Map<Id, MeetingWorkFlowConfiguration__mdt>(mdtPaths);
        List<ObjectWorkflowPathAssociation__c> associations = this.associationDao.getByWorkflowPathIds(mdtPathsByIds.keySet());
        Map<Id, WorkflowPath> pathsByIds = new Map<Id, WorkflowPath>();

        if (ArrayUtils.isNotEmpty(associations)) {
            Map<Id, Id> pathIdsByMeetingIds = new Map<Id, Id>();
            for (ObjectWorkflowPathAssociation__c association : associations) {
                pathIdsByMeetingIds.put(association.ObjectRecordID__c, association.WorkflowPathId__c);
            }

            Map<Id, String> userRolesByMeetingIds =
                    this.meetingWorkflowService
                            .getUserMeetingsRole(pathIdsByMeetingIds.keySet(), UserInfo.getUserId());

            for (Id meetingId : pathIdsByMeetingIds.keySet()) {
                Id pathId = pathIdsByMeetingIds.get(meetingId);
                String userRole = userRolesByMeetingIds.get(meetingId);
                MeetingWorkFlowConfiguration__mdt mdtPath = mdtPathsByIds.get(pathId);

                WorkflowPath path = new WorkflowPath(
                        createMdtPathWithRelevantNodes(mdtPath, userRole)
                );

                pathsByIds.put(pathId, path);
            }
        }

        return pathsByIds;
    }

    private MeetingWorkFlowConfiguration__mdt createMdtPathWithRelevantNodes(MeetingWorkFlowConfiguration__mdt mdtPath, String role) {
        List<MeetingWorkFlowNodeConfiguration__mdt> validNodes = new List<MeetingWorkFlowNodeConfiguration__mdt>();

        for (MeetingWorkFlowNodeConfiguration__mdt node : mdtPath.MeetingWorkFlowNodeConfigurations__r) {
            if (node.MeetingRole__c == role) {
                validNodes.add(node);
            }
        }

        Map<String, Object> mdtPathValuesByFieldNames = mdtPath.getPopulatedFieldsAsMap().clone();
        mdtPathValuesByFieldNames.put('MeetingWorkFlowNodeConfigurations__r', new Map<String, Object> {
                'totalSize' => validNodes.size(),
                'records' => validNodes
        });

        return (MeetingWorkFlowConfiguration__mdt) JSON.deserialize(JSON.serialize(mdtPathValuesByFieldNames), MeetingWorkFlowConfiguration__mdt.class);
    }

    public Map<Id, List<Action>> getActionsByPathNodeIds(Set<Id> pathNodeIds) {
        List<MeetingWorkFlowActionConfiguration__mdt> mdtActions = actionsDao.getWithNextNodeByCurrentNodeIds(pathNodeIds);

        Map<Id, List<Action>> actionsByNodeIds = new Map<Id, List<Action>>();
        for (Integer i = 0; i < mdtActions.size(); i++) {
            MeetingWorkFlowActionConfiguration__mdt mdtAction = mdtActions.get(i);
            Id pathNodeId = mdtAction.MeetingWorkFlowNode__c;

            List<Action> actions = actionsByNodeIds.get(pathNodeId);
            if (actions == null) {
                actions = new List<Action>();
                actionsByNodeIds.put(pathNodeId, actions);
            }

            Action action = ActionFactory.createUsing(mdtAction);

            actions.add(action);
        }

        return actionsByNodeIds;
    }

    public Map<Id, CrudPermissions> getCrudPermissionsByRecordIds(Set<Id> recordIds) {
        initActionNamesByRecordActionPermissions();

        Map<SObject, Id> meetingIdsByRecords = this.mapRecordsToMeetingIds(recordIds);
        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds =
                this.getActionPermissionsByMeetingIds(meetingIdsByRecords);
        Map<Id, CrudPermissions> permissionsByRecordIds =
                this.mapRecordIdsToCrudPermissions(meetingIdsByRecords, actionPermissionsByMeetingIds);

        return permissionsByRecordIds;
    }

    public Map<WorkflowObjectPrototype, CrudPermissions> getCrudPermissionsByPrototypes(List<WorkflowObjectPrototype> prototypes) {
        if (BaseUtilities.isNullOrEmpty(prototypes)) return new Map<WorkflowObjectPrototype, CrudPermissions>();
        initActionNamesByRecordActionPermissions();

        Map<String, Map<String, Boolean>> actionPermissionsByMeetingPrototypes =
                this.getActionPermissionsByMeetingIds(prototypes);
        Map<WorkflowObjectPrototype, CrudPermissions> permissionsByPrototypes =
                this.mapPrototypesToCrudPermissions(prototypes, actionPermissionsByMeetingPrototypes);

        return permissionsByPrototypes;
    }

    private Map<SObject, Id> mapRecordsToMeetingIds(Set<Id> recordIds) {
        Map<SObject, Id> meetingIdsByRecords = new Map<SObject, Id>();
        Map<String, List<Id>> childrenIdsByObjectNames = new Map<String, List<Id>>();
        Map<String, Set<String>> childrenFieldsByObjectNames = new Map<String, Set<String>>();
        for (Id recordId : recordIds) {
            SObjectType objectType = recordId.getSObjectType();
            String objectName = objectType.getDescribe().getName();

            if (isMeetingObjectType(objectType)) {
                meetingIdsByRecords.put(new Meeting__c(Id = recordId), recordId);
            } else {
                List<Id> equivalentTypeRecordIds = childrenIdsByObjectNames.get(objectName);

                if (equivalentTypeRecordIds == null) {
                    equivalentTypeRecordIds = new List<Id>();
                    childrenIdsByObjectNames.put(objectName, equivalentTypeRecordIds);
                    childrenFieldsByObjectNames.put(objectName, this.getMeetingChildObjectFields(objectType));
                }

                equivalentTypeRecordIds.add(recordId);
            }
        }

        if (!childrenIdsByObjectNames.isEmpty()) {
            List<SObject> children = this.sobjectDao.getByObjectNameToIdsMap(childrenIdsByObjectNames, childrenFieldsByObjectNames);

            for (SObject record : children) {
                SObjectType objectType = record.getSObjectType();
                String meetingRelationshipName = meetingRelationshipNamesByObjectTypes.get(objectType);
                Id meetingId = (Id) ObjectUtilities.getValueByFieldPath(record, meetingRelationshipName);

                meetingIdsByRecords.put(record, meetingId);
            }
        }

        return meetingIdsByRecords;
    }

    private Boolean isMeetingObjectType(SObjectType objectType) {
        return objectType == SObjectType.Meeting__c.getSObjectType();
    }

    private Set<String> getMeetingChildObjectFields(SObjectType objectType) {
        Set<String> fields = new Set<String>();

        fields.add(
                meetingRelationshipNamesByObjectTypes.get(objectType)
        );

        if (objectType == MeetingExpenseAllocation__c.getSObjectType()) {
            fields.add('MeetingExpenseType__c');
        } else if (isControlledByRecordType(objectType)) {
            fields.add('RecordType.DeveloperName');
        }

        return fields;
    }

    private Map<String, Map<String, Boolean>> getActionPermissionsByMeetingIds(Map<SObject, Id> meetingIdsByRecords) {
        List<SObject> records = new List<SObject>(meetingIdsByRecords.keySet());
        Set<String> actionNames = this.getRecordsActionNames(records);

        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds =
                this.meetingWorkflowService.getMeetingsActionsAvailability(
                        new List<Id>(new Set<Id>(meetingIdsByRecords.values())),
                        UserInfo.getUserId(),
                        actionNames
                );

        return actionPermissionsByMeetingIds;
    }

    private Map<String, Map<String, Boolean>> getActionPermissionsByMeetingIds(List<WorkflowObjectPrototype> prototypes) {
        Set<String> actionNames = this.getRecordsActionNames(prototypes);
        Set<Id> meetingIds = new Set<Id>();
        for (WorkflowObjectPrototype prototype : prototypes) {
            meetingIds.add(prototype.getParentObjectId());
        }

        Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds =
                this.meetingWorkflowService.getMeetingsActionsAvailability(
                        new List<Id>(meetingIds),
                        UserInfo.getUserId(),
                        actionNames
                );

        return actionPermissionsByMeetingIds;
    }

    private Set<String> getRecordsActionNames(List<SObject> records) {
        Set<String> actionNames = new Set<String>();

        for (SObject record : records) {
            SObjectType objectType = record.getSObjectType();
            String type = this.getType(record);
            actionNames.addAll(this.getRecordActionNames(objectType, type));
        }

        return actionNames;
    }

    private Set<String> getRecordsActionNames(List<WorkflowObjectPrototype> prototypes) {
        Set<String> actionNames = new Set<String>();

        for (WorkflowObjectPrototype prototype : prototypes) {
            SObjectType objectType = prototype.getPrototypeSObjectType();
            String type = this.getType(prototype);
            actionNames.addAll(this.getRecordActionNames(objectType, type));
        }

        return actionNames;
    }

    private String getType(SObject record) {
        SObjectType objectType = record.getSObjectType();
        String type;
        if (objectType == MeetingExpenseAllocation__c.getSObjectType()) {
            type = (String) ObjectUtilities.getValueByFieldPath(record, 'MeetingExpenseType__c');
        } else if (isControlledByRecordType(objectType)) {
            type = (String) ObjectUtilities.getValueByFieldPath(record, 'RecordType.DeveloperName');
        }
        return type;
    }

    private String getType(WorkflowObjectPrototype prototype) {
        SObjectType objectType = prototype.getPrototypeSObjectType();
        String type;
        if (isControlledByRecordType(objectType)
                || objectType == MeetingExpenseAllocation__c.getSObjectType()) {

            type = prototype.getRecordTypeDeveloperName();
        }
        return type;
    }

    private Set<String> getRecordActionNames(SObjectType objectType, String type) {
        Set<String> actionNames = new Set<String>();

        String create = actionNamesByRecordActionPermissions.get(createRecordActionPermission(objectType, type, CREATE_PERMISSION_NAME));
        String edit = actionNamesByRecordActionPermissions.get(createRecordActionPermission(objectType, type, EDIT_PERMISSION_NAME));
        String del = actionNamesByRecordActionPermissions.get(createRecordActionPermission(objectType, type, DELETE_PERMISSION_NAME));
        if (String.isNotBlank(create)) actionNames.add(create);
        if (String.isNotBlank(edit)) actionNames.add(edit);
        if (String.isNotBlank(del)) actionNames.add(del);

        return actionNames;
    }

    private RecordActionPermission createRecordActionPermission(SObjectType objectType, String type, String permissionName) {
        String objectName = objectType.getDescribe().getName();

        return new RecordActionPermission(objectName, type, permissionName);
    }

    private static Boolean isControlledByRecordType(SObjectType objectType) {
        return objectType == MeetingMember__c.getSObjectType()
                || objectType == MeetingExpense__c.getSObjectType();
    }

    private Map<Id, CrudPermissions> mapRecordIdsToCrudPermissions(
            Map<SObject, Id> meetingIdsByRecords,
            Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds
    ) {
        Map<Id, CrudPermissions> permissionsByRecordIds = new Map<Id, CrudPermissions>();

        for (SObject record : meetingIdsByRecords.keySet()) {
            Id recordId = (Id) record.get('Id');
            Id meetingId = meetingIdsByRecords.get(record);
            Map<String, Boolean> permissionsByActionNames = actionPermissionsByMeetingIds.get(meetingId);

            Boolean isCreatable = getIsCreatablePermission(permissionsByActionNames, record.getSObjectType(), this.getType(record));
            Boolean isEditable = getIsEditablePermission(permissionsByActionNames, record.getSObjectType(), this.getType(record));
            Boolean isDeletable = getIsDeletablePermission(permissionsByActionNames, record.getSObjectType(), this.getType(record));
            CrudPermissions permissions = new CrudPermissions(isCreatable, isEditable, isDeletable);

            permissionsByRecordIds.put(recordId, permissions);
        }

        return permissionsByRecordIds;
    }

    private Map<WorkflowObjectPrototype, CrudPermissions> mapPrototypesToCrudPermissions(
            List<WorkflowObjectPrototype> prototypes,
            Map<String, Map<String, Boolean>> actionPermissionsByMeetingIds
    ) {
        Map<WorkflowObjectPrototype, CrudPermissions> permissionsByPrototypes = new Map<WorkflowObjectPrototype, CrudPermissions>();

        for (WorkflowObjectPrototype recordPrototype : prototypes) {
            Map<String, Boolean> permissionsByActionNames = actionPermissionsByMeetingIds.get(recordPrototype.getParentObjectId());

            Boolean isCreatable = getIsCreatablePermission(permissionsByActionNames, recordPrototype.getPrototypeSObjectType(), this.getType(recordPrototype));
            Boolean isEditable = getIsEditablePermission(permissionsByActionNames, recordPrototype.getPrototypeSObjectType(), this.getType(recordPrototype));
            Boolean isDeletable = getIsDeletablePermission(permissionsByActionNames, recordPrototype.getPrototypeSObjectType(), this.getType(recordPrototype));
            CrudPermissions permissions = new CrudPermissions(isCreatable, isEditable, isDeletable);

            permissionsByPrototypes.put(recordPrototype, permissions);
        }

        return permissionsByPrototypes;
    }

    private Boolean getIsCreatablePermission(Map<String, Boolean> permissionsByActionNames, SObjectType objectType, String type) {
        return getPermission(permissionsByActionNames, objectType, type, CREATE_PERMISSION_NAME);
    }

    private Boolean getIsEditablePermission(Map<String, Boolean> permissionsByActionNames, SObjectType objectType, String type) {
        return getPermission(permissionsByActionNames, objectType, type, EDIT_PERMISSION_NAME);
    }

    private Boolean getIsDeletablePermission(Map<String, Boolean> permissionsByActionNames, SObjectType objectType, String type) {
        return getPermission(permissionsByActionNames, objectType, type, DELETE_PERMISSION_NAME);
    }

    private Boolean getPermission(Map<String, Boolean> permissionsByActionNames, SObjectType objectType, String type, String permissionName) {
        RecordActionPermission recordActionPermission = this.createRecordActionPermission(objectType, type, permissionName);
        String actionName = actionNamesByRecordActionPermissions.get(recordActionPermission);

        return BooleanUtils.toBooleanDefaultIfNull(permissionsByActionNames.get(actionName), true);
    }


    private static void initActionNamesByRecordActionPermissions() {
        initMeetingActionNames();
        initMeetingAttendeeActionNames();
        initMeetingNonProfiledAttendeeActionNames();
        initMeetingSpeakerActionNames();
        initMeetingColleagueActionNames();
        initMeetingLocationActionNames();
        initMeetingTopicActionNames();
        initMeetingBudgetActionNames();
        initMeetingBudget2ActionNames();
        initMeetingProductActionNames();
        initMeetingActualExpenseActionNames();
        initMeetingEstimatedExpenseActionNames();
        initMeetingEstimatedExpenseAllocationActionNames();
        initMeetingActualExpenseAllocationActionNames();
        initMeetingExpenseBudgetAllocationActionNames();
    }

    private static void initMeetingActionNames() {
        final String meeting = Meeting__c.getSObjectType().getDescribe().getName();

        RecordActionPermission edit = new RecordActionPermission(meeting, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meeting, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(edit, MEETING_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, MEETING_DELETE_ACTION_NAME);
    }

    private static void initMeetingAttendeeActionNames() {
        final String meetingMember = MeetingMember__c.getSObjectType().getDescribe().getName();
        final String attendee = 'Attendee';

        RecordActionPermission create = new RecordActionPermission(meetingMember, attendee, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingMember, attendee, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingMember, attendee, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, ATTENDEE_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, ATTENDEE_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, ATTENDEE_DELETE_ACTION_NAME);
    }

    private static void initMeetingNonProfiledAttendeeActionNames() {
        final String meetingMember = MeetingMember__c.getSObjectType().getDescribe().getName();
        final String nonProfiledAttendee = 'NonProfiledAttendee';

        RecordActionPermission create = new RecordActionPermission(meetingMember, nonProfiledAttendee, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingMember, nonProfiledAttendee, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingMember, nonProfiledAttendee, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, NON_PROFILED_ATTENDEE_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, NON_PROFILED_ATTENDEE_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, NON_PROFILED_ATTENDEE_DELETE_ACTION_NAME);
    }

    private static void initMeetingSpeakerActionNames() {
        final String meetingMember = MeetingMember__c.getSObjectType().getDescribe().getName();
        final String speaker = 'Speaker';

        RecordActionPermission create = new RecordActionPermission(meetingMember, speaker, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingMember, speaker, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingMember, speaker, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, SPEAKER_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, SPEAKER_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, SPEAKER_DELETE_ACTION_NAME);
    }

    private static void initMeetingColleagueActionNames() {
        final String meetingMember = MeetingMember__c.getSObjectType().getDescribe().getName();
        final String colleague = 'Colleague';

        RecordActionPermission create = new RecordActionPermission(meetingMember, colleague, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingMember, colleague, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingMember, colleague, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, COLLEAGUE_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, COLLEAGUE_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, COLLEAGUE_DELETE_ACTION_NAME);
    }

    private static void initMeetingLocationActionNames() {
        final String meetingLocation = MeetingLocation__c.getSObjectType().getDescribe().getName();

        RecordActionPermission create = new RecordActionPermission(meetingLocation, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingLocation, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingLocation, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, LOCATION_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, LOCATION_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, LOCATION_DELETE_ACTION_NAME);
    }

    private static void initMeetingTopicActionNames() {
        final String meetingTopic = MeetingTopic__c.getSObjectType().getDescribe().getName();

        RecordActionPermission create = new RecordActionPermission(meetingTopic, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingTopic, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingTopic, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, TOPIC_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, TOPIC_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, TOPIC_DELETE_ACTION_NAME);
    }

    private static void initMeetingBudgetActionNames() {
        final String meetingBudget = MeetingBudget2__c.getSObjectType().getDescribe().getName();

        RecordActionPermission create = new RecordActionPermission(meetingBudget, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingBudget, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingBudget, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, BUDGET_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, BUDGET_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, BUDGET_DELETE_ACTION_NAME);
    }

    private static void initMeetingBudget2ActionNames() {
        final String meetingBudget = MeetingBudget2__c.getSObjectType().getDescribe().getName();

        RecordActionPermission create = new RecordActionPermission(meetingBudget, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingBudget, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingBudget, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, BUDGET_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, BUDGET_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, BUDGET_DELETE_ACTION_NAME);
    }

    private static void initMeetingProductActionNames() {
        final String meetingProduct = MeetingProduct__c.getSObjectType().getDescribe().getName();

        RecordActionPermission del = new RecordActionPermission(meetingProduct, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(del, PRODUCT_DELETE_ACTION_NAME);
    }

    private static void initMeetingEstimatedExpenseAllocationActionNames() {
        final String meetingExpenseAllocation = MeetingExpenseAllocation__c.getSObjectType().getDescribe().getName();
        final String estimate = 'Estimate';

        RecordActionPermission create = new RecordActionPermission(meetingExpenseAllocation, estimate, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingExpenseAllocation, estimate, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingExpenseAllocation, estimate, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, ESTIMATED_EXPENSE_ALLOCATION_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, ESTIMATED_EXPENSE_ALLOCATION_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, ESTIMATED_EXPENSE_ALLOCATION_DELETE_ACTION_NAME);
    }

    private static void initMeetingActualExpenseAllocationActionNames() {
        final String meetingExpenseAllocation = MeetingExpenseAllocation__c.getSObjectType().getDescribe().getName();
        final String actual = 'Actual';

        RecordActionPermission create = new RecordActionPermission(meetingExpenseAllocation, actual, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingExpenseAllocation, actual, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingExpenseAllocation, actual, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, ACTUAL_EXPENSE_ALLOCATION_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, ACTUAL_EXPENSE_ALLOCATION_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, ACTUAL_EXPENSE_ALLOCATION_DELETE_ACTION_NAME);
    }

    private static void initMeetingEstimatedExpenseActionNames() {
        final String meetingExpense = MeetingExpense__c.getSObjectType().getDescribe().getName();
        final String estimate = 'Estimate';

        RecordActionPermission create = new RecordActionPermission(meetingExpense, estimate, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingExpense, estimate, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingExpense, estimate, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, ESTIMATED_EXPENSE_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, ESTIMATED_EXPENSE_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, ESTIMATED_EXPENSE_DELETE_ACTION_NAME);
    }

    private static void initMeetingActualExpenseActionNames() {
        final String meetingExpense = MeetingExpense__c.getSObjectType().getDescribe().getName();
        final String actual = 'Actual';

        RecordActionPermission create = new RecordActionPermission(meetingExpense, actual, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingExpense, actual, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingExpense, actual, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, ACTUAL_EXPENSE_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, ACTUAL_EXPENSE_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, ACTUAL_EXPENSE_DELETE_ACTION_NAME);
    }

    private static void initMeetingExpenseBudgetAllocationActionNames() {
        final String meetingExpenseBudgetAllocation = MeetingExpenseBudgetAllocation__c.getSObjectType().getDescribe().getName();

        RecordActionPermission create = new RecordActionPermission(meetingExpenseBudgetAllocation, CREATE_PERMISSION_NAME);
        RecordActionPermission edit = new RecordActionPermission(meetingExpenseBudgetAllocation, EDIT_PERMISSION_NAME);
        RecordActionPermission del = new RecordActionPermission(meetingExpenseBudgetAllocation, DELETE_PERMISSION_NAME);

        actionNamesByRecordActionPermissions.put(create, EXPENSE_BUDGET_ALLOCATION_ADD_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(edit, EXPENSE_BUDGET_ALLOCATION_EDIT_ACTION_NAME);
        actionNamesByRecordActionPermissions.put(del, EXPENSE_BUDGET_ALLOCATION_DELETE_ACTION_NAME);
    }


    class RecordActionPermission {
        public String objectName;
        public String type;
        public String permissionName;

        public RecordActionPermission(String objectName, String type, String permissionName) {
            this.objectName = objectName;
            this.type = type;
            this.permissionName = permissionName;
        }

        public RecordActionPermission(String objectName, String permissionName) {
            this.objectName = objectName;
            this.permissionName = permissionName;
        }

        public override String toString() {
            return objectName + type + permissionName;
        }

        public override Integer hashCode() {
            return this.toString().hashCode();
        }

        public Boolean equals(Object obj) {
            RecordActionPermission compareWith = (RecordActionPermission) obj;

            return this.toString().equals(compareWith.toString());
        }
    }
}
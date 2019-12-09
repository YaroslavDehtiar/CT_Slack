public with sharing class WorkflowPathService {

    private static final Set<String> MEETING_CHILDREN_TYPES_CONTROLLED_BY_WORKFLOW_PATH = new Set<String> {
            SObjectType.MeetingMember__c.getName(),
            SObjectType.MeetingProduct__c.getName(),
            SObjectType.MeetingLocation__c.getName(),
            SObjectType.MeetingTopic__c.getName(),
            SObjectType.MeetingExpense__c.getName(),
            SObjectType.MeetingBudget2__c.getName(),
            SObjectType.MeetingExpenseAllocation__c.getName(),
            SObjectType.MeetingExpenseBudgetAllocation__c.getName()
    };

    @TestVisible
    private MeetingWorkFlowConfigurationDao workflowDao = new MeetingWorkFlowConfigurationDao();
    @TestVisible
    private ObjectWorkflowPathAssociationDao associationDao = new ObjectWorkflowPathAssociationDao();
    @TestVisible
    private ContextTypeDao contextTypeDao = new ContextTypeDao();
    @TestVisible
    private SObjectDao sobjectDao = new SObjectDao();
    @TestVisible
    private WorkflowPathMeetingAdapter workflowPathAdapter = new WorkflowPathMeetingAdapter();

    public Boolean isObjectControlledByWorkflowPath(String objectName) {
        return this.isObjectsControlledByWorkflowPath(new Set<String> { objectName }).get(objectName);
    }

    public Map<String, Boolean> isObjectsControlledByWorkflowPath(Set<String> objectNames) {
        Map<String, ContextType__mdt> contextTypesByObjectNames = this.contextTypeDao.getByObjectNames(objectNames);

        Map<String, Boolean> controllingIndicatorsByObjectNames = new Map<String, Boolean>();
        for (String objectName : objectNames) {
            ContextType__mdt contextType = contextTypesByObjectNames.get(objectName);
            Boolean indicator = this.isContextTypeControlledByWorkflowPath(contextType);

            controllingIndicatorsByObjectNames.put(objectName, indicator);
        }

        return controllingIndicatorsByObjectNames;
    }

    private Boolean isContextTypeControlledByWorkflowPath(ContextType__mdt contextType) {
        return contextType != null && contextType.IsControlledByWorkflowPath__c;
    }

    public Map<Id, WorkflowPathAssociation> getPathAssociationsByRecordIds(Set<Id> recordIds) {
        Map<Id, WorkflowPathAssociation> pathAssociationsByRecordIds = new Map<Id, WorkflowPathAssociation>();
        Map<Id, WorkflowPath> pathsByRecordIds = this.getPathsByRecordIds(recordIds);
        if (!pathsByRecordIds.isEmpty()) {
            Map<String, Set<String>> fieldNamesByObjectNames = this.getPathsControllingFields(pathsByRecordIds.values());
            Map<String, List<Id>> recordIdsByObjectNames = ObjectUtilities.mapRecordIdsByObjectName(recordIds);

            List<SObject> records = this.sobjectDao.getByObjectNameToIdsMap(recordIdsByObjectNames, fieldNamesByObjectNames);
            pathAssociationsByRecordIds = this.getPathAssociationsByRecordIds(records, pathsByRecordIds);
        }

        return pathAssociationsByRecordIds;
    }

    private Map<String, Set<String>> getPathsControllingFields(List<WorkflowPath> paths) {
        Map<String, Set<String>> fieldNamesByObjectNames = new Map<String, Set<String>>();

        for (WorkflowPath path : paths) {
            if (path != null) {
                fieldNamesByObjectNames.put(
                        path.getObjectName(),
                        new Set<String>{ path.getControllingField() }
                );
            }
        }

        return fieldNamesByObjectNames;
    }

    private Map<Id, WorkflowPathAssociation> getPathAssociationsByRecordIds(List<SObject> records, Map<Id, WorkflowPath> pathsByRecordIds) {
        Map<Id, WorkflowPathAssociation> pathAssociationsByRecordIds = new Map<Id, WorkflowPathAssociation>();

        Map<Id, Id> legacyPathNodeIdsByRecordIds = new Map<Id, Id>();
        Map<Id, Id> pathNodeIdsByRecordIds = new Map<Id, Id>();
        for (SObject record : records) {
            Id recordId = (Id) record.get('Id');
            WorkflowPath path = pathsByRecordIds.get(recordId);

            if (path != null) {
                WorkflowPathNode activePathNode;

                String controllingField = path.getControllingField();
                String controllingFieldValue = (String) record.get(controllingField);

                for (WorkflowPathNode pathNode : path.getNodes()) {
                    if (controllingFieldValue == pathNode.getControllingFieldValue()) {
                        activePathNode = pathNode;

                        if (path.isLegacy()) {
                            legacyPathNodeIdsByRecordIds.put(recordId, activePathNode.getId());
                        } else {
                            pathNodeIdsByRecordIds.put(recordId, activePathNode.getId());
                        }

                        break;
                    }
                }

                WorkflowPathAssociation pathAssociation = new WorkflowPathAssociation(recordId, path, activePathNode);
                pathAssociationsByRecordIds.put(recordId, pathAssociation);
            }
        }

        assignPathNodesActions(
                legacyPathNodeIdsByRecordIds,
                pathNodeIdsByRecordIds,
                pathAssociationsByRecordIds
        );

        return pathAssociationsByRecordIds;
    }

    private void assignPathNodesActions(
            Map<Id, Id> legacyPathNodeIdsByRecordIds,
            Map<Id, Id> pathNodeIdsByRecordIds,
            Map<Id, WorkflowPathAssociation> pathAssociationsByRecordIds
    ) {
        Set<Id> legacyPathNodeIds = new Set<Id>(legacyPathNodeIdsByRecordIds.values());
        Map<Id, List<Action>> actionsByPathNodeIds = this.getActionsByPathNodeIds(pathNodeIdsByRecordIds);
        actionsByPathNodeIds.putAll(
                this.workflowPathAdapter.getActionsByPathNodeIds(legacyPathNodeIds)
        );

        actionsByPathNodeIds = WorkflowPathService.translateActionLabels(actionsByPathNodeIds);

        for (Id recordId : pathAssociationsByRecordIds.keySet()) {
            WorkflowPathAssociation pathAssociation = pathAssociationsByRecordIds.get(recordId);
            WorkflowPathNode pathNode = pathAssociation.getActivePathNode();
            List<Action> actions = actionsByPathNodeIds.get(pathNode.getId());

            pathNode.setActions(actions);
        }
    }

    public Map<Id, List<Action>> getActionsByPathNodeIds(Map<Id, Id> pathNodeIdsByRecordIds) {
        // TODO: Implement the logic for Context related entities
        return new Map<Id, List<Action>>();
    }

    public WorkflowPath getPathByRecordId(Id recordId) {
        return this.getPathsByRecordIds(new Set<Id>{ recordId }).get(recordId);
    }

    public Map<Id, WorkflowPath> getPathsByRecordIds(Set<Id> recordIds) {
        Map<Id, WorkflowPath> pathsByRecordIds = new Map<Id, WorkflowPath>();
        List<ObjectWorkflowPathAssociation__c> associations = this.associationDao.getByObjectRecordIds(recordIds);
        if (!associations.isEmpty()) {
            Set<Id> pathsIds = new Set<Id>();
            for (ObjectWorkflowPathAssociation__c association : associations) {
                pathsIds.add(association.WorkflowPathId__c);
            }

            Map<Id, WorkflowPath> pathsByIds = this.getWorkflowPathsByIds(pathsIds);
            pathsByRecordIds = this.mapPathsByRecordIds(pathsByIds, associations);
        }

        return pathsByRecordIds;
    }

    private Map<Id, WorkflowPath> getWorkflowPathsByIds(Set<Id> workflowPathIds) {
        Map<Id, WorkflowPath> legacyPathsByIds = this.workflowPathAdapter.getPathsByIds(workflowPathIds);

        workflowPathIds.removeAll(legacyPathsByIds.keySet());
        List<MeetingWorkFlowConfiguration__mdt> mdtWorkflowPaths = this.workflowDao.getWithContextTypeAndNodesByIds(workflowPathIds);

        Map<Id, WorkflowPath> workflowPathByIds = new Map<Id, WorkflowPath>();
        for (MeetingWorkFlowConfiguration__mdt mdtWorkflowPath : mdtWorkflowPaths) {
            workflowPathByIds.put(mdtWorkflowPath.Id, new WorkflowPath(mdtWorkflowPath));
        }

        workflowPathByIds.putAll(legacyPathsByIds);
        return workflowPathByIds;
    }

    private Map<Id, WorkflowPath> mapPathsByRecordIds(Map<Id, WorkflowPath> pathsByIds, List<ObjectWorkflowPathAssociation__c> associations) {
        Map<Id, WorkflowPath> pathsByRecordIds = new Map<Id, WorkflowPath>();

        WorkflowPath path;
        for (ObjectWorkflowPathAssociation__c association : associations) {
            path = pathsByIds.get(association.WorkflowPathId__c);

            if (path != null) {
                pathsByRecordIds.put(association.ObjectRecordId__c, path);
            }
        }

        return pathsByRecordIds;
    }

    public WorkflowPath getPathByObjectRecordType(WorkflowPathObjectRecordType objectRecordType) {
        Set<WorkflowPathObjectRecordType> objectRecordTypes = new Set<WorkflowPathObjectRecordType> { objectRecordType };
        Map<WorkflowPathObjectRecordType, WorkflowPath> paths = this.getPathsByObjectRecordTypes(objectRecordTypes);

        return paths.get(objectRecordType);
    }

    public Map<WorkflowPathObjectRecordType, WorkflowPath> getPathsByObjectRecordTypes(Set<WorkflowPathObjectRecordType> objectRecordTypes) {
        // TODO: implement the logic
        return null;
    }

    public CrudPermissions getCrudPermissions(WorkflowPathObjectRecordType objectRecordType) {
        return this.getCrudPermissions(new Set<WorkflowPathObjectRecordType> { objectRecordType }).get(objectRecordType);
    }

    public Map<WorkflowPathObjectRecordType, CrudPermissions> getCrudPermissions(Set<WorkflowPathObjectRecordType> objectRecordTypes) {
        Map<WorkflowPathObjectRecordType, WorkflowPath> pathsByObjectRecordTypes =
                this.getPathsByObjectRecordTypes(objectRecordTypes);



        return null;
    }

    public CrudPermissions getCrudPermissions(Id recordId) {
        Map<Id, CrudPermissions> abilitiesByRecordIds = this.getCrudPermissions(new Set<Id> { recordId });

        return abilitiesByRecordIds.get(recordId);
    }

    public Map<Id, CrudPermissions> getCrudPermissions(Set<Id> recordIds) {
        Set<String> objectNames = new Set<String>();
        for (Id recordId : recordIds) {
            objectNames.add(recordId.getSobjectType().getDescribe().getName());
        }

        Map<Id, CrudPermissions> permissionsByRecordIds = new Map<Id, CrudPermissions>();
        Map<String, ContextType__mdt> contextTypesByObjectNames = this.contextTypeDao.getByObjectNames(objectNames);

        Set<Id> controlledRecordIds = new Set<Id>();
        String objectName;
        ContextType__mdt contextType;
        Boolean isObjectControlledByWorkflowPath = false;
        for (Id recordId : recordIds) {
            objectName = recordId.getSobjectType().getDescribe().getName();
            contextType = contextTypesByObjectNames.get(objectName);

            isObjectControlledByWorkflowPath = this.isContextTypeControlledByWorkflowPath(contextType);

            if (isObjectControlledByWorkflowPath) {
                controlledRecordIds.add(recordId);
            } else {
                permissionsByRecordIds.put(recordId, CrudPermissions.all());
            }
        }


        Map<Id, WorkflowPathAssociation> legacyPathAssociationsByRecordIds = new Map<Id, WorkflowPathAssociation>();
        Map<Id, WorkflowPathAssociation> pathAssociationsByRecordIds = this.getPathAssociationsByRecordIds(controlledRecordIds);

        for (Id recordId : controlledRecordIds) {
            WorkflowPathAssociation pathAssociation = pathAssociationsByRecordIds.get(recordId);

            if (pathAssociation != null) {
                if (pathAssociation.getPath().isLegacy()) {
                    legacyPathAssociationsByRecordIds.put(recordId, pathAssociation);
                    pathAssociationsByRecordIds.remove(recordId);
                }
            } else if (isMeetingChildrenRecord(recordId)) {
                // TODO: Refactor while Context Matching implementation, it will overlap functionality
                legacyPathAssociationsByRecordIds.put(recordId, null);
            }
    }

        permissionsByRecordIds.putAll(
                this.getCrudPermissionsByPathAssociations(pathAssociationsByRecordIds)
        );
        permissionsByRecordIds.putAll(
                this.workflowPathAdapter.getCrudPermissionsByRecordIds(legacyPathAssociationsByRecordIds.keySet())
        );

        return permissionsByRecordIds;
    }

    public Map<WorkflowObjectPrototype, CrudPermissions> getCrudPermissions(List<WorkflowObjectPrototype> recordPrototypes) {
        Set<String> objectNames = new Set<String>();
        for (WorkflowObjectPrototype recordPrototype : recordPrototypes) {
            objectNames.add(recordPrototype.getPrototypeSObjectName());
        }
        Map<String, ContextType__mdt> contextTypesByObjectNames = this.contextTypeDao.getByObjectNames(objectNames);

        Map<WorkflowObjectPrototype, CrudPermissions> permissionsByPrototypes = new Map<WorkflowObjectPrototype, CrudPermissions>();

        List<WorkflowObjectPrototype> controlledPrototypes = new List<WorkflowObjectPrototype>();
        for (WorkflowObjectPrototype recordPrototype : recordPrototypes) {
            ContextType__mdt contextType = contextTypesByObjectNames.get(recordPrototype.getPrototypeSObjectName());
            if (this.isContextTypeControlledByWorkflowPath(contextType)) {
                controlledPrototypes.add(recordPrototype);
            } else {
                permissionsByPrototypes.put(recordPrototype, CrudPermissions.all());
            }
        }

        List<WorkflowObjectPrototype> legacyPrototypes = new List<WorkflowObjectPrototype>();

        //TODO: implement new path logic
        for (WorkflowObjectPrototype prototype : controlledPrototypes) {
            if (isMeetingChildrenRecord(prototype.getPrototypeSObjectType())) {
                legacyPrototypes.add(prototype);
            }
        }

        permissionsByPrototypes.putAll(
                this.workflowPathAdapter.getCrudPermissionsByPrototypes(legacyPrototypes)
        );

        return permissionsByPrototypes;
    }

    private Map<Id, CrudPermissions> getCrudPermissionsByPathAssociations(Map<Id, WorkflowPathAssociation> pathAssociationsByRecordIds) {
        // TODO: Implement the logic for Context related entities
        return new Map<Id, CrudPermissions>();
    }

    private Boolean isMeetingChildrenRecord(SObjectType objectType) {
        return MEETING_CHILDREN_TYPES_CONTROLLED_BY_WORKFLOW_PATH.contains(objectType.getDescribe().getName());
    }

    private Boolean isMeetingChildrenRecord(Id recordId) {
        return this.isMeetingChildrenRecord(recordId.getSobjectType());
    }

    /**
     * Translate action labels using Action.labelApiName field
     *
     * @param actionsByNodeIds
     *
     * @return
     */
    public static Map<Id, List<Action>> translateActionLabels(Map<Id, List<Action>> actionsByNodeIds) {
        Set<String> labelApiNames = new Set<String>();
        for (List<Action> actionsList : actionsByNodeIds.values()) {
            labelApiNames.addAll(getLabelApiNamesByActions(actionsList));
        }
        if (labelApiNames.isEmpty()) return actionsByNodeIds;
        Map<String, String> translationMapping = new CustomLabelResolverService().resolve(new List<String>(labelApiNames));
        for (List<Action> actionsList : actionsByNodeIds.values()) {
            applyTranslationToLabels(actionsList, translationMapping);
        }
        return actionsByNodeIds;
    }

    /**
     * Translate action labels using Action.labelApiName field
     *
     * @param actionsByNodeIds
     *
     * @return
     */
    public static List<Action> translateActionLabels(List<Action> actions) {
        Set<String> labelApiNames = getLabelApiNamesByActions(actions);
        Map<String, String> translationMapping = new CustomLabelResolverService().resolve(new List<String>(labelApiNames));
        applyTranslationToLabels(actions, translationMapping);
        return actions;
    }

    private static void applyTranslationToLabels(List<Action> actions, Map<String, String> translationMapping) {
        for (Action singleAction : actions) {
            if (translationMapping.containsKey(singleAction.getLabelApiName())) {
                singleAction.setLabel(translationMapping.get(singleAction.getLabelApiName()));
            }
        }
    }

    private static Set<String> getLabelApiNamesByActions(List<Action> actions) {
        Set<String> labelApiNames = new Set<String>();
        for (Action action : actions) {
            if (action.getLabelApiName() != null) {
                labelApiNames.add(action.getLabelApiName());
            }
        }
        return labelApiNames;
    }

}
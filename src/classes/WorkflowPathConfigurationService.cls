public inherited sharing class WorkflowPathConfigurationService {

    @TestVisible
    private MeetingWorkFlowConfigurationDao workflowPathDao = new MeetingWorkFlowConfigurationDao();

    @TestVisible
    private ContextDao contextDao = new ContextDao();

    @TestVisible
    private ContextTypeDao contextTypeDao = new ContextTypeDao();

    @TestVisible
    private ActionDao actionDao = new ActionDao();

    public WorkflowConfigurationDto getWorkflowPathConfigurationByParams(WorkflowParamsDto params) {
        WorkflowConfigurationDto configurationDto = new WorkflowConfigurationDto();
        configurationDto.actions = this.getActions();
        configurationDto.contextTypes = this.getAllContextTypes();

        if (params.isUpdate()){
                    configurationDto.workflowPath = this.getWorkflowPathToUpdate(params);
        } else {
            configurationDto.workflowPath = this.getNewWorkflowPath(params);
            ContextType__mdt foundedContextType = contextTypeDao.getByObjectNameAndEmptyRelationship(params.sObjectName);
            if (foundedContextType != null) {
                WorkflowConfigurationDto.WorkflowContextTypeDto updatedContextType = new WorkflowConfigurationDto.WorkflowContextTypeDto(foundedContextType);
                configurationDto.workflowPath.contextTypeDeveloperName = updatedContextType.name;
                updatedContextType.isControlledByWorkflowPath = true;
                configurationDto.newContextTypes.add(updatedContextType);
                configurationDto.contextTypes = this.substituteContextType(configurationDto.contextTypes, updatedContextType);
            } else {
                WorkflowConfigurationDto.WorkflowContextTypeDto newContextType = this.getNewContextType(params);
                configurationDto.newContextTypes.add(newContextType);
                configurationDto.contextTypes.add(newContextType);
            }
        }

        return configurationDto;
    }

    public String deployWorkflow(WorkflowConfigurationDto configurationDto) {
        List<Metadata.CustomMetadata> metadataToDeploy = new List<Metadata.CustomMetadata>();

        metadataToDeploy.addAll(getWorkflowPathCustomMetadata(configurationDto.workflowPath));

        if (ArrayUtils.isNotEmpty(configurationDto.newActions)) {
            metadataToDeploy.addAll(this.getActionsCustomMetadata(configurationDto.newActions));
        }

        if (ArrayUtils.isNotEmpty(configurationDto.newContextTypes)) {
            metadataToDeploy.addAll(this.getContextTypesCustomMetadata(configurationDto.newContextTypes));
        }

        Metadata.DeployResult result = CustomMetadataService.deploy(metadataToDeploy, null);
        return result.id;
    }

    @TestVisible
    private WorkflowConfigurationDto.WorkflowContextTypeDto getNewContextType(WorkflowParamsDto params){
        WorkflowConfigurationDto.WorkflowContextTypeDto contextType = new WorkflowConfigurationDto.WorkflowContextTypeDto();
        contextType.name = params.sObjectName;
        contextType.label = params.sObjectName;
        contextType.isControlledByWorkflowPath = true;
        contextType.objectx = params.sObjectName;
        return contextType;
    }

    @TestVisible
    private List<Metadata.CustomMetadata> getActionsCustomMetadata(List<WorkflowConfigurationDto.WorkflowActionDto> actions) {
        List<Metadata.CustomMetadata> contextConditionsMetadata = new List<Metadata.CustomMetadata>();
        for (WorkflowConfigurationDto.WorkflowActionDto action : actions) {
            Metadata.CustomMetadata actionCustomMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                    action.getMetadataRecord(),
                    new Map<String, Object>{
                            Action__mdt.ContextType__c.getDescribe().getName() => action.contextTypeDeveloperName
                    }
            );
            actionCustomMetadata.fullName = Action__mdt.getSObjectType().getDescribe().getName() + '.' + action.name;
            contextConditionsMetadata.add(actionCustomMetadata);
        }
        return contextConditionsMetadata;
    }

    @TestVisible
    private List<Metadata.CustomMetadata> getContextTypesCustomMetadata(List<WorkflowConfigurationDto.WorkflowContextTypeDto> contextTypes) {
        List<Metadata.CustomMetadata> contextTypesMetadata = new List<Metadata.CustomMetadata>();
        for (WorkflowConfigurationDto.WorkflowContextTypeDto contextType : contextTypes) {
            Metadata.CustomMetadata contextTypeCustomMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                    contextType.getMetadataRecord()
            );
            contextTypeCustomMetadata.fullName = ContextType__mdt.getSObjectType().getDescribe().getName() + '.' + contextType.name;
            contextTypesMetadata.add(contextTypeCustomMetadata);
        }
        return contextTypesMetadata;
    }


    @TestVisible
    private List<Metadata.CustomMetadata> getContextsCustomMetadata(List<WorkflowConfigurationDto.WorkflowContextDto> contexts) {
        List<Metadata.CustomMetadata> contextsMetadata = new List<Metadata.CustomMetadata>();
        for (WorkflowConfigurationDto.WorkflowContextDto context : contexts) {
            Metadata.CustomMetadata contextCustomMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                    context.getMetadataRecord(),
                    new Map<String, Object>{
                            Context__mdt.WorkflowPathNode__c.getDescribe().getName() => context.workflowPathNodeDeveloperName,
                            Context__mdt.ContextType__c.getDescribe().getName() => context.contextTypeDeveloperName
                    }
            );
            contextCustomMetadata.fullName = Context__mdt.getSObjectType().getDescribe().getName() + '.' + context.name;
            contextsMetadata.add(contextCustomMetadata);

            if (ArrayUtils.isNotEmpty(context.contextConditions)) {
                contextsMetadata.addAll(this.getContextConditionsCustomMetadata(context.contextConditions));
            }

            if (ArrayUtils.isNotEmpty(context.contextActions)) {
                contextsMetadata.addAll(this.getContextActionsCustomMetadata(context.contextActions));
            }

            if (ArrayUtils.isNotEmpty(context.childContexts)) {
                contextsMetadata.addAll(this.getContextsCustomMetadata(context.childContexts));
            }
        }
        return contextsMetadata;
    }

    @TestVisible
    private List<Metadata.CustomMetadata> getContextConditionsCustomMetadata(List<WorkflowConfigurationDto.WorkflowContextConditionDto> contextConditions) {
        List<Metadata.CustomMetadata> contextConditionsMetadata = new List<Metadata.CustomMetadata>();
        for (WorkflowConfigurationDto.WorkflowContextConditionDto contextCondition : contextConditions) {
            Metadata.CustomMetadata contextConditionCustomMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                    contextCondition.getMetadataRecord(),
                    new Map<String, Object>{
                            ContextCondition__mdt.Context__c.getDescribe().getName() => contextCondition.contextDeveloperName
                    }
            );
            contextConditionCustomMetadata.fullName = ContextCondition__mdt.getSObjectType().getDescribe().getName() + '.' + contextCondition.name;
            contextConditionsMetadata.add(contextConditionCustomMetadata);
        }
        return contextConditionsMetadata;
    }

    @TestVisible
    private List<Metadata.CustomMetadata> getContextActionsCustomMetadata(List<WorkflowConfigurationDto.WorkflowContextActionDto> contextActions) {
        List<Metadata.CustomMetadata> contextActionsMetadata = new List<Metadata.CustomMetadata>();
        for (WorkflowConfigurationDto.WorkflowContextActionDto contextAction : contextActions) {
            Metadata.CustomMetadata contextActionCustomMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                    contextAction.getMetadataRecord(),
                    new Map<String, Object>{
                            ContextAction__mdt.Context__c.getDescribe().getName() => contextAction.contextDeveloperName,
                            ContextAction__mdt.Action__c.getDescribe().getName() => contextAction.actionDeveloperName
                    }
            );
            contextActionCustomMetadata.fullName = ContextAction__mdt.getSObjectType().getDescribe().getName() + '.' + contextAction.name;
            contextActionsMetadata.add(contextActionCustomMetadata);
        }
        return contextActionsMetadata;
    }

    @TestVisible
    private List<Metadata.CustomMetadata> getWorkflowPathNodesCustomMetadata(List<WorkflowConfigurationDto.WorkflowPathNodeDto> pathNodes) {
        List<Metadata.CustomMetadata> nodesCustomMetadata = new List<Metadata.CustomMetadata>();
        for (WorkflowConfigurationDto.WorkflowPathNodeDto pathNode : pathNodes) {
            Metadata.CustomMetadata nodeRecordMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                    pathNode.getMetadataRecord(),
                    new Map<String, Object>{
                            MeetingWorkFlowNodeConfiguration__mdt.MeetingWorkFlowConfiguration__c.getDescribe().getName() => pathNode.workflowPathDeveloperName
                    }
            );
            nodeRecordMetadata.fullName = MeetingWorkFlowNodeConfiguration__mdt.getSObjectType().getDescribe().getName() + '.' + pathNode.name;
            nodesCustomMetadata.add(nodeRecordMetadata);

            nodesCustomMetadata.addAll(this.getContextsCustomMetadata(pathNode.contexts));
        }
        return nodesCustomMetadata;
    }

    @TestVisible
    private List<Metadata.CustomMetadata> getWorkflowPathCustomMetadata(WorkflowConfigurationDto.WorkflowPathDto workflowPath) {
        List<Metadata.CustomMetadata> metadataToDeploy = new List<Metadata.CustomMetadata>();
        Metadata.CustomMetadata workflowPathCustomMetadata = CustomMetadataService.generateMetadataRecordToCreate(
                workflowPath.getMetadataRecord(),
                new Map<String, Object>{
                        MeetingWorkFlowConfiguration__mdt.ContextType__c.getDescribe().getName() => workflowPath.contextTypeDeveloperName
                }
        );
        workflowPathCustomMetadata.fullName = MeetingWorkFlowConfiguration__mdt.getSObjectType().getDescribe().getName() + '.' + workflowPath.name;
        metadataToDeploy.add(workflowPathCustomMetadata);

        if (ArrayUtils.isNotEmpty(workflowPath.nodes)) {
            metadataToDeploy.addAll(this.getWorkflowPathNodesCustomMetadata(workflowPath.nodes));
        }
        return metadataToDeploy;
    }

    @TestVisible
    private List<WorkflowConfigurationDto.WorkflowActionDto> getActions(){
        List<WorkflowConfigurationDto.WorkflowActionDto> actions = new List<WorkflowConfigurationDto.WorkflowActionDto>();
        for (Action__mdt action : this.actionDao.getAllWithContextTypeDevName()) {
            actions.add(new WorkflowConfigurationDto.WorkflowActionDto(action));
        }
        return actions;
    }

    @TestVisible
    private WorkflowConfigurationDto.WorkflowPathDto getNewWorkflowPath(WorkflowParamsDto params){
        WorkflowConfigurationDto.WorkflowPathDto workflowPathDto = new WorkflowConfigurationDto.WorkflowPathDto();
        workflowPathDto.label = params.masterLabel;
        workflowPathDto.controllingField = params.controllingField;
        workflowPathDto.recordType = params.recordType;
        workflowPathDto.name = params.developerName;
        workflowPathDto.objectName = params.sObjectName;
        workflowPathDto.recordTypeId = RecordTypeUtils.getIdByDeveloperName(params.sObjectName, params.recordType);
        return workflowPathDto;
    }

    @TestVisible
    private List<WorkflowConfigurationDto.WorkflowContextTypeDto> getAllContextTypes() {
        List<WorkflowConfigurationDto.WorkflowContextTypeDto> contextTypeDtos = new List<WorkflowConfigurationDto.WorkflowContextTypeDto>();
        for (ContextType__mdt contextType : contextTypeDao.getAll()) {
            contextTypeDtos.add(new WorkflowConfigurationDto.WorkflowContextTypeDto(contextType));
        }
        return contextTypeDtos;
    }

    private WorkflowConfigurationDto.WorkflowPathDto getWorkflowPathToUpdate(WorkflowParamsDto params) {
        MeetingWorkFlowConfiguration__mdt workflowPath = workflowPathDao.getWorkflowPathWithAllChildByDevName(params.developerName);
        WorkflowConfigurationDto.WorkflowPathDto workflowPathDto = new WorkflowConfigurationDto.WorkflowPathDto(workflowPath);
        workflowPathDto.label = params.masterLabel;

        Set<Id> pathNodeIds = new Map<Id, MeetingWorkFlowNodeConfiguration__mdt>(workflowPath.MeetingWorkFlowNodeConfigurations__r).keySet();
        if (pathNodeIds.isEmpty()) {
            return workflowPathDto;
        }

        List<Context__mdt> contexts = this.contextDao.getFirstLevelContextsWithChildByPathNodeIds(pathNodeIds);

        List<Context__mdt> childContexts = this.contextDao.getContextsWithChildByParents(
               new Set<String>(BaseUtilities.mapToStrings(contexts, Context__mdt.DeveloperName.getDescribe().getName()))
        );

        Map<Object, List<Object>> childContextsByParentIds = CollectionUtilities.asGrouppedMap(
                childContexts,
                Context__mdt.ParentContext__c.getDescribe().getName()
        );

        Map<Id, List<SObject>> contextsByWorkflowPathNodeIds = CollectionUtilities.indexById(
                contexts,
                Context__mdt.WorkflowPathNode__c.getDescribe().getName()
        );

        for (WorkflowConfigurationDto.WorkflowPathNodeDto pathNodeDto : workflowPathDto.nodes) {
            if (contextsByWorkflowPathNodeIds.containsKey(pathNodeDto.id)) {
                for (Context__mdt context : (List<Context__mdt>) contextsByWorkflowPathNodeIds.get(pathNodeDto.id)) {
                    WorkflowConfigurationDto.WorkflowContextDto contextDto = new WorkflowConfigurationDto.WorkflowContextDto(context);
                    if (childContextsByParentIds.containsKey(contextDto.name)) {
                        contextDto.setChildContexts(getChildContexts(childContextsByParentIds.get(contextDto.name)));
                    }
                    pathNodeDto.contexts.add(contextDto);
                }
            }
        }

        return workflowPathDto;
    }

    @TestVisible
    private List<Context__mdt> getChildContexts(List<Object> objects){
        List<Context__mdt> childContextsForRecord = new List<Context__mdt>();
        for (Object obj : objects) {
            childContextsForRecord.add((Context__mdt)obj);
        }
        return childContextsForRecord;
    }

    private List<WorkflowConfigurationDto.WorkflowContextTypeDto> substituteContextType(
            List<WorkflowConfigurationDto.WorkflowContextTypeDto> contextTypes,
            WorkflowConfigurationDto.WorkflowContextTypeDto contextTypeToSubstitute
    ) {
        List<WorkflowConfigurationDto.WorkflowContextTypeDto> result = new List<WorkflowConfigurationDto.WorkflowContextTypeDto>(contextTypes);
        Integer index = 0;
        for (WorkflowConfigurationDto.WorkflowContextTypeDto contextType : result) {
            if (contextType.name == contextTypeToSubstitute.name) {
                break;
            }
            index++;
        }
        result.remove(index);
        result.add(contextTypeToSubstitute);
        return result;
    }

    public class WorkflowParamsDto {

        @AuraEnabled
        public String recordType;

        @AuraEnabled
        public String controllingField;

        @AuraEnabled
        public String masterLabel;

        @AuraEnabled
        public String developerName;

        @AuraEnabled
        public String sObjectName;

        public Boolean isUpdate() {
            return this.recordType == null
                    && this.controllingField == null
                    && this.sObjectName == null;
        }
    }
}
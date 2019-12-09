public with sharing class WorkflowConfigurationDto {

    @AuraEnabled
    public WorkflowPathDto workflowPath;

    @AuraEnabled
    public List<WorkflowActionDto> actions;

    @AuraEnabled
    public List<WorkflowActionDto> newActions = new List<WorkflowConfigurationDto.WorkflowActionDto>();

    @AuraEnabled
    public List<WorkflowContextTypeDto> contextTypes;

    @AuraEnabled
    public List<WorkflowContextTypeDto> newContextTypes = new List<WorkflowConfigurationDto.WorkflowContextTypeDto>();

    public class WorkflowPathDto {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String controllingField;

        @AuraEnabled
        public String status;

        @AuraEnabled
        public String objectName;

        @AuraEnabled
        public String recordType;

        @AuraEnabled
        public Id recordTypeId;

        @AuraEnabled
        public Id contextType;

        @AuraEnabled
        public String contextTypeDeveloperName;

        @AuraEnabled
        public List<WorkflowPathNodeDto> nodes;

        private MeetingWorkFlowConfiguration__mdt record;

        public WorkflowPathDto(){}

        public WorkflowPathDto(MeetingWorkFlowConfiguration__mdt record) {
            this.record = record;
            this.id = record.Id;
            this.label = record.MasterLabel;
            this.name = record.DeveloperName;
            this.status = record.Status__c;
            this.recordType = record.MeetingRecordTypeName__c.split('-')[1];

            this.contextType = record.ContextType__c;
            this.contextTypeDeveloperName = record.ContextType__r.DeveloperName;
            this.controllingField = record.ControllingField__c;
            this.objectName = record.ContextType__r.Object__c;
            this.recordTypeId = RecordTypeUtils.getIdByDeveloperName(this.objectName, this.recordType);
            this.nodes = this.createWorkflowPathNodes(record);
        }

        public MeetingWorkFlowConfiguration__mdt getMetadataRecord() {
            if (this.record == null) {
                this.record = new MeetingWorkFlowConfiguration__mdt();
            }
            this.record.Id = this.id;
            this.record.MasterLabel = this.label;
            this.record.DeveloperName = this.name;
            this.record.Status__c = this.status;
            this.record.MeetingRecordTypeName__c = this.objectName + '-' + recordType;
            this.record.ControllingField__c = this.controllingField;
            this.record.ContextType__c = this.contextType;
            return this.record;
        }

        private List<WorkflowPathNodeDto> createWorkflowPathNodes(MeetingWorkFlowConfiguration__mdt workflow) {
            List<WorkflowPathNodeDto> nodes = new List<WorkflowPathNodeDto>();
            for (MeetingWorkFlowNodeConfiguration__mdt nodeMdt : workflow.MeetingWorkFlowNodeConfigurations__r) {
                nodes.add(new WorkflowPathNodeDto(nodeMdt));
            }
            return nodes;
        }
    }

    public class WorkflowPathNodeDto {
        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public Id workflowPathId;

        @AuraEnabled
        public String workflowPathDeveloperName;

        @AuraEnabled
        public String controllingFieldValue;

        @AuraEnabled
        public List<WorkflowContextDto> contexts;

        private MeetingWorkFlowNodeConfiguration__mdt record;

        public WorkflowPathNodeDto(){}

        public WorkflowPathNodeDto(MeetingWorkFlowNodeConfiguration__mdt node) {
            this.record = node;
            this.id = node.Id;
            this.label = node.MasterLabel;
            this.name = node.DeveloperName;
            this.workflowPathId = node.MeetingWorkFlowConfiguration__c;
            this.workflowPathDeveloperName = node.MeetingWorkFlowConfiguration__r.DeveloperName;
            this.controllingFieldValue = node.MeetingStatus__c;
            this.contexts = this.createContexts();
        }

        public MeetingWorkFlowNodeConfiguration__mdt getMetadataRecord() {
            if (this.record == null) {
                this.record = new MeetingWorkFlowNodeConfiguration__mdt();
            }
            this.record.Id = this.id;
            this.record.DeveloperName = this.name;
            this.record.MasterLabel = this.label;
            this.record.MeetingWorkFlowConfiguration__c = this.workflowPathId;
            this.record.MeetingStatus__c = this.controllingFieldValue;
            return this.record;
        }

        private List<WorkflowContextDto> createContexts() {
            List<WorkflowContextDto> contextDtos = new List<WorkflowContextDto>();
            for (Context__mdt context : this.record.Contexts__r) {
                contextDtos.add(new WorkflowContextDto(context));
            }
            return contextDtos;
        }
    }

    public class WorkflowContextDto{
        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public Boolean create;

        @AuraEnabled
        public Boolean edit;

        @AuraEnabled
        public Boolean deletex;

        @AuraEnabled
        public String type;

        @AuraEnabled
        public String parentContext;

        @AuraEnabled
        public Id workflowPathNode;

        @AuraEnabled
        public String workflowPathNodeDeveloperName;

        @AuraEnabled
        public Id contextType;

        @AuraEnabled
        public String contextTypeDeveloperName;

        @AuraEnabled
        public List<WorkflowContextConditionDto> contextConditions;

        @AuraEnabled
        public List<WorkflowContextActionDto> contextActions;

        @AuraEnabled
        public List<WorkflowContextDto> childContexts;

        private Context__mdt record;

        public WorkflowContextDto(){}

        public WorkflowContextDto(Context__mdt record){
            this.record = record;
            this.id = record.Id;
            this.name = record.DeveloperName;
            this.label = record.MasterLabel;
            this.create = record.Create__c;
            this.edit = record.Edit__c;
            this.deletex = record.Delete__c;
            this.type = record.Type__c;
            this.parentContext = record.ParentContext__c;
            this.workflowPathNode = record.WorkflowPathNode__c;
            this.workflowPathNodeDeveloperName = record.WorkflowPathNode__r.DeveloperName;
            this.contextType = record.ContextType__c;
            this.contextTypeDeveloperName = record.ContextType__r.DeveloperName;
            this.contextConditions = this.createWorkflowContextConditions();
            this.contextActions = this.createWorkflowContextActions();
        }

        public Context__mdt getMetadataRecord(){
            if (this.record == null) {
                this.record = new Context__mdt();
            }
            this.record.Id = this.id;
            this.record.DeveloperName = this.name;
            this.record.MasterLabel = this.label;
            this.record.Create__c = this.create;
            this.record.Delete__c = this.deletex;
            this.record.Edit__c = this.edit;
            this.record.Type__c = this.type;
            this.record.ParentContext__c = this.parentContext;
            this.record.WorkflowPathNode__c = this.workflowPathNode;
            this.record.ContextType__c = this.contextType;
            return this.record;
        }

        public void setChildContexts(List<Context__mdt> childContexts){
            this.childContexts = new List<WorkflowConfigurationDto.WorkflowContextDto>();
            for (Context__mdt context : childContexts) {
                this.childContexts.add(new WorkflowConfigurationDto.WorkflowContextDto(context));
            }
        }

        private List<WorkflowContextConditionDto> createWorkflowContextConditions(){
            List<WorkflowContextConditionDto> conditionDtos = new List<WorkflowContextConditionDto>();
            for (ContextCondition__mdt contextCondition : this.record.ContextConditions__r) {
                conditionDtos.add(new WorkflowContextConditionDto(contextCondition));
            }
            return conditionDtos;
        }

        private List<WorkflowContextActionDto> createWorkflowContextActions(){
            List<WorkflowContextActionDto> workflowContextActionDtos = new List<WorkflowContextActionDto>();
            for (ContextAction__mdt contextAction : this.record.ContextActions__r) {
                workflowContextActionDtos.add(new WorkflowContextActionDto(contextAction));
            }
            return workflowContextActionDtos;
        }
    }

    public class WorkflowContextConditionDto{

        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String field;

        @AuraEnabled
        public String operator;

        @AuraEnabled
        public String value;

        @AuraEnabled
        public Id context;

        @AuraEnabled
        public String contextDeveloperName;

        private ContextCondition__mdt record;

        public WorkflowContextConditionDto(){}

        public WorkflowContextConditionDto(ContextCondition__mdt record){
            this.record = record;
            this.id = record.Id;
            this.label = record.MasterLabel;
            this.name = record.DeveloperName;
            this.field = record.Field__c;
            this.operator = record.Operator__c;
            this.value = record.Value__c;
            this.context = record.Context__c;
            this.contextDeveloperName = record.Context__r.DeveloperName;
        }

        public ContextCondition__mdt getMetadataRecord(){
            if (this.record == null) {
                this.record = new ContextCondition__mdt();
            }
            this.record.Id = this.id;
            this.record.DeveloperName = this.name;
            this.record.MasterLabel = this.label;
            this.record.Field__c = this.field;
            this.record.Operator__c = this.operator;
            this.record.Value__c = this.value;
            this.record.Context__c = this.context;
            return this.record;
        }
    }

    public class WorkflowContextActionDto{

        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public Id action;

        @AuraEnabled
        public String actionDeveloperName;

        @AuraEnabled
        public Id context;

        @AuraEnabled
        public String contextDeveloperName;

        @AuraEnabled
        public Double order;

        private ContextAction__mdt record;

        public WorkflowContextActionDto(){}

        public WorkflowContextActionDto(ContextAction__mdt record){
            this.record = record;
            this.id = record.Id;
            this.name = record.DeveloperName;
            this.label = record.MasterLabel;
            this.action = record.Action__c;
            this.actionDeveloperName = record.Action__r.DeveloperName;
            this.context = record.Context__c;
            this.contextDeveloperName = record.Context__r.DeveloperName;
            this.order = record.Order__c;
        }

        public ContextAction__mdt getMetadataRecord(){
            if (this.record == null) {
                this.record = new ContextAction__mdt();
            }
            this.record.Id = this.id;
            this.record.DeveloperName = this.name;
            this.record.MasterLabel = this.label;
            this.record.Context__c = this.context;
            this.record.Action__c = this.action;
            this.record.Order__c = this.order;
            return this.record;
        }
    }

    public class WorkflowActionDto{

        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public Id contextType;

        @AuraEnabled
        public String contextTypeDeveloperName;

        @AuraEnabled
        public String field;

        @AuraEnabled
        public String newValue;

        @AuraEnabled
        public String parameters;

        @AuraEnabled
        public String type;

        private Action__mdt record;

        public WorkflowActionDto(){}

        public WorkflowActionDto(Action__mdt action){
            this.record = record;
            this.id = action.Id;
            this.label = action.MasterLabel;
            this.name = action.DeveloperName;
            this.type = action.Type__c;
            this.newValue = action.NewValue__c;
            this.contextType = action.ContextType__c;
            this.contextTypeDeveloperName = action.ContextType__r.DeveloperName;
            this.field = action.Field__c;
            this.parameters = action.Parameters__c;
        }

        public Action__mdt getMetadataRecord(){
            if (this.record == null) {
                this.record = new Action__mdt();
            }
            this.record.Id = this.id;
            this.record.DeveloperName = this.name;
            this.record.MasterLabel = this.label;
            this.record.ContextType__c = this.contextType;
            this.record.Field__c = this.field;
            this.record.NewValue__c = this.newValue;
            this.record.Type__c = this.type;
            this.record.Parameters__c = this.parameters;
            return this.record;
        }
    }

    public class WorkflowContextTypeDto{
        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public Boolean isControlledByWorkflowPath;

        @AuraEnabled
        public String objectx;

        @AuraEnabled
        public String relationship;

        private ContextType__mdt record;

        public WorkflowContextTypeDto(){}

        public WorkflowContextTypeDto(ContextType__mdt record){
            this.record = record;
            this.id = record.Id;
            this.name = record.DeveloperName;
            this.label = record.MasterLabel;
            this.isControlledByWorkflowPath = record.IsControlledByWorkflowPath__c;
            this.objectx = record.Object__c;
            this.relationship = record.Relationship__c;
        }

        public ContextType__mdt getMetadataRecord(){
            if (this.record == null) {
                this.record = new ContextType__mdt();
            }
            this.record.Id = this.id;
            this.record.MasterLabel = this.label;
            this.record.DeveloperName = this.name;
            this.record.IsControlledByWorkflowPath__c = this.isControlledByWorkflowPath;
            this.record.Object__c = this.objectx;
            this.record.Relationship__c = this.relationship;
            return this.record;
        }
    }
}
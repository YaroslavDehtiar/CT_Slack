public inherited sharing class WorkflowPath {
    private static final String ACTIVE_STATUS = 'Active';
    private static final String MEETING_OBJECT_NAME = SObjectType.Meeting__c.getName();
    private static final String MEETING_STATUS_FIELD_NAME = SObjectType.Meeting__c.fields.Status__c.getName();

    @AuraEnabled
    public String id { private get; private set; }
    @AuraEnabled
    public String label { private get; private set; }
    @AuraEnabled
    public String name { private get; private set; }
    @AuraEnabled
    public String controllingField { private get; private set; }
    @AuraEnabled
    public String status { private get; private set; }
    @AuraEnabled
    public String recordType { private get; private set; }
    @AuraEnabled
    public String objectName { private get; private set; }
    @AuraEnabled
    public ContextType__mdt contextType { private get; private set; }
    @AuraEnabled
    public List<WorkflowPathNode> nodes { private get; private set; }

    private MeetingWorkFlowConfiguration__mdt record;
    private WorkflowPathObjectRecordType objectRecordType;

    public WorkflowPath(MeetingWorkFlowConfiguration__mdt workflow) {
        this.record = workflow;
        this.objectRecordType = WorkflowPathObjectRecordType.byUsing(workflow);

        this.id = workflow.Id;
        this.label = workflow.MasterLabel;
        this.name = workflow.DeveloperName;
        this.status = workflow.Status__c;
        this.recordType = this.objectRecordType.getRecordType();
        this.objectName = this.objectRecordType.getObjectName();
        this.contextType = this.getContextType(workflow);
        this.controllingField = this.createControllingField(workflow);
        this.nodes = this.createWorkflowPathNodes(workflow);
    }

    public Id getId() {
        return this.id;
    }

    public String getLabel() {
        return this.label;
    }

    public String getName() {
        return this.name;
    }

    public String getControllingField() {
        return this.controllingField;
    }

    public String getStatus() {
        return this.status;
    }

    public String getRecordType() {
        return this.recordType;
    }

    public String getObjectName() {
        return this.objectName;
    }

    public ContextType__mdt getContextType() {
        return this.contextType;
    }

    public List<WorkflowPathNode> getNodes() {
        return this.nodes;
    }

    public WorkflowPathObjectRecordType getObjectRecordType() {
        return this.objectRecordType;
    }

    public Boolean isLegacy() {
        return this.contextType == null;
    }

    public Boolean isActive() {
        return this.status == ACTIVE_STATUS;
    }


    private List<WorkflowPathNode> createWorkflowPathNodes(MeetingWorkFlowConfiguration__mdt workflow) {
        List<WorkflowPathNode> nodes = new List<WorkflowPathNode>();

        for(String picklistOption : ObjectUtilities.getActivePicklistValues(objectName, controllingField)){
            for (MeetingWorkFlowNodeConfiguration__mdt nodeMdt : workflow.MeetingWorkFlowNodeConfigurations__r) {
                if(nodeMdt.MeetingStatus__c == picklistOption){
                    nodes.add(new WorkflowPathNode(nodeMdt));
                }
            }
        }

        return nodes;
    }

    private String createControllingField(MeetingWorkFlowConfiguration__mdt workflow) {
        return this.isLegacy() ? MEETING_STATUS_FIELD_NAME : workflow.ControllingField__c;
    }

    private ContextType__mdt getContextType(MeetingWorkFlowConfiguration__mdt workflow) {
        return JSON.serialize(workflow).contains('ContextType__r') ? workflow.ContextType__r : null;
    }
}
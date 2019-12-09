public inherited sharing class WorkflowPathNode {
    @AuraEnabled
    public Id id { private get; private set; }
    @AuraEnabled
    public String label { private get; private set; }
    @AuraEnabled
    public String name { private get; private set; }
    @AuraEnabled
    public Id workflowPathId { private get; private set; }
    @AuraEnabled
    public String controllingFieldValue { private get; private set; }
    @AuraEnabled
    public List<Action> actions { private get; private set; }

    private MeetingWorkFlowNodeConfiguration__mdt record;

    public WorkflowPathNode(MeetingWorkFlowNodeConfiguration__mdt node) {
        this.record = node;

        this.id = node.Id;
        this.label = node.MasterLabel;
        this.name =  node.DeveloperName;
        this.workflowPathId = node.MeetingWorkFlowConfiguration__c;
        this.controllingFieldValue = node.MeetingStatus__c;
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

    public Id getWorkflowPathId() {
        return this.workflowPathId;
    }

    public String getControllingFieldValue() {
        return this.controllingFieldValue;
    }

    public List<Action> getActions() {
        return this.actions;
    }

    public void setActions(List<Action> actions) {
        this.actions = actions;
    }
}
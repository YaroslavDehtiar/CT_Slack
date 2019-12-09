public class WorkflowPathAssociation {
    @AuraEnabled
    public Id recordId { private get; private set; }
    @AuraEnabled
    public WorkflowPath path { private get; private set; }
    @AuraEnabled
    public WorkflowPathNode activePathNode { private get; private set; }

    public WorkflowPathAssociation(Id recordId, WorkflowPath path, WorkflowPathNode activePathNode) {
        this.recordId = recordId;
        this.path = path;
        this.activePathNode = activePathNode;
    }

    public Id getRecordId() {
        return this.recordId;
    }

    public WorkflowPath getPath() {
        return this.path;
    }

    public WorkflowPathNode getActivePathNode() {
        return this.activePathNode;
    }
}
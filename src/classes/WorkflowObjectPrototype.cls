public inherited sharing class WorkflowObjectPrototype {

    private Id parentObjectId;
    private SObject record;
    private String recordTypeDeveloperName;

    public Id getParentObjectId() {
        return this.parentObjectId;
    }

    public String getRecordTypeDeveloperName() {
        return this.recordTypeDeveloperName;
    }

    public SObjectType getPrototypeSObjectType() {
        return this.record.getSObjectType();
    }

    public String getPrototypeSObjectName() {
        return this.getPrototypeSObjectType().getDescribe().getName();
    }

    public WorkflowObjectPrototype(SObject record, String recordTypeDeveloperName, Id parentObjectId) {
        this.record = record;
        this.recordTypeDeveloperName = recordTypeDeveloperName;
        this.parentObjectId = parentObjectId;
    }

    public WorkflowObjectPrototype(SObject record, Id parentObjectId) {
        this.record = record;
        this.parentObjectId = parentObjectId;
    }

    public Boolean equals(Object obj) {
        if (super.equals(obj)) return true;
        if (!(obj instanceof WorkflowObjectPrototype)) return false;

        WorkflowObjectPrototype comparedPrototype = (WorkflowObjectPrototype) obj;

        return (this.parentObjectId == comparedPrototype.parentObjectId
                && this.record == comparedPrototype.record
                && this.recordTypeDeveloperName == comparedPrototype.recordTypeDeveloperName);
    }

    public override Integer hashCode() {
        Integer prime = 31;
        Integer result = 1;
        result = prime * result + ((this.parentObjectId == null) ? 0 : String.valueOf(this.parentObjectId).hashCode());
        result = prime * result + ((this.recordTypeDeveloperName == null) ? 0 : this.recordTypeDeveloperName.hashCode());
        result = prime * result + ((this.record == null) ? 0 : System.hashCode(this.record));
        return result;
    }

}
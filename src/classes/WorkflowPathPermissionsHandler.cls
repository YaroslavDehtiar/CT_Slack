public with sharing class WorkflowPathPermissionsHandler extends TriggerService.Handler {

    @TestVisible
    private static WorkflowPathService workflowPathService = new WorkflowPathService();

    public override void afterInsert(TriggerService.Context cont) {
        this.checkOperationPermissions(cont.newMap, PermissionDao.Operation.DML_INSERT);
    }

    public override void beforeUpdate(TriggerService.Context cont) {
        this.checkOperationPermissions(cont.newMap, PermissionDao.Operation.DML_UPDATE);
    }

    public override void beforeDelete(TriggerService.Context cont) {
        this.checkOperationPermissions(cont.oldMap, PermissionDao.Operation.DML_DELETE);
    }

    public override Boolean skipExecution(TriggerService.Context cont) {
        if(cont.isSelect){
            return true;
        }
        String objectName = cont.getSObjectType().getDescribe().name;
        return !workflowPathService.isObjectControlledByWorkflowPath(objectName);
    }

    private void checkOperationPermissions(Map<Id, SObject> recordsByIds, PermissionDao.Operation operation) {

        Map<Id, CrudPermissions> permissionsByRecordIds = workflowPathService.getCrudPermissions(recordsByIds.keySet());

        for (Id recordId : recordsByIds.keySet()) {
            SObject record = recordsByIds.get(recordId);
            CrudPermissions permissions = permissionsByRecordIds.get(recordId);

            if (permissions == null) {
                this.addPermissionNotFoundErrorMessage(record);
            } else {
                checkOperationPermissions(record, permissions, operation);
            }
        }
    }

    private void checkOperationPermissions(
            SObject record,
            CrudPermissions permissions,
            PermissionDao.Operation operation
    ) {
        if (operation == PermissionDao.Operation.DML_INSERT && permissions.isNotCreatable()) {
            this.addErrorMessage(record, Label.Workflows_SObjectCanNotBeCreated);
        } else if (operation == PermissionDao.Operation.DML_UPDATE && permissions.isNotEditable()) {
            this.addErrorMessage(record, Label.Workflows_SObjectCanNotBeEdited);
        } else if (operation == PermissionDao.Operation.DML_DELETE && permissions.isNotDeletable()) {
            this.addErrorMessage(record, Label.Workflows_SObjectCanNotBeDeleted);
        }
    }

    private void addPermissionNotFoundErrorMessage(SObject record){
        String sObjectLabel = this.getSObjectLabel(record);
        String permissionNotFoundErrorMessage =
                this.formatLabel(
                        Label.Workflows_InvalidWorkFlowPathConfiguration,
                        new String[]{ sObjectLabel }
                );
        record.addError(permissionNotFoundErrorMessage);
    }

    private void addErrorMessage(SObject record, String label){
        String sObjectLabel = this.getSObjectLabel(record);
        String errorMessage = this.formatLabel(
                    label,
                    new String[]{ sObjectLabel }
            );
        record.addError(errorMessage);
    }

    private String getSObjectLabel(SObject record){
        return record.getSObjectType().getDescribe().label;
    }

    private String formatLabel(String label, List<String> arguments){
        return String.format(label, arguments);
    }

}
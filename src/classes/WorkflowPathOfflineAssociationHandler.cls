public with sharing class WorkflowPathOfflineAssociationHandler extends TriggerService.Handler {

    private static WorkflowPathOfflineAssociationService service = new WorkflowPathOfflineAssociationService();

    public override void beforeInsert(TriggerService.Context cont) {
        service.syncObjectWorkflowPathAssociations(cont.newList);
    }

}
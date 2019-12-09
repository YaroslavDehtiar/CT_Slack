public with sharing class WorkflowPathAssociationHandler extends TriggerService.Handler {

    private static final String OFFLINE_UNIQUE_ID_FIELD = 'OfflineUniqueId__c';
    @TestVisible
    private static WorkflowPathAssociationService service = new WorkflowPathAssociationService();
    private ActionResultService resultService = new ActionResultService();
    @TestVisible
    private static WorkflowPathService workflowPathService = new WorkflowPathService();


    /**
	* Skip execution
	*/
    public override Boolean skipExecution(TriggerService.Context context) {
        if (context.isSelect){
            return true;
        }
        String objectName = context.getSObjectType().getDescribe().name;
        return !workflowPathService.isObjectControlledByWorkflowPath(objectName);
    }

    /**
   * After insert hook
   */
    public override void afterInsert(TriggerService.Context context) {
        Set<Id> ids = this.getNotOfflineRecords(context.newMap);
        ActionResult actionResult;
        if (!ids.isEmpty()) {
            actionResult = service.assignWorkflowPathToRecords(ids);
            resultService.addErrors(context.newMap, actionResult.getErrorsByRecordIds());
        }
    }

    private Set<Id> getNotOfflineRecords(Map<Id, SObject> records) {
        Set<Id> ids = new Set<Id>();
        for (Id recordId : records.keySet()) {
            if (records.get(recordId).get(OFFLINE_UNIQUE_ID_FIELD) == null) {
                ids.add(recordId);
            }
        }

        return ids;
    }
}
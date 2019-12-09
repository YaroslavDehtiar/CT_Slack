public with sharing class WorkflowPathController {
    @TestVisible
    private static WorkflowPathService workflowPathService = new WorkflowPathService();
    @TestVisible
    private static WorkflowPathActionService workflowPathActionService = new WorkflowPathActionService();
    @TestVisible
    private static MetadataDeletionService metadataDeletionService = new MetadataDeletionService();

    @AuraEnabled
    public static WorkflowPathAssociation getPathAssociation(Id recordId) {
        try {
            return workflowPathService.getPathAssociationsByRecordIds(new Set<Id>{
                    recordId
            }).get(recordId);
        } catch (Exception ex) {
            LogService.getLogger().logException(ex, 'WorkflowPathController.getPathAssociation()');
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void updateRecord(Id recordId, String fieldName, String newValue) {
        try {
            SObject record = ObjectUtilities.newSobjectInstance(String.valueOf(recordId.getSobjectType()),
                    new Map<String, Object>{
                            'Id' => recordId,
                            fieldName => newValue
                    });
            DataLayer.updateSingle(record);
        } catch (DmlException e) {
            LogService.getLogger().logException(e, 'WorkflowPathController.updateRecord()');
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            LogService.getLogger().logException(e, 'WorkflowPathController.updateRecord()');
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ActionResult publishPlatformEvent(Id recordId, String eventName, Object fieldValues) {
        try {

            Map<String, Object> params = BaseUtilities.toPropertyMap(fieldValues);
            return workflowPathActionService.publishPlatformEvent(recordId, eventName, params);

        } catch (Exception e) {
            LogService.getLogger().logException(e, 'WorkflowPathController.publishPlatformEvent()');
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteRecord(String objectApiName, String developerName) {
        try {
            metadataDeletionService.deleteMetadataHierarchy(objectApiName, developerName);
        } catch(Exception e) {
            LogService.getLogger().logException(e, 'WorkflowPathController.deleteRecord()');
            throw new AuraHandledException(e.getMessage());
        }
    }

}
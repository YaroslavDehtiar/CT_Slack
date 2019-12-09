public inherited sharing class WorkflowContextConfigurationController {

    @TestVisible
    private static MetadataDeletionService metadataDeletionService = new MetadataDeletionService();

    @AuraEnabled
    public static void deleteWorkflowContextHierarchy(String objectApiName, String developerName) {
        try {
            metadataDeletionService.deleteMetadataHierarchy(objectApiName, developerName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
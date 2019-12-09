public with sharing class WorkflowPathConfigurationController {

    @TestVisible
    private static WorkflowPathConfigurationService service = new WorkflowPathConfigurationService();

    @AuraEnabled
    public static WorkflowConfigurationDto getWorkflow(String params) {
        try {
            WorkflowPathConfigurationService.WorkflowParamsDto paramsDto = (WorkflowPathConfigurationService.WorkflowParamsDto)JSON.deserialize(
                    params,
                    WorkflowPathConfigurationService.WorkflowParamsDto.class
            );
            return service.getWorkflowPathConfigurationByParams(paramsDto);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String deployWorkflowPath(String configuration){
        try {
            WorkflowConfigurationDto configurationDto = (WorkflowConfigurationDto) JSON.deserialize(configuration, WorkflowConfigurationDto.class);
            return service.deployWorkflow(configurationDto);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
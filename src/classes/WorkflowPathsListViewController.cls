public with sharing class WorkflowPathsListViewController {

    private static final String PATH_STATUS_ACTIVE = 'Active';
    private static final String DASH_SEPARATOR = '-';
    private static final String DEPLOYMENT_STATUS_DEPLOYED = 'Deployed';

    @TestVisible
    private static MeetingWorkFlowConfigurationDao meetingPathDao = new MeetingWorkFlowConfigurationDao();

    @AuraEnabled
    public static WorkflowPaths getWorkflowPaths() {
        try {
            List<MeetingWorkFlowConfiguration__mdt> configurations = meetingPathDao.getAllWithContextType();

            List<WorkflowPath> paths = new List<WorkflowPath>();
            for (MeetingWorkFlowConfiguration__mdt configuration : configurations) {
                paths.add(new WorkflowPath(configuration));
            }

            return new WorkflowPaths(paths);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    public class WorkflowPaths {

        @AuraEnabled
        public List<WorkflowPath> paths = new List<WorkflowPath>();

        @AuraEnabled
        public String namespace = PackageUtilities.namespace;

        public WorkflowPaths(List<WorkflowPath> paths) {
            this.paths = paths;
        }
    }

    public class WorkflowPath {

        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String developerName;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String contextType;

        @AuraEnabled
        public String recordTypeName;

        @AuraEnabled
        public String controllingField;

        @AuraEnabled
        public String activeStatus;

        @AuraEnabled
        public String deploymentStatus;

        public WorkflowPath(MeetingWorkFlowConfiguration__mdt configuration) {
            this.id = configuration.Id;
            this.developerName = configuration.DeveloperName;
            this.label = configuration.MasterLabel;
            this.contextType = configuration.ContextType__r.MasterLabel;
            this.recordTypeName = this.formatRecordTypeName(configuration.MeetingRecordTypeName__c);
            this.controllingField = configuration.ControllingField__c;
            this.activeStatus = configuration.Status__c;
            this.deploymentStatus = DEPLOYMENT_STATUS_DEPLOYED;
        }

        private String formatRecordTypeName(String name) {
            if (String.isEmpty(name) || !name.contains(DASH_SEPARATOR)) return name;
            return name.substringAfter(DASH_SEPARATOR);
        }
    }
}
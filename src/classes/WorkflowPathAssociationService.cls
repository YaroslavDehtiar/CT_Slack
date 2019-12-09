/**
 * The service provides Workflow Path to relevant sObject records assignment functionality.
 * It uses WorkflowPathObjectRecordType class as an option to map sObject record to Workflow Path.
 *
 * @see WorkflowPathObjectRecordType
 */

public with sharing class WorkflowPathAssociationService {

    private static final String RECORD_ID_FIELD_NAME = 'Id';
    private static final String RECORDTYPE_DEV_NAME_FIELD = 'RecordType.DeveloperName';
    private static final String RECORDTYPE_NAMESPACE_PREFIX_FIELD = 'RecordType.NamespacePrefix';

    @TestVisible
    private MeetingWorkFlowConfigurationDao workflowDao = new MeetingWorkFlowConfigurationDao();
    private LogService.Logger logger = LogService.getLogger();

    private ActionResult actionResult;

    public ActionResult assignWorkflowPathToRecords(Set<Id> recordIds) {
        this.initActionResult();

        List<SObject> records = this.getRecords(recordIds);
        Map<Id, WorkflowPathObjectRecordType> objectRecordTypesByRecordIds = this.createObjectRecordTypesByRecordIds(records);
        List<ObjectWorkflowPathAssociation__c> associations = this.createAssociations(objectRecordTypesByRecordIds);

        if (!associations.isEmpty()) {
            List<Database.SaveResult> saveResults = DataLayer.insertAll(associations, false);
            this.addAssociationsSaveActionResults(associations, saveResults);
        }

        this.logger.persistLogs();

        return actionResult;
    }

    private void initActionResult() {
        this.actionResult = new ActionResult();
    }

    private List<ObjectWorkflowPathAssociation__c> createAssociations(
            Map<Id, WorkflowPathObjectRecordType> objectRecordTypesByRecordIds
    ) {
        List<ObjectWorkflowPathAssociation__c> associations = new List<ObjectWorkflowPathAssociation__c>();
        if (objectRecordTypesByRecordIds.isEmpty()) return associations;
        Set<String> objectRecordTypeCombinations =
                WorkflowPathObjectRecordType.asCombinations(objectRecordTypesByRecordIds.values());
        List<MeetingWorkFlowConfiguration__mdt> mdtPaths =
                workflowDao.getActiveByObjectRecordTypeNames(objectRecordTypeCombinations);
        Map<WorkflowPathObjectRecordType, MeetingWorkFlowConfiguration__mdt> workFlowPathByConfigurations =
                this.mapMdtPathToObjectRecordTypes(mdtPaths);

        if (mdtPaths != null && !mdtPaths.isEmpty()) {
            associations.addAll(
                    this.createAssociationsUsingObjectRecordTypes(
                            workFlowPathByConfigurations,
                            objectRecordTypesByRecordIds
                    )
            );
        }

        return associations;
    }

    private List<SObject> getRecords(Set<Id> recordIds) {
        Map<String, List<Id>> recordIdsByObjectTypeNames = ObjectUtilities.mapRecordIdsByObjectName(recordIds);
        List<SObject> records = new List<SObject>();
        String query;
        List<Id> equivalentTypeRecordIds;
        Condition condition;
        for (String objectName : recordIdsByObjectTypeNames.keySet()) {
            equivalentTypeRecordIds = recordIdsByObjectTypeNames.get(objectName);
            condition = new SetCondition(RECORD_ID_FIELD_NAME, Operator.INX, equivalentTypeRecordIds);
            query = new SoqlBuilder()
                    .selectx(RECORDTYPE_DEV_NAME_FIELD)
                    .selectx(RECORDTYPE_NAMESPACE_PREFIX_FIELD)
                    .fromx(objectName)
                    .wherex(condition)
                    .toSoql();

            records.addAll(
                    DataLayer.queryAll(query)
            );
        }

        return records;
    }

    private void addAssociationsSaveActionResults(
            List<ObjectWorkflowPathAssociation__c> associations,
            List<Database.SaveResult> saveResults
    ) {
        for (Integer i = 0; i < saveResults.size(); i++) {
            Database.SaveResult result = saveResults.get(i);
            ObjectWorkflowPathAssociation__c association = associations.get(i);

            this.actionResult.setSaveResult(result, association.ObjectRecordId__c);

            if (this.isUnsuccessfulSaveResult(result)) {
                this.logRecordUnsuccessfulSaveResult(
                        result,
                        association.ObjectRecordId__c,
                        'addAssociationsSaveActionResults'
                );
            }
        }
    }

    private Boolean isUnsuccessfulSaveResult(Database.SaveResult result) {
        return !result.isSuccess();
    }

    private void logRecordUnsuccessfulSaveResult(Database.SaveResult result, Id recordId, String methodName) {
        String messageTemplate = 'Record Id: {0}, {1}';
        for (Database.Error error : result.getErrors()) {
            this.logger.error(
                    String.format(messageTemplate, new List<Object>{
                            recordId, error.getMessage()
                    }),
                    'WorkflowPathAssociationService.' + methodName
            );
        }
    }

    private List<ObjectWorkflowPathAssociation__c> createAssociationsUsingObjectRecordTypes(
            Map<WorkflowPathObjectRecordType, MeetingWorkFlowConfiguration__mdt> mdtPathsByObjectRecordTypes,
            Map<Id, WorkflowPathObjectRecordType> objectRecordTypesByRecordIds
    ) {
        List<ObjectWorkflowPathAssociation__c> associations = new List<ObjectWorkflowPathAssociation__c>();

        WorkflowPathObjectRecordType objectRecordType;
        MeetingWorkFlowConfiguration__mdt mdtPath;
        ObjectWorkflowPathAssociation__c association;
        for (Id recordId : objectRecordTypesByRecordIds.keySet()) {
            objectRecordType = objectRecordTypesByRecordIds.get(recordId);
            mdtPath = mdtPathsByObjectRecordTypes.get(objectRecordType);

            if (objectRecordType != null && mdtPath != null) {
                association = new ObjectWorkflowPathAssociation__c(
                        ObjectRecordId__c = recordId,
                        ObjectName__c = objectRecordType.getObjectName(),
                        WorkflowPathId__c = mdtPath.Id
                );

                associations.add(association);
            }
        }

        return associations;
    }

    private Map<Id, WorkflowPathObjectRecordType> createObjectRecordTypesByRecordIds(List<SObject> records) {
        Map<Id, WorkflowPathObjectRecordType> objectRecordTypesByRecordIds = new Map<Id, WorkflowPathObjectRecordType>();

        WorkflowPathObjectRecordType objectRecordType;
        String objectName;
        Id recordId;
        RecordType recordType;
        for (SObject record : records) {
            objectName = record.getSObjectType().getDescribe().getName();
            recordId = (Id) record.get(RECORD_ID_FIELD_NAME);
            recordType = (RecordType) record.getSObject('RecordType');
            objectRecordType = this.createObjectRecordType(recordType, objectName, recordId);

            if (objectRecordType != null) {
                objectRecordTypesByRecordIds.put(recordId, objectRecordType);
            }
        }

        return objectRecordTypesByRecordIds;
    }

    private WorkflowPathObjectRecordType createObjectRecordType(RecordType recordType, String objectName, Id recordId) {
        WorkflowPathObjectRecordType objectRecordType;

        try {
            objectRecordType = this.createObjectRecordType(recordType, objectName);
        } catch (Exception ex) {
            this.actionResult.setError(new ActionResult.Error(recordId, ex.getMessage()));
            this.logger.logException(ex, 'WorkflowPathAssociationService.createObjectRecordType: ' + ex.getMessage());
        }

        return objectRecordType;
    }

    private WorkflowPathObjectRecordType createObjectRecordType(RecordType recordType, String objectName) {
        WorkflowPathObjectRecordType objectRecordType;

        if (recordType != null) {
            objectRecordType = WorkflowPathObjectRecordType.byUsing(objectName, recordType);
        } else {
            objectRecordType = WorkflowPathObjectRecordType.byUsing(objectName);
        }

        return objectRecordType;
    }

    private Map<WorkflowPathObjectRecordType, MeetingWorkFlowConfiguration__mdt> mapMdtPathToObjectRecordTypes(
            List<MeetingWorkFlowConfiguration__mdt> mdtPaths
    ) {
        Map<WorkflowPathObjectRecordType, MeetingWorkFlowConfiguration__mdt> mdtPathsByObjectRecordTypes =
                new Map<WorkflowPathObjectRecordType, MeetingWorkFlowConfiguration__mdt>();
        if (mdtPaths == null) return mdtPathsByObjectRecordTypes;

        for (MeetingWorkFlowConfiguration__mdt mdtPath : mdtPaths) {
            WorkflowPathObjectRecordType objectRecordType = this.createWorkflowPathObjectRecordType(mdtPath);

            if (objectRecordType != null) {
                mdtPathsByObjectRecordTypes.put(objectRecordType, mdtPath);
            }
        }

        return mdtPathsByObjectRecordTypes;
    }

    private WorkflowPathObjectRecordType createWorkflowPathObjectRecordType(MeetingWorkFlowConfiguration__mdt mdtPath) {
        WorkflowPathObjectRecordType objectRecordType;

        try {
            objectRecordType = WorkflowPathObjectRecordType.byUsing(mdtPath);
        } catch (Exception ex) {
            this.logger.logException(ex, 'WorkflowPathAssociationService.createWorkflowPathObjectRecordType: ' + ex.getMessage());
        }

        return objectRecordType;
    }
}
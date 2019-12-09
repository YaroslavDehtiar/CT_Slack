public inherited sharing class WorkflowPathOfflineAssociationService {


    private static final String OFFLINE_UNIQ_ID_FIELD =
            PackageUtilities.addNamespacePrefixToObjectField('OfflineUniqueId__c');

    public void syncObjectWorkflowPathAssociations(List<ObjectWorkflowPathAssociation__c> associations) {
        Map<String, ObjectWorkflowPathAssociation__c> associationsByObjectOfflineId =
                this.getAssociationsByObjectOfflineId(associations);
        Map<String, List<String>> offlineIdsBySObjectName = this.getOfflineIdsBySObjectName(associations);

        String offlineUniqueId;
        for(String sObjectName: offlineIdsBySObjectName.keySet()) {
            List<SObject> records = this.getRecordsByOfflineIds(sObjectName, offlineIdsBySObjectName.get(sObjectName));

            for(SObject record: records) {
                offlineUniqueId = (String) record.get(OFFLINE_UNIQ_ID_FIELD);
                associationsByObjectOfflineId.get(offlineUniqueId).ObjectRecordID__c = record.Id;
            }
        }
    }

    private Map<String, ObjectWorkflowPathAssociation__c> getAssociationsByObjectOfflineId(
            List<ObjectWorkflowPathAssociation__c> objectWorkflowPathAssociations
    ) {

        Map<String, ObjectWorkflowPathAssociation__c> associationsByObjectOfflineId =
                new Map<String, ObjectWorkflowPathAssociation__c>();
        for (ObjectWorkflowPathAssociation__c objectWorkflowPathAssociation: objectWorkflowPathAssociations) {
            associationsByObjectOfflineId.put(
                    objectWorkflowPathAssociation.ObjectOfflineId__c,
                    objectWorkflowPathAssociation
            );
        }

        return associationsByObjectOfflineId;
    }

    private Map<String, List<String>> getOfflineIdsBySObjectName(List<ObjectWorkflowPathAssociation__c> objectWorkflowPathAssociations) {
        Map<String, List<String>> offlineIdBySObjectName = new Map<String, List<String>>();

        for (ObjectWorkflowPathAssociation__c record: objectWorkflowPathAssociations) {

            if(!offlineIdBySObjectName.containsKey(record.ObjectName__c)){
                offlineIdBySObjectName.put(record.ObjectName__c, new List<String>());
            }

            offlineIdBySObjectName.get(record.ObjectName__c).add(record.ObjectOfflineId__c);
        }

        return offlineIdBySObjectName;
    }

    private List<SObject> getRecordsByOfflineIds(String sObjectName, List<String> offlineIds) {
        return SObjectDao.getSObjects(sObjectName, OFFLINE_UNIQ_ID_FIELD, offlineIds, new Set<String>{'Id', OFFLINE_UNIQ_ID_FIELD});
    }

}
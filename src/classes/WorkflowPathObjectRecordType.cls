public inherited sharing class WorkflowPathObjectRecordType {

    private static final String OBJECT_REC_TYPE_DELIMITER = BaseUtilities.HYPHEN;

    private String objectName;
    private String recordType;

    private WorkflowPathObjectRecordType(String objectName, String recordType) {
        this.objectName = objectName;
        this.recordType = recordType;
    }

    private WorkflowPathObjectRecordType(String objectName) {
        this(objectName, null);
    }

    public String getObjectName() {
        return this.objectName;
    }

    public String getRecordType() {
        return this.recordType;
    }

    public String getCombination() {
        return this.objectName + OBJECT_REC_TYPE_DELIMITER + (String.isBlank(this.recordType) ? '' : this.recordType);
    }

    public String getLegacyCombination() {
        return this.recordType;
    }

    public static WorkflowPathObjectRecordType byUsing(String objectName) {
        return new WorkflowPathObjectRecordType(objectName);
    }

    public static WorkflowPathObjectRecordType byUsing(String objectName, RecordType recordType) {
        String recordTypeName = RecordTypeUtils.getFullyQualifiedDeveloperName(recordType);

        return new WorkflowPathObjectRecordType(objectName, recordTypeName);
    }

    public static WorkflowPathObjectRecordType byUsing(MeetingWorkFlowConfiguration__mdt mdtWorkflowPath) {
        WorkflowPathObjectRecordType instance;

        String combination = getObjectAndRecordTypeCombination(mdtWorkflowPath);

        if (isInvalidCombination(combination)) {
            throwInvalidCombinationException(mdtWorkflowPath);
        }

        if (isLegacyMeetingWorkflowPath(combination)) {
            String meetingObjectName = Meeting__c.SObjectType.getDescribe().getName();
            String meetingRecordType = combination;

            instance = new WorkflowPathObjectRecordType(meetingObjectName, meetingRecordType);
        } else {
            String[] values = combination.split(OBJECT_REC_TYPE_DELIMITER);
            String objectName = values[0];

            if (isRecordTypeDefined(values)) {
                String recordType = values[1];

                instance = new WorkflowPathObjectRecordType(objectName, recordType);
            } else {
                instance = new WorkflowPathObjectRecordType(objectName);
            }
        }

        return instance;
    }

    private static String getObjectAndRecordTypeCombination(MeetingWorkFlowConfiguration__mdt mdtWorkflowPath) {
        return mdtWorkflowPath.MeetingRecordTypeName__c;
    }

    private static String throwInvalidCombinationException(MeetingWorkFlowConfiguration__mdt mdtWorkflowPath) {
        String message = 'Invalid MeetingWorkFlowConfiguration__mdt.MeetingRecordTypeName__c value.';
        throw WorkflowPathException.newInstance(mdtWorkflowPath, message);
    }

    private static Boolean isInvalidCombination(String combination) {
        return String.isBlank(combination);
    }

    private static Boolean isLegacyMeetingWorkflowPath(String combination) {
        return !combination.contains(OBJECT_REC_TYPE_DELIMITER);
    }

    private static Boolean isRecordTypeDefined(String[] objectNameAndRecordTypeValues) {
        return objectNameAndRecordTypeValues.size() > 1;
    }


    public static Set<String> asCombinations(List<WorkflowPathObjectRecordType> objectRecordTypes) {
        Set<String> combinations = new Set<String>();

        for (WorkflowPathObjectRecordType objectRecordType : objectRecordTypes) {
            if (isMeeting(objectRecordType.getObjectName())) {
                combinations.add(objectRecordType.getLegacyCombination());
            }

            combinations.add(objectRecordType.getCombination());
        }

        return combinations;
    }

    private static Boolean isMeeting(String objectName) {
        return SObjectType.Meeting__c.getName() == objectName;
    }

    public Boolean equals(Object obj) {
        if (obj != null && obj instanceof WorkflowPathObjectRecordType) {
            WorkflowPathObjectRecordType o = (WorkflowPathObjectRecordType) obj;
            return this.objectName.equals(o.objectName)
                    && this.recordType.equals(o.recordType);
        }

        return false;
    }

    public Integer hashCode() {
        if (this.objectName != null && this.recordType != null) {
            return (31 * this.objectName.hashCode()) ^ this.recordType.hashCode();
        } else if (this.objectName == null && this.recordType != null) {
            return (31 * this.recordType.hashCode());
        }

        return (31 * this.objectName.hashCode());
    }
}
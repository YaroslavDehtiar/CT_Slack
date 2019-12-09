@IsTest
private class WorkflowPathObjectRecordTypeTest {
    //SObjects
    private static final SObjectType MEETING_SOBJECT_TYPE = Schema.Meeting__c.SObjectType;
    private static final String MEETING_SOBJECT_NAME = SObjectType.Meeting__c.getName();
    private static final String CONTACT_SOBJECT_NAME = SObjectType.Contact.getName();
    private static final String MEETING_MEMBER_SOBJECT_NAME = SObjectType.MeetingMember__c.getName();

    //Meeting RecordTypes
    private static final String REC_TYPE_NAME_SPEAKER = PackageUtilities.addNamespacePrefixToName('Speaker_Meeting');
    private static final String REC_TYPE_NAME_PARTNER = PackageUtilities.addNamespacePrefixToName('Partner');
    private static final String REC_TYPE_NAME_ATTENDEE = PackageUtilities.addNamespacePrefixToName('Attendee');

    //WorkflowPath RecordTypes
    private static final String MEETING_REC_TYPE_NAME_SPEAKER = MEETING_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_SPEAKER;


    @IsTest
    static void testByUsedObjectName() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();

        //When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(meetingObjectName);
        Test.stopTest();

        //Then
        System.assertEquals(meetingObjectName, objectRecordType.getObjectName());
        System.assertEquals(null, objectRecordType.getRecordType());

    }

    @IsTest
    static void testByUsedObjectNameAndRecordType() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();
        final RecordType recordType = RecordTypeUtils.getRecordTypeByDeveloperName(meetingObjectName, REC_TYPE_NAME_SPEAKER);

        //When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(meetingObjectName, recordType);
        Test.stopTest();

        //Then
        System.assertEquals(meetingObjectName, objectRecordType.getObjectName());
        System.assertEquals(PackageUtilities.addNamespacePrefixToName('Speaker_Meeting'), objectRecordType.getRecordType());
    }

    @IsTest
    static void testByUsedMeetingWorkflowConfiguration() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        MeetingWorkFlowConfiguration__mdt configuration = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                , MeetingRecordTypeName__c = REC_TYPE_NAME_SPEAKER);
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();

        //When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(configuration);
        Test.stopTest();

        //Then
        System.assertEquals(meetingObjectName, objectRecordType.getObjectName());
        System.assertEquals(REC_TYPE_NAME_SPEAKER, objectRecordType.getRecordType());
    }

    @IsTest
    static void testByUsedGenericMeetingWorkflowConfiguration() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        MeetingWorkFlowConfiguration__mdt configuration = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_SPEAKER);
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();

        //When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(configuration);
        Test.stopTest();

        //Then
        System.assertEquals(meetingObjectName, objectRecordType.getObjectName());
        System.assertEquals(REC_TYPE_NAME_SPEAKER, objectRecordType.getRecordType());
    }

    @IsTest
    static void testByUsedIncorrectCombination() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        MeetingWorkFlowConfiguration__mdt configuration = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                , MeetingRecordTypeName__c = null);
        Boolean exceptionThrown = false;


        //When
        Test.startTest();
        try {
            WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(configuration);
        } catch (Exception ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        //Then
        System.assert(exceptionThrown);

    }

    @IsTest
    static void testIsTheSameConfiguration() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        final String meetingObjectName = MEETING_SOBJECT_TYPE.getDescribe().getName();
        final RecordType recordType = RecordTypeUtils.getRecordTypeByDeveloperName(meetingObjectName, REC_TYPE_NAME_SPEAKER);
        MeetingWorkFlowConfiguration__mdt configuration = new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                , MeetingRecordTypeName__c = REC_TYPE_NAME_SPEAKER);

        //When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordTypeTest1 = WorkflowPathObjectRecordType.byUsing(configuration);
        WorkflowPathObjectRecordType objectRecordTypeTest2 = WorkflowPathObjectRecordType.byUsing(meetingObjectName,recordType);
        Test.stopTest();

        //Then
        System.assertEquals(true, objectRecordTypeTest2.equals(objectRecordTypeTest1));

    }

    @IsTest
    static void testGetCombinationNonRecordType() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(CONTACT_SOBJECT_NAME);
        Test.stopTest();

        // Then
        System.assertEquals(CONTACT_SOBJECT_NAME + '-', objectRecordType.getCombination());
    }

    @IsTest
    static void testGetCombinationWithRecordType() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType =
                WorkflowPathObjectRecordType.byUsing(CONTACT_SOBJECT_NAME,
                        new RecordType(DeveloperName = REC_TYPE_NAME_PARTNER));
        Test.stopTest();

        // Then
        System.assertEquals(CONTACT_SOBJECT_NAME + '-' + REC_TYPE_NAME_PARTNER, objectRecordType.getCombination());
    }

    @IsTest
    static void testGetLegacyCombination() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // When
        Test.startTest();
        WorkflowPathObjectRecordType objectRecordType = WorkflowPathObjectRecordType.byUsing(MEETING_SOBJECT_NAME, new RecordType(DeveloperName = REC_TYPE_NAME_SPEAKER));
        Test.stopTest();

        // Then
        System.assertEquals(REC_TYPE_NAME_SPEAKER, objectRecordType.getLegacyCombination());
    }

    @IsTest
    static void testAsCombinationsWithoutLegacyPaths() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        List<WorkflowPathObjectRecordType> objectRecordTypes = new List<WorkflowPathObjectRecordType> {
                WorkflowPathObjectRecordType.byUsing(CONTACT_SOBJECT_NAME),
                WorkflowPathObjectRecordType.byUsing(MEETING_MEMBER_SOBJECT_NAME, new RecordType(DeveloperName = REC_TYPE_NAME_ATTENDEE))
        };

        // When
        Test.startTest();
        Set<String> combinations = WorkflowPathObjectRecordType.asCombinations(objectRecordTypes);
        Test.stopTest();

        // Then
        System.assert(combinations.contains(CONTACT_SOBJECT_NAME + '-'));
        System.assert(combinations.contains(MEETING_MEMBER_SOBJECT_NAME + '-' + REC_TYPE_NAME_ATTENDEE));
    }

    @IsTest
    static void testAsCombinationsWithLegacyPaths() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        // Given
        List<WorkflowPathObjectRecordType> objectRecordTypes = new List<WorkflowPathObjectRecordType> {
                WorkflowPathObjectRecordType.byUsing(CONTACT_SOBJECT_NAME),
                WorkflowPathObjectRecordType.byUsing(MEETING_SOBJECT_NAME, new RecordType(DeveloperName = REC_TYPE_NAME_SPEAKER)),
                WorkflowPathObjectRecordType.byUsing(MEETING_MEMBER_SOBJECT_NAME, new RecordType(DeveloperName = REC_TYPE_NAME_ATTENDEE))
        };

        // When
        Test.startTest();
        Set<String> combinations = WorkflowPathObjectRecordType.asCombinations(objectRecordTypes);
        Test.stopTest();

        // Then
        System.assert(combinations.contains(CONTACT_SOBJECT_NAME + '-'));
        System.assert(combinations.contains(MEETING_MEMBER_SOBJECT_NAME + '-' + REC_TYPE_NAME_ATTENDEE));
        System.assert(combinations.contains(MEETING_SOBJECT_NAME + '-' + REC_TYPE_NAME_SPEAKER));
        System.assert(combinations.contains(REC_TYPE_NAME_SPEAKER));
    }
}
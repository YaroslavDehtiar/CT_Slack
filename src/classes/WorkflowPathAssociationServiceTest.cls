@IsTest
private class WorkflowPathAssociationServiceTest {

    //SObjects
    private static final SObjectType MEETING_SOBJECT_TYPE = Schema.Meeting__c.SObjectType;
    private static final SObjectType ACCOUNT_SOBJECT_TYPE = Schema.Account.SObjectType;

    private static final String STATUS_ACTIVE = 'Active';

    //Meeting RecordTypes
    private static final String REC_TYPE_NAME_SPEAKER = PackageUtilities.addNamespacePrefixToName('Speaker_Meeting');
    private static final String REC_TYPE_NAME_HCP = PackageUtilities.addNamespacePrefixToName('HCP_Sponsorship');
    private static final String REC_TYPE_NAME_EXHIBITS = PackageUtilities.addNamespacePrefixToName('Displays_Exhibits');

    //Account RecordTypes
    private static final String REC_TYPE_NAME_INSTITUTION = PackageUtilities.addNamespacePrefixToName('Institution');
    private static final String REC_TYPE_NAME_DEPARTMENT = PackageUtilities.addNamespacePrefixToName('Department');

    //WorkflowPath RecordTypes
    private static final String MEETING_REC_TYPE_NAME_SPEAKER = MEETING_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_SPEAKER;
    private static final String MEETING_REC_TYPE_NAME_HCP = MEETING_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_HCP;
    private static final String MEETING_REC_TYPE_NAME_EXHIBITS = MEETING_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_EXHIBITS;
    private static final String ACCOUNT_REC_TYPE_NAME_INSTITUTION = ACCOUNT_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_INSTITUTION;
    private static final String ACCOUNT_REC_TYPE_NAME_DEPARTMENT = ACCOUNT_SOBJECT_TYPE.getDescribe().getName() + BaseUtilities.HYPHEN + REC_TYPE_NAME_DEPARTMENT;

    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();

    @IsTest
    static void testGenericWorkflowPath() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        List<SObject> meetings = new List<SObject>();
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_EXHIBITS));
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_HCP));
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_SPEAKER));
        DataLayer.insertAll(meetings);

        Set<Id> recordIds = new Set<Id>();
        for (SObject record : meetings) {
            recordIds.add((Id) record.get('Id'));
        }

        List<MeetingWorkFlowConfiguration__mdt> configurations = new List<MeetingWorkFlowConfiguration__mdt>{
                new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_SPEAKER)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_HCP)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_EXHIBITS)
        };

        TestUtils.Stub workflowPathStub = stubFactory.stub();
        Set<String> objectRecordTypeCombinations = new Set<String> {
                MEETING_REC_TYPE_NAME_SPEAKER, MEETING_REC_TYPE_NAME_HCP, MEETING_REC_TYPE_NAME_EXHIBITS,
                REC_TYPE_NAME_SPEAKER, REC_TYPE_NAME_HCP, REC_TYPE_NAME_EXHIBITS
        };
        workflowPathStub.when('getActiveByObjectRecordTypeNames', objectRecordTypeCombinations).thenReturn(configurations);
        WorkflowPathAssociationService service = new WorkflowPathAssociationService();
        service.workflowDao =
                (MeetingWorkFlowConfigurationDao)
                        mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathStub);

        List<ObjectWorkflowPathAssociation__c> associations = getAssociations();
        System.assertEquals(0, associations.size());

        //When
        Test.startTest();
        service.assignWorkflowPathToRecords(recordIds);
        Test.stopTest();

        //Then
        associations = getAssociations();
        System.assertEquals(3, associations.size());

        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(0).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(1).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(2).ObjectName__c);

        System.assertEquals(meetings.get(0).Id, associations.get(0).ObjectRecordID__c);
        System.assertEquals(meetings.get(1).Id, associations.get(1).ObjectRecordID__c);
        System.assertEquals(meetings.get(2).Id, associations.get(2).ObjectRecordID__c);
    }

  @IsTest
    static void testNotGenericWorkflowPath() {
        //Check test level
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        List<SObject> meetings = new List<SObject>();
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_EXHIBITS));
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_HCP));
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_SPEAKER));
        DataLayer.insertAll(meetings);

        Set<Id> recordIds = new Set<Id>();
        for (SObject record : meetings) {
            recordIds.add((Id) record.get('Id'));
        }

        List<MeetingWorkFlowConfiguration__mdt> configurations = new List<MeetingWorkFlowConfiguration__mdt>{
                new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_SPEAKER)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_HCP)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_EXHIBITS)
        };

        TestUtils.Stub workflowPathStub = stubFactory.stub();
        Set<String> objectRecordTypeCombinations = new Set<String> {
                MEETING_REC_TYPE_NAME_SPEAKER, MEETING_REC_TYPE_NAME_HCP, MEETING_REC_TYPE_NAME_EXHIBITS,
                REC_TYPE_NAME_SPEAKER, REC_TYPE_NAME_HCP, REC_TYPE_NAME_EXHIBITS
        };
        workflowPathStub.when('getActiveByObjectRecordTypeNames', objectRecordTypeCombinations).thenReturn(configurations);
        WorkflowPathAssociationService service = new WorkflowPathAssociationService();
        service.workflowDao =
                (MeetingWorkFlowConfigurationDao)
                        mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathStub);

        List<ObjectWorkflowPathAssociation__c> associations = getAssociations();
        System.assertEquals(0, associations.size());

        //When
        Test.startTest();
        service.assignWorkflowPathToRecords(recordIds);
        Test.stopTest();

        //Then
        associations = getAssociations();
        System.assertEquals(3, associations.size());

        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(0).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(1).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(2).ObjectName__c);

        System.assertEquals(meetings.get(0).Id, associations.get(0).ObjectRecordID__c);
        System.assertEquals(meetings.get(1).Id, associations.get(1).ObjectRecordID__c);
        System.assertEquals(meetings.get(2).Id, associations.get(2).ObjectRecordID__c);
    }

    @IsTest
    static void testGenericWorkflowPathMixSobjects() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        List<SObject> sObjects = new List<SObject>();
        sObjects.add(TestUtils.createMeeting(false, REC_TYPE_NAME_EXHIBITS));
        sObjects.add(TestUtils.createMeeting(false, REC_TYPE_NAME_HCP));
        sObjects.add(TestUtils.createMeeting(false, REC_TYPE_NAME_SPEAKER));

        Id institutionId = TestUtils.getRecordTypeId('Account', REC_TYPE_NAME_INSTITUTION);
        Id departmentId = TestUtils.getRecordTypeId('Account', REC_TYPE_NAME_DEPARTMENT);

        sObjects.add(TestUtils.createAccount(
                new Map<String, Object>{
                        'Name' => 'Test Account 1',
                        'ProfessionalTitle__c' => 'Dentists',
                        'Specialty__c' => 'Pediatric, diag lab immun',
                        'Status__c' => 'Active',
                        'NumberOfEmployees' => 10,
                        'RecordTypeId' => institutionId
                },
                false
        ));
        sObjects.add(TestUtils.createAccount(
                new Map<String, Object>{
                        'Name' => 'Test Account 2',
                        'ProfessionalTitle__c' => 'Dentists',
                        'Specialty__c' => 'Pediatric, diag lab immun',
                        'Status__c' => 'Active',
                        'NumberOfEmployees' => 10,
                        'RecordTypeId' => departmentId
                },
                false
        ));

        DataLayer.insertAll(sObjects);

        Set<Id> recordIds = new Set<Id>();
        for (SObject record : sObjects) {
            recordIds.add((Id) record.get('Id'));
        }

        List<MeetingWorkFlowConfiguration__mdt> configurations = new List<MeetingWorkFlowConfiguration__mdt>{
                new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_SPEAKER)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_HCP)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_EXHIBITS)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = ACCOUNT_REC_TYPE_NAME_DEPARTMENT)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = ACCOUNT_REC_TYPE_NAME_INSTITUTION)
        };
        TestUtils.Stub workflowPathStub = stubFactory.stub();
        Set<String> objectRecordTypeCombinations = new Set<String> {
                MEETING_REC_TYPE_NAME_SPEAKER, MEETING_REC_TYPE_NAME_HCP, MEETING_REC_TYPE_NAME_EXHIBITS,
                REC_TYPE_NAME_SPEAKER, REC_TYPE_NAME_HCP, REC_TYPE_NAME_EXHIBITS,
                ACCOUNT_REC_TYPE_NAME_DEPARTMENT, ACCOUNT_REC_TYPE_NAME_INSTITUTION
        };
        workflowPathStub.when('getActiveByObjectRecordTypeNames', objectRecordTypeCombinations).thenReturn(configurations);
        WorkflowPathAssociationService service = new WorkflowPathAssociationService();
        service.workflowDao =
                (MeetingWorkFlowConfigurationDao)
                        mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathStub);

        List<ObjectWorkflowPathAssociation__c> associations = getAssociations();
        System.assertEquals(0, associations.size());

        //When
        Test.startTest();
        service.assignWorkflowPathToRecords(recordIds);
        Test.stopTest();

        //Then
        associations = getAssociations();
        System.assertEquals(5, associations.size());

        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(0).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(1).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(2).ObjectName__c);
        System.assertEquals(ACCOUNT_SOBJECT_TYPE.getDescribe().getName(), associations.get(3).ObjectName__c);
        System.assertEquals(ACCOUNT_SOBJECT_TYPE.getDescribe().getName(), associations.get(4).ObjectName__c);

        System.assertEquals(sObjects.get(0).Id, associations.get(0).ObjectRecordID__c);
        System.assertEquals(sObjects.get(1).Id, associations.get(1).ObjectRecordID__c);
        System.assertEquals(sObjects.get(2).Id, associations.get(2).ObjectRecordID__c);
        System.assertEquals(sObjects.get(3).Id, associations.get(3).ObjectRecordID__c);
        System.assertEquals(sObjects.get(4).Id, associations.get(4).ObjectRecordID__c);
    }

    @IsTest
    static void testGenericAndNotGenericWorkflowPath() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        RecordType departmentRecType = RecordTypeUtils.getRecordTypeByDeveloperName(ACCOUNT_SOBJECT_TYPE, REC_TYPE_NAME_DEPARTMENT);
        RecordType institutionRecType = RecordTypeUtils.getRecordTypeByDeveloperName(ACCOUNT_SOBJECT_TYPE, REC_TYPE_NAME_INSTITUTION);
        List<SObject> sObjects = new List<SObject>();
        sObjects.add(TestUtils.createMeeting(false, REC_TYPE_NAME_EXHIBITS));
        sObjects.add(TestUtils.createMeeting(false, REC_TYPE_NAME_HCP));
        sObjects.add(TestUtils.createMeeting(false, REC_TYPE_NAME_SPEAKER));

        sObjects.add(TestUtils.createAccount(
                new Map<String, Object>{
                        'Name' => 'Test Account 1',
                        'ProfessionalTitle__c' => 'Dentists',
                        'Specialty__c' => 'Pediatric, diag lab immun',
                        'Status__c' => 'Active',
                        'NumberOfEmployees' => 10,
                        'RecordTypeId' => institutionRecType.Id
                },
                false
        ));
        sObjects.add(TestUtils.createAccount(
                new Map<String, Object>{
                        'Name' => 'Test Account 2',
                        'ProfessionalTitle__c' => 'Dentists',
                        'Specialty__c' => 'Pediatric, diag lab immun',
                        'Status__c' => 'Active',
                        'NumberOfEmployees' => 10,
                        'RecordTypeId' => departmentRecType.Id
                },
                false
        ));

        DataLayer.insertAll(sObjects);

        Set<Id> recordIds = new Set<Id>();
        for (SObject record : sObjects) {
            recordIds.add((Id) record.get('Id'));
        }

        List<MeetingWorkFlowConfiguration__mdt> configurations = new List<MeetingWorkFlowConfiguration__mdt>{
                new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_SPEAKER)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_HCP)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = REC_TYPE_NAME_EXHIBITS)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = ACCOUNT_REC_TYPE_NAME_INSTITUTION)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = ACCOUNT_REC_TYPE_NAME_DEPARTMENT)
        };

        TestUtils.Stub workflowPathStub = stubFactory.stub();
        Set<String> objectRecordTypeCombinations = new Set<String> {
                REC_TYPE_NAME_SPEAKER, REC_TYPE_NAME_HCP, REC_TYPE_NAME_EXHIBITS,
                MEETING_REC_TYPE_NAME_SPEAKER, MEETING_REC_TYPE_NAME_HCP, MEETING_REC_TYPE_NAME_EXHIBITS,
                ACCOUNT_REC_TYPE_NAME_INSTITUTION, ACCOUNT_REC_TYPE_NAME_DEPARTMENT
        };
        workflowPathStub
                .when('getActiveByObjectRecordTypeNames', objectRecordTypeCombinations)
                .thenReturn(configurations);

        WorkflowPathAssociationService service = new WorkflowPathAssociationService();
        service.workflowDao =
                (MeetingWorkFlowConfigurationDao)
                        mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathStub);

        List<ObjectWorkflowPathAssociation__c> associations = getAssociations();
        System.assertEquals(0, associations.size());

        //When
        Test.startTest();
        service.assignWorkflowPathToRecords(recordIds);
        Test.stopTest();

        //Then
        associations = getAssociations();
        System.assertEquals(5, associations.size());

        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(0).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(1).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(2).ObjectName__c);
        System.assertEquals(ACCOUNT_SOBJECT_TYPE.getDescribe().getName(), associations.get(3).ObjectName__c);
        System.assertEquals(ACCOUNT_SOBJECT_TYPE.getDescribe().getName(), associations.get(4).ObjectName__c);

        System.assertEquals(sObjects.get(0).Id, associations.get(0).ObjectRecordID__c);
        System.assertEquals(sObjects.get(1).Id, associations.get(1).ObjectRecordID__c);
        System.assertEquals(sObjects.get(2).Id, associations.get(2).ObjectRecordID__c);
        System.assertEquals(sObjects.get(3).Id, associations.get(3).ObjectRecordID__c);
        System.assertEquals(sObjects.get(4).Id, associations.get(4).ObjectRecordID__c);
    }

    @IsTest
    static void testIncorrectConfigurations() {
        if (TestConfigurationDao.isNotLowScope()) {
            return;
        }

        //Given
        List<SObject> meetings = new List<SObject>();
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_EXHIBITS));
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_HCP));
        meetings.add(TestUtils.createMeeting(false, REC_TYPE_NAME_SPEAKER));
        DataLayer.insertAll(meetings);

        Set<Id> recordIds = new Set<Id>();
        for (SObject record : meetings) {
            recordIds.add((Id) record.get('Id'));
        }

        List<MeetingWorkFlowConfiguration__mdt> configurations = new List<MeetingWorkFlowConfiguration__mdt>{
                new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_SPEAKER)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = MEETING_REC_TYPE_NAME_HCP)
                , new MeetingWorkFlowConfiguration__mdt(
                        Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType)
                        , Status__c = STATUS_ACTIVE
                        , MeetingRecordTypeName__c = null)
        };

        TestUtils.Stub workflowPathStub = stubFactory.stub();
        Set<String> objectRecordTypeCombinations = new Set<String> {
                MEETING_REC_TYPE_NAME_SPEAKER, MEETING_REC_TYPE_NAME_HCP, MEETING_REC_TYPE_NAME_EXHIBITS,
                REC_TYPE_NAME_SPEAKER, REC_TYPE_NAME_HCP, REC_TYPE_NAME_EXHIBITS
        };
        workflowPathStub.when('getActiveByObjectRecordTypeNames', objectRecordTypeCombinations).thenReturn(configurations);
        WorkflowPathAssociationService service = new WorkflowPathAssociationService();
        service.workflowDao =
                (MeetingWorkFlowConfigurationDao)
                        mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathStub);

        List<ObjectWorkflowPathAssociation__c> associations = getAssociations();
        System.assertEquals(0, associations.size());

        //When
        Test.startTest();
        service.assignWorkflowPathToRecords(recordIds);
        Test.stopTest();

        //Then
        associations = getAssociations();
        System.assertEquals(2, associations.size());

        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(0).ObjectName__c);
        System.assertEquals(MEETING_SOBJECT_TYPE.getDescribe().getName(), associations.get(1).ObjectName__c);
    }

    private static List<ObjectWorkflowPathAssociation__c> getAssociations() {
        return [
                SELECT Id
                        , ObjectRecordID__c
                        , ObjectName__c
                        , WorkflowPathId__c
                FROM ObjectWorkflowPathAssociation__c
        ];
    }
}
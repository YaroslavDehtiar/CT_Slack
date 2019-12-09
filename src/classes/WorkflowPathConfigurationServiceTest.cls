@IsTest
private class WorkflowPathConfigurationServiceTest {
    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();

    @isTest
    static void getChildContextsTest() {
        //Given

        //When
        Test.startTest();
        List<Context__mdt> contexts = new WorkflowPathConfigurationService().getChildContexts(getContexts());
        Test.stopTest();

        //Then
        System.assert(!contexts.isEmpty());
    }

    @isTest
    static void getNewContextTypeTest() {
        //Given
        WorkflowPathConfigurationService.WorkflowParamsDto params = getParams();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowContextTypeDto contextTypeDto = new WorkflowPathConfigurationService().getNewContextType(params);
        Test.stopTest();

        //Then
        System.assert(params != null);
        System.assert(params.sObjectName == contextTypeDto.objectx);
    }

    @isTest
    static void getActionsCustomMetadataTest() {
        //Given
        WorkflowConfigurationDto.WorkflowActionDto actionDto = new WorkflowConfigurationDto.WorkflowActionDto(getActions()[0]);

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getActionsCustomMetadata(
                new List<WorkflowConfigurationDto.WorkflowActionDto>{actionDto}
        );
        Test.stopTest();

        //Then
        System.assert(customMetadata.size() == 1);
        System.assert(customMetadata[0].fullName.contains(actionDto.name));
    }

    @isTest
    static void getContextTypesCustomMetadataTest() {
        //Given
        List<WorkflowConfigurationDto.WorkflowContextTypeDto> contextTypeDtos = new List<WorkflowConfigurationDto.WorkflowContextTypeDto>{
                new WorkflowConfigurationDto.WorkflowContextTypeDto(getContextTypes()[0])
        };

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getContextTypesCustomMetadata(contextTypeDtos);
        Test.stopTest();

        //Then
        System.assert(!customMetadata.isEmpty());
        System.assert(customMetadata[0].fullName.contains(contextTypeDtos[0].name));
    }

    @isTest
    static void getWorkflowPathCustomMetadataTest() {
        //Given
        WorkflowConfigurationDto.WorkflowPathDto workflowPath = new WorkflowConfigurationDto.WorkflowPathDto(getPath());

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getWorkflowPathCustomMetadata(workflowPath);
        Test.stopTest();

        //Then
        System.assert(!customMetadata.isEmpty());
        System.assert(customMetadata[0].fullName.contains(workflowPath.name));
    }

    @isTest
    static void getContextsCustomMetadataTest() {
        //Given
        List<WorkflowConfigurationDto.WorkflowContextDto> contextDtos = new List<WorkflowConfigurationDto.WorkflowContextDto>{
                new WorkflowConfigurationDto.WorkflowContextDto(getContexts()[0])
        };

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getContextsCustomMetadata(contextDtos);
        Test.stopTest();

        //Then
        System.assert(!customMetadata.isEmpty());
        System.assert(customMetadata[0].fullName.contains(contextDtos[0].name));
    }

    @isTest
    static void getContextConditionsCustomMetadataTest() {
        //Given
        List<WorkflowConfigurationDto.WorkflowContextConditionDto> contextConditionDtos = new List<WorkflowConfigurationDto.WorkflowContextConditionDto>{
                new WorkflowConfigurationDto.WorkflowContextConditionDto(getContextConditions()[0])
        };

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getContextConditionsCustomMetadata(contextConditionDtos);
        Test.stopTest();

        //Then
        System.assert(!customMetadata.isEmpty());
        System.assert(customMetadata[0].fullName.contains(contextConditionDtos[0].name));
    }

    @isTest
    static void getContextConditionsActionsMetadataTest() {
        //Given
        List<WorkflowConfigurationDto.WorkflowContextActionDto> contextActionDtos = new List<WorkflowConfigurationDto.WorkflowContextActionDto>{
                new WorkflowConfigurationDto.WorkflowContextActionDto(getContextActions()[0])
        };

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getContextActionsCustomMetadata(contextActionDtos);
        Test.stopTest();

        //Then
        System.assert(!customMetadata.isEmpty());
        System.assert(customMetadata[0].fullName.contains(contextActionDtos[0].name));
    }

    @isTest
    static void getWorkflowPathNodesCustomMetadataTest() {
        //Given
        List<WorkflowConfigurationDto.WorkflowPathNodeDto> pathNodeDtos = new List<WorkflowConfigurationDto.WorkflowPathNodeDto>{
                new WorkflowConfigurationDto.WorkflowPathNodeDto(getPathNodes()[0])
        };

        //When
        Test.startTest();
        List<Metadata.CustomMetadata> customMetadata = new WorkflowPathConfigurationService().getWorkflowPathNodesCustomMetadata(pathNodeDtos);
        Test.stopTest();

        //Then
        System.assert(!customMetadata.isEmpty());
        System.assert(customMetadata[0].fullName.contains(pathNodeDtos[0].name));
    }


    @isTest
    static void getNewWorkflowPathTest() {
        //Given
        WorkflowPathConfigurationService.WorkflowParamsDto params = getParams();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowPathDto workflowPath = new WorkflowPathConfigurationService().getNewWorkflowPath(params);
        Test.stopTest();

        //Then
        System.assert(workflowPath != null);
        System.assert(workflowPath.objectName == params.sObjectName);
        System.assert(workflowPath.name == params.sObjectName);
    }

    @isTest
    static void getAllContextTypesTest() {
        //Given
        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getAll', null)
                .thenReturn(getContextTypes());
        WorkflowPathConfigurationService service = new WorkflowPathConfigurationService();
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        //When
        Test.startTest();
        List<WorkflowConfigurationDto.WorkflowContextTypeDto> contextTypes = service.getAllContextTypes();
        Test.stopTest();

        //Then
        System.assert(!contextTypes.isEmpty());
    }

    @isTest
    static void deployWorkflowTest() {
        //Given
        WorkflowConfigurationDto configuration = new WorkflowConfigurationDto();

        configuration.newActions = new List<WorkflowConfigurationDto.WorkflowActionDto>{
                new WorkflowConfigurationDto.WorkflowActionDto(getActions()[0])
        };

        configuration.newContextTypes = new List<WorkflowConfigurationDto.WorkflowContextTypeDto>{
                new WorkflowConfigurationDto.WorkflowContextTypeDto(getContextTypes()[0])
        };

        configuration.workflowPath = new  WorkflowConfigurationDto.WorkflowPathDto(getPath());

        configuration.workflowPath.nodes = new List<WorkflowConfigurationDto.WorkflowPathNodeDto>{
                new WorkflowConfigurationDto.WorkflowPathNodeDto(getPathNodes()[0])
        };

        //When
        Test.startTest();
        Id deploymentProcessId = new WorkflowPathConfigurationService().deployWorkflow(configuration);
        Test.stopTest();

        //Then
        System.assert(deploymentProcessId == null);
    }

    @isTest
    static void getActionsTest_Success () {
        //Given
        TestUtils.Stub actionDaoStub = stubFactory.stub();
        actionDaoStub
                .when('getAllWithContextTypeDevName')
                .thenReturn(getActions());
        WorkflowPathConfigurationService service = new WorkflowPathConfigurationService();
        service.actionDao = (ActionDao) mockFactory.mock(ActionDao.class, actionDaoStub);

        //When
        Test.startTest();
        List<WorkflowConfigurationDto.WorkflowActionDto> actions = service.getActions();
        Test.stopTest();

        //Then
        System.assert(actions != null);
        System.assert(actions.size() == 1);
    }

    @isTest
    static void getWorkflowPathConfigurationByParamsTest_CreateWithExistingContextType() {
        //Given
        WorkflowPathConfigurationService service = new WorkflowPathConfigurationService();
        WorkflowPathConfigurationService.WorkflowParamsDto params = getParams();

        //actions
        TestUtils.Stub actionDaoStub = stubFactory.stub();
        actionDaoStub
                .when('getAllWithContextTypeDevName')
                .thenReturn(getActions());
        service.actionDao = (ActionDao) mockFactory.mock(ActionDao.class, actionDaoStub);

        //contextTypes
        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getAll', null)
                .thenReturn(getContextTypes());
        contextTypeDaoStub
                .when('getByObjectNameAnd', params.sObjectName)
                .thenReturn(getContextTypes()[0]);
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        //When
        Test.startTest();
        WorkflowConfigurationDto configurationDto = service.getWorkflowPathConfigurationByParams(params);
        Test.stopTest();

        //Then
        System.assert(configurationDto.workflowPath.objectName == params.sObjectName);
        System.assert(configurationDto.workflowPath.recordType == params.recordType);
        System.assert(configurationDto.workflowPath.controllingField == params.controllingField);
        System.assert(configurationDto.workflowPath.label == params.masterLabel);

        System.assert(!configurationDto.newContextTypes.isEmpty());
        System.assert(!configurationDto.actions.isEmpty());
        System.assert(!configurationDto.contextTypes.isEmpty());
    }

    @isTest
    static void getWorkflowPathConfigurationByParamsTest_CreateWithNewContextType() {
        //Given
        WorkflowPathConfigurationService service = new WorkflowPathConfigurationService();
        WorkflowPathConfigurationService.WorkflowParamsDto params = getParams();

        //actions
        TestUtils.Stub actionDaoStub = stubFactory.stub();
        actionDaoStub
                .when('getAllWithContextTypeDevName')
                .thenReturn(getActions());
        service.actionDao = (ActionDao) mockFactory.mock(ActionDao.class, actionDaoStub);

        //contextTypes
        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getAll', null)
                .thenReturn(getContextTypes());
        contextTypeDaoStub
                .when('getByObjectNameAnd', params.sObjectName)
                .thenReturn(null);
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        //When
        Test.startTest();
        WorkflowConfigurationDto configurationDto = service.getWorkflowPathConfigurationByParams(params);
        Test.stopTest();

        //Then
        System.assert(configurationDto.workflowPath.objectName == params.sObjectName);
        System.assert(configurationDto.workflowPath.recordType == params.recordType);
        System.assert(configurationDto.workflowPath.label == params.masterLabel);
        System.assert(configurationDto.workflowPath.controllingField == params.controllingField);

        System.assert(!configurationDto.newContextTypes.isEmpty());
        System.assert(!configurationDto.actions.isEmpty());
        System.assert(!configurationDto.contextTypes.isEmpty());
    }

    @isTest
    static void getWorkflowPathConfigurationByParamsTest_UpdatePath() {
        //Given
        WorkflowPathConfigurationService service = new WorkflowPathConfigurationService();
        WorkflowPathConfigurationService.WorkflowParamsDto params = getParams();
        params.recordType = null;
        params.sObjectName = null;
        params.controllingField = null;

        //actions
        TestUtils.Stub actionDaoStub = stubFactory.stub();
        actionDaoStub
                .when('getAllWithContextTypeDevName')
                .thenReturn(getActions());
        service.actionDao = (ActionDao) mockFactory.mock(ActionDao.class, actionDaoStub);

        //contextTypes
        TestUtils.Stub contextTypeDaoStub = stubFactory.stub();
        contextTypeDaoStub
                .when('getAll', null)
                .thenReturn(getContextTypes());
        contextTypeDaoStub
                .when('getByObjectNameAnd', params.sObjectName)
                .thenReturn(null);
        service.contextTypeDao = (ContextTypeDao) mockFactory.mock(ContextTypeDao.class, contextTypeDaoStub);

        //workflow path
        TestUtils.Stub workflowPathDao = stubFactory.stub();
        workflowPathDao
                .when('getWorkflowPathWithAllChildByDevName', params.developerName)
                .thenReturn(getPath());

        service.workflowPathDao = (MeetingWorkFlowConfigurationDao) mockFactory.mock(MeetingWorkFlowConfigurationDao.class, workflowPathDao);

        //When
        Test.startTest();
        WorkflowConfigurationDto configurationDto = service.getWorkflowPathConfigurationByParams(params);
        Test.stopTest();

        //Then
        System.assert(configurationDto.workflowPath.objectName == params.sObjectName);
        System.assert(configurationDto.workflowPath.label == params.masterLabel);

        System.assert(!configurationDto.actions.isEmpty());
        System.assert(!configurationDto.contextTypes.isEmpty());
    }

    static WorkflowPathConfigurationService.WorkflowParamsDto getParams() {
        WorkflowPathConfigurationService.WorkflowParamsDto paramsDto = new WorkflowPathConfigurationService.WorkflowParamsDto();
        paramsDto.recordType = 'RepPresentation';
        paramsDto.sObjectName = 'Meeting__c';
        paramsDto.masterLabel = 'test label';
        paramsDto.developerName = 'Meeting__c';
        paramsDto.controllingField = 'Status__c';
        return paramsDto;
    }

    static List<Context__mdt> getContexts() {
        return new List<Context__mdt>{
                new Context__mdt(
                        DeveloperName = 'Test context',
                        MasterLabel = 'Test label',
                        Type__c = 'Workflow Path',
                        Delete__c = true,
                        Create__c = true,
                        Edit__c = true
                )
        };
    }

    static List<Action__mdt> getActions() {
        return new List<Action__mdt>{
                new Action__mdt(
                        DeveloperName = 'Test action',
                        MasterLabel = 'Test label',
                        Type__c = 'Workflow Path',
                        NewValue__c = 'PendingApproval',
                        Field__c = 'Status__c'
                )
        };
    }

    static List<ContextType__mdt> getContextTypes() {
        return new List<ContextType__mdt>{
                new ContextType__mdt(
                        DeveloperName = 'Test contetx type',
                        MasterLabel = 'Test label',
                        Object__c = 'Meeting__c',
                        IsControlledByWorkflowPath__c = true
                )
        };
    }

    static List<ContextCondition__mdt> getContextConditions() {
        return new List<ContextCondition__mdt>{
                new ContextCondition__mdt(
                        DeveloperName = 'Test context condition',
                        MasterLabel = 'Test label',
                        Field__c = 'Status.c',
                        Operator__c = 'EQUALS',
                        Value__c = 'Draft'
                )
        };
    }

    static List<ContextAction__mdt> getContextActions() {
        return new List<ContextAction__mdt>{
                new ContextAction__mdt(
                        DeveloperName = 'Test context action',
                        MasterLabel = 'Test label',
                        Order__c = 1
                )
        };
    }

    static List<MeetingWorkFlowNodeConfiguration__mdt> getPathNodes() {
        return new List<MeetingWorkFlowNodeConfiguration__mdt>{
                new MeetingWorkFlowNodeConfiguration__mdt(
                        DeveloperName = 'Test context action',
                        MasterLabel = 'Test label',
                        MeetingStatus__c = 'Draft'

                )
        };
    }

    static MeetingWorkFlowConfiguration__mdt getPath() {
        return new MeetingWorkFlowConfiguration__mdt(
                DeveloperName = 'Test context action',
                MasterLabel = 'Test label',
                ControllingField__c = 'Status__c',
                MeetingRecordTypeName__c = 'Meeting__c-Rep_Presentation'
        );
    }
}
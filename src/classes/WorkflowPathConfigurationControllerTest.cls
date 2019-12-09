@IsTest
private class WorkflowPathConfigurationControllerTest {
    private static TestUtils.StubFactory stubFactory = new TestUtils.StubFactory();
    private static TestUtils.MockFactory mockFactory = new TestUtils.MockFactory();

    @isTest
    static void getWorkflowTest_Success () {
        //Given
        WorkflowPathConfigurationService.WorkflowParamsDto params = new WorkflowPathConfigurationService.WorkflowParamsDto();
        WorkflowConfigurationDto configuration = new WorkflowConfigurationDto();


        TestUtils.Stub workflowPathConfigurationService = stubFactory.stub();
        workflowPathConfigurationService
                .when(
                'getWorkflowPathConfigurationByParams',
                params
        )
                .thenReturn(configuration);

        WorkflowPathConfigurationController.service = (WorkflowPathConfigurationService) mockFactory.mock(WorkflowPathConfigurationService.class, workflowPathConfigurationService);

        //When
        Test.startTest();
        WorkflowConfigurationDto receivedConfiguration = WorkflowPathConfigurationController.getWorkflow(JSON.serialize(params));
        Test.stopTest();

        //Then
        System.assert(receivedConfiguration != null);
    }

    @isTest
    static void getWorkflowTest_Exception() {
        //Given
        Boolean exFlag = false;

        WorkflowPathConfigurationService service = (WorkflowPathConfigurationService) Test.createStub(
                WorkflowPathConfigurationService.class,
                new WorkflowPathConfigurationServiceErrorStubProvider()
        );
        WorkflowPathConfigurationController.service = service;

        //When
        try {
            Test.startTest();
            WorkflowPathConfigurationController.getWorkflow('dev name');
            Test.stopTest();
        } catch (Exception e) {
            exFlag = true;
        }

        //Then
        System.assert(exFlag);
    }

    @isTest
    static void deployWorkflowPath_Success () {
        //Given
        WorkflowConfigurationDto configuration = new WorkflowConfigurationDto();

        TestUtils.Stub workflowPathConfigurationService = stubFactory.stub();
        workflowPathConfigurationService
                .when(
                'deployWorkflowPath',
                configuration
        )
                .thenReturn(null);

        WorkflowPathConfigurationController.service = (WorkflowPathConfigurationService) mockFactory.mock(WorkflowPathConfigurationService.class, workflowPathConfigurationService);

        //When
        Test.startTest();
        Id deploymentId = WorkflowPathConfigurationController.deployWorkflowPath(JSON.serialize(configuration));
        Test.stopTest();

        //Then
        System.assert(deploymentId == null);
    }

    @isTest
    static void deployWorkflowPath_Exception() {
        //Given
        Boolean exFlag = false;
        WorkflowConfigurationDto configuration = new WorkflowConfigurationDto();

        WorkflowPathConfigurationService service = (WorkflowPathConfigurationService) Test.createStub(
                WorkflowPathConfigurationService.class,
                new WorkflowPathConfigurationServiceErrorStubProvider()
        );
        WorkflowPathConfigurationController.service = service;

        //When
        try {
            Test.startTest();
            WorkflowPathConfigurationController.deployWorkflowPath(JSON.serialize(configuration));
            Test.stopTest();
        } catch (Exception e) {
            exFlag = true;
        }

        //Then
        System.assert(exFlag);
    }

    private class WorkflowPathConfigurationServiceErrorStubProvider implements System.StubProvider{

        public Object handleMethodCall(Object stubbedObject,
                String stubbedMethodName,
                System.Type returnType,
                List<System.Type> listOfParamTypes,
                List<String> listOfParamNames,
                List<Object> listOfArgs) {

            throw new WorkflowPathConfigurationServiceErrorStubException();
        }


    }

    private class WorkflowPathConfigurationServiceErrorStubException extends Exception {
    }
}
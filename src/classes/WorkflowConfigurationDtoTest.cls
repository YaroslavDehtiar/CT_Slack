@IsTest
private class WorkflowConfigurationDtoTest {

    @isTest
    static void testWorkflowDtoCreateTest_Success() {
        //Given
        MeetingWorkFlowConfiguration__mdt meetingWorkFlowConfiguration = getMeetingWorkFlowConfiguration();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowPathDto workflowPathDto = new WorkflowConfigurationDto.WorkflowPathDto(meetingWorkFlowConfiguration);
        Test.stopTest();

        //Then
        System.assert(workflowPathDto.id == meetingWorkFlowConfiguration.Id);
        System.assert(workflowPathDto.label == meetingWorkFlowConfiguration.MasterLabel);
        System.assert(workflowPathDto.name == meetingWorkFlowConfiguration.DeveloperName);
        System.assert(workflowPathDto.controllingField == meetingWorkFlowConfiguration.ControllingField__c);
        System.assert(workflowPathDto.contextType == meetingWorkFlowConfiguration.ContextType__c);
        System.assert(workflowPathDto.status == meetingWorkFlowConfiguration.Status__c);
    }

    @isTest
    static void testWorkflowDtoGetMetadataRecordTest_Success() {
        //Given
        MeetingWorkFlowConfiguration__mdt meetingWorkFlowConfiguration = getMeetingWorkFlowConfiguration();
        WorkflowConfigurationDto.WorkflowPathDto workflowPathDto = new WorkflowConfigurationDto.WorkflowPathDto(meetingWorkFlowConfiguration);

        //When
        Test.startTest();
        MeetingWorkFlowConfiguration__mdt receivedMeetingWorkFlowConfiguration = workflowPathDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(receivedMeetingWorkFlowConfiguration.Id == meetingWorkFlowConfiguration.Id);
        System.assert(receivedMeetingWorkFlowConfiguration.MasterLabel == meetingWorkFlowConfiguration.MasterLabel);
        System.assert(receivedMeetingWorkFlowConfiguration.DeveloperName == meetingWorkFlowConfiguration.DeveloperName);
        System.assert(receivedMeetingWorkFlowConfiguration.ControllingField__c == meetingWorkFlowConfiguration.ControllingField__c);
        System.assert(receivedMeetingWorkFlowConfiguration.Status__c == meetingWorkFlowConfiguration.Status__c);
        System.assert(receivedMeetingWorkFlowConfiguration.MeetingRecordTypeName__c == meetingWorkFlowConfiguration.MeetingRecordTypeName__c);
        System.assert(receivedMeetingWorkFlowConfiguration.ContextType__c == meetingWorkFlowConfiguration.ContextType__c);
    }

    @isTest
    static void workflowPathNodeDtoCreateTest_Success() {
        //Given
        MeetingWorkFlowNodeConfiguration__mdt meetingWorkFlowNodeConfiguration = getMeetingWorkFlowNodeConfiguration();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowPathNodeDto pathNodeDto = new WorkflowConfigurationDto.WorkflowPathNodeDto(meetingWorkFlowNodeConfiguration);
        Test.stopTest();

        //Then
        System.assert(pathNodeDto.id == meetingWorkFlowNodeConfiguration.Id);
        System.assert(pathNodeDto.name == meetingWorkFlowNodeConfiguration.DeveloperName);
        System.assert(pathNodeDto.label == meetingWorkFlowNodeConfiguration.MasterLabel);
        System.assert(pathNodeDto.controllingFieldValue == meetingWorkFlowNodeConfiguration.MeetingStatus__c);
    }

    @isTest
    static void workflowPathNodeDtoGetMetadatarecordTest_Success() {
        //Given
        MeetingWorkFlowNodeConfiguration__mdt meetingWorkFlowNodeConfiguration = getMeetingWorkFlowNodeConfiguration();
        WorkflowConfigurationDto.WorkflowPathNodeDto pathNodeDto = new WorkflowConfigurationDto.WorkflowPathNodeDto(meetingWorkFlowNodeConfiguration);
        //When
        Test.startTest();
        MeetingWorkFlowNodeConfiguration__mdt receivedMeetingWorkFlowNodeConfiguration = pathNodeDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(receivedMeetingWorkFlowNodeConfiguration.Id == meetingWorkFlowNodeConfiguration.Id);
        System.assert(receivedMeetingWorkFlowNodeConfiguration.DeveloperName == meetingWorkFlowNodeConfiguration.DeveloperName);
        System.assert(receivedMeetingWorkFlowNodeConfiguration.MasterLabel == meetingWorkFlowNodeConfiguration.MasterLabel);
        System.assert(receivedMeetingWorkFlowNodeConfiguration.MeetingStatus__c == meetingWorkFlowNodeConfiguration.MeetingStatus__c);
    }

    @isTest
    static void workflowContextDtoCreateTest_Success() {
        //Given
        Context__mdt context = getContext();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowContextDto contextDto = new WorkflowConfigurationDto.WorkflowContextDto(context);
        Test.stopTest();

        //Then
        System.assert(context.Id == contextDto.id);
        System.assert(context.DeveloperName == contextDto.name);
        System.assert(context.MasterLabel == contextDto.label);
        System.assert(context.Create__c == contextDto.create);
        System.assert(context.Edit__c == contextDto.edit);
        System.assert(context.Delete__c == contextDto.deletex);
        System.assert(context.Type__c == contextDto.type);
        System.assert(context.ParentContext__c == contextDto.parentContext);
        System.assert(context.WorkflowPathNode__c == contextDto.workflowPathNode);
    }

    @isTest
    static void workflowContextDtoGetMetadataRecordTest_Success() {
        //Given
        Context__mdt context = getContext();
        WorkflowConfigurationDto.WorkflowContextDto contextDto = new WorkflowConfigurationDto.WorkflowContextDto(context);

        //When
        Test.startTest();
        Context__mdt receivedContext = contextDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(context.Id == receivedContext.id);
        System.assert(context.DeveloperName == receivedContext.DeveloperName);
        System.assert(context.MasterLabel == receivedContext.MasterLabel);
        System.assert(context.Create__c == receivedContext.Create__c);
        System.assert(context.Edit__c == receivedContext .Edit__c);
        System.assert(context.Delete__c == receivedContext.Delete__c);
        System.assert(context.Type__c == receivedContext.Type__c);
        System.assert(context.ParentContext__c == receivedContext.ParentContext__c);
        System.assert(context.WorkflowPathNode__c == receivedContext.WorkflowPathNode__c);
    }

    @isTest
    static void WorkflowContextConditionDtoCreateTest_Success() {
        //Given
        ContextCondition__mdt contextCondition = getContextCondition();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowContextConditionDto contextConditionDto = new WorkflowConfigurationDto.WorkflowContextConditionDto(contextCondition);
        Test.stopTest();

        //Then
        System.assert(contextCondition.Id == contextConditionDto.id);
        System.assert(contextCondition.DeveloperName == contextConditionDto.name);
        System.assert(contextCondition.MasterLabel == contextConditionDto.label);
        System.assert(contextCondition.Field__c == contextConditionDto.field);
        System.assert(contextCondition.Operator__c == contextConditionDto.operator);
        System.assert(contextCondition.Value__c == contextConditionDto.value);
        System.assert(contextCondition.Context__c == contextConditionDto.context);
    }

    @isTest
    static void WorkflowContextConditionDtoGetMetadataRecordTest_Success() {
        //Given
        ContextCondition__mdt contextCondition = getContextCondition();
        WorkflowConfigurationDto.WorkflowContextConditionDto contextConditionDto = new WorkflowConfigurationDto.WorkflowContextConditionDto(contextCondition);

        //When
        Test.startTest();
        ContextCondition__mdt receivedContextCondition = contextConditionDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(contextCondition.Id == receivedContextCondition.Id);
        System.assert(contextCondition.DeveloperName == receivedContextCondition.DeveloperName);
        System.assert(contextCondition.MasterLabel == receivedContextCondition.MasterLabel);
        System.assert(contextCondition.Field__c == receivedContextCondition.Field__c);
        System.assert(contextCondition.Operator__c == receivedContextCondition.Operator__c);
        System.assert(contextCondition.Value__c == receivedContextCondition.Value__c);
        System.assert(contextCondition.Context__c == receivedContextCondition.Context__c);
    }

    @isTest
    static void WorkflowContextActionDtoCreateTest_Success() {
        //Given
        ContextAction__mdt contextAction = getContextAction();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowContextActionDto contextActionDto = new WorkflowConfigurationDto.WorkflowContextActionDto(contextAction);
        Test.stopTest();

        //Then
        System.assert(contextAction.Id == contextActionDto.id);
        System.assert(contextAction.DeveloperName == contextActionDto.name);
        System.assert(contextAction.MasterLabel == contextActionDto.label);
        System.assert(contextAction.Action__c == contextActionDto.action);
        System.assert(contextAction.Context__c == contextActionDto.context);
        System.assert(contextAction.Order__c == contextActionDto.order);
    }

    @isTest
    static void WorkflowContextActionDtoGetMetadataRecordTest_Success() {
        //Given
        ContextAction__mdt contextAction = getContextAction();
        WorkflowConfigurationDto.WorkflowContextActionDto contextActionDto = new WorkflowConfigurationDto.WorkflowContextActionDto(contextAction);

        //When
        Test.startTest();
        ContextAction__mdt receivedContextAction = contextActionDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(contextAction.Id == receivedContextAction.Id);
        System.assert(contextAction.DeveloperName == receivedContextAction.DeveloperName);
        System.assert(contextAction.MasterLabel == receivedContextAction.MasterLabel);
        System.assert(contextAction.Action__c == receivedContextAction.Action__c);
        System.assert(contextAction.Context__c == receivedContextAction.Context__c);
        System.assert(contextAction.Order__c == receivedContextAction.Order__c);
    }

    @isTest
    static void workflowActionDtoCreateTest_Success() {
        //Given
        Action__mdt action = getAction();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowActionDto actionDto = new WorkflowConfigurationDto.WorkflowActionDto(action);
        Test.stopTest();

        //Then
        System.assert(action.Id == actionDto.id);
        System.assert(action.DeveloperName == actionDto.name);
        System.assert(action.MasterLabel == actionDto.label);
        System.assert(action.ContextType__c == actionDto.contextType);
        System.assert(action.Field__c == actionDto.field);
        System.assert(action.NewValue__c == actionDto.newValue);
        System.assert(action.Type__c == actionDto.type);
    }

    @isTest
    static void workflowActionDtoGetMetadataRecordTest_Success() {
        //Given
        Action__mdt action = getAction();
        WorkflowConfigurationDto.WorkflowActionDto actionDto = new WorkflowConfigurationDto.WorkflowActionDto(action);

        //When
        Test.startTest();
        Action__mdt receivedAction = actionDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(action.Id == receivedAction.Id);
        System.assert(action.DeveloperName == receivedAction.DeveloperName);
        System.assert(action.MasterLabel == receivedAction.MasterLabel);
        System.assert(action.ContextType__c == receivedAction.ContextType__c);
        System.assert(action.Field__c == receivedAction.Field__c);
        System.assert(action.NewValue__c == receivedAction.NewValue__c);
        System.assert(action.Type__c == receivedAction.Type__c);
    }

    @isTest
    static void workflowContextTypeDtoCreateTest_Success() {
        //Given
        ContextType__mdt contextType = getContextType();

        //When
        Test.startTest();
        WorkflowConfigurationDto.WorkflowContextTypeDto contextTypeDto = new WorkflowConfigurationDto.WorkflowContextTypeDto(contextType);
        Test.stopTest();

        //Then
        System.assert(contextType.Id == contextTypeDto.id);
        System.assert(contextType.DeveloperName == contextTypeDto.name);
        System.assert(contextType.MasterLabel == contextTypeDto.label);
        System.assert(contextType.IsControlledByWorkflowPath__c == contextTypeDto.isControlledByWorkflowPath);
    }

    @isTest
    static void workflowContextTypeDtoGetMetadataRecordTest_Success() {
        //Given
        ContextType__mdt contextType = getContextType();
        WorkflowConfigurationDto.WorkflowContextTypeDto contextTypeDto = new WorkflowConfigurationDto.WorkflowContextTypeDto(contextType);

        //When
        Test.startTest();
        ContextType__mdt receivedContextType = contextTypeDto.getMetadataRecord();
        Test.stopTest();

        //Then
        System.assert(contextType.Id == receivedContextType.id);
        System.assert(contextType.DeveloperName == receivedContextType.DeveloperName);
        System.assert(contextType.MasterLabel == receivedContextType.MasterLabel);
        System.assert(contextType.IsControlledByWorkflowPath__c == receivedContextType.IsControlledByWorkflowPath__c);
    }

    static ContextType__mdt getContextType() {
        return new ContextType__mdt(
                Id = IdUtils.generate(ContextType__mdt.SObjectType),
                MasterLabel = 'label',
                DeveloperName = 'dev name',
                IsControlledByWorkflowPath__c = true,
                Object__c = 'Meeting__c'
        );
    }

    static Action__mdt getAction() {
        return new Action__mdt(
                Id = IdUtils.generate(Action__mdt.SObjectType),
                MasterLabel = 'label',
                DeveloperName = 'dev name',
                ContextType__c = IdUtils.generate(ContextType__mdt.SObjectType),
                Field__c = 'field',
                NewValue__c = 'value',
                Type__c = 'type'
        );
    }

    static ContextAction__mdt getContextAction() {
        return new ContextAction__mdt(
                Id = IdUtils.generate(ContextAction__mdt.SObjectType),
                MasterLabel = 'label',
                DeveloperName = 'dev name',
                Action__c = IdUtils.generate(Action__mdt.SObjectType),
                Context__c = IdUtils.generate(Context__mdt.SObjectType),
                Order__c = 2
        );
    }

    static ContextCondition__mdt getContextCondition() {
        return new ContextCondition__mdt(
                Id = IdUtils.generate(ContextCondition__mdt.SObjectType),
                MasterLabel = 'label',
                DeveloperName = 'dev name',
                Field__c = 'field',
                Operator__c = 'operator',
                Value__c = 'value',
                Context__c = IdUtils.generate(Context__mdt.SObjectType)
        );
    }

    static Context__mdt getContext() {
        return new Context__mdt(
                Id = IdUtils.generate(Context__mdt.SObjectType),
                DeveloperName = 'dev name',
                MasterLabel = 'label',
                Create__c = true,
                Edit__c = true,
                Delete__c = true,
                Type__c = 'type',
                ParentContext__c = 'parent context',
                WorkflowPathNode__c = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType)
        );
    }

    static MeetingWorkFlowNodeConfiguration__mdt getMeetingWorkFlowNodeConfiguration() {
        return new MeetingWorkFlowNodeConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowNodeConfiguration__mdt.SObjectType),
                DeveloperName = 'dev name',
                MasterLabel = 'master label',
                MeetingStatus__c = 'draft'
        );
    }

    private static MeetingWorkFlowConfiguration__mdt getMeetingWorkFlowConfiguration() {
        return new MeetingWorkFlowConfiguration__mdt(
                Id = IdUtils.generate(MeetingWorkFlowConfiguration__mdt.SObjectType),
                DeveloperName = 'dev name',
                MasterLabel = 'master label',
                ControllingField__c = 'field',
                Status__c = 'draft',
                MeetingRecordTypeName__c = 'MeetingMember__c-Attendee',
                ContextType__c = IdUtils.generate(ContextType__mdt.SObjectType)
        );
    }
}
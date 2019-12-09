public inherited sharing class WorkflowPathException extends Exception {

    public static WorkflowPathException newInstance(MeetingWorkFlowConfiguration__mdt mdtWorkflowPath, String message) {
        String jsonWorkflowPath = JSON.serialize(mdtWorkflowPath);
        String decoratedMessage = message + '\nMeetingWorkFlowConfiguration__mdt: ' + jsonWorkflowPath;

        return new WorkflowPathException(decoratedMessage);
    }
}
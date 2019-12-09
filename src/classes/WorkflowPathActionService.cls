public inherited sharing class WorkflowPathActionService {

    private static final String EXPRESSION_WITH_POINT = '$value.';
    private static final String EXPRESSION = '$value';
    private static final String EMPTY_STRING = '';

    public ActionResult publishPlatformEvent(Id recordId, String eventName, Map<String, Object> eventParams) {
        Set<String> fieldToSelect = this.getFieldsToSelect(eventParams, recordId.getSobjectType());
        SObject record;

        if (!fieldToSelect.isEmpty()) {
            VirtualDAO virtualDAO = new VirtualDAO(recordId.getSobjectType());
            record = virtualDAO.getSObjectById(recordId, fieldToSelect);
        }

        SObject event = this.initEvent(eventName, eventParams, record);

        Database.SaveResult saveResult = EventBus.publish(event);
        ActionResult actionResult = new ActionResult();
        actionResult.setSaveResults( new List<Database.SaveResult>{saveResult});

        return actionResult;
    }

    private Set<String> getFieldsToSelect(Map<String, Object> eventParams, SObjectType sObjectType) {
        Set<String> fieldToSelect = new Set<String>();
        String sObjectName = sObjectType.getDescribe().getName();
        String sObjectFieldName;

        for (String eventFieldName: eventParams.keySet()) {
            String value = (String)eventParams.get(eventFieldName);

            if (value.contains(EXPRESSION_WITH_POINT)) {
                sObjectFieldName = value.replace(EXPRESSION_WITH_POINT, EMPTY_STRING);

                if (ObjectUtilities.isField(sObjectName, sObjectFieldName)) {
                    fieldToSelect.add(sObjectFieldName);
                }

            } else if (value == EXPRESSION) {
                return SchemaDescribeUtils.getAllFields(sObjectType);
            }
        }

        return fieldToSelect;
    }

    private SObject initEvent(String eventName,  Map<String, Object> eventParams, SObject record) {
        SObject event  = (SObject) Type.forName(eventName).newInstance();
        String sObjectFieldName;

        for (String eventFieldName: eventParams.keySet()) {
            String value = (String)eventParams.get(eventFieldName);

            if (value.contains(EXPRESSION_WITH_POINT)) {
                sObjectFieldName = value.replace(EXPRESSION_WITH_POINT, EMPTY_STRING);

                if (ObjectUtilities.isField(record, sObjectFieldName)) {
                    event.put(eventFieldName, record.get(sObjectFieldName));
                }

            } else if (value == EXPRESSION) {
                event.put(eventFieldName, JSON.serialize(record));
            } else {
                event.put(eventFieldName, value);
            }
        }

        return event;
    }
}
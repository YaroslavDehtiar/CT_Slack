trigger RollOut on GrandChild__c (after insert, after update, before delete ) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            GrandChildTriggerHandler.afterInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            GrandChildTriggerHandler.afterUpdate(Trigger.newMap);
        }
    }
    if(Trigger.isBefore){
        if (Trigger.isDelete) {
            GrandChildTriggerHandler.afterDelete(Trigger.oldMap);
        }
    }
}
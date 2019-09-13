/**
 * Created by YaroslavDehtiar on 27.08.2019.
 */

public with sharing class QueryBuilder {

    @AuraEnabled
    public static List<String> getObjects() {
        Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();
        List<String> getAllObjectLabels = new List<String>();

        for (Schema.SObjectType thisObj : allObjects.values()) {
            getAllObjectLabels.add(String.valueOf(thisObj));
        }
        getAllObjectLabels.sort();

        return getAllObjectLabels;
    }

    @AuraEnabled
    public static List<String> getFields(String objectName) {
        List<String> fieldNames = new List<String>(
                Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().keySet());
        List<String> fieldNamesToUpperCase = new List<String>();
        for (String str : fieldNames) {
            fieldNamesToUpperCase.add(str.substring(0, 1).toUpperCase() + str.substring(1, str.length()));
        }
        return fieldNamesToUpperCase;
    }

    @AuraEnabled
    public static List<Object> finalExecute(String objectName, List<String> fieldList,
            String filterField, String operator, String value) {
        String allFields = '';
        for (String str : fieldList) {
            allFields += str + ',';
        }
        allFields = allFields.substring(0, allFields.length() - 1);
        String query;
        if(filterField == null || operator == null || value == null){
            query = 'Select ' + allFields + ' From ' + objectName;
        }else{
            query = 'Select ' + allFields + ' From ' + objectName + ' Where '
                + filterField + ' ' + operator + ' \'' + value + '\'';
        }
        System.debug(query);
        List<Object> allPickedObjects = Database.query(query);
        return allPickedObjects;
    }
}
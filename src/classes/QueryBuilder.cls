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
    public static Map<String, String> getFields(String objectName) {
        Map<String, Schema.SObjectField> mapOfObjects = new Map<String, Schema.SObjectField>
                (Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap());
        List<String> typeOfFields = new List<String>();
        for (SObjectField sObjectField : mapOfObjects.values()) {
            typeOfFields.add(String.valueOf(sObjectField.getDescribe().getType()));
        }
        List<String> fieldNames = new List<String>();
        for (String str : mapOfObjects.keySet()) {
            fieldNames.add(str);
        }
        List<String> fieldNamesToUpperCase = new List<String>();
        for (String str : fieldNames) {
            fieldNamesToUpperCase.add(str.substring(0, 1).toUpperCase() + str.substring(1, str.length()));
        }
        Map<String, String> returnObjects = new Map<String, String>();
        for (Integer i = 0; i < fieldNamesToUpperCase.size(); i++) {
            returnObjects.put(fieldNamesToUpperCase.get(i), typeOfFields.get(i));
        }
        return returnObjects;
    }

    @AuraEnabled
    public static List<Object> finalExecute(String objectName, List<String> fieldList,
            List<String> filterStrings) {
        String allFields = '';
        for (String str : fieldList) {
            allFields += str + ',';
        }
        String subQuery = '';
        allFields = allFields.substring(0, allFields.length() - 1);
        String query;
        query = 'Select ' + allFields + ' From ' + objectName;
        if(filterStrings.size() != 0) {
            subQuery += 'Where ';
            for (String str : filterStrings) {
                subQuery += str + ' ';
            }
            subQuery.trim();
            query += ' ' + subQuery;
        }
        System.debug(query);
        List<Object> allPickedObjects = Database.query(query);
        return allPickedObjects;
    }

    @AuraEnabled
    public static List<String> getAllTypesFromObject(String getObject) {
        String field_name = 'Type';
        String[] values = new String[]{
        };
        String[] types = new String[]{
                getObject
        };
        Schema.DescribeSObjectResult[] results = Schema.describeSObjects(types);
        for (Schema.DescribeSObjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.add(entry.getValue());
                }
            }
        }
        return values;
    }
}
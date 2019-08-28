/**
 * Created by YaroslavDehtiar on 27.08.2019.
 */

public with sharing class QueryBuilder {

    @AuraEnabled
    public static List<String> getObjects(){
        Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();
        List<String> getAllObjectLabels = new List<String>();

        for(Schema.SObjectType thisObj : allObjects.values()) {
            getAllObjectLabels.add(String.valueOf(thisObj));
        }
        getAllObjectLabels.sort();

        return getAllObjectLabels;
    }

    @AuraEnabled
    public static List<String> getFields(String objectName){
        List<String> fieldNames = new List<String>(
                Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().keySet());
        List<String> fieldNamesToUpperCase = new List<String>();
        for (String str : fieldNames) {
            fieldNamesToUpperCase.add(str.substring(0,1).toUpperCase() + str.substring(1, str.length()));
        }
        return fieldNamesToUpperCase;
    }

}
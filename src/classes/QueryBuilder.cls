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

        return getAllObjectLabels;
    }

}
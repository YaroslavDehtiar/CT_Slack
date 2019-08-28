/**
 * Created by YaroslavDehtiar on 27.08.2019.
 */

public with sharing class QueryBuilder {

    @AuraEnabled
    public static List<String> getObjects(){
        Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();
        List<String> getAllObjectLabels = new List<String>();

//        Integer count = 0;
        for(Schema.SObjectType thisObj : allObjects.values()) {
            getAllObjectLabels.add(String.valueOf(thisObj));
//            count++;
//            if (count >= 50) {
//                break;
//            }
        }
        getAllObjectLabels.sort();

        return getAllObjectLabels;
    }

    @AuraEnabled
    public static List<String> getFields(String str){
        String query = 'SELECT ID FROM ' + str;
        List<String> objects = new List<String>();
        objects.add('asdasd');
        objects.add('asdasd1');
        objects.add('asdasd12');
        return objects;
    }

}
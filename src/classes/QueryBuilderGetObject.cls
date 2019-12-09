/**
 * Created by YaroslavDehtiar on 27.09.2019.
 */

public with sharing class QueryBuilderGetObject {
    @AuraEnabled
    public static List<String> getAllTypesFromObject(){
        QueryBuilder getObj = new QueryBuilder();
        String getObject = getObj.getMainObject();
        String query = 'Select Type From ' + getObject;
        System.debug(getObject);
        List<Object> newTypes = Database.query(query);
        List<String> allTypes = new List<String>();
        for (Object obj : newTypes) {
            allTypes.add(String.valueOf(obj));
        }
        System.debug(allTypes);
        return allTypes;
    }
}
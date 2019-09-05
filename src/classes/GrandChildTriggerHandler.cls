/**
 * Created by YaroslavDehtiar on 04.09.2019.
 */

public with sharing class GrandChildTriggerHandler {

    public static void afterInsert(Map<Id, GrandChild__c> child){
        RollOut.insertQuantity(child);
    }

    public static void afterUpdate(Map<Id, GrandChild__c> child){
        
    }

    public static void afterDelete(List<GrandChild__c> child){

    }

}
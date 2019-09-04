/**
 * Created by YaroslavDehtiar on 04.09.2019.
 */

trigger RollOut on GrandChild__c (after insert, after update, after delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){

        }
        if(Trigger.isUpdate){

        }
        if(Trigger.isDelete){

        }
    }
}
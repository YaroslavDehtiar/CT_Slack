/**
 * Created by YaroslavDehtiar on 15.10.2019.
 */
public with sharing class Notification {
    @AuraEnabled
    public static String notificationMessage(){
        return 'Hello from Notification';
    }
}
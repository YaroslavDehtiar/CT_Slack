/**
 * Created by YaroslavDehtiar on 23.08.2019.
 */

public with sharing class getAllContactSObjects {
    public static List<Contact> getAllContactField() {
        Map<String, Schema.SObjectField> fieldMap = Contact.SObjectType.getDescribe().fields.getMap();
        Set<String> fieldNames = fieldMap.keySet();
        String tmp = '';
        for (String str : fieldNames) {
            tmp += str + ',';
        }
        tmp = tmp.substring(0, tmp.length()-1);
        List<Contact> listContactFields = Database.query('SELECT ' + tmp + ' FROM Contact');
        return listContactFields;
    }

}
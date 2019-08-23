/**
 * Created by YaroslavDehtiar on 23.08.2019.
 */

public with sharing class getAllContactSObjects {
    public static List<Contact> getAllContactField() {
        Map<String, Schema.SObjectField> fieldMap = Contact.SObjectType.getDescribe().fields.getMap();
        Set<String> fieldNames = fieldMap.keySet();
        String tmp = '';
        List<Contact> listContactFields = new List<Contact>();
        for (String str : fieldNames) {
            tmp += str.substring(0,1).toUpperCase() + str.substring(1) + ', ';
            if(tmp.length() > 500){
                tmp += tmp.substring(0, tmp.length()-2);
                listContactFields.addAll(chock(str));
                tmp = '';
            }
        }
        tmp = tmp.substring(0, tmp.length()-2);
        listContactFields.addAll(chock(tmp));
        return listContactFields;
    }

    public static List<Contact> chock(String str){
        List<Contact> listContactFields = Database.query('SELECT ' + str + ' FROM Contact');
        return listContactFields;
    }

}
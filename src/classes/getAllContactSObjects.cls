/**
 * Created by YaroslavDehtiar on 23.08.2019.
 */

public with sharing class getAllContactSObjects {
    public static List<Contact> getAllContactField() {
        List<String> fieldNames = new List<String>(
                Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet());
        String tmp = String.join(fieldNames, ',');
        List<Contact> listContactFields = Database.query('SELECT ' + tmp + ' FROM Contact');
        return listContactFields;
    }

}
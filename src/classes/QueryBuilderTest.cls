/**
 * Created by YaroslavDehtiar on 27.08.2019.
 */
@isTest
public with sharing class QueryBuilderTest {

    @isTest
    public static void checkObjects() {
        QueryBuilder.getObjects();
    }

    @isTest
    public static void checkFields() {
        QueryBuilder.getFields('Contact');
    }

    @isTest
    public static void checkExecute() {
        List<String> str = new List<String>();
        str.add('Id');
        str.add('Name');
        QueryBuilder.finalExecute('Account', str);
    }
}
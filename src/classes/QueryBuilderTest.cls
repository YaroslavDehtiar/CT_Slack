/**
 * Created by YaroslavDehtiar on 27.08.2019.
 */
@IsTest
public with sharing class QueryBuilderTest {

    @IsTest
    public static void checkObjects() {
        QueryBuilder.getObjects();
    }

    @IsTest
    public static void checkFields() {
        QueryBuilder.getFields('Contact');
    }

    @IsTest
    public static void checkExecute() {
        List<String> str = new List<String>();
        str.add('Id');
        str.add('Name');
        List<String> lStrings = new List<String>();
        QueryBuilder.finalExecute('Account', str, lStrings);
    }

    @IsTest
    public static void checkTypes() {
        String str = 'Account';
        QueryBuilder.getAllTypesFromObject(str);
    }
}
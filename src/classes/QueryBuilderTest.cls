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
}
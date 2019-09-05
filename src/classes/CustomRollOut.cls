/**
 * Created by YaroslavDehtiar on 03.09.2019.
 */

public with sharing class CustomRollOut implements Database.Batchable<SObject>, Schedulable  {


    public Iterable<SObject> start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM GrandChild__c');
    }

    public void execute(Database.BatchableContext bc, List<GrandChild__c> scope) {
        List<Account> accountList = new List<Account>();
        List<GrandChild__c> updatedChild = [SELECT Id, Contact__r.AccountId FROM GrandChild__c WHERE Id = :scope];

        for (GrandChild__c child : updatedChild) {
            for (Account account : [
                    SELECT Id, Quantity_Child__c
                    FROM Account
                    WHERE Id = :child.Contact__r.AccountId
            ]) {
                if (child.Contact__c != null && child.Contact__r.AccountId == account.Id) {
                    if (account.Quantity_Child__c == null) {
                        account.Quantity_Child__c = 0;
                    }
                    account.Quantity_Child__c++;
                    if (!accountList.contains(account)) {
                        accountList.add(account);
                    }
                }
            }
        }
        update accountList;
    }

    public void finish(Database.BatchableContext bc) {

    }

    public void execute(SchedulableContext ctx) {
        CustomRollOut b = new CustomRollOut();
        Database.executeBatch(b);
        String sch = '0 36 16 * *';
        String jobID = System.schedule('Update Job', sch, b);
    }
}
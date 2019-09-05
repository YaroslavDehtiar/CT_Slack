/**
 * Created by YaroslavDehtiar on 04.09.2019.
 */

public with sharing class RollOut {

    public static void insertQuantity(Map<Id, GrandChild__c> grandChild) {
        List<Account> accountList = new List<Account>();
        List<GrandChild__c> updatedChild = [SELECT Id, Contact__r.AccountId FROM GrandChild__c WHERE Id = :grandChild.keySet()];

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
}
/**
 * Created by YaroslavDehtiar on 04.09.2019.
 */

public with sharing class RollOut {

    public static void insertQuantity(Map<Id, GrandChild__c> grandChild) {
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (GrandChild__c child : grandChild.values()) {
            if (accountMap.containsKey(child.Contact__r.AccountId)) {
                Account account = accountMap.get(child.Contact__r.AccountId);
                if (account.Quantity_Child__c == null) {
                    account.Quantity_Child__c = 0;
                }
                account.Quantity_Child__c++;
            } else {
                accountMap.put(child.Contact__r.AccountId, new Account(
                        Id = child.Contact__r.AccountId,
                        Quantity_Child__c = 1
                ));
            }
        }
        update accountMap.values();
    }

    public static void deleteRecord(Map<Id, GrandChild__c> childMap) {
        List<GrandChild__c> childToDelete = [
                SELECT Id, Name, Contact__r.AccountId
                FROM GrandChild__c
                WHERE Id = :childMap.keySet()
        ];
        List<Account> accountList = new List<Account>();
        Set<Id> accountIds = new Set<Id>();
        for (GrandChild__c child : childToDelete) {
            accountIds.add(child.Contact__r.AccountId);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id, Quantity_Child__c
                FROM Account
                WHERE Id IN :accountIds
        ]);

        for (GrandChild__c child : childToDelete) {
            Account accountId = accountMap.get(child.Contact__r.AccountId);
            accountId.Quantity_Child__c--;
            if (!accountList.contains(accountId)) {
                accountList.add(accountId);
            } else {
                accountList.remove(accountList.size() - 1);
                accountList.add(accountId);
            }
        }
        update accountList;
    }
}
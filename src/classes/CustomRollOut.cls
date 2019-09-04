/**
 * Created by YaroslavDehtiar on 03.09.2019.
 */

public with sharing class CustomRollOut implements Database.Batchable<SObject> {


    public Iterable<SObject> start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Name, Quantity_Child__c FROM Contacts) FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Account> duplicateList = new List<Account>();
        List<Account> accountsToUpdate = new List<Account>();
        for (Account account : scope) {
            for (GrandChild__c grandChild : [
                    SELECT Contact__c, Contact__r.Id, Contact__r.AccountId,
                            Contact__r.Account.Quantity_Child__c
                    FROM GrandChild__c WHERE Contact__c != NULL
            ]) {
                if (grandChild.Contact__r.AccountId == account.Id) {
                    if(account.Quantity_Child__c == null){
                        account.Quantity_Child__c = 0;
                    }
                    account.Quantity_Child__c ++;
                    duplicateList.add(account);
                }
            }
        }
        for (Account account : duplicateList) {
            if(!accountsToUpdate.contains(account)){
                accountsToUpdate.add(account);
            }
        }
        update accountsToUpdate;
    }

    public void finish(Database.BatchableContext bc) {

    }

}
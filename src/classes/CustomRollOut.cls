/**
 * Created by YaroslavDehtiar on 03.09.2019.
 */

public with sharing class CustomRollOut implements Database.Batchable<SObject>, Queueable {


    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Contact__r.AccountId, Contact__c FROM GrandChild__c');
    }

    public void execute(Database.BatchableContext bc, List<GrandChild__c> scope) {
        List<Account> accountList = new List<Account>();
        Set<Id> accountIds = new Set<Id>();
        for (GrandChild__c child : scope) {
            accountIds.add(child.Contact__r.AccountId);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id, Quantity_Child__c
                FROM Account
                WHERE Id IN :accountIds
        ]);
        for (Account account : accountMap.values()) {
            account.Quantity_Child__c = 0;
        }
        for (GrandChild__c child : scope) {
            Account accountId = accountMap.get(child.Contact__r.AccountId);
            accountId.Quantity_Child__c++;
            if (!accountList.contains(accountId)) {
                accountList.add(accountId);
            } else {
                accountList.remove(accountList.size() - 1);
                accountList.add(accountId);
            }
        }
        update accountList;
    }

    public void finish(Database.BatchableContext bc) {

        List<String> errorMessages = new List<String>();
        AsyncApexJob asyncApexJobs = [
                SELECT Id, Status, NumberOfErrors, JobItemsProcessed, MethodName,
                        TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob
                WHERE Id = :bc.getJobId()
        ];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{
                asyncApexJobs.CreatedBy.Email
        };
        mail.setToAddresses(toAddresses);
        mail.setSubject('JOB Salesforce RenewalEmailNotification Finished: ' + asyncApexJobs.Status);
        String bodyText = 'Total Job Items ' + asyncApexJobs.TotalJobItems + ' Number of records processed ' +
                asyncApexJobs.JobItemsProcessed + ' with ' + asyncApexJobs.NumberOfErrors + ' failures.\n';
        bodyText += 'Number of Error Messages ' + errorMessages.size() + '\n';
        bodyText += 'Error Message' + String.join(errorMessages, '\n');
        mail.setPlainTextBody(bodyText);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                mail
        });
    }

    public void execute(QueueableContext param1) {
        Database.executeBatch(this, 1);
    }
}
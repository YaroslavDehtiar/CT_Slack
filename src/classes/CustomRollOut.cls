/**
 * Created by YaroslavDehtiar on 03.09.2019.
 */

public with sharing class CustomRollOut implements Database.Batchable<SObject>, Queueable {


    public Iterable<SObject> start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Contact__r.AccountId, Contact__c FROM GrandChild__c');
    }

    public void execute(Database.BatchableContext bc, List<GrandChild__c> scope) {
        List<Account> accountList = new List<Account>();

        for (GrandChild__c child : scope) {
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
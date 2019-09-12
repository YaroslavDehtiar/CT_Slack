/**
 * Created by YaroslavDehtiar on 03.09.2019.
 */

public with sharing class CustomRollOut implements Database.Batchable<SObject>, Queueable, Database.Stateful {

    private Map<Id, Account> accountMap = new Map<Id, Account>();

    public Iterable<SObject> start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Contact__r.AccountId, Contact__c FROM GrandChild__c');
    }

    public void execute(Database.BatchableContext bc, List<GrandChild__c> scope) {

        for (GrandChild__c child : scope) {
            if(accountMap.containsKey(child.Contact__r.AccountId)){
                Account account = accountMap.get(child.Contact__r.AccountId);
                if (account.Quantity_Child__c == null) {
                    account.Quantity_Child__c = 0;
                }
                account.Quantity_Child__c ++;
            }else{
                accountMap.put(child.Contact__r.AccountId, new Account(
                        Id = child.Contact__r.AccountId,
                        Quantity_Child__c = 1
                ));
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        update accountMap.values();
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
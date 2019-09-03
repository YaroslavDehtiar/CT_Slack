/**
 * Created by YaroslavDehtiar on 03.09.2019.
 */

public with sharing class CustomRollOut implements Schedulable, Database.Batchable<SObject>{


    public Iterable<SObject> start(Database.BatchableContext param1) {
        return Database.getQueryLocator('SELECT');
    }

    public void execute(Database.BatchableContext param1, List<SObject> param2) {
    }

    public void finish(Database.BatchableContext param1) {
    }

    public void execute(SchedulableContext param1) {
    }
}
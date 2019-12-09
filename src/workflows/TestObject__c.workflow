<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TestFieldUpdate</fullName>
        <field>TextField__c</field>
        <formula>CreatedBy.CompanyName  &amp;  Owner:Queue.QueueName</formula>
        <name>TestFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_GSO_Contract_Date_Approved</fullName>
        <description>Update GSO Contract Date Approved</description>
        <field>Date_Approved__c</field>
        <formula>Now()</formula>
        <name>Update GSO Contract Date Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Approval Date</fullName>
        <actions>
            <name>Update_GSO_Contract_Date_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GSOContract__c.Approval_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>GSOContract__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>GSOContract__c.Date_Approved__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the approval date when the approval status is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

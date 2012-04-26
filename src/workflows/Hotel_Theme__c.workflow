<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Theme_Active</fullName>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Theme Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Theme_Not_Active</fullName>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Theme Not Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Theme Active</fullName>
        <actions>
            <name>Theme_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Hotel_Theme__c.Theme_Status__c</field>
            <operation>equals</operation>
            <value>Hotel meets criteria</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Theme Not Active</fullName>
        <actions>
            <name>Theme_Not_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Hotel_Theme__c.Theme_Status__c</field>
            <operation>equals</operation>
            <value>Hotel does not meet criteria,Removed theme at hotel&apos;s request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Hotel_Theme__c.Theme_Status__c</field>
            <operation>notEqual</operation>
            <value>Hotel meets criteria</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

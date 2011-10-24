<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Account_Hotel_Record_Type</fullName>
        <description>Will update the Account Record Type to Hotel.</description>
        <field>RecordTypeId</field>
        <lookupValue>Hotel</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Hotel Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Record_Type_DS</fullName>
        <description>Set the Account Record type to Destination Services</description>
        <field>RecordTypeId</field>
        <lookupValue>Destination_Services</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Record Type - DS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Record Type - Destination Services</fullName>
        <actions>
            <name>Set_Account_Record_Type_DS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>DestinationServices</value>
        </criteriaItems>
        <description>Set the Account Record Type to Destination Services when created and matches PSG Record Types below.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account Record Type - Hotel</fullName>
        <actions>
            <name>Set_Account_Hotel_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>MarketManagementHotelAccounts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>EuropeMarketManagement</value>
        </criteriaItems>
        <description>Set the Account Record Type to Hotel when created and matches PSG Record Types below.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

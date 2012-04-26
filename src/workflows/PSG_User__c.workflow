<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Re_Contracting_Authentication</fullName>
        <description>Send Re-Contracting Authentication</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ReContracting/Re_Contracting_Authentication</template>
    </alerts>
    <rules>
        <fullName>Send Re-Contracting Authentication</fullName>
        <actions>
            <name>Send_Re_Contracting_Authentication</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PSG_User__c.Token_Issued_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>PSG_User__c.ReContracting_Token__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PSG_User__c.Token_Verified__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Send Re-Contracting url to Market manager to confirm authentication</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

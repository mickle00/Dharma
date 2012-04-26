<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Notice</fullName>
        <description>Approval Notice</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ReContracting/Approval_Notice</template>
    </alerts>
    <alerts>
        <fullName>Rejected_Notice</fullName>
        <description>Rejected Notice</description>
        <protected>false</protected>
        <recipients>
            <field>Market_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ReContracting/Rejected_Notice</template>
    </alerts>
    <rules>
        <fullName>Approval Notice</fullName>
        <actions>
            <name>Approval_Notice</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GSO_Contract_Submission__c.Contracts_Pending_Approval__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Approval Notice</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rejected Notice</fullName>
        <actions>
            <name>Rejected_Notice</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>GSO_Contract_Submission__c.Contracts_Rejected__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Notify market managers when a contract submission is rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

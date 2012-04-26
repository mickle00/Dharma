<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Out_of_Office_Active_for_Case_Assignment</fullName>
        <description>Out of Office Active for Case Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Out_of_Office_Notice/Out_Of_Office_Notice_Active_for_Case_Assignment</template>
    </alerts>
    <alerts>
        <fullName>Out_of_Office_Notice_Created</fullName>
        <description>Out of Office Notice - Created</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Out_of_Office_Notice/Out_of_Office_Notice_Created_Email</template>
    </alerts>
    <alerts>
        <fullName>Out_of_Office_Notice_Start</fullName>
        <description>Out of Office Notice Start</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Out_of_Office_Notice/Out_Of_Office_Notice_Inactive_for_Case_Assignment</template>
    </alerts>
    <fieldUpdates>
        <fullName>OOF_Notice_Status_to_Active</fullName>
        <description>Set the status on a Out Of Office Notice record to Active</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>OOF Notice - Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <description>Set the status on the Out of Office Notice record to Inactive</description>
        <field>Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>OOF Notice - Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Out of Office Notice - Created</fullName>
        <actions>
            <name>Out_of_Office_Notice_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Out_of_Office_Notice__c.Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fires when Out of Office Notice is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Out of Office Notice - End</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Out_of_Office_Notice__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fires when Out of Office Notice End date is reached</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Out_of_Office_Active_for_Case_Assignment</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>OOF_Notice_Status_to_Active</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Out_of_Office_Notice__c.End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Out of Office Notice - Start</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Out_of_Office_Notice__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fires when Out of Office Notice Start date is reached</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Out_of_Office_Notice_Start</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Status_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Out_of_Office_Notice__c.Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>

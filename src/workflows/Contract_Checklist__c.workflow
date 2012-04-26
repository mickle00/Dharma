<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ARI_Hotel_Ready_Connectivity_Setup</fullName>
        <ccEmails>scook@expedia.com</ccEmails>
        <description>ARI Hotel Ready Connectivity Setup</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Contract_Loading_Contract_Checklist/ARI_Property_Ready_for_Connectivity_Setup</template>
    </alerts>
    <alerts>
        <fullName>EQC_Property_Ready_for_Connectivity_Setup</fullName>
        <ccEmails>eqchelp@expedia.com</ccEmails>
        <description>EQC Property Ready for Connectivity Setup</description>
        <protected>false</protected>
        <senderAddress>expedia.loading@trx.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Contract_Loading_Contract_Checklist/EQC_Property_Ready_for_Connectivity_Setup</template>
    </alerts>
    <alerts>
        <fullName>Ready_to_Load_Additional_Rates_and_Inventory</fullName>
        <ccEmails>scook@expedia.com</ccEmails>
        <description>Ready to Load Additional Rates and Inventory</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Contract_Loading_Contract_Checklist/Ready_to_Load_Additional_Rates_and_Inventory</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Date_Additional_Inventory_Loaded</fullName>
        <field>Date_Addtional_Inventory_Was_Loaded__c</field>
        <formula>Now()</formula>
        <name>Set Date Additional Inventory Loaded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Ready_to_Load_Addnl_Inventory</fullName>
        <description>Set Contract Checklist Status to Ready to Load Additional Rates and Inventory</description>
        <field>Status__c</field>
        <literalValue>Ready to Load Additional Inventory</literalValue>
        <name>Set Status Ready to Load Addnl Inventory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ARI Property Contract Loading Complete</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contract_Checklist__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hotel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.Status__c</field>
            <operation>equals</operation>
            <value>Contract Loading Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.Booking_Notification_Method__c</field>
            <operation>equals</operation>
            <value>ARI/BN</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Additional Rates Ready to Load</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Checklist__c.Duration_of_Inventory__c</field>
            <operation>equals</operation>
            <value>3,2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.Last_Date_of_Inventory_and_Rates__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.Status__c</field>
            <operation>equals</operation>
            <value>Contract Loading Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Date_Additional_Inventory_Loaded</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Status_Ready_to_Load_Addnl_Inventory</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract_Checklist__c.Last_Date_of_Inventory_and_Rates__c</offsetFromField>
            <timeLength>-547</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EQC%2FBN Contract Completed</fullName>
        <actions>
            <name>EQC_Property_Ready_for_Connectivity_Setup</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>EQC_Property_Ready_for_Connectivity_Setup_Notice_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Checklist__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hotel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.Booking_Notification_Method__c</field>
            <operation>equals</operation>
            <value>EQC,EQC/BN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.EQC_Addendum_Attached__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract_Checklist__c.Status__c</field>
            <operation>equals</operation>
            <value>Contract Loading Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>EQC_Property_Ready_for_Connectivity_Setup_Notice_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <description>EQC Notice sent to EQC Help via workflow rule</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>EQC Property Ready for Connectivity Setup Notice Sent</subject>
    </tasks>
</Workflow>

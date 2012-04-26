<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Breakage_Hotel_Shortpay_Case_Created</fullName>
        <ccEmails>breakage@expedia.com</ccEmails>
        <description>Breakage/Hotel Shortpay Case Created</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LodgeOps_Hotel_Partner_Support/Relocation_Short_Pay_Notification2</template>
    </alerts>
    <alerts>
        <fullName>Europe_new_relocations_case_notification_of_a_guest</fullName>
        <ccEmails>customercare@expedialodging.com</ccEmails>
        <description>Europe new relocations case notification of a guest. customercare@expedialodging.com</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LodgeOps_Hotel_Partner_Support/International_New_Case_Notification2</template>
    </alerts>
    <alerts>
        <fullName>Hotel_Shared_Cost_Shortpay_Notification</fullName>
        <ccEmails>breakage@expedia.com</ccEmails>
        <description>Hotel Shared Cost Shortpay Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>LodgeOps_Hotel_Partner_Support/Hotel_Short_Pay_Notification_Shared2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Absorption_updated_to_Expedia</fullName>
        <description>Asorbpiton field updated to Expedia when the Relocations Reason is set to Wyndham Request</description>
        <field>Difference_Absorbed_By__c</field>
        <literalValue>Expedia</literalValue>
        <name>Absorption updated to Expedia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_to_False</fullName>
        <field>Closed__c</field>
        <literalValue>0</literalValue>
        <name>Closed to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Guest_Closed_By_GSO_Salesforce</fullName>
        <field>Closed_By__c</field>
        <formula>&quot;GSO Salesforce&quot;</formula>
        <name>Guest Closed By GSO Salesforce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Guest_Reopen_Status</fullName>
        <field>Status__c</field>
        <literalValue>Reopened</literalValue>
        <name>Guest Reopen Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_Arrival_Status</fullName>
        <field>Status__c</field>
        <literalValue>Past Arrival</literalValue>
        <name>Past Arrival Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Closed_Time_Stamp</fullName>
        <field>Closed_Date_Time__c</field>
        <name>Remove Closed Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Removed_Closed_By</fullName>
        <field>Closed_By__c</field>
        <name>Removed Closed By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_closed_to_true</fullName>
        <description>Sets the boolean &quot;closed&quot; to true.</description>
        <field>Closed__c</field>
        <literalValue>1</literalValue>
        <name>Set closed to &quot;true&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Timestamp_Guest</fullName>
        <description>Updates the guest closed date/time stamp when the status is set to &quot;Completed&quot;</description>
        <field>Closed_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Timestamp Guest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Guest_Closed_By</fullName>
        <field>Closed_By__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Update Guest Closed By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Absorption field update when set to Wyndham</fullName>
        <actions>
            <name>Absorption_updated_to_Expedia</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Relocation_Reason__c</field>
            <operation>startsWith</operation>
            <value>Wyndham Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>API Only,System Administrator</value>
        </criteriaItems>
        <description>Absorption will be updated to Expedia when the Relocation Reason is Wyndham.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Breakage Case - Hotel Shared Cost Shortpay</fullName>
        <actions>
            <name>Breakage_Hotel_Shortpay_Case_Created</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Hotel_Shortpay_Case_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Guest__c.Difference_Absorbed_By__c</field>
            <operation>equals</operation>
            <value>Shared Hotel &amp; Expedia,Walk with Guest Compensation,Hotel</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Booking_Net_Difference__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>API Only,System Administrator</value>
        </criteriaItems>
        <description>A Breakage email is sent when a Hotel Shared Cost Shortpay is identified. Email to shortpay case when asorb=hotel, booking net difference=&gt;0 and case is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Fallbacks After Arrival Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Guest__c.Closed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fallback</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Guest_Closed_By_GSO_Salesforce</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Past_Arrival_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_closed_to_true</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Timestamp_Guest</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Guest__c.Arrival_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Europe Relocation Case Notification</fullName>
        <actions>
            <name>Europe_new_relocations_case_notification_of_a_guest</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification to be sent when the Travel Product selected is Other Europe</description>
        <formula>AND (            Travel_Product__r.Name =&quot;Other (Europe)&quot;,            NOT(ISBLANK(Relocation_Reason__c)),            NOT($Profile.Name = &quot;API Only&quot;),            NOT($Profile.Name = &quot;System Administrator&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Guest Completed</fullName>
        <actions>
            <name>Set_closed_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Timestamp_Guest</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Guest_Closed_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>2 AND (1 OR (3 and 4))</booleanFilter>
        <criteriaItems>
            <field>Guest__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>API Only,System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fallback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Status__c</field>
            <operation>equals</operation>
            <value>Resend,Relocated,Confirmed</value>
        </criteriaItems>
        <description>When the guest status is set to completed, update the boolean, timestamp and note fields to indicate completion and enable reporting.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Guest Reopened Alert</fullName>
        <actions>
            <name>Closed_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Closed_Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Alert relocation supervisors that a guest that had been closed has since been re-opened.</description>
        <formula>OR(AND(ISPICKVAL(PRIORVALUE(Status__c),&quot;Completed&quot;),ISCHANGED(Status__c),NOT(ISPICKVAL(Status__c,&quot;Accommodated at original hotel&quot;))), AND(ISPICKVAL(PRIORVALUE(Status__c), &quot;Accommodated at original hotel&quot;),ISCHANGED(Status__c),NOT(ISPICKVAL(Status__c,&quot;Completed&quot;))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Hotel Shared Short Pay</fullName>
        <actions>
            <name>Hotel_Shared_Cost_Shortpay_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Hotel_Shortpay_Notification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Guest__c.Difference_Absorbed_By__c</field>
            <operation>equals</operation>
            <value>Shared Hotel &amp; Expedia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Hotel_Shared_Cost__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>API Only,System Administrator</value>
        </criteriaItems>
        <description>Notification when additional relocation cost is being shared with Hotel and Expedia. This send an email to shortpay for charging the hotel their portion.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reopen Unconfirmed Fallsbacks</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Guest__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fallback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Closed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Guest__c.Lodging_Booking_Status__c</field>
            <operation>equals</operation>
            <value>Unconfirmed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Closed_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Guest_Reopen_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Remove_Closed_Time_Stamp</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Removed_Closed_By</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Guest__c.Closed_Date_Time__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Hotel_Shortpay_Case_Created</fullName>
        <assignedTo>gsosfdc@expedia.com.dharma</assignedTo>
        <assignedToType>user</assignedToType>
        <description>A workflow email has been sent to breakage@expedia.com to create the breakage case where the hotel is responsible for the relocation and the difference is greater than zero and the overall case has been closed.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Breakage/Hotel Shortpay Case Created Notification</subject>
    </tasks>
    <tasks>
        <fullName>Hotel_Shortpay_Notification</fullName>
        <assignedTo>gsosfdc@expedia.com.dharma</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Email is being sent to accounting shortpay to have the hotel billed for their portion of the additional relocation cost.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Hotel Shortpay Notification</subject>
    </tasks>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Priority3</fullName>
        <field>Priority</field>
        <literalValue>3</literalValue>
        <name>Priority3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Priority4</fullName>
        <field>Priority</field>
        <literalValue>4</literalValue>
        <name>Priority4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Priority_1</fullName>
        <field>Priority</field>
        <literalValue>1</literalValue>
        <name>Priority 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Priority</fullName>
        <field>Priority</field>
        <literalValue>1</literalValue>
        <name>Update Case Priority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Priority</fullName>
        <field>Priority</field>
        <literalValue>4</literalValue>
        <name>Update Priority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Troubleshooting</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Closed Case Update</fullName>
        <actions>
            <name>Update_Priority</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS1</fullName>
        <actions>
            <name>Priority_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(	$RecordType.DeveloperName  = &quot;Commissions&quot;,
	OR(ISCHANGED(Subject),
           ISCHANGED(AccountId)),
	OR(ISPICKVAL(Account.Rating , &quot;1&quot;),
	   CONTAINS( Subject , &quot;prio 1&quot;) ,
	   CONTAINS( Subject , &quot;priority 1&quot;),
	   CONTAINS( Subject , &quot;urgent&quot;),
	   CONTAINS( Subject , &quot;disney&quot;),
	   CONTAINS( Subject , &quot;error&quot;),
	   CONTAINS( Subject , &quot;pri 1&quot;),
	   CONTAINS( Subject , &quot;Moto&quot;),
	   CONTAINS( Subject , &quot;SBK&quot;),
	   CONTAINS( Subject , &quot;Super&quot;),
	   CONTAINS( Subject , &quot;GP&quot;),
	   CONTAINS( Subject , &quot;prix&quot;),
	   CONTAINS( Subject , &quot;F1&quot;),
	   CONTAINS( Subject , &quot;Superbike&quot;),
	   CONTAINS( Subject , &quot;Paddock&quot;),
	   CONTAINS( Subject , &quot;wrong&quot;),
	   CONTAINS( Subject , &quot;mistake&quot;),
	   CONTAINS( Subject , &quot;fix&quot;)
	)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Intake Form Priority 3</fullName>
        <actions>
            <name>Priority3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Intake Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Images/videos</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Intake Form Priority 4</fullName>
        <actions>
            <name>Priority4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Intake Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Ground transfer/zones</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Troubleshooting Que</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Troubleshooting Transport Queue</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

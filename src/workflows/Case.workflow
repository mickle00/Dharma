<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Reply_Notification</fullName>
        <description>Case Reply Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/SUPPORT_Case_Reply_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Spam_Case</fullName>
        <field>Status</field>
        <literalValue>Closed - Spam</literalValue>
        <name>Close_Spam_Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Account_Lookup</fullName>
        <description>Clear the Contact/Account Lookup field once an account and contact has been assigned to the case</description>
        <field>Contact_Account_Lookup_Results__c</field>
        <name>Contact/Account Lookup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Case_Update_Email_Rcvd</fullName>
        <description>Updates case status to &quot;Reply: Customer Email&quot; when an email is received from customer</description>
        <field>Status</field>
        <literalValue>Reply: Customer Email</literalValue>
        <name>DS Case Update - Email Rcvd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Escalate</fullName>
        <description>Checks &quot;Escalated&quot; box</description>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>DS Escalate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Priority_1</fullName>
        <description>Updates Priority to 1 if Account Rank is 1</description>
        <field>Priority</field>
        <literalValue>1</literalValue>
        <name>DS Priority 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Priority_2</fullName>
        <description>Updates case priority to 2 if account is ranked 2</description>
        <field>Priority</field>
        <literalValue>2</literalValue>
        <name>DS Priority 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Priority_3</fullName>
        <description>Updates Case to Priority 3 if Account Rank is 3</description>
        <field>Priority</field>
        <literalValue>3</literalValue>
        <name>DS Priority 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DS_Priority_4</fullName>
        <description>Updates Priority to 4 of Account Rank is 4</description>
        <field>Priority</field>
        <literalValue>4</literalValue>
        <name>DS Priority 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalate_Transfer_DS</fullName>
        <description>Reassigns escalated case to Kim Birkmeyer.</description>
        <field>OwnerId</field>
        <lookupValue>kbirkmeyer@expedia.com.dharma</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>DS Escalate Case Transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_DM_Case</fullName>
        <field>DM_Case__c</field>
        <literalValue>1</literalValue>
        <name>Flag DM Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_as_New_Unrated</fullName>
        <field>Type</field>
        <literalValue>New Star Review</literalValue>
        <name>Flag as New Unrated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HDM_Prio_1</fullName>
        <field>Priority</field>
        <literalValue>1</literalValue>
        <name>HDM Prio 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loc_Category_Bug</fullName>
        <field>Case_Category__c</field>
        <literalValue>Issue</literalValue>
        <name>Loc Category - Bug</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loc_Category_Project</fullName>
        <field>Case_Category__c</field>
        <literalValue>Project</literalValue>
        <name>Loc Category - Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loc_Follow_Up</fullName>
        <field>Case_Category__c</field>
        <literalValue>Follow-Up</literalValue>
        <name>Loc - Follow Up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Loc_Type_Intake_Form</fullName>
        <field>Type</field>
        <literalValue>Intake Form</literalValue>
        <name>Loc Type - Intake Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Media_DS_Case_Type</fullName>
        <description>Changes case type to &quot;Image Audit&quot; when received by the dsmedia alias</description>
        <field>Type</field>
        <literalValue>DS Update</literalValue>
        <name>Media DS Case Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_DS_Case_Type</fullName>
        <description>Changes DS case type to &quot;Not DS&quot;</description>
        <field>Type</field>
        <literalValue>Not DS</literalValue>
        <name>Not DS Case Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Owner_to_Contract_Loading</fullName>
        <field>OwnerId</field>
        <lookupValue>Contract Loading</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case Owner to Contract Loading</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Record_Type_For_HPS</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Lodging_Operations_HPS</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Case Record Type For HPS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Type_to_Zero_Inventory</fullName>
        <field>Type</field>
        <literalValue>Zero Inventory</literalValue>
        <name>Set Case Type to Zero Inventory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Loading_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Contract_Loading</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contract Loading Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_of_First_Response</fullName>
        <field>Date_of_First_Response__c</field>
        <formula>NOW()</formula>
        <name>Set Date of First Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_To_FinOps</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Financial_Operations</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type To FinOps</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_escalation_case_transfer</fullName>
        <description>Transfers case to Scott Darlage when Escalated = true</description>
        <field>OwnerId</field>
        <lookupValue>nancyroller@expedia.com.dharma</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Star escalation case transfer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Venere_Confirmations</fullName>
        <description>Close Venere Confirmation cases as closed - spam</description>
        <field>Status</field>
        <literalValue>Closed - Spam</literalValue>
        <name>Venere Confirmations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Auto_Close_HPS</fullName>
        <actions>
            <name>Close_Spam_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Canc_by_agent IHR,Canc_by_cc IHR,Canc_by_hotel IHR,Canc_by_udr IHR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lodging Operations - HPS</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Auto_Close_PACSAM</fullName>
        <actions>
            <name>Close_Spam_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>DEACTIVATION,REACTIVATION,Risposta Automatica</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lodging Operations - PAC/SAM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>invoicing@venere.com,no_reply@expedia.com,husamoncloa@venere.com</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Auto_Close_PACSAM_2</fullName>
        <actions>
            <name>Close_Spam_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>aec_news_letter@aeccafe.com,mcad_news_letter@mcadcafe.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lodging Operations - PAC/SAM</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Auto_Close_PACSAM_3</fullName>
        <actions>
            <name>Close_Spam_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>VENERE.COM - CANCELLATION DUE TO WRONG CREDIT CARD,VENERE.COM - CANCELLAZIONE PER DATI DI CARTA DI CREDITO NON,VENERE.COM - ANULACIÓN DEBIDA A DATOS,VENERE.COM - ANNULATION DÛ À DONNÉES,CANC BY UDR IHR,Max Hstart login exceeded for hotel,CANC_BY_UDR IHR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lodging Operations - PAC/SAM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>Out of Office Auto,Respuesta automática,Thank you for contacting Expedia Market,VENERE.COM - ANNULATION DÛ À DONNÉES DE CARTE DE CRÉDIT,VENERE.COM - ANULACIÓN DEBIDA A DATOS DE TARJETA DE CRÉDITO ERRÓNEOS,VENERE.COM - CANCELLATION DUE TO WRONG CREDIT</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Reply Notification</fullName>
        <actions>
            <name>Case_Reply_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>EVC - SR,Lodging Operations - HPS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Reply: Customer Email,Closed - Reply</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>EVC - SR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Lodging Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Team__c</field>
            <operation>equals</operation>
            <value>HPS-Destination Services</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Fallback Case</fullName>
        <actions>
            <name>Close_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lodging Operations - Fallback</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Total_Guests__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Unresolved_Guests__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>After all fallbacks are resolved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact%2FAccount Lookup</fullName>
        <actions>
            <name>Contact_Account_Lookup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears field once an account and contact have been assigned to a case</description>
        <formula>AND(  NOT ISBLANK( AccountId ) ,  Account.Name != &apos;Internal Contacts&apos; ,  Account.Name != &apos;External Contacts&apos; ,  NOT ISBLANK( ContactId )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Loading - Zero Inventory</fullName>
        <actions>
            <name>Set_Case_Owner_to_Contract_Loading</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Case_Type_to_Zero_Inventory</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Contract_Loading_Recordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>Make_it_so</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DS Case Prio 1</fullName>
        <actions>
            <name>DS_Priority_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>prio 1,priority 1,urgent,disney,error,pri 1,Moto,SBK,Super,GP,prix,F1,Superbike,Paddock,wrong,mistake,fix</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Destination Services</value>
        </criteriaItems>
        <description>Updates Case Priority to 1 if conditions are met</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Case Prio 2</fullName>
        <actions>
            <name>DS_Priority_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>prio 2,pri 2,priority 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Destination Services</value>
        </criteriaItems>
        <description>Updates Case Priority to 2 if Account Rank is 2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Case Prio 3</fullName>
        <actions>
            <name>DS_Priority_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>prio 3,priority 3,pri 3,image,images,video,videos</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Destination Services</value>
        </criteriaItems>
        <description>Updates Case Priority to 3 if Account Rank is 3</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Case Prio 4</fullName>
        <actions>
            <name>DS_Priority_4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>pri 4,priority 4,prio 4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Zone Update</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Destination Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>prio 1,priority 1,urgent,disney,error,pri 1,Moto,SBK,Super,GP,prix,F1,Superbike,Paddock,wrong,mistake,fix</value>
        </criteriaItems>
        <description>Updates Case Priority to 4 if Account Rank is 4</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DS Media Case Type</fullName>
        <actions>
            <name>Media_DS_Case_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_Recipients__c</field>
            <operation>contains</operation>
            <value>dsmedia</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DS Update Owner - Escalated</fullName>
        <actions>
            <name>Escalate_Transfer_DS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Destination Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates DS Case owner when case is escalated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Destination Management Case</fullName>
        <actions>
            <name>DS_Priority_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Flag_DM_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>psgccl@expedia.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Destination_Management__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>ADM,Destination Services,Geography,HDM,Localisation,Lodging Content,Media Content,Star Ratings,User Generated Content,Virtual Tours Content</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HDM Case Prio 1</fullName>
        <actions>
            <name>HDM_Prio_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>trx.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>HDM</value>
        </criteriaItems>
        <description>Updates Case Priority to 1 if conditions are met</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HSTS Case Prio 1</fullName>
        <actions>
            <name>DS_Priority_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>VolMgt,Ticket INC,Outage,[Ticket #,trx.com,unexpected,no bookings,delivery,direct connect,critical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hotel Systems Technical Support</value>
        </criteriaItems>
        <description>Updates Case Priority to 1 if conditions are met</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>HSTS Case Prio 2</fullName>
        <actions>
            <name>DS_Priority_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Priority,Pri 2,Maintenance,Emergency,EQC errors,booking limit,connection down,time out,internal problem,no faxes,site error,sync</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hotel Systems Technical Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>greaterThan</operation>
            <value>2</value>
        </criteriaItems>
        <description>Updates Case Priority to 2 if conditions are met</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>HSTS Case Prio 3</fullName>
        <actions>
            <name>DS_Priority_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Account.Rating</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>not receiving bookings,not showing on site,rate discrepancies,not getting faxes,rate plans,Urgent! Problem,XML,password,reset,Access,Expedite,Exception,errors,venere,reservation reconciliations,assistance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hotel Systems Technical Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>greaterThan</operation>
            <value>3</value>
        </criteriaItems>
        <description>Updates Case Priority to 3 if conditions are met</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loc Bug</fullName>
        <actions>
            <name>Loc_Category_Bug</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loc_Type_Intake_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>locissue_dummy_address@expedia.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Localisation</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loc Follow Up</fullName>
        <actions>
            <name>Loc_Follow_Up</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loc_Type_Intake_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>locfollowup_dummy_address@expedia.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Localisation</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Loc Project</fullName>
        <actions>
            <name>Loc_Category_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Loc_Type_Intake_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>locrequest_dummy_address@expedia.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Localisation</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Not DS</fullName>
        <actions>
            <name>Not_DS_Case_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Destination Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Stop Sale,Stop Sell</value>
        </criteriaItems>
        <description>Rule changes case type to &quot;Not DS&quot; when conditions are met</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Record Type for FinOps</fullName>
        <actions>
            <name>Set_Record_Type_To_FinOps</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>Financial_Operations</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Date of First Response for ID Request Cases</fullName>
        <actions>
            <name>Set_Date_of_First_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Id Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Date_of_First_Response__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Additional_Status__c</field>
            <operation>equals</operation>
            <value>Contract Loading</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set HPS Case Record Type</fullName>
        <actions>
            <name>Set_Case_Record_Type_For_HPS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 or 4</booleanFilter>
        <criteriaItems>
            <field>Case.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>Destination_Services_Partner_Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>HotelPartnerSupportGuestContact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>LodgingOperationsRelocations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.PSG_Record_Type__c</field>
            <operation>equals</operation>
            <value>Hotel_Partner_Support_Relo_Management</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star Ratings New Unrated</fullName>
        <actions>
            <name>Flag_as_New_Unrated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>&lt;Do Not Reply&gt; Email Notification RE: Bookable Properties Without Star Ratings</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>gsodb@expedia.com</value>
        </criteriaItems>
        <description>Rule to auto assign new unrateds the correct case type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Star Ratings Update Owner - Escalated</fullName>
        <actions>
            <name>Star_escalation_case_transfer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Star Ratings</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsEscalated</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates Star Ratings case owner when case is escalated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Venere Confirmations</fullName>
        <actions>
            <name>Venere_Confirmations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>CONFIRMED IHR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>customer.service@venere.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lodging Operations - HPS</value>
        </criteriaItems>
        <description>Close Venere Confirmation cases as closed - spam</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

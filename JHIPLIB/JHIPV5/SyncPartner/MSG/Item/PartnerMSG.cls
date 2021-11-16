Class JHIPLIB.JHIPV5.SyncPartner.MSG.Item.PartnerMSG Extends (%SerialObject, %XML.Adaptor)
{

Property Description As %String(XMLNAME = "Description");

Property PartnerName As %String(XMLNAME = "PartnerName");

Property PrimaryContactName As %String(XMLNAME = "PrimaryContactName");

Property PrimaryContactTitle As %String(XMLNAME = "PrimaryContactTitle");

Property PrimaryContactPhoneNumber As %String(XMLNAME = "PrimaryContactPhoneNumber");

Property PrimaryContactMobileNumber As %String(XMLNAME = "PrimaryContactMobileNumber");

Property PrimaryContactNotes As %String(XMLNAME = "PrimaryContactNotes");

Property PrimaryContactEmail As %String(XMLNAME = "PrimaryContactEmail");

Property AlternativeContactName As %String(XMLNAME = "AlternativeContactName");

Property AlternativeContactTitle As %String(XMLNAME = "AlternativeContactTitle");

Property AlternativeContactNotes As %String(XMLNAME = "AlternativeContactNotes");

Property AlternativeContactPhoneNumber As %String(XMLNAME = "AlternativeContactPhoneNumber");

Property AlternativeContactMobileNumber As %String(XMLNAME = "AlternativeContactMobileNumber");

Property AlternativeContactEmail As %String(XMLNAME = "AlternativeContactEmail");

Storage Default
{
<Data name="PartnerMSGState">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>PartnerName</Value>
</Value>
<Value name="3">
<Value>PrimaryContactName</Value>
</Value>
<Value name="4">
<Value>PrimaryContactTitle</Value>
</Value>
<Value name="5">
<Value>PrimaryContactPhoneNumber</Value>
</Value>
<Value name="6">
<Value>PrimaryContactMobileNumber</Value>
</Value>
<Value name="7">
<Value>PrimaryContactNotes</Value>
</Value>
<Value name="8">
<Value>PrimaryContactEmail</Value>
</Value>
<Value name="9">
<Value>AlternativeContactName</Value>
</Value>
<Value name="10">
<Value>AlternativeContactTitle</Value>
</Value>
<Value name="11">
<Value>AlternativeContactNotes</Value>
</Value>
<Value name="12">
<Value>AlternativeContactPhoneNumber</Value>
</Value>
<Value name="13">
<Value>AlternativeContactMobileNumber</Value>
</Value>
<Value name="14">
<Value>AlternativeContactEmail</Value>
</Value>
</Data>
<State>PartnerMSGState</State>
<StreamLocation>^JHIPLIB.JHIPV5.SynF168.PartnerMSGS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

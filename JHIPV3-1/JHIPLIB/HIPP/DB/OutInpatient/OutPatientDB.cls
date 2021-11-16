Class JHIPLIB.HIPP.DB.OutInpatient.OutPatientDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "Outpatient";

// 患者就诊类型        

Property EncounterType As %String;

// 患者ID        

Property PatientID As %String;

Storage Default
{
<Data name="OutPatientDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>EncounterType</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP37FD.OutPatientDBD</DataLocation>
<DefaultData>OutPatientDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP37FD.OutPatientDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP37FD.OutPatientDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP37FD.OutPatientDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

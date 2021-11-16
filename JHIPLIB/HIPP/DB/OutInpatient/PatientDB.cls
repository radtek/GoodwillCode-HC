Class JHIPLIB.HIPP.DB.OutInpatient.PatientDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "PatientDB";

// 患者年龄        

Property Age As %String;

// 患者性别

Property Sex As %String;

// 患者ID

Property PatientID As %String;

// 门诊住院类型

Property PatientType As %String;

Storage Default
{
<Data name="PatientDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>Sex</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>PatientType</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP.DB37FD.PatientDBD</DataLocation>
<DefaultData>PatientDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP.DB37FD.PatientDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP.DB37FD.PatientDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP.DB37FD.PatientDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

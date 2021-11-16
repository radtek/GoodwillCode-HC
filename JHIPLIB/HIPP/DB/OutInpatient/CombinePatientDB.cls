Class JHIPLIB.HIPP.DB.OutInpatient.CombinePatientDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "CombinePatientDB";

// 患者姓名        

Property PatientName As %String;

Storage Default
{
<Data name="CombinePatientDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HI37FD.CombinePatiAB54D</DataLocation>
<DefaultData>CombinePatientDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HI37FD.CombinePatiAB54D</IdLocation>
<IndexLocation>^JHIPLIB.HI37FD.CombinePatiAB54I</IndexLocation>
<StreamLocation>^JHIPLIB.HI37FD.CombinePatiAB54S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

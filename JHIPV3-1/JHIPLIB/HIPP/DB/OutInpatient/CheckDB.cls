Class JHIPLIB.HIPP.DB.OutInpatient.CheckDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "CheckDB";

// 患者就诊类型        

Property EncounterType As %String;

// 检查类别        

Property CheckType As %String;

// 检查名称        

Property CheckName As %String;

Storage Default
{
<Data name="CheckDBDefaultData">
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
<Value>CheckType</Value>
</Value>
<Value name="5">
<Value>CheckName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP.DB.Ou37FD.CheckDBD</DataLocation>
<DefaultData>CheckDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP.DB.Ou37FD.CheckDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP.DB.Ou37FD.CheckDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP.DB.Ou37FD.CheckDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

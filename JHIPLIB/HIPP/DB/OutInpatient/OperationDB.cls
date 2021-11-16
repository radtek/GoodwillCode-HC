Class JHIPLIB.HIPP.DB.OutInpatient.OperationDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "Outpatient";

// 手术状态        

Property Status As %String;

Storage Default
{
<Data name="OperationDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP.D37FD.OperationDBD</DataLocation>
<DefaultData>OperationDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP.D37FD.OperationDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP.D37FD.OperationDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP.D37FD.OperationDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class JHIPLIB.HIPP.DB.OutInpatient.OrderDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "Outpatient";

// 患者就诊类型        

Property OrderType As %String;

Storage Default
{
<Data name="OrderDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>OrderType</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP.DB.Ou37FD.OrderDBD</DataLocation>
<DefaultData>OrderDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP.DB.Ou37FD.OrderDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP.DB.Ou37FD.OrderDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP.DB.Ou37FD.OrderDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

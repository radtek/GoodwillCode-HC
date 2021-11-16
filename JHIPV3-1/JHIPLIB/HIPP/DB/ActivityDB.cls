Class JHIPLIB.HIPP.DB.ActivityDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "Activity";

// 业务合作伙伴        

Property BusinessPartner As %String;

// 活动量

Property Number As %String;

// 事件标识

Property EventType As %String;

// 组件名称

Property ConfigName As %String;

// 输入输出I/O

Property Type As %String;

Storage Default
{
<Data name="ActivityDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>BusinessPartner</Value>
</Value>
<Value name="4">
<Value>Number</Value>
</Value>
<Value name="5">
<Value>EventType</Value>
</Value>
<Value name="6">
<Value>ConfigName</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP.DB.ActivityDBD</DataLocation>
<DefaultData>ActivityDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP.DB.ActivityDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP.DB.ActivityDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP.DB.ActivityDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

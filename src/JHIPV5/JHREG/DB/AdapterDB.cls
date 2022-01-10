/// Classname:	JHIPV5.JHREG.DB.AdapterDB
/// Summary:	JHIPV5.3 适配器管理DB;
/// TODO:		JHIPV5.3 适配器管理DB,维护适配器的相关信息;
/// Version:	1.0;
/// Date:		2021年12月06日;
/// Author:		LHX;
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.AdapterDB Extends %Persistent
{

/// 适配器编号
Property AdapterID As %String(MAXLEN = 256000);

/// 适配器名称
Property AdapterName As %String;

/// 类名称
Property ClassName As %String;

/// 标准
Property Standed As %String;

/// 类型
Property Type As %String;

Storage Default
{
<Data name="AdapterDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdapterID</Value>
</Value>
<Value name="3">
<Value>AdapterName</Value>
</Value>
<Value name="4">
<Value>ClassName</Value>
</Value>
<Value name="5">
<Value>Standed</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREG.DB.AdapterDBD</DataLocation>
<DefaultData>AdapterDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREG.DB.AdapterDBD</IdLocation>
<IndexLocation>^JHIPV5.JHREG.DB.AdapterDBI</IndexLocation>
<StreamLocation>^JHIPV5.JHREG.DB.AdapterDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

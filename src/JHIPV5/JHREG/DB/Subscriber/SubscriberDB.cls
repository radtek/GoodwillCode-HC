/// Classname JHIPV5.JHREG.BO.Domain.GetNameSpaceDetails
/// Summary   订户列表 
/// Explain	  存放订户有关的数据
/// Version   1.0<br>
/// Date      2021年12月08日 
/// Author    LHX
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.DB.Subscriber.SubscriberDB Extends %Persistent
{

/// 订户ID
Property subscriberID As %String;

/// 订户名称
Property subscriberName As %String;

/// 订户编码
Property subscriberCode As %String;

/// 域名称
Property NameSpace As %String;

/// 通讯标准
Property standard As %String;

/// 组织机构
Property Organization As %String;

/// 启用停用按钮
Property Enabled As %String;

/// 业务场景
Property Category As %String;

/// 发布系统
Property BusinessPartner As %String;

/// 适配器
Property Adapter As %String;

/// 运行池大小
Property PoolSize As %String;

/// 订户注释
Property Comment As %String;

/// 日志开启
Property LogTraceEvents As %String;

/// 字符集
Property Charset As %String;

/// SOAPURL
Property WebServiceURL As %String;

/// 客户端类
Property WebServiceClientClass As %String;

Storage Default
{
<Data name="SubscriberDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>subscriberID</Value>
</Value>
<Value name="3">
<Value>subscriberName</Value>
</Value>
<Value name="4">
<Value>subscriberCode</Value>
</Value>
<Value name="5">
<Value>NameSpace</Value>
</Value>
<Value name="6">
<Value>standard</Value>
</Value>
<Value name="7">
<Value>Organization</Value>
</Value>
<Value name="8">
<Value>Enabled</Value>
</Value>
<Value name="9">
<Value>Category</Value>
</Value>
<Value name="10">
<Value>BusinessPartner</Value>
</Value>
<Value name="11">
<Value>Adapter</Value>
</Value>
<Value name="12">
<Value>PoolSize</Value>
</Value>
<Value name="13">
<Value>Comment</Value>
</Value>
<Value name="14">
<Value>LogTraceEvents</Value>
</Value>
<Value name="15">
<Value>Charset</Value>
</Value>
<Value name="16">
<Value>WebServiceURL</Value>
</Value>
<Value name="17">
<Value>WebServiceClientClass</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREGB45E.SubscriberDBD</DataLocation>
<DefaultData>SubscriberDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREGB45E.SubscriberDBD</IdLocation>
<IndexLocation>^JHIPV5.JHREGB45E.SubscriberDBI</IndexLocation>
<StreamLocation>^JHIPV5.JHREGB45E.SubscriberDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

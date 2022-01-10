/// Classname JHIPV5.JHREG.DB.SubscriptionDB
/// Summary   消息监控 -订阅关系表
/// Explain	  存放订阅发布的主题和订户关系
/// Version   1.0<br>
/// Date      2021年12月2日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.DB.SubscriptionDB Extends %Persistent
{

/// 订户名称
Property TargetName As %String;

/// 主题名称
Property ThemeName As %String;

/// 发布系统
Property Publish As %String;

/// 订阅系统
Property Subscribe As %String;

/// 集成场景
Property ServiceType As %String;

/// 接入方式
Property AccessWay As %String;

/// 联通方式
Property Scope As %String;

Storage Default
{
<Data name="SubscriptionDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TargetName</Value>
</Value>
<Value name="3">
<Value>ThemeName</Value>
</Value>
<Value name="4">
<Value>Publish</Value>
</Value>
<Value name="5">
<Value>Subscribe</Value>
</Value>
<Value name="6">
<Value>ServiceType</Value>
</Value>
<Value name="7">
<Value>AccessWay</Value>
</Value>
<Value name="8">
<Value>Scope</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHRECB30.SubscriptionDBD</DataLocation>
<DefaultData>SubscriptionDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHRECB30.SubscriptionDBD</IdLocation>
<IndexLocation>^JHIPV5.JHRECB30.SubscriptionDBI</IndexLocation>
<StreamLocation>^JHIPV5.JHRECB30.SubscriptionDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

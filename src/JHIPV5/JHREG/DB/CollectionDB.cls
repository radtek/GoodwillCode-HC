/// Classname:	JHIPV5.JHREG.DB.CollectionDB
/// Summary:	JHIPV5.3 消息检索收藏表;
/// TODO:		JHIPV5.3 消息检索收藏表, 收藏查询条件;
/// Version:	1.0;
/// Date:		2021年11月29日;
/// Author:		ZFT;
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.CollectionDB Extends %Persistent
{

/// 主键
Property FileBody As %String(MAXLEN = 256000);

/// 搜索内容
Property SearchValue As %String;

/// 域ID
Property NameSpace As %String;

/// 域名称
Property NameSpaceValue As %String;

/// 搜索条件
Property SearchType As %String;

/// 主题名称
Property ThemeName As %String;

/// 开始时间
Property StartTime As %String;

/// 结束时间
Property EndTime As %String;

/// 收藏时间
Property SaveTime As %String;

/// 消息内容
Property MessageValue As %String;

/// 消息状态
Property MessageStatus As %String;

/// 消息类型
Property MessageType As %String;

Storage Default
{
<Data name="CollectionDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileBody</Value>
</Value>
<Value name="3">
<Value>SearchValue</Value>
</Value>
<Value name="4">
<Value>NameSpace</Value>
</Value>
<Value name="5">
<Value>SearchType</Value>
</Value>
<Value name="6">
<Value>ThemeName</Value>
</Value>
<Value name="7">
<Value>StartTime</Value>
</Value>
<Value name="8">
<Value>EndTime</Value>
</Value>
<Value name="9">
<Value>SaveTime</Value>
</Value>
<Value name="10">
<Value>MessageValue</Value>
</Value>
<Value name="11">
<Value>MessageStatus</Value>
</Value>
<Value name="12">
<Value>MessageType</Value>
</Value>
<Value name="13">
<Value>NameSpaceValue</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREG.DB.CollectionDBD</DataLocation>
<DefaultData>CollectionDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREG.DB.CollectionDBD</IdLocation>
<IndexLocation>^JHIPV5.JHREG.DB.CollectionDBI</IndexLocation>
<StreamLocation>^JHIPV5.JHREG.DB.CollectionDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

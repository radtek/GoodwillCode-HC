/// Classname:	JHIPV5.JHREG.DB.MessageRetrievalDB
/// Summary:	JHIPV5.3 消息检索查询中间表;
/// TODO:		JHIPV5.3 消息检索 查询, 初步筛选后放入此表,进行二次筛选;
/// Version:	1.0;
/// Date:		2021年11月29日;
/// Author:		ZFT;
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.MessageRetrievalDB Extends %Persistent
{

/// 消息ID
Property SessionId As %BigInt;

/// 源
Property SourceConfigName As %String(MAXLEN = 256000);

/// 目标
Property TargetConfigName As %String;

/// 消息状态
Property Status As %String;

/// 开始时间
Property TimeCreated As %String;

/// 结束时间
Property TimeProcessed As %String;

/// 消息类型
Property Type As %String;

/// 排序ID
Property SortID As %BigInt;

Index SortIDIdx On SortID;

/// 源类型
Property SourceBusinessType As %String;

/// 目标类型
Property TargetBusinessType As %String;

Storage Default
{
<Data name="MessageRetrievalDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SessionId</Value>
</Value>
<Value name="3">
<Value>SourceConfigName</Value>
</Value>
<Value name="4">
<Value>TargetConfigName</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>TimeCreated</Value>
</Value>
<Value name="7">
<Value>TimeProcessed</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>SortID</Value>
</Value>
<Value name="10">
<Value>SourceBusinessType</Value>
</Value>
<Value name="11">
<Value>TargetBusinessType</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHRCB30.MessageRetrCE11D</DataLocation>
<DefaultData>MessageRetrievalDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHRCB30.MessageRetrCE11D</IdLocation>
<IndexLocation>^JHIPV5.JHRCB30.MessageRetrCE11I</IndexLocation>
<StreamLocation>^JHIPV5.JHRCB30.MessageRetrCE11S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

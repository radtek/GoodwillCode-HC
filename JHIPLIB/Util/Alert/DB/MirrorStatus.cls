/// Classname JHIPLIB.Util.DB.MirrorStatus<br>
/// Summary   镜像状态信息DB<br>
/// Version   1.0<br>
/// Date      2020年9月18日 10:00<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Alert.DB.MirrorStatus Extends %Persistent
{

Index MemberName On MemberName;

/// 成员名称
Property MemberName As %String;

/// 当前角色
Property CurrentRole As %String;

/// 当前状态
Property CurrentStatus As %String;

/// 日志时间延迟
Property JournalTimeLatency As %String;

/// 数据库时效性
Property DatabaseTimeLatency As %String;

/// Ip地址
Property IpAddress As %String;

/// Time
Property CreatedTime As %String;

Storage Default
{
<Data name="MirrorStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MemberName</Value>
</Value>
<Value name="3">
<Value>CurrentRole</Value>
</Value>
<Value name="4">
<Value>CurrentStatus</Value>
</Value>
<Value name="5">
<Value>JournalTimeLatency</Value>
</Value>
<Value name="6">
<Value>DatabaseTimeLatency</Value>
</Value>
<Value name="7">
<Value>IpAddress</Value>
</Value>
<Value name="8">
<Value>CreatedTime</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.Util5115.MirrorStatusD</DataLocation>
<DefaultData>MirrorStatusDefaultData</DefaultData>
<IdLocation>^JHIPLIB.Util5115.MirrorStatusD</IdLocation>
<IndexLocation>^JHIPLIB.Util5115.MirrorStatusI</IndexLocation>
<StreamLocation>^JHIPLIB.Util5115.MirrorStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

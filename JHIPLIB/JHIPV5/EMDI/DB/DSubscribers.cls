/// 科室订阅系统存储表
Class JHIPLIB.JHIPV5.EMDI.DB.DSubscribers Extends %Persistent
{

Index DictId On DictId;

/// 字典唯一标识
Property DictId As %String;

/// 字典名称
Property DictName As %String;

/// 订阅系统--订阅该字典的系统简称，多个系统中间使用,分割;<br/>
/// 如：HIS,EMR
Property SubscriberSystems As %String(MAXLEN = 256000);

/// 发布系统--发布该字典的系统简称，多个系统中间使用,分割;<br/>
/// 如：HIS,EMR
Property PublishSystems As %String(MAXLEN = 256000);

/// 备注
Property Remarks As %String(MAXLEN = 256000);

Storage Default
{
<Data name="DSubscribersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictId</Value>
</Value>
<Value name="3">
<Value>DictName</Value>
</Value>
<Value name="4">
<Value>SubscriberSystems</Value>
</Value>
<Value name="5">
<Value>PublishSystems</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.JHIPV5.ECFFF.DSubscribersD</DataLocation>
<DefaultData>DSubscribersDefaultData</DefaultData>
<IdLocation>^JHIPLIB.JHIPV5.ECFFF.DSubscribersD</IdLocation>
<IndexLocation>^JHIPLIB.JHIPV5.ECFFF.DSubscribersI</IndexLocation>
<StreamLocation>^JHIPLIB.JHIPV5.ECFFF.DSubscribersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

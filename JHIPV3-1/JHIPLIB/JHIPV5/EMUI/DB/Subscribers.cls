/// 人员订阅系统存储表
Class JHIPLIB.JHIPV5.EMUI.DB.Subscribers Extends %Persistent
{

Index DictName On DictName;

/// 字典名称
Property DictName As %String;

/// 订阅系统--订阅该字典的系统简称，多个系统中间使用,分割;<br/>
/// 如：HIS,EMR
Property SubscriberSystems As %String(MAXLEN = 256000);

/// 发布系统--发布该字典的系统简称，多个系统中间使用,分割;<br/>
/// 如：HIS,EMR
Property PublishSystems As %String(MAXLEN = 256000);

Storage Default
{
<Data name="SubscribersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictName</Value>
</Value>
<Value name="3">
<Value>SubscriberSystems</Value>
</Value>
<Value name="4">
<Value>PublishSystems</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.JHIPV5.EMCC03.SubscribersD</DataLocation>
<DefaultData>SubscribersDefaultData</DefaultData>
<IdLocation>^JHIPLIB.JHIPV5.EMCC03.SubscribersD</IdLocation>
<IndexLocation>^JHIPLIB.JHIPV5.EMCC03.SubscribersI</IndexLocation>
<StreamLocation>^JHIPLIB.JHIPV5.EMCC03.SubscribersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

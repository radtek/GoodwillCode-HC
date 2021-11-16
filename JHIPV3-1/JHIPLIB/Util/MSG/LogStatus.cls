/// 日志的状态
Class JHIPLIB.Util.MSG.LogStatus Extends Ens.Request
{

Property Assert As %String;

Property Error As %String;

Property Warning As %String;

Property Info As %String;

Property Trace As %String;

Property Alert As %String;

Storage Default
{
<Data name="LogStatusDefaultData">
<Subscript>"LogStatus"</Subscript>
<Value name="1">
<Value>Assert</Value>
</Value>
<Value name="2">
<Value>Error</Value>
</Value>
<Value name="3">
<Value>Warning</Value>
</Value>
<Value name="4">
<Value>Info</Value>
</Value>
<Value name="5">
<Value>Trace</Value>
</Value>
<Value name="6">
<Value>Alert</Value>
</Value>
</Data>
<DefaultData>LogStatusDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

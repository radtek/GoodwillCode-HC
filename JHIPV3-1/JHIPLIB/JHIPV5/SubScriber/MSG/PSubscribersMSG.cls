Class JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property DictName As %String(MAXLEN = 25600, XMLNAME = "DICTNAME");

Property SubscriberSystems As %String(MAXLEN = 25600, XMLNAME = "SUBSCRIBERSYSTEMS");

Property PublishSystems As %String(MAXLEN = 25600, XMLNAME = "PUBLISHSYSTEMS");

Storage Default
{
<Data name="PSubscribersMSGDefaultData">
<Subscript>"PSubscribersMSG"</Subscript>
<Value name="1">
<Value>DictName</Value>
</Value>
<Value name="2">
<Value>SubscriberSystems</Value>
</Value>
<Value name="3">
<Value>PublishSystems</Value>
</Value>
</Data>
<DefaultData>PSubscribersMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

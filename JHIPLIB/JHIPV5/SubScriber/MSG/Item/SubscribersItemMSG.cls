Class JHIPLIB.JHIPV5.SubScriber.MSG.Item.SubscribersItemMSG Extends (%SerialObject, %XML.Adaptor)
{

Property DictID As %String(MAXLEN = 25600, XMLNAME = "DICTID");

Property DictName As %String(MAXLEN = 25600, XMLNAME = "DICTNAME");

Property SubscriberSystems As %String(MAXLEN = 25600, XMLNAME = "SUBSCRIBERSYSTEMS");

Property PublishSystems As %String(MAXLEN = 25600, XMLNAME = "PUBLISHSYSTEMS");

Property Remarks As %String(MAXLEN = 25600, XMLNAME = "REMARKS");

Storage Default
{
<Data name="SubscribersItemMSGState">
<Value name="1">
<Value>DictID</Value>
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
<Value name="5">
<Value>Remarks</Value>
</Value>
</Data>
<State>SubscribersItemMSGState</State>
<StreamLocation>^JHIPLIB.JHIPV20E8.SubscribersBBB9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

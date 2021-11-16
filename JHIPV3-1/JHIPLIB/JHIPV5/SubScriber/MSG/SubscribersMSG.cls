Class JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property Item As list Of JHIPLIB.JHIPV5.SubScriber.MSG.Item.SubscribersItemMSG(XMLNAME = "ITEM", XMLPROJECTION = "element");

Storage Default
{
<Data name="SubscribersMSGDefaultData">
<Subscript>"SubscribersMSG"</Subscript>
<Value name="1">
<Value>Item</Value>
</Value>
</Data>
<DefaultData>SubscribersMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

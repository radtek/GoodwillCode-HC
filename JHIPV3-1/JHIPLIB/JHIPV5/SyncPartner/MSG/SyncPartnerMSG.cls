Class JHIPLIB.JHIPV5.SyncPartner.MSG.SyncPartnerMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property Item As list Of JHIPLIB.JHIPV5.SyncPartner.MSG.Item.PartnerMSG(XMLNAME = "Item", XMLPROJECTION = "element");

Storage Default
{
<Data name="SyncPartnerMSGDefaultData">
<Subscript>"SyncPartnerMSG"</Subscript>
<Value name="1">
<Value>Item</Value>
</Value>
</Data>
<DefaultData>SyncPartnerMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

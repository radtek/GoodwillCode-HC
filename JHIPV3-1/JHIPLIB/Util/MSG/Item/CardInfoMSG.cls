Class JHIPLIB.Util.MSG.Item.CardInfoMSG Extends (%SerialObject, %XML.Adaptor)
{

Property IDNUMBER As %String(XMLNAME = "ID_NUMBER");

Property CARDTYPE As %String(XMLNAME = "CARD_TYPE");

Storage Default
{
<Data name="CardInfoMSGState">
<Value name="1">
<Value>IDNUMBER</Value>
</Value>
<Value name="2">
<Value>CARDTYPE</Value>
</Value>
</Data>
<State>CardInfoMSGState</State>
<StreamLocation>^JHIPLIB.Util.MBB78.CardInfoMSGS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

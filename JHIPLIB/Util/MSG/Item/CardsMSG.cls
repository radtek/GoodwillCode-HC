Class JHIPLIB.Util.MSG.Item.CardsMSG Extends (%SerialObject, %XML.Adaptor)
{

Property CARDINFO As list Of JHIPLIB.Util.MSG.Item.CardInfoMSG(XMLNAME = "CARD_INFO", XMLPROJECTION = "ELEMENT");

Storage Default
{
<Data name="CardsMSGState">
<Value name="1">
<Value>CARDINFO</Value>
</Value>
</Data>
<State>CardsMSGState</State>
<StreamLocation>^JHIPLIB.Util.MSGBB78.CardsMSGS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

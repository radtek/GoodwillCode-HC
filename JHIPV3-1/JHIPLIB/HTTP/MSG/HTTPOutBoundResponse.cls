Class JHIPLIB.HTTP.MSG.HTTPOutBoundResponse Extends Ens.Response
{

Parameter XMLNAME = "Reponse";

Property MessageStream As %GlobalCharacterStream(CONTENT = "MIXED");

Storage Default
{
<Data name="HTTPOutBoundResponseDefaultData">
<Subscript>"HTTPOutBoundResponse"</Subscript>
<Value name="1">
<Value>MessageStream</Value>
</Value>
</Data>
<DefaultData>HTTPOutBoundResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

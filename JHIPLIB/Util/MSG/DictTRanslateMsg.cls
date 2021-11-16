Class JHIPLIB.Util.MSG.DictTRanslateMsg Extends Ens.Response
{

Parameter XMLNAME = "RESPONSE";

Property code As %String(XMLNAME = "CODE");

Property value As %String(XMLNAME = "VALUE");

Storage Default
{
<Data name="DictTRanslateMsgDefaultData">
<Subscript>"DictTRanslateMsg"</Subscript>
<Value name="1">
<Value>code</Value>
</Value>
<Value name="2">
<Value>value</Value>
</Value>
</Data>
<DefaultData>DictTRanslateMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

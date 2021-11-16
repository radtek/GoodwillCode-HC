Class JHIPLIB.Util.MSG.GetQueryDictMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property ALIASNAME As %String(XMLNAME = "ALIASNAME");

Property TABLENAME As %String(XMLNAME = "TABLENAME");

Property IDENTIFICATION As %String(XMLNAME = "IDENTIFICATION");

Property VALUE As %String(MAXLEN = 50000, XMLNAME = "VALUE");

Storage Default
{
<Data name="GetQueryDictMSGDefaultData">
<Subscript>"GetQueryDictMSG"</Subscript>
<Value name="1">
<Value>ALIASNAME</Value>
</Value>
<Value name="2">
<Value>TABLENAME</Value>
</Value>
<Value name="3">
<Value>IDENTIFICATION</Value>
</Value>
<Value name="4">
<Value>VALUE</Value>
</Value>
</Data>
<DefaultData>GetQueryDictMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

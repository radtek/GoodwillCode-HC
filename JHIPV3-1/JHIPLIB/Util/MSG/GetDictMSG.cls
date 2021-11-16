Class JHIPLIB.Util.MSG.GetDictMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property ALIASNAME As %String(XMLNAME = "ALIASNAME");

Property TABLENAME As %String(XMLNAME = "TABLENAME");

Property IDENTIFICATION As %String(XMLNAME = "IDENTIFICATION");

Property SUBSCRIBERS As %String(XMLNAME = "SUBSCRIBERS");

Property VALUE As %String(MAXLEN = 50000, XMLNAME = "VALUE");

Storage Default
{
<Data name="GetDictMSGDefaultData">
<Subscript>"GetDictMSG"</Subscript>
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
<Value>SUBSCRIBERS</Value>
</Value>
<Value name="5">
<Value>VALUE</Value>
</Value>
</Data>
<DefaultData>GetDictMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

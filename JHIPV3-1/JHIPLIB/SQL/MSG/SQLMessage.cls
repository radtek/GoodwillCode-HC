/// 这是一个SQL查询消息载体
Class JHIPLIB.SQL.MSG.SQLMessage Extends Ens.Request
{

Parameter XMLNAME = "SQL";

Property sqlreq As %String(MAXLEN = 500, XMLNAME = "sqlreq");

Property sqltype As %String(MAXLEN = 50, XMLNAME = "sqltype");

Property tablename As %String(MAXLEN = 50, XMLNAME = "tablename");

Storage Default
{
<Data name="SQLMessageDefaultData">
<Subscript>"SQLMessage"</Subscript>
<Value name="1">
<Value>sqlreq</Value>
</Value>
<Value name="2">
<Value>sqltype</Value>
</Value>
<Value name="3">
<Value>tablename</Value>
</Value>
</Data>
<DefaultData>SQLMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

/// 多个动态参数调用
Class JHIPLIB.Util.MSG.MessageList Extends Ens.Request
{

// 消息入参

Property Action As %String;

Property MessageBody As list Of %String(MAXLEN = "");

Method %OnNew(Action As %String, initvalue As %CacheString) As %Status
{
	Set len=$LISTLENGTH($g(initvalue))
	Set ..Action=Action
	FOR i=1:1:len{
		Set tSC=..MessageBody.Insert($lg($g(initvalue),i))
		}
	
	Quit tSC
}

Storage Default
{
<Data name="MessageListDefaultData">
<Subscript>"MessageList"</Subscript>
<Value name="1">
<Value>Action</Value>
</Value>
<Value name="2">
<Value>MessageBody</Value>
</Value>
</Data>
<DefaultData>MessageListDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

/// 挂起的消息和队列的消息
Class JHIPLIB.Util.MSG.MessageDetail Extends Ens.Request
{

// 排队的消息

Property QueuedMessage As list Of %String;

// 挂起的消息

Property SuspendedMessage As list Of %String;

Storage Default
{
<Data name="MessageDetailDefaultData">
<Subscript>"MessageDetail"</Subscript>
<Value name="1">
<Value>QueuedMessage</Value>
</Value>
<Value name="2">
<Value>SuspendedMessage</Value>
</Value>
</Data>
<DefaultData>MessageDetailDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

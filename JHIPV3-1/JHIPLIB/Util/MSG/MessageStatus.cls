/// 获取消息状态列表
Class JHIPLIB.Util.MSG.MessageStatus Extends Ens.Request
{

/// 排队的消息
Property Queued As %String;

/// 已传递的消息
Property Delivered As %String;

/// 已放弃的消息
Property Discarded As %String;

/// 错误的消息
Property Error As %String;

/// 已完成的消息
Property Completed As %String;

/// 已挂起的消息
Property Suspended As %String;

Storage Default
{
<Data name="MessageStatusDefaultData">
<Subscript>"MessageStatus"</Subscript>
<Value name="1">
<Value>Queued</Value>
</Value>
<Value name="2">
<Value>Delivered</Value>
</Value>
<Value name="3">
<Value>Discarded</Value>
</Value>
<Value name="4">
<Value>Error</Value>
</Value>
<Value name="5">
<Value>Completed</Value>
</Value>
<Value name="6">
<Value>Suspended</Value>
</Value>
</Data>
<DefaultData>MessageStatusDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

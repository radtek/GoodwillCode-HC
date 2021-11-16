/// Classname JHIPLIB.Util.MSG.JHRequestMsg
/// Summary   通用请求消息
/// Version   1.0
/// Date      2018年10月15日
/// Author    liuwenyi
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.MSG.JHRequestMsg Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

/// 事件名称
Property action As %String(XMLNAME = "ACTION");

/// 消息的多个参数
Property pArg As list Of %String(MAXLEN = "", XMLNAME = "PARG", XMLPROJECTION = "element");

/// CONTENT = "MIXED"

Storage Default
{
<Data name="JHRequestMsgDefaultData">
<Subscript>"JHRequestMsg"</Subscript>
<Value name="1">
<Value>action</Value>
</Value>
<Value name="2">
<Value>pArg</Value>
</Value>
</Data>
<DefaultData>JHRequestMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

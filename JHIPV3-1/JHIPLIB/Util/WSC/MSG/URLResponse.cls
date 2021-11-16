/// Classname JHIPLIB.Util.WSC.MSG.URLResponse
/// Summary   URL响应载体
/// Version   1.0
/// Date      2019年09月06日
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.WSC.MSG.URLResponse Extends Ens.Request
{

Parameter XMLNAME = "Response";

/// 结果描述
Property Result As %String(XMLNAME = "Result");

/// Web 服务客户端类
Property ClassName As %String(MAXLEN = 150, XMLNAME = "ClassName");

/// 接收方名称
Property ReceiverName As %String(XMLNAME = "ReceiverName");

/// URL地址
Property URL As %String(MAXLEN = 150, XMLNAME = "URL");

/// 创建时间
Property CreatedTime As %String(XMLNAME = "CreatedTime");

Storage Default
{
<Data name="URLResponseDefaultData">
<Subscript>"URLResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>ReceiverName</Value>
</Value>
<Value name="4">
<Value>URL</Value>
</Value>
<Value name="5">
<Value>CreatedTime</Value>
</Value>
</Data>
<DefaultData>URLResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

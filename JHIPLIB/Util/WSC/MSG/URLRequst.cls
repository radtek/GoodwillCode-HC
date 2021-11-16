/// Classname JHIPLIB.Util.WSC.MSG.URLRequst
/// Summary   URL请求载体
/// Version   1.0
/// Date      2019年09月06日
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.WSC.MSG.URLRequst Extends Ens.Request
{

Parameter XMLNAME = "Request";

/// 接收方名称
Property ReceiverName As %String(XMLNAME = "ReceiverName");

/// URL地址
Property URL As %String(MAXLEN = 123, XMLNAME = "URL");

/// 创建Web 服务客户端类所在包的包名称
Property PackageName As %String(XMLNAME = "PackageName");

Storage Default
{
<Data name="URLRequstDefaultData">
<Subscript>"URLRequst"</Subscript>
<Value name="1">
<Value>ReceiverName</Value>
</Value>
<Value name="2">
<Value>URL</Value>
</Value>
<Value name="3">
<Value>PackageName</Value>
</Value>
</Data>
<DefaultData>URLRequstDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

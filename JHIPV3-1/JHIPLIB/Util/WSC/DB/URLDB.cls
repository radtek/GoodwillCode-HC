/// Classname JHIPLIB.Util.WSC.DB.URLDB
/// Summary   URL创建存储类
/// Version   1.0
/// Date      2019年09月09日
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.WSC.DB.URLDB Extends Ens.Request
{

Parameter XMLNAME = "Response";

/// Web 服务客户端类
Property ClassName As %String(XMLNAME = "ClassName");

/// 接收方名称
Property ReceiverName As %String(XMLNAME = "ReceiverName");

/// URL地址
Property URL As %String(MAXLEN = 123, XMLNAME = "URL");

/// 创建Web 服务客户端类所在包的包名称
Property PackageName As %String(XMLNAME = "PackageName");

/// 创建时间
Property CreatedTime As %String(XMLNAME = "CreatedTime");

Storage Default
{
<Data name="URLDBDefaultData">
<Subscript>"URLDB"</Subscript>
<Value name="1">
<Value>ClassName</Value>
</Value>
<Value name="2">
<Value>ReceiverName</Value>
</Value>
<Value name="3">
<Value>URL</Value>
</Value>
<Value name="4">
<Value>PackageName</Value>
</Value>
<Value name="5">
<Value>CreatedTime</Value>
</Value>
</Data>
<DefaultData>URLDBDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

/// Classname JHIPLIB.Util.WSC.MSG.URLRequst
/// Summary   URL请求载体
/// Version   1.0
/// Date      2019年09月06日
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.Code.MSG.Requst Extends Ens.Request
{

Parameter XMLNAME = "Request";

/// 导出/导入类名称
Property ClassName As %String(XMLNAME = "ClassName");

/// 导出/导入文件路径
Property FilePath As %String(MAXLEN = 123, XMLNAME = "FilePath");

Storage Default
{
<Data name="RequstDefaultData">
<Subscript>"Requst"</Subscript>
<Value name="1">
<Value>ClassName</Value>
</Value>
<Value name="2">
<Value>FilePath</Value>
</Value>
</Data>
<DefaultData>RequstDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

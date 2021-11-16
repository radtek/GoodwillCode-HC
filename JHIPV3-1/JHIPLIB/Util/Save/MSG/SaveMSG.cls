/// Classname JHIPLIB.Util.Save.BS.GetService<br/>
/// Summary   消息存储通用消息类型，传输载体<br/>
/// Version   1.0<br>
/// Date      2019年4月29日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Save.MSG.SaveMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property MethodName As %String;

Property FileName As %String;

Property FileBody As %String(MAXLEN = "");

Storage Default
{
<Data name="SaveMSGDefaultData">
<Subscript>"SaveMSG"</Subscript>
<Value name="1">
<Value>MethodName</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>FileBody</Value>
</Value>
</Data>
<DefaultData>SaveMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

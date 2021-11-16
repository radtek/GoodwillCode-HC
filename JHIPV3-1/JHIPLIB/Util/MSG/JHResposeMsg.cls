/// Classname JHIPLIB.Util.MSG.JHResposeMsg
/// Summary   通用返回消息
/// Version   1.0
/// Date      2016年6月15日
/// Author    
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.MSG.JHResposeMsg Extends Ens.Response
{

Parameter XMLNAME = "RESPONSE";

/// 结果编码
Property ResultCode As %String(XMLNAME = "RESULT_CODE");

/// 结果描述
Property ResultContent As %String(MAXLEN = 256000, XMLNAME = "RESULT_CONTENT");

Storage Default
{
<Data name="JHResposeMsgDefaultData">
<Subscript>"JHResposeMsg"</Subscript>
<Value name="1">
<Value>ResultCode</Value>
</Value>
<Value name="2">
<Value>ResultContent</Value>
</Value>
</Data>
<DefaultData>JHResposeMsgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

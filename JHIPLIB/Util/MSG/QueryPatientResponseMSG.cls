/// 患者查询返回患者基本信息响应消息
Class JHIPLIB.Util.MSG.QueryPatientResponseMSG Extends Ens.Response
{

Parameter XMLNAME = "RESPONSE";

Property RESULTCODE As %String(XMLNAME = "RESULT_CODE");

Property RESULTCONTENT As %String(XMLNAME = "RESULT_CONTENT");

Property PATIENTS As JHIPLIB.Util.MSG.Item.CardsMSG(XMLNAME = "PATIENTS");

Storage Default
{
<Data name="QueryPatientResponseMSGDefaultData">
<Subscript>"QueryPatientResponseMSG"</Subscript>
<Value name="1">
<Value>RESULTCODE</Value>
</Value>
<Value name="2">
<Value>RESULTCONTENT</Value>
</Value>
<Value name="3">
<Value>PATIENTS</Value>
</Value>
</Data>
<DefaultData>QueryPatientResponseMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

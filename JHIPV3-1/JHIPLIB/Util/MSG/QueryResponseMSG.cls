/// 患者查询返回证件号信息响应消息
Class JHIPLIB.Util.MSG.QueryResponseMSG Extends Ens.Response
{

Parameter XMLNAME = "RESPONSE";

Property RESULTCODE As %String(XMLNAME = "RESULT_CODE");

Property RESULTCONTENT As %String(XMLNAME = "RESULT_CONTENT");

Property CARDS As list Of JHIPLIB.Util.MSG.Item.CardsMSG(XMLNAME = "CARDS");

Storage Default
{
<Data name="QueryResponseMSGDefaultData">
<Subscript>"QueryResponseMSG"</Subscript>
<Value name="1">
<Value>RESULTCODE</Value>
</Value>
<Value name="2">
<Value>RESULTCONTENT</Value>
</Value>
<Value name="3">
<Value>CARDS</Value>
</Value>
</Data>
<DefaultData>QueryResponseMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

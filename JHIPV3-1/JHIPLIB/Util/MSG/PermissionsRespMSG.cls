Class JHIPLIB.Util.MSG.PermissionsRespMSG Extends Ens.Request
{

Parameter XMLNAME = "RESPONSE";

Property RESULTCODE As %String(XMLNAME = "RESULT_CODE");

Property RESULTCONTENT As %String(XMLNAME = "RESULT_CONTENT");

Property SYSTEMCODE As %String(XMLNAME = "SYSTEM_CODE");

Property SYSTEMNAME As %String(XMLNAME = "SYSTEM_NAME");

Property DATETIME As %String(XMLNAME = "DATE_TIME");

Storage Default
{
<Data name="PermissionsRespMSGDefaultData">
<Subscript>"PermissionsRespMSG"</Subscript>
<Value name="1">
<Value>RESULTCODE</Value>
</Value>
<Value name="2">
<Value>RESULTCONTENT</Value>
</Value>
<Value name="3">
<Value>SYSTEMCODE</Value>
</Value>
<Value name="4">
<Value>SYSTEMNAME</Value>
</Value>
<Value name="5">
<Value>DATETIME</Value>
</Value>
</Data>
<DefaultData>PermissionsRespMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

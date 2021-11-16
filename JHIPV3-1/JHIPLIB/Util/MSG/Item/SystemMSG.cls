Class JHIPLIB.Util.MSG.Item.SystemMSG Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Property SYSTEMCODE As %String(XMLNAME = "SYSTEM_CODE");

Property SYSTEMPARENTCODE As %String(XMLNAME = "SYSTEM_PARENT_CODE");

Property USERFUNCTION As list Of JHIPLIB.Util.MSG.Item.UserFunctionMSG(XMLNAME = "USER_FUNCTION");

Storage Default
{
<Data name="SystemMSGState">
<Value name="1">
<Value>SYSTEMCODE</Value>
</Value>
<Value name="2">
<Value>SYSTEMPARENTCODE</Value>
</Value>
<Value name="3">
<Value>USERFUNCTION</Value>
</Value>
</Data>
<State>SystemMSGState</State>
<StreamLocation>^JHIPLIB.Util.MSG.Item.SystemMSGS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

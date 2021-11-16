Class JHIPLIB.Util.MSG.Item.SystemMSG1 Extends (%SerialObject, %XML.Adaptor)
{

Property SYSTEMCODE As %String(XMLNAME = "SYSTEM_CODE");

Property SYSTEMPARENTCODE As %String(XMLNAME = "SYSTEM_PARENT_CODE");

Property USERFUNCTION As list Of JHIPLIB.Util.MSG.Item.UserFunctionMSG(XMLNAME = "USER_FUNCTION");

Storage Default
{
<Data name="SystemMSG1State">
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
<State>SystemMSG1State</State>
<StreamLocation>^JHIPLIB.Util.MSG.Item.SystemMSG1S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

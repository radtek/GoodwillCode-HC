Class JHIPLIB.Util.MSG.Item.UserMSG Extends (%SerialObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Property USERCODE As %String(XMLNAME = "USER_CODE");

Property USERDEPTCODE As %String(XMLNAME = "USER_DEPT_CODE");

Property SYSTEM As list Of JHIPLIB.Util.MSG.Item.SystemMSG(XMLNAME = "SYSTEM");

Property USERPROPERTY As list Of JHIPLIB.Util.MSG.Item.UserPropertyMSG(XMLNAME = "USER_PROPERTY");

Storage Default
{
<Data name="UserMSGState">
<Value name="1">
<Value>USERCODE</Value>
</Value>
<Value name="2">
<Value>USERDEPTCODE</Value>
</Value>
<Value name="3">
<Value>SYSTEM</Value>
</Value>
<Value name="4">
<Value>USERPROPERTY</Value>
</Value>
</Data>
<State>UserMSGState</State>
<StreamLocation>^JHIPLIB.Util.MSG.Item.UserMSGS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

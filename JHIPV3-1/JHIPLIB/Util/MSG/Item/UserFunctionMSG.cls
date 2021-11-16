Class JHIPLIB.Util.MSG.Item.UserFunctionMSG Extends (%SerialObject, %XML.Adaptor)
{

Property USERFUNCTIONCODE As %String(XMLNAME = "USER_FUNCTION_CODE");

Property USERFUNCTIONNAME As %String(XMLNAME = "USER_FUNCTION_NAME");

Storage Default
{
<Data name="UserFunctionMSGState">
<Value name="1">
<Value>USERFUNCTIONCODE</Value>
</Value>
<Value name="2">
<Value>USERFUNCTIONNAME</Value>
</Value>
</Data>
<State>UserFunctionMSGState</State>
<StreamLocation>^JHIPLIB.UtilD24E.UserFunctioB630S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

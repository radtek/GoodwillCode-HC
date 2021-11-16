Class JHIPLIB.Util.MSG.Item.UserPropertyMSG Extends (%SerialObject, %XML.Adaptor)
{

Property USERPROPERTYNAME As %String(XMLNAME = "USER_PROPERTY_NAME");

Property USERPROPERTYVALUE As %String(XMLNAME = "USER_PROPERTY_VALUE");

Storage Default
{
<Data name="UserPropertyMSGState">
<Value name="1">
<Value>USERPROPERTYNAME</Value>
</Value>
<Value name="2">
<Value>USERPROPERTYVALUE</Value>
</Value>
</Data>
<State>UserPropertyMSGState</State>
<StreamLocation>^JHIPLIB.UtilD24E.UserPropertF1E4S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

Class JHIPLIB.Util.MSG.PermissionsMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property SYSTEMCODE As %String(XMLNAME = "SYSTEM_CODE");

Property USER As list Of JHIPLIB.Util.MSG.Item.UserMSG(XMLNAME = "USER");

Storage Default
{
<Data name="PermissionsMSGDefaultData">
<Subscript>"PermissionsMSG"</Subscript>
<Value name="1">
<Value>SYSTEMCODE</Value>
</Value>
<Value name="2">
<Value>USER</Value>
</Value>
</Data>
<DefaultData>PermissionsMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

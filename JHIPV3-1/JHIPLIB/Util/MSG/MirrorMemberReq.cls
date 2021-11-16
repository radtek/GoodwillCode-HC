/// mirrro成员的基本信息
Class JHIPLIB.Util.MSG.MirrorMemberReq Extends Ens.Request
{

Parameter XMLNAME = "MirrorMember";

Property AgentAddress As %String;

Property AsyncMemberType As %String;

Property AsyncMemberGUID As %String;

Property AsyncUseSystemPurgeInterval As %String;

Property JoinMirror As %String;

Property SystemName As %String;

Property ValidatedMember As %String;

Property VirtualAddressInterface As %String;

Storage Default
{
<Data name="MirrorMemberReqDefaultData">
<Subscript>"MirrorMemberReq"</Subscript>
<Value name="1">
<Value>AgentAddress</Value>
</Value>
<Value name="2">
<Value>AsyncMemberType</Value>
</Value>
<Value name="3">
<Value>AsyncMemberGUID</Value>
</Value>
<Value name="4">
<Value>AsyncUseSystemPurgeInterval</Value>
</Value>
<Value name="5">
<Value>JoinMirror</Value>
</Value>
<Value name="6">
<Value>SystemName</Value>
</Value>
<Value name="7">
<Value>ValidatedMember</Value>
</Value>
<Value name="8">
<Value>VirtualAddressInterface</Value>
</Value>
</Data>
<DefaultData>MirrorMemberReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

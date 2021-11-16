/// 这是一个镜像基本信息的请求
Class JHIPLIB.Util.MSG.MirrorsReq Extends Ens.Request
{

Parameter XMLNAME = "MIRRORS";

Property GUID As %String;

Property ACKRequirement As %String;

Property AgentContactRequiredForTakeover As %String;

Property ArbiterNode As %String;

Property CompressionForAsynoMembers As %String;

Property CompressionforFailoverMembers As %String;

Property DefinedPrimary As %String;

Property QOSTimeout As %String;

Property RequireAuthentication As %String;

Property TroubleTimeout As %String;

Property UseSSL As %String;

Property VirtualAddress As %String;

Storage Default
{
<Data name="MirrorsReqDefaultData">
<Subscript>"MirrorsReq"</Subscript>
<Value name="1">
<Value>GUID</Value>
</Value>
<Value name="2">
<Value>ACKRequirement</Value>
</Value>
<Value name="3">
<Value>AgentContactRequiredForTakeover</Value>
</Value>
<Value name="4">
<Value>ArbiterNode</Value>
</Value>
<Value name="5">
<Value>CompressionForAsynoMembers</Value>
</Value>
<Value name="6">
<Value>CompressionforFailoverMembers</Value>
</Value>
<Value name="7">
<Value>DefinedPrimary</Value>
</Value>
<Value name="8">
<Value>QOSTimeout</Value>
</Value>
<Value name="9">
<Value>RequireAuthentication</Value>
</Value>
<Value name="10">
<Value>TroubleTimeout</Value>
</Value>
<Value name="11">
<Value>UseSSL</Value>
</Value>
<Value name="12">
<Value>VirtualAddress</Value>
</Value>
</Data>
<DefaultData>MirrorsReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

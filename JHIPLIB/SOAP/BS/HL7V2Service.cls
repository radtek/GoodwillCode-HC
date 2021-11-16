/// Classname JHIPLIB.SOAP.BS.HL7V2Service<br/>
/// Summary   HL7V2SOAPBS封装类，参数Input为字符流。<br/>
/// Version   1.0<br>
/// Date      2019年4月29日 15:15:39<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.SOAP.BS.HL7V2Service Extends (JHIPLIB.SOAP.AESCBC.AESCBCService, JHIPLIB.Util.Base.HL7Service) [ ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter ADAPTER;

Parameter NAMESPACE = "http://goodwillcis.com";

Parameter SERVICENAME = "HL7v2Service";

Parameter SETTINGS = "-Framing,IsSync:Basic";

Property DummyLibStreamIn As %Stream.GlobalCharacter;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

Property IOStreamIn As %IO.MetaCharacterStream;

Property LibStreamReply As %Stream.GlobalCharacter;

Property IOStreamReply As %IO.MetaCharacterStream;

/// 结束段标记字符
Property SegTerminator As %String [ InitialExpression = {$C(13,10)} ];

/// 初始化业务主机对象
Method %OnNew(pConfigName As %String) As %Status
{
	#; %cspServer在没有配置名的情况下实例化我们。我们需要推迟初始化。
	Quit:""=$G(pConfigName) $$$OK
	Quit ##class(Ens.BusinessService)$this.%OnNew(.pConfigName)
}

Method OnInit() As %Status
{
	Set tSC=##class(JHIPLIB.Util.Base.HL7Service)$this.OnInit()  Quit:$$$ISERR(tSC) tSC
	Set ..IOStreamIn=##class(%IO.MetaCharacterStream).%New()
	Set ..LibStreamReply=##class(%GlobalCharacterStream).%New()
	Set ..IOStreamReply=##class(%IO.MetaCharacterStream).%New(..LibStreamReply)
	Set ..IOStreamReply.Name="SOAPReplyStream"
	Set:..IsSync=1 ..AckMode="App"
	Set:..IsSync=0 ..AckMode="Immed"
	
	Quit $$$OK
}

Method Send(Input As %Stream.GlobalCharacter) As %Stream.GlobalCharacter [ WebMethod ]
{
	if ..IsAESCBC{
		if ..Verification() '= $$$OK{
			Quit "鉴权失败无法调用接口"
			}
		}
	Set tSC=..ProcessInput(Input,.tStreamOut)  Do:$$$ISERR(tSC) ..ReturnMethodStatusFault(tSC)
	Quit tStreamOut
}

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	$$$LOGINFO(..AckMode)
	Set tSC=$$$OK  Do pStreamIn.Rewind()
	$$$sysTRACE("Got SOAP Stream "_pStreamIn_"("_pStreamIn.Size_")")
	Do ..IOStreamIn.BindInput(pStreamIn, .tSC)  Quit:$$$ISERR(tSC) tSC
	Set tSC = ..IOStreamIn.BindOutput(pStreamIn)  Quit:$$$ISERR(tSC) tSC
	Set ..IOStreamIn.Name=..%ConfigName_"_SOAPStream"
	Do ..%Parser.Reset()
	Do ..LibStreamReply.Clear(), ..IOStreamReply.Rewind(.tSC1)  Quit:$$$ISERR(tSC1) $$$ADDSC(tSC,tSC1)
	While '..IOStreamIn.AtEnd { ; 循环流中的文档
		Set tSC1=..%Parser.ParseFramedIOStream(..IOStreamIn,,1)
		Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
		Quit:$$$StatusEquals(tSC1,$$$EnsErrGeneral) // !!! 仅在出现致命错误时退出
	}
	Do ..IOStreamIn.BindInput(..DummyLibStreamIn, .tSC)  Quit:$$$ISERR(tSC) tSC
	Set tSC = ..IOStreamIn.BindOutput(..DummyLibStreamIn)  Quit:$$$ISERR(tSC) tSC
	Do ..%Parser.Reset() ; release the file
	Set pStreamOut=..LibStreamReply
	Quit tSC
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit:'$IsObject(pReplyDocument) ..LibStreamReply.Write(pReplyDocument)
	Set pReplyDocument.IsMutable=0

	Set:$Case(..%outFraming,"uninitialized":1,"xxf":1,:0) ..%outFraming=..%Parser.%outFraming
 	Set tSC=..OutputFramedToIOStream(..IOStreamReply,pReplyDocument,,,1,..IOLogEntry)
	If $$$ISERR(tSC) {
		Set:$IsObject(..IOLogEntry) ..IOLogEntry.Annotation = $S(""=..IOLogEntry.Annotation:"",1:..IOLogEntry.Annotation_" | ")_"after SOAP WriteHL7 error on "_..Adapter.IOAddr
	} Else {
		Set:$IsObject(..IOLogEntry) ..IOLogEntry.Annotation = $S(""=..IOLogEntry.Annotation:"",1:..IOLogEntry.Annotation_" | ")_"after SOAP WriteHL7 on "_..Adapter.IOAddr
	}
	Quit tSC
}

/// 返回语法分析器和OutputTo…（）方法将使用的段结束符字符串。
Method GetSegmentTerminator() As %String
{
	Quit ..SegTerminator
}

}

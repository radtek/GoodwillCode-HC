/// Classname JHIPLIB.HTTP.BS.HL7V2Service
/// Summary   HL7V2Service封装类。<br>
/// Explain	  出参到BP时为EnsLib.HL7.Message类型,唯一服务标识（BS名称前6位）会在对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
///            入参及出参编码格式为UTF-8
/// Version   1.0<br>
/// Date      2019年11月20日 10:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.HTTP.BS.HL7V2Service Extends JHIPLIB.Util.Base.HL7Service [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

/// 此服务应返回哪种HTTP响应？
/// codeonly:返回HTTP响应代码200表示确定，500表示错误，没有HTTP响应正文文本
/// codewithackbody:返回HTTP响应代码200表示OK，500表示错误，HL7响应消息作为body文本
/// okcodewithackbody:以body文本的形式返回HL7响应消息，如果body存在，则始终返回HTTP响应代码200表示OK
Property HTTPResponseMode As %String(VALUELIST = ",CodeOnly,CodeWithACKBody,OKCodeWithACKBody") [ InitialExpression = "OKCodeWithACKBody" ];

Parameter SETTINGS = "IsSync:Basic,HTTPResponseMode";

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

Property ReplyStream As %GlobalCharacterStream;

Property ReplyIOStream As %IO.MetaCharacterStream;

/// 结束段标记字符
Property SegTerminator As %String [ InitialExpression = {$C(13,10)} ];

Method OnInit() As %Status
{
	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set ..ReplyStream=##class(%GlobalCharacterStream).%New()
	Set ..ReplyStream.Attributes("Content-Type")="text/xml"
	Set ..ReplyIOStream=##class(%IO.MetaCharacterStream).%New(..ReplyStream)
	Set ..ReplyIOStream.Name="HTTP Response"
	Set:""=$ZStrip(..HTTPResponseMode,"<>W") ..HTTPResponseMode="OKCodeWithACKBody"
	Set:..IsSync=1 ..AckMode="App"
	Set:..IsSync=0 ..AckMode="Immed"
	Quit $$$OK
}

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	Do ..%Parser.Reset()
	Do ..ReplyStream.Clear()
	Set tSC=..%Parser.ParseFramedIOStream(##class(%IO.MetaCharacterStream).%New(pStreamIn),,1)
	Do ..ReplyIOStream.Flush()
	If $$$ISERR(tSC) { $$$LOGSTATUS(tSC) } 
	Set ..ReplyStream.Attributes("Content-Type")="text/xml"
	Set ..ReplyStream.Attributes("Charset")="UTF-8"
	Set stuts=..ReplyStream.Write($zcvt(..ReplyStream.Read(),"O","UTF8"))
	Set pStreamOut=..ReplyStream
	Set t4=..ReplyStream.Read(4)
	If t4?3N." " {
		#;如果响应文本表示HTTP代码，则使用它并跳过流
		Set tResponse=t4_..ReplyStream.Read()
		Set:tResponse=t4 tResponse=$S($$$ISERR(tSC)&&(500'=+t4):"500 Internal Server Error", 1:tResponse)
		Do ..ReplyStream.Clear()
		Set ..ReplyStream.Attributes("ResponseCode")=tResponse
	} ElseIf $Case(t4, $C($$$SingleByteAckAcceptAscii):1, $C($$$SingleByteAckErrorAscii):1, :0) {
		#; 如果响应文本表示1字节的ACK，请使用它并跳过流
		Set tResponse=$S($$$ISERR(tSC)||($C($$$SingleByteAckErrorAscii)=t4):"500 Internal Server Error", 1:"200 OK")
		Do ..ReplyStream.Clear()
		Set ..ReplyStream.Attributes("ResponseCode")=tResponse
	} Else {
		#; 如果响应文本表示确认消息，则根据配置设置将其用作响应正文。
		If $$$ISERR(tSC) {
			If ..HTTPResponseMode="CodeOnly" {
				Do ..ReplyStream.Clear()
				Set ..ReplyStream.Attributes("ResponseCode")="500 内部服务器错误"
			} ElseIf ..HTTPResponseMode="CodeWithACKBody" {
				Do ..ReplyStream.Rewind()
				Set ..ReplyStream.Attributes("ResponseCode")="500 内部服务器错误"
			} Else { ; OKCodeWithACKBody
				Do ..ReplyStream.Rewind()
				Set:'..ReplyStream.Size ..ReplyStream.Attributes("ResponseCode")="500 内部服务器错误"
			}
		} Else {
			If ..HTTPResponseMode="CodeOnly" {
				Do ..ReplyStream.Clear()
			} Else {
				Do ..ReplyStream.Rewind()
			}
		}
	}
	Quit $$$OK
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit:'$IsObject(pReplyDocument) ..ReplyStream.Write(pReplyDocument)
	Set pReplyDocument.IsMutable=0
	Quit:"ACK_HTTP"=$E(pReplyDocument.Name,1,$L("ACK_HTTP")) ..ReplyStream.Write($P(pReplyDocument.Name,"_",3))

	Set:$Case(..%outFraming,"uninitialized":1,"xxf":1,:0) ..%outFraming=..%Parser.%outFraming
	Do ..ReplyIOStream.Clear()
 	Set tSC=..OutputFramedToIOStream(..ReplyIOStream,pReplyDocument,,,1,..IOLogEntry)
	If $$$ISERR(tSC) {
 		Set:$IsObject(..IOLogEntry) ..IOLogEntry.Annotation = $S(""=..IOLogEntry.Annotation:"",1:..IOLogEntry.Annotation_" | ")_"上的HTTP WRITEHL7错误在"_..Adapter.IOAddr
	} Else {
		Set:$IsObject(..IOLogEntry) ..IOLogEntry.Annotation = $S(""=..IOLogEntry.Annotation:"",1:..IOLogEntry.Annotation_" | ")_"上的HTTP WRITEHL7错误在"_..Adapter.IOAddr
	}
	Quit tSC
}

}

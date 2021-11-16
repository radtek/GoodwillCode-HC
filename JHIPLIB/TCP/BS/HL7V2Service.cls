Class JHIPLIB.TCP.BS.HL7V2Service Extends JHIPLIB.Util.Base.HL7Service [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "JHIPLIB.TCP.Adapter.HL7InAdapter";

/// 控制发送ACK前清除TCP接收缓冲区；选项：<br/>
/// -否：在返回当前消息的ACK之前，不要丢弃任何等待的入站数据。<br/>
/// -是&警告：在返回当前消息的ACK之前丢弃等待的入站数据，并在事件日志中记录警告<br/>
/// -是：在返回当前消息的ACK之前，丢弃等待的入站数据。仅当启用调试跟踪时在事件日志中记录。< BR>
/// 如果选择“是”选项并且启用了archiveio，则任何丢弃的数据都将写入archiveio日志
Property PreACKTCPClear As %String(DISPLAYLIST = ",No,Yes and Warn,Yes", VALUELIST = ",0,1,2") [ InitialExpression = "0", Required ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.HL7.Service.Standard},LocalFacilityApplication,Framing:Connection:selector?context={Ens.ContextSearch/getDisplayList?host=@currHostId&prop=Framing},AckMode,UseAckCommitCodes,IgnoreInboundAck,AddNackERR,NackErrorCode,PreACKTCPClear";

Method OnInit() As %Status
{
	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set ..%Parser.StartTimeout=..Adapter.CallInterval, ..%Parser.ReadTimeout=..Adapter.ReadTimeout
	Quit $$$OK
}

Method OnProcessInput(pLine As Ens.StringContainer, Output pLineLeftOver As Ens.StringContainer) As %Status
{
 	Set pLineLeftOver=""
	Do ..%Parser.ResetPosition()
	Set ..%Parser.%LookaheadLineIsNew=$LI(pLine,1), ..%Parser.%LookaheadLine=$LI(pLine,3), ..%Parser.%LookaheadLineTerminator=$LI(pLine,2)
	Set tSC=..%Parser.ParseFramedIOStream(..Adapter.Socket,,1,..IOLogEntry)
	Set:""'=..%Parser.%LookaheadLine||(""'=..%Parser.%LookaheadLineTerminator) pLineLeftOver=$LB(0,..%Parser.%LookaheadLineTerminator,..%Parser.%LookaheadLine)
	Quit tSC
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document = {$$$NULLOREF}) As %Status
{
	Quit:'..Adapter.Connected $$$OK
	
	If ..PreACKTCPClear {
		Set tSC1 = ..Adapter.ClearRecvBuffer(..PreACKTCPClear,.tMappedDiscardData,..IOLogEntry)
		Quit:'..Adapter.Connected tSC1
	}
	
	Set:$Case(..%outFraming,"uninitialized":1,"xxf":1,:'..%Parser.RememberFlex) ..%outFraming=..%Parser.%outFraming
 	Set tSC=..OutputFramedToIOStream(..Adapter.Socket,pReplyDocument,,,1,..IOLogEntry)
	If $$$ISERR(tSC) {
		If ..Adapter.IsWriteError(tSC) {
			Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 Write", ..Adapter.Device, $$$StatusDisplayString(tSC))
			Do ..Adapter.Disconnect()
		}
		$$$SAVEIOLOGENTRY(tSC,"TCP 写HL7错误发生在 "_..Adapter.IOAddr,pReplyDocument)
	} Else {
		$$$SAVEIOLOGENTRY(tSC,"TCP 写HL7错误发生在"_..Adapter.IOAddr,pReplyDocument)
	}
	Quit tSC
}

}

Include Ensemble

/// Classname JHIPLIB.TCP.Adapter.InAdapter
/// Summary   TCPIn适配器
/// Version   1.0
/// Date      2019年12月25日 10:00
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.TCP.Adapter.InAdapter Extends (EnsLib.TCP.InboundAdapter, EnsLib.TCP.FramedCommon, EnsLib.TCP.TextLineCommon) [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter SERVICEINPUTCLASS = "Ens.StreamContainer";

Parameter SERVICEOUTPUTCLASS = "Ens.StreamContainer";

/// 如果丢弃框架错误的数据并且SendAcknowledgement为true
/// 以及不是由服务的目标生成的确认
/// 如果此设置为false（默认值），则返回NACK else
/// 忽略。
Property DiscardSilently As %Boolean [ InitialExpression = 0 ];

/// 此设置用于在框架中包装确认
/// 由MessageFrameStart和MessageFrameEnd指定。默认值为真。
Property AddFramingToAcknowledgement As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "UseFileStream,MessageFrameStart:Additional,MessageFrameEnd:Additional,RemoveFraming:Additional,DiscardDataNotwithinFraming:Additional,DiscardSilently:Additional,AddFramingToAcknowledgement:Additional";

Method OnInit() As %Status
{
	Try {
		Set ..Terminators = ..AsciiOrHexAsChars(..MessageFrameEnd)
		Set ..MessageFrameEndAsChars = ..Terminators
		Set ..MessageFrameStartAsChars = ..AsciiOrHexAsChars(..MessageFrameStart)
	} Catch {}
	Quit ##super()
}

Method OnConnected() As %Status
{
	Set tSC=$$$OK, tQuitErr=1
	Set tCharset=..Charset  Set:$Case($ZCVT(..Charset,"L"),"default":1,"auto":1,:0) tCharset="UTF-8"
	Try {
		Set tSC = ..ReadFramedStream(.tStream,tCharset,..CallInterval,..ReadTimeout,1, .tProcessMessage, .tDiscardedData)
		/* 我们可能在等待正确的终结者时超时。希望继续能够报告*/
		Quit:($$$ISERR(tSC)&&'tProcessMessage)
		If tProcessMessage,'tDiscardedData {
			Do tStream.Rewind()
			Set tSC=..BusinessHost.ProcessInput(tStream,.tResponse)
		} ElseIf tDiscardedData {
			Quit:..DiscardSilently /* 不发送响应 */
			Try {
				Set tResponse = ""
				Set:..BusinessHost.SendAcknowledgement tResponse=##Class(%IO.StringStream).%New(..BusinessHost.AckNotOKAsChars)
			} Catch { Set tSC = $$$SystemError}	
		} Else {
			#;未收到此投票的数据
			Quit
		}
		Quit:$$$ISERR(tSC)
		#; 写入服务返回的响应, Ens.StreamContainer, Ens.StringRequest, Ens.StringResponse.
		
		Try {
			If $IsObject(tResponse) {
				 If tResponse.%IsA("EnsLib.EDI.XML.Document") {
					Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
					Set tResponse = ##Class(%IO.StringStream).%New(Util.OutputToString(tResponse))
					Set tResponseSize = tResponse.Size	
				 } ElseIf tResponse.%IsA("Ens.StringResponse")||tResponse.%IsA("Ens.StringRequest"){
				 	Set tResponse = ##Class(%IO.StringStream).%New(tResponse.StringValue)
				 	Set tResponseSize = tResponse.Size	
				 } ElseIf tResponse.%IsA("%Stream.Object")||tResponse.%IsA("%IO.I.Stream") {
					Set tResponseSize = tResponse.Size	 
				}
			} ElseIf (tResponse'="") {
				
				Set tResponse = ##Class(%IO.StringStream).%New(tResponse)
				Set tResponseSize = tResponse.Size
			}
		} Catch {
			Set tResponseSize=0
		}
		If tResponseSize {
			Set tSC  = ..WriteFramedStream(tResponse,tCharset,1,..AddFramingToAcknowledgement)
			$$$LOGINFO("tSC"_tSC)
		}
	} Catch { Set tSC = $$$SystemError}
	#; 返回错误状态将导致此侦听器作业终止
	If $$$ISERR(tSC) {
		#; 从不退出侦听器，但在出现无法识别的错误时断开连接
		If tQuitErr,..Connected,..StayConnected { 
			$$$LOGERROR("由于 "_$$$StatusDisplayString(tSC))
			Set tSC=$$$OK
			Do ..Disconnect()
		}
		If $$$ISERR(tSC) $$$LOGSTATUS(tSC)
	}
	Quit $$$OK
}

Method Disconnect()
{
	Do ##super()
}

}

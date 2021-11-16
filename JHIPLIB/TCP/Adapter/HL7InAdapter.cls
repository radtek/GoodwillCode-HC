Include EnsHL7

/// Classname JHIPLIB.TCP.Adapter.HL7InAdapter
/// Summary   HL7V2TCP适配器
/// Version   1.0
/// Date      2019年8月22日 10:00
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.TCP.Adapter.HL7InAdapter Extends EnsLib.TCP.InboundAdapter [ ClassType = "", ProcedureBlock, System = 4 ]
{

/* （重写从基类继承的设置InitialExpression）*/

/*（重写从基类继承的设置InitialExpression）*/
/// 在我们开始处理之前，操作系统应该代表我们打开多少个传入连接？<P>
/// 如果一次只需要一个连接，则设置为0。如果许多客户机将快速连接，则设置为大量。
Property QSize As %Integer(MAXVAL = 1000, MINVAL = 0) [ InitialExpression = 0 ];

/// 生成一个新作业来处理每个传入的TCP连接。允许同时处理多个连接。< BR>
/// 请注意，更改此适配器的已配置qsize设置和将作业服务器配置为系统配置选项都会影响此设置的性能。
Property JobPerConnection As %Boolean [ InitialExpression = 0 ];

/// 解析器的lookahead行的本地持有者
Property %OutLine As %String;

Method OnInit() As %Status
{
	#; 重写（空）超类初始终止符值
	Set ..Terminators=..BusinessHost.GetSegmentTerminator()
	Quit ##super()
}

Method OnConnected() As %Status
{
	Set tSC=$$$OK, tQuitErr=1
	Do {
		If ""=..%OutLine {
			$$$catTRACE("connwait","终止符的开始头读取'"_$A(..Terminators)_"' 超时"_..CallInterval_" on "_..IOAddr)
			Set tTimeout=..CallInterval, tZB=..Terminators, tLine=..Socket.ReadLine(32000,.tTimeout,.tSC,.tZB)
			If $$$ISERR(tSC) {
				If ..IsReadError(tSC) {
					Set tSC=$$$ERROR($$$EnsErrInConnectionLost,"HL7 Read",..IOAddr,$$$StatusDisplayString(tSC))
					Set tQuitErr=0  Do ..Disconnect()
					If ""=tLine Set tTxt=$$$StatusText(tSC), tSC=$$$OK  If ..StayConnected<0 { $$$LOGWARNING(tTxt) } ElseIf ..%logConnections { $$$LOGINFO(tTxt) } Else { $$$sysTRACE(tTxt) } ; 如果失去没有数据的连接，将错误更改为信息
				}
			} ElseIf tTimeout=..CallInterval {
				If ""'=tLine { ; 只有在获取某些数据后超时时才报告错误
					Set tSC=$$$ERROR($$$EnsErrTCPTerminatedReadTimeoutExpired,tTimeout,"EndData="_$A($E(..Terminators))_$S(""=$E(..Terminators,2):"",1:","_$A($E(..Terminators,2))),tLine)
					Set tQuitErr=0
				}
			}
			#; 不需要检查超时-只要看看我们有没有数据
			Quit:""=tLine
			$$$catTRACE("connwait","Got line '"_tLine_"'")
			Quit:$$$ISERR(tSC)
			Set ..%OutLine=$LB(1,tZB,tLine)
		}
		$$$ANEWINIOLOGENTRY($$$OK,"TCP ReadHL7 on :"_..IOAddr,"EnsLib.HL7.Message")
		Set tSC=..BusinessHost.ProcessInput(..%OutLine,.tOutLine)
		Set ..%OutLine=tOutLine
		If $$$ISERR(tSC) {
			Set tIsWriteErr=..IsWriteError(tSC)
			If tIsWriteErr||..IsReadError(tSC) {
				Set tSC=$$$ERROR($$$EnsErrInConnectionLost,$S(tIsWriteErr:"HL7 Write",1:"HL7 Read"),..IOAddr,$$$StatusDisplayString(tSC))
				Set tQuitErr=0  Do ..Disconnect()
			}
			$$$ACLOSEIOLOGENTRY(tSC,"TCP ProcessInput错误在 :"_..IOAddr,$$$NULLOREF)
		} Else {
			If $IsObject(..BusinessHost.IOLogEntry) && ..BusinessHost.IOLogEntry.IsEmpty() { Set ..BusinessHost.IOLogEntry=$$$NULLOREF } ; don't log empty IO if no error
			Else { $$$ACLOSEIOLOGENTRY(tSC,"TCP ProcessInput错误在"_..IOAddr,$$$NULLOREF) }
		}
	} While 0
	If $$$ISERR(tSC) {
		#; 发生无法识别的错误时删除连接
		If tQuitErr&&..Connected&&..StayConnected {
			$$$LOGERROR("Disconnecting due to "_$$$StatusDisplayString(tSC))
			Do ..Disconnect()
		} Else {
			$$$LOGSTATUS(tSC)
		}
	}
	#; 返回错误状态将导致此侦听器作业终止；永远不要退出侦听器
	Quit $$$OK
}

Method Disconnect()
{
	If ""'=..%OutLine $$$LOGWARNING("Discarding leftover input '"_$LG(..%OutLine,3)_"'")
	Set ..%OutLine=""
	Do:..Connected ..BusinessHost.%Parser.Reset()
	Do ##super()
}

// 此方法用于清除接收缓冲区。

/// 如果有读取错误，将调用disconnect（）。
/// 如果使用，则在返回ACK之前立即调用
/// PClearFlag可以是：
/// -0：不要丢弃任何等待的入站数据
/// -1：丢弃等待的入站数据，并在事件日志中记录警告<br/>
/// -2：丢弃等待的入站数据。仅当启用调试跟踪时在事件日志中记录。< BR>
/// pdiscarded返回调用方第一个被丢弃的行，其中映射了任何控件characted。
Method ClearRecvBuffer(pClearFlag As %Integer = 0, Output pDiscarded As %String, ByRef pIOLogEntry As Ens.Util.IOLog = {$$$NULLOREF}) As %Status
{
#define MapCtlChars(%s)	$TR(%s,$C(1,2,9,10,11,13,28),"12tlsre")
#define MapCtlLine(%s)	($$$MapCtlChars($E(%s,1,1000))_$S($L(%s)>1000:"...",1:""))
#define MapCtlLineZB(%s,%zb)	($$$MapCtlLine(%s)_"+"_$$$MapCtlChars(%zb))
		
	Set tSC = $$$OK
	Set pDiscarded = ""
	Quit:'pClearFlag $$$OK

	Try {	
		#; 清除所有挂起的邮件，因为在我们答复之前
		#; 除了可能重试我们正在回复的同一封邮件外，没有其他邮件。
		Set tMaxReadLen = $$$HL7MaxReadLen
		$$$catTRACE("parse","打包前在网上查找数据.")
		While '..Socket.AtEnd {
			Kill tZB  Set tLine=..Socket.ReadLine(tMaxReadLen,0,.tSC,.tZB)
			If $$$ISERR(tSC) {
				$$$LOGSTATUS(tSC)
				Quit
			}
			Quit:((""=tLine)&&(""=tZB))
			Set tMappedDiscardData = $$$MapCtlLineZB(tLine,tZB)
			If (pClearFlag#2) {
				$$$LOGWARNING("丢弃在hl7 ack send之前在缓冲区中找到的数据："_tMappedDiscardData)
			} Else {
				$$$catTRACE("parse","丢弃在hl7 ack send之前在缓冲区中找到的数据： "_tMappedDiscardData)
			}
			If $IsObject(pIOLogEntry) {
				If '$$$IsdefObject(tDiscard) { Set tDiscard=##class(%Stream.GlobalCharacter).%New() }
				Do tDiscard.Write(tMappedDiscardData)
			}
			Set:(pDiscarded="") pDiscarded = tMappedDiscardData
		}
		If $$$IsdefObject(tDiscard) {
			Set tPreJunk=tDiscard.Read(1000) Do tDiscard.Rewind()
			Set tNote="意外的HL7读取数据 ("_$S(tDiscard.Size>1000:"...",1:"")_tPreJunk_") 打开消息之前 "_..Socket.Name
			Do ..BusinessHost.IOLogDiscard(tSC,tNote,tDiscard)
		}
	} Catch { 
		Set tSC = $$$EnsSystemError
	}
	If $$$ISERR(tSC) {
		If ..IsReadError(tSC) {
			Set tSC=$$$ERROR($$$EnsErrOutConnectionLost,"HL7 Read", ..Device, $$$StatusDisplayString(tSC))
			Do ..Disconnect()
		}
	}
	Quit tSC
}

}

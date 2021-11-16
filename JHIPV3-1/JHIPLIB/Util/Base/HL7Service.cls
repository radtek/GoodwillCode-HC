Include EnsHL7

/// HL7工具父类
Class JHIPLIB.Util.Base.HL7Service Extends (Ens.BusinessService, EnsLib.HL7.Util.IOFraming, EnsLib.EDI.ServiceInterface) [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS As %String = "EnsLib.HL7.Message";

/// 要向其发送消息的配置项
Property TargetConfigNames As %String(MAXLEN = 2000);

/// 存储与处理的每个HL7消息关联的一组可搜索属性。< BR>
/// 这些记录将存储在命名的searchTable类（如果有）中。
Property SearchTableClass As %String(MAXLEN = 128);

/// 以冒号分隔的localfacility:localapplication代码，表示此（接收）设备和应用程序<br/>
/// 这些用于将reply ack消息头构造为sendingFacility和sendApplication。< BR>
/// 符号“@”表示使用来自传入消息的相应字段。< BR>
/// 如果ID必须包含文本@符号，则用反斜杠对其进行转义：“\@”
Property LocalFacilityApplication As %String [ InitialExpression = "ISC:EnsembleHL7" ];

/* （覆盖从基类继承的设置的注释、显示列表和默认值） */
/// HL7入站消息帧协议。选项为：<br/><ul>
/// <li>灵活：根据接收到的每条消息的接收数据内容确定帧样式。</LI>
/// <li>灵活！：根据接收到的第一条消息数据的内容确定帧样式，并要求后续消息具有相同的帧样式。</LI>
/// <li>无：无框架-以“msh”开头的每一行都是新消息的开始。</LI>
/// <li>MLLP：最低级别协议-用ASCII代码11前缀和ASCII代码28,13后缀为每个HL7消息编帧。</LI>
/// <li>MLLPN/M：最小的低级协议-用ASCII码N前缀和ASCII码M后缀以及附加的ASCII码13为每个HL7消息编帧。</LI>
/// <li>asciilf：用ASCII码10（换行符）将每条报文与后续报文分开的帧报文。</LI>
/// <li>asciicr：用一个额外的ascii码13（回车）将每条报文与随后的报文分开的帧报文。</LI>
/// <li>ascii m：用ascii码m后缀字符将每条报文与后续报文分开的帧报文。</LI>
/// <li>ascii n/m：在每条消息和ascii代码m后缀字符之前使用ascii代码n前缀字符对消息进行帧处理，但在mllpn/m中没有尾随的ascii代码13。</li>
/// <li>LLP：低级协议-（过时）在冗余校验和块中为每个HL7消息帧。<li>><ul>>
/// 说明：<br/>
/// -ASCII代码n是一个或多个字符的序列，由它们的ASCII代码表示，如果有多个字符，则用逗号分隔。< BR>
/// -所有ASCII码应以十进制给出。< BR>
/// -不允许将ASCII代码120（字符“x”）作为帧字符。< BR>
Property Framing As %String(DISPLAYLIST = ",Flexible,Flexible!,None,MLLP,MLLP11/28,AsciiLF,AsciiCR,Ascii11,Ascii11/28,LLP") [ InitialExpression = "Flexible" ];

/// ACK处理的控制。选项为：<br/><ul>
/// <li>从不：不要发送任何确认。< BR>
/// <li>立即：收到入站消息后立即返回（提交）ACK回复消息。</LI>
/// <li>应用程序：如果消息通过验证，请等待目标配置项的确认，并在消息到达时将其转发回。</LI>
/// <li>已确定的MSH：根据传入消息的MSH头中的请求发送回ACK应答消息。</LI>
/// <li>字节：发送一个即时的单一ACK码字节，而不是ACK消息。字节ascii代码6='确定'，ascii代码21='错误'.<li>>
Property AckMode As %String(DISPLAYLIST = ",Never,Immediate,Application,MSH-determined,Byte", VALUELIST = ",Never,Immed,App,Msh,Byte") [ InitialExpression = "Immed", Required ];

/// 如果“true”和HL7消息版本ID为2.3或更高，请使用msa:1（“acknowledgmentcode”）中的“增强模式”ack“commit”代码（“cx”）。（否则使用传统模式“AX”代码。）
Property UseAckCommitCodes As %Boolean [ InitialExpression = 1 ];

/// 忽略入站ACK消息以避免ACK反馈循环。
Property IgnoreInboundAck As %Boolean [ InitialExpression = 1 ];

/// 生成nack消息时添加err错误代码段；否则不要在nack消息中嵌入内部错误状态信息。
Property AddNackERR As %Boolean;

/// 控制此服务在处理传入消息时生成的nack消息msa:1中的错误代码。<br/><br/>
/// 默认的“content”行为是返回代码“e”（对于消息内容中的错误）和代码“r”（对于试图处理消息时在Ensemble中遇到的系统错误）。<br/><br/>
/// 这一区别很重要，因为系统错误预计会得到解决，因此如果远程客户端稍后重试，则可能不会发生这些错误，而消息内容和验证错误预计需要在源位置进行更正，不值得以相同的形式重试。.<br/><br/>
/// 但是，某些客户端系统可能期望或需要不同的错误行为。因此，还提供了3种额外的行为。这4种行为如下：<br/><ul>
/// <li>content=使用MSA错误代码“e”报告消息内容中的错误，并使用代码“r”由于（可重试）系统错误而拒绝。</LI>
/// <li>content r=返回“r”表示内容错误，返回“e”表示系统错误。</LI>
/// <li>all e=返回所有内容和系统错误的“e”。</LI>
/// <li>all r=返回所有内容和系统错误的“r”。<li>><ul>>
/// 早期版本的Ensemble只使用了行为“content”。
Property NackErrorCode As %String(VALUELIST = ",ContentE,ContentR,AllE,AllR") [ InitialExpression = "ContentE" ];

/// 如何处理接收到的批处理文档：<br/><ul>
/// <li>整批：不单独处理子文档，将整批文档作为一个复合文档累计发送。</LI>
/// <li>单会话批处理：作为单会话的一部分转发批处理中的所有文档，包括包含批头和尾部段的最终父文档对象。</LI>
/// <li>多会话批处理：在自己的会话中转发批处理中的每个文档，然后转发包含批头和尾部段的最终父文档对象。</LI>
/// <li>单个：在自己的会话中转发批中的每个子文档；不转发父批文档对象。<li>>ul>
Property BatchHandling As %String(DISPLAYLIST = ",Whole Batch,Single-Session Batch,Multi-Session Batch,Individual", VALUELIST = ",Whole,1Session,Batch,Indiv") [ InitialExpression = "1Session", Required ];

/// 应用于传入消息类型的类别，以生成完整的doctype规范。<p/>
/// 与文档类型名称（msh:9）结合生成messagetype规范，然后使用该规范
/// 在给定HL7架构类别的messagetypes部分中查找messagestructure/doctype。<p/>
/// 此设置还可以包含多个逗号分隔的类型名，后跟=然后是
/// 要应用于包含该类型名的HL7消息的doctypecategory或完整doctype值。<p/>
/// 给定部分类型名称末尾的尾随星号（*）将匹配具有该开始部分的任何类型。<p/>
/// 例如：messageSchemaCategory='2.3.1，adt_*=2.5，bar_p10=2.4，orm_o01_6=2.4:rde_o01'<br>
/// 请注意，验证或SearchTableClass索引可能需要doctype分配。
Property MessageSchemaCategory As %String(MAXLEN = 1000);

/// 如何根据msh:9中的消息类型解析doctype。选项为：<br/><ul>
/// <li>标准：将有效的messageSchemaCategory值与在相应架构类别中查找msh:9消息类型值的消息结构名称相结合。这是默认设置。</LI>
/// <li>忽略9.3：与“标准”类似，但如果msh:9有3个或更多的片段，则忽略其他片段。标准行为是，如果没有子部分，则使用第3部分作为类型名的一部分，因为某些模式包含三部分的类型名。</LI>
/// <li>使用9.3：与“标准”类似，但是如果msh:9有3个或更多的片段，则使用附加片段作为适用模式类别中文档结构的文字名称。请谨慎使用，因为消息到达时可能带有msh:9.3值，所选架构类别中不存在任何结构。</LI>
/// <li>literal：将有效的messageSchemaCategory值与解释为消息结构名称的literal msh:9消息类型值组合在一起。仅与每个消息类型都有相应结构定义的自定义架构一起使用。<li>>ul>
Property DocTypeResolution As %String(DISPLAYLIST = ",Standard,Ignore 9.3,Use 9.3,Literal", VALUELIST = ",Std,Ign,Use,Lit") [ InitialExpression = "Std", Required ];

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.HL7.Service.Standard},LocalFacilityApplication,Framing:Connection:selector?context={Ens.ContextSearch/getDisplayList?host=@currHostId&prop=Framing},AckMode,UseAckCommitCodes,IgnoreInboundAck,AddNackERR,NackErrorCode,BatchHandling,MessageSchemaCategory:Basic:selector?context={Ens.ContextSearch/SchemaCategories?host=EnsLib.HL7.Service.Standard},DefCharEncoding::selector?context={Ens.ContextSearch/CharacterSets},DocTypeResolution,SaveReplies";

/// 在reply/ack消息中，使用我们要回复的消息的controlID，而不是构造一个新的唯一消息。
Parameter UseOriginalControlId As %Boolean = 1;

/* 在Ackin中使用…子类 */
/// 除了根据AckMode设置转发完整的Ack消息外，在此服务的TCP连接上返回即时的1字节Ack。
Property ImmediateByteAck As %Boolean;

/// 对于批处理文档，不要单独处理子消息文档；一次累积并发送整个批。
Property %ForwardBatchWhole As %Boolean [ Internal ];

/// 单独处理子文档时，除了包含子消息文档外，还转发批头/尾段shell文档。
Property %ForwardBatchHeaders As %Boolean [ InitialExpression = 1, Internal ];

/// 对于批处理消息，将批处理中的每个消息作为单个会话的一部分转发。
Property %SingleBatchSession As %Boolean [ Internal ];

/// 为一批消息发送单独的ACK回复文档，而不是为回复构建一个批包装器。
Property NoBatchReply As %Boolean [ InitialExpression = 0 ];

/// 如果发生错误，则停止处理批处理文档。否则，累积所有错误并将其作为一个组报告。
Property QuitOnError As %Boolean [ InitialExpression = 0 ];

/// 逗号分隔的字符串，指定要执行的验证类型。如果重写onvalidate（）并需要提供选项，则将其设置为子类中的一个设置。
Property Validation As %String;

/// [已弃用]应改为使用<property>save答复</property>property/setting。
/// 如果设置了searchTableClass，则使用它为任何答复编制索引（包括OK Acks，除非indexAcks=false）。
Parameter IndexReplies As %Boolean = 0;

/// [已弃用]应改为使用<property>save答复</property>property/setting。
/// 如果indexrepries也是真的并且给出了searchTable类，则index ok确认。
Parameter IndexACKs As %Boolean = 0;

/// 保存发送回远程系统的回复消息的副本。还可以使用配置的searchTableClass（如果有的话）为它们编制索引。
/// 此设置的选项如下：<br/><ul>
/// <li>无：不要保存或索引任何答复消息。这是默认行为，除非
/// <parameter>indexacks<parameter>has been overrided in this class.</LI>
/// <li>Notoks：保存不是简单OK ACK消息的答复，例如错误NACK和查询响应。</LI>
/// <li>全部：保存发送回远程系统的所有回复消息的副本。</LI>
/// <li>indexnotoks：保存不是简单OK ACK消息的回复，并使用配置的searchtable对其进行索引。</LI>
/// <li>index all：保存所有回复消息的副本，并使用配置的searchTable对其进行索引。<li>>ul>
Property SaveReplies As %String(VALUELIST = ",None,NotOKs,All,IndexNotOKs,IndexAll") [ InitialExpression = {$select(..#IndexReplies: "Index"_$select(..#IndexACKs: "All", 1: "NotOKs"), 1: "None")} ];

Property %Parser As EnsLib.HL7.Parser [ Internal ];

/// 这将回复文档保存为 EnsLib.EDI.Document.
Property %ReplyDocuments [ InitialExpression = 0, Internal, MultiDimensional ];

/// 当前消息是批处理中的第一条吗？（用于对批处理中的第一条消息启动新会话）
Property %isNewBatch As %Boolean [ InitialExpression = 1, Internal ];

Method OnInit() As %Status
{
	Set ..%Parser=##class(EnsLib.HL7.Parser).%New($this)
	If "!"=$E(..Framing,*) { Set ..%Parser.Framing=$E(..Framing,1,*-1), ..%Parser.RememberFlex=1}
	Else { Set ..%Parser.Framing=..Framing }
	Set ..%Parser.DefCharEncoding=..DefCharEncoding
	Set:""=..AckMode ..AckMode="Immed"
	Set:""=..NackErrorCode ..NackErrorCode="ContentR" ; 为了与以前配置的服务保持向后兼容性
	Set:""=..BatchHandling ..BatchHandling="1Session"

	Set ..%ForwardBatchWhole=$Case(..BatchHandling, "Whole":1, :0)
	Set ..%ForwardBatchHeaders=$Case(..BatchHandling, "Whole":0, "Indiv":0, :1)
	Set ..%SingleBatchSession=$Case(..BatchHandling, "1Session":1, :0)

	#; 为了向后兼容，如果旧版本已将ESN初始化为-1，则终止ESN。
	Kill:-1=$G($$$ExpectedSequenceNumber) $$$ExpectedSequenceNumber

	If ""=..TargetConfigNames { $$$LOGWARNING("No Target Config Name configured") }
	Quit $$$OK
}

/// 注意：pdocin未声明为enslib.hl7.message，因此子类可以在调用super（）之前处理其他类型并转换它们。
Method OnProcessInput(pDocIn As %RegisteredObject, Output pDocOut As %RegisteredObject) As %Status
{
	$$$ASSERT(0_"子类任务")
}

/// 重写此方法以实现处理传入ACK消息的自定义方法。
/// 返回非零意味着您正在处理它，普通框架应该忽略它。
Method OnInboundAck(pDoc As EnsLib.EDI.Document, pMSH As EnsLib.HL7.Segment, ByRef pSC As %Status) As %Boolean
{
	If ..IgnoreInboundAck {
		$$$LOGWARNING("不处理入站 "_pDoc.Name_" 消息 "_pDoc_"/"_pDoc.%Id())
		Set pDoc.IsMutable=0
		Quit 1
	}
	Quit 0
}

/// 重写此方法以实现用于验证传入文档的自定义方法。
/// 返回非零以防止消息的默认验证（如果有）。
Method OnValidate(pDoc As EnsLib.EDI.Document, pValSpec As %String, Output pStatus As %Status) As %Boolean
{
	Quit 0
}

/// 重写此方法以实现用于解析传入消息的doctype的自定义方法。
/// 返回非零意味着您正在重写框架的标准doctype解析。
Method OnResolveDocType(pDoc As EnsLib.EDI.Document, ByRef pDocType As %String) As %Boolean
{
	Quit 0
}

Method standardOnProcessInput(pDocIn As EnsLib.HL7.Message, Output pDocOut As EnsLib.HL7.Message) As %Status
{
	Set (tSC,tSCVal)=$$$OK, pDocOut=$$$NULLOREF
	$$$ASSERT($$$IsdefObject(pDocIn) && pDocIn.%IsA("EnsLib.HL7.Message"))
	$$$sysTRACE("Got Message "_pDocIn_" / "_pDocIn.%Id())
	Set tMSH=pDocIn.getSegmentByIndex(1,.tSC)
	If $$$ISOK(tSC) {
		If $Case(tMSH.Name,"FHS":1,"BHS":1,:0) { Set tMSH=$$$NULLOREF }
		ElseIf $Case(tMSH.GetValueAt("9.1"),"ACK":1,"ADR":1,:0) {
			Quit:..OnInboundAck(pDocIn,tMSH,.tSC) tSC
		}
		Set tSCVal=..resolveAndIndex(pDocIn,tMSH)
	}
	Set tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,0), tResponse=$$$NULLOREF
	If $$$ISOK(tSC)&&$$$ISOK(tSCVal)&&(""'=..TargetConfigNames) {
		Set pDocIn.IsMutable=0
		Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
		If $Case(..AckMode,"Never":1,"Immed":1,"Byte":1,"Msh":'$IsObject(tMSH)||$Case(tMSH.GetValueAt(16),"AL":0,"SU":0,"ER":0,:1),:0) { ; ApplicationAcknowledgmentType="NEver"
			#; Send Async; no reply required
			$$$SyncCommitSet(tSyncCommit)
			For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
				$$$sysTRACE("Sending HL7 Message "_pDocIn_" / "_pDocIn.%Id()_" from "_pDocIn.Source_" to '"_tOneTarget_"'")
				Set pDocIn.OriginalDocId=$e(..%ConfigName,1,6)
				Set tSC1=..SendRequestAsync(tOneTarget,pDocIn)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
			}
			;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,pDocIn.OriginalDocId,..%ConfigName,"I")
			$$$SyncCommitClear(tSyncCommit)
			If $$$ISOK(tSC) { $$$sysTRACE("异步转发HL7消息后 "_pDocIn.%Id()_", 回复码='"_tReplyCode_"'") }
			ElseIf ""'=tReplyCode { Set tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,0) } ; 获取新代码，因为我们有新的错误

			If ..ImmediateByteAck {
				#; $$$ASSERT(..AckMode'="Byte") : 将导致双重确认，但这两个设置不应重合。
				Set tReplyCode1=$S(""'=tReplyCode:tReplyCode, 1:..getReplyCode(tMSH,tSC,tSCVal,-1)) ; force a code
				Do ..reportReply(pDocIn,tReplyCode1,.tSC,-1)
			}
		} Else {
			#; 发送同步；需要答复-对于应用程序确认模式（显式或请求MSH）
			If ""'=tReplyCode||..ImmediateByteAck {
				$$$sysTRACE("强制提前提交确认；等待应用程序答复")
				$$$SyncCommitSet(tSyncCommit)
				Set tSC=pDocIn.%Save() ; 保存消息，因为我们要确认它。
				$$$SyncCommitClear(tSyncCommit)
				If $$$ISERR(tSC) {
					$$$LOGERROR("Failed to save message "_pDocIn_" / "_pDocIn.%Id()_" : "_$$$StatusDisplayString(tSC))
					Set tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,0) ; 获取新代码，因为我们有新的错误
				}
				Set:""=tReplyCode tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,-1) ; 强制执行代码
				Do ..reportReply(pDocIn,tReplyCode,.tSC,1-(2*..ImmediateByteAck))
				Set tReplyCode=""
			}
			If $$$ISOK(tSC) {
				If 1'=$L(..TargetConfigNames, ",") $$$LOGWARNING("为同步转发指定了多个目标配置名称： "_..TargetConfigNames)
				$$$sysTRACE("发送 "_pDocIn_"/"_pDocIn.%Id()_" 从 "_pDocIn.Source_" 到 '"_..TargetConfigNames_"'")
				Set pDocIn.OriginalDocId=$e(..%ConfigName,1,6)
				Set tSC=..SendRequestSync(..TargetConfigNames,pDocIn,.tResponse)
			}
			;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,pDocIn.OriginalDocId,..%ConfigName,"I")
			If '$IsObject(tResponse) { ; 没有回复消息-我们必须构造一个
				Set tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,1) ; 获取要构造的应用程序答复代码
				Set tTxt="用代码构造ACK "_tReplyCode_" 由于 SendRequestSync()  "_pDocIn_"/"_pDocIn.%Id()_" 返回时没有响应对象和状态： "_$$$StatusDisplayString(tSC)
				If $$$ISERR(tSC) { $$$LOGWARNING(tTxt) } Else { $$$sysTRACE(tTxt) }
			} Else {
				If "Msh"=..AckMode&&$IsObject(tMSH)&&
					$Case(tMSH.GetValueAt(16), ; ApplicationAcknowledgmentType
						"SU":"A"'=$E(tResponse.GetValueAt("2:1"),2),
						"ER":"A"=$E(tResponse.GetValueAt("2:1"),2),
						:0) { ; Don't return Ack if MSH-mode MSH values restrict it
							Set tResponse=$$$NULLOREF
				}
				If '$IsObject(tResponse) { $$$sysTRACE("Not returning Application ACK for message "_pDocIn_"; AckMode="_..AckMode_"; tReplyCode='"_tReplyCode_"', MSH:AccAckTyp='"_$S($IsObject(tMSH):tMSH.GetValueAt(15),1:"null")_"'") }
				Else { $$$sysTRACE("Returning reply message "_tResponse.%Id()_" ("_tResponse.Name_") received from message "_pDocIn.%Id()_" forwarded to "_..TargetConfigNames) }
			}
		}
	} Else { ; not forwarding due to error or no target
		If ""=tReplyCode {
			Set tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,1) ; see if we need an App reply code - if so we have to fake it because we didn't call the app
		}
		If (""'=tReplyCode||..ImmediateByteAck)&&$$$ISOK(tSC)&&$$$ISOK(tSCVal) {
			$$$SyncCommitSet(tSyncCommit)
			Set pDocIn.IsMutable=0, tSC=pDocIn.%Save() ; save the message because we're going to ACK it.
			$$$SyncCommitClear(tSyncCommit)
			If $$$ISERR(tSC) {
				$$$LOGERROR("Failed to save message "_pDocIn_" / "_pDocIn.%Id()_" : "_$$$StatusDisplayString(tSC))
				Set tReplyCode=..getReplyCode(tMSH,tSC,tSCVal,-1) ; get a new code since we have a new error
			}
		}
		If ..ImmediateByteAck {
			#; $$$ASSERT(..AckMode'="Byte") : would result in double Ack, but the 2 settings should never coincide
			Set tReplyCode1=$S(""'=tReplyCode:tReplyCode, 1:..getReplyCode(tMSH,tSC,tSCVal,-1)) ; force a code
			Do ..reportReply(pDocIn,tReplyCode1,.tSC,-1)
		}
		If ""=tReplyCode { $$$sysTRACE("Not returning ACK for message "_pDocIn_"/"_pDocIn.%Id()_"; AckMode="_..AckMode_"; tReplyCode='"_tReplyCode_"', MSH:AccAckTyp='"_$S($IsObject(tMSH):tMSH.GetValueAt(15),1:"null")_"'"_$S($$$ISERR(tSC):" status "_$$$StatusDisplayString(tSC),1:"")) }
		Else { $$$sysTRACE("Returning ACK code "_tReplyCode_" but not forwarding message "_pDocIn_"/"_pDocIn.%Id()_$S($$$ISERR(tSC):" status "_$$$StatusDisplayString(tSC),1:"")) }
	}
	If $IsObject(tResponse) {
		Set pDocOut=..reportReply(pDocIn,tResponse,.tSC)
		Set tReplyCode=tResponse.GetValueAt("2:1")
	} ElseIf ""'=tReplyCode {
		Set tSC=$$$ADDSC(tSC,tSCVal)
		Set pDocOut=..reportReply(pDocIn,tReplyCode,.tSC)
	}
	#; Increment SequenceNumber if not a rejection ACK and not a query for the SequenceNumber (ie. 0)
	If $Case($E(tReplyCode,2),"R":(..NackErrorCode'="ContentR"),"E":(..NackErrorCode'="ContentE"),:1)&&$G($$$ExpectedSequenceNumber)&&$IsObject(tMSH)&&tMSH.GetValueAt(13) {
		Set $$$ExpectedSequenceNumber = $$$ExpectedSequenceNumber+1
		$$$catTRACE("protocol","Incremented ESN to "_$$$ExpectedSequenceNumber)
	}
	Quit tSC
}

/// Accept only specified document names; resolve DocType and perform requested validation if any.
Method resolveAndIndex(pDoc As EnsLib.HL7.Message, pMSH As EnsLib.HL7.Segment) As %Status
{
	Set tDocType=..resolveDocType(pDoc)
	Do pDoc.PokeDocType(tDocType)

	#; Do further validation if required
	Set tSC=$$$OK
	If ""=..Validation||'..OnValidate(pDoc,..Validation,.tSC)||("s"=$E(..Validation)&&$$$ISOK(tSC)) {
		#; do default validation - Validate sequence number if we have an ESN and if OnValidate() abdicated or ..Validation starts with "s"
		If ""'=$G($$$ExpectedSequenceNumber)&&$IsObject(pMSH) {
			Set tSeqNum=pMSH.GetValueAt(13)
			If (tSeqNum<-1) {
				Set tSC=$$$EnsError($$$EnsErrGeneral,"Invalid Sequence Number Format:"_tSeqNum)
			} ElseIf tSeqNum=-1 {
				$$$sysTRACE("Incoming Sequence Number requests reset ("_tSeqNum_"); Resetting Expected Sequence Number from "_$$$ExpectedSequenceNumber_" to 0 ")
				Set $$$ExpectedSequenceNumber=0
				Set tSC=$$$ERROR($$$EnsEDIHL7ErrAckSeqNum) ; special code to ACK OK but not forward the message
			} ElseIf 0=tSeqNum {
				$$$sysTRACE("Incoming Sequence Number Query (0): our Expected Sequence Number = "_$$$ExpectedSequenceNumber)
				Set tSC=$$$ERROR($$$EnsEDIHL7ErrAckSeqNum) ; special code to ACK OK but not forward the message
				#; the query will be satisfied when we build the ACK
			} Else {
				$$$catTRACE("protocol","Incoming Sequence Number: "_tSeqNum)
				If 0=$$$ExpectedSequenceNumber&&(""'=tSeqNum) {
					#; We have a reset ESN and they sent one
					$$$LOGINFO("Setting ESN from 0 to received value "_tSeqNum)
					Set $$$ExpectedSequenceNumber=tSeqNum
				} ElseIf tSeqNum'=$$$ExpectedSequenceNumber {
					#; Require that client's and our Sequence Number match
					Set tSC=$$$EnsError($$$EnsErrGeneral,"Incoming Sequence Number "_tSeqNum_" doesn't match ESN "_$$$ExpectedSequenceNumber)
				}			
				#; else - successful match of sequence number - we will increment our Expected Sequence Number if we ACK OK
			}
			$$$catTRACE("protocol","resolveAndIndex OK with Expected Sequence Number "_$$$ExpectedSequenceNumber)
		}
	}
	Quit:$$$ISERR(tSC) tSC

	If ""'=..SearchTableClass {
		TRY {		
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",pDoc)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for message "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		} CATCH errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_pDoc_"/"_pDoc.%Id()_" with DocType='"_pDoc.DocType_"' : "_errobj.AsSystemError()) }
	}
	Quit tSC
}

/// Return the DocType that this service will assign to this document.
Method resolveDocType(pDoc As EnsLib.HL7.Message, pMSH As EnsLib.HL7.Segment = {$$$NULLOREF}) As %String
{
	Set tDocType=pDoc.DocType, tDefCat=""
	If ""=tDocType {
		If $IsObject(pMSH) {
			Set tMSHType=pMSH.GetValueAt(9,":_~\&")  Set:""=tMSHType tMSHType=pDoc.Name
		} Else { Set tMSHType=pDoc.Name }
		#; Match with the DocType specified if any in MessageSchemaCategory for the received Message's type name
		Set tAcceptTypes=..MessageSchemaCategory, tNameFound=tMSHType, tUNameFound=$ZCVT(tNameFound,"U")
		Set nTypes=$S(""=$ZStrip(tAcceptTypes,"<>W"):0, 1:$L(tAcceptTypes,","))
		Set (tVal,tDef)=""
		For i=1:1:nTypes { Set tType=$P(tAcceptTypes,",",i) Continue:""=tType
			Set tVal=$ZStrip($P(tType,"=",2),"<>W")
			Set tName=$ZStrip($P(tType,"=",1),"<>W"), tNameLen=$L(tName), tUName=$ZCVT(tName,"U")
			If ""=tVal {
				Set:""=tDef tDef=tName
			} Else {
				#; Quit on match; accept trailing wildcard also
				If tUNameFound=tUName
				 || ("*"=$E(tName,tNameLen) && ($E(tUName,1,tNameLen-1)=$E(tUNameFound,1,tNameLen-1))) {
					If tVal[":" { Set tDocType=tVal }
					Else { Set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(tVal,tNameFound,,..DocTypeResolution) }
					Quit
				}
				Set tVal=""
			}
		}
		If ""'=tDocType {
			If tVal[":" {
				$$$sysTRACE("Using DocType='"_tDocType_"' for type name '"_tNameFound_"' matching '"_tUName_"' in MessageSchemaCategory list; calling OnResolveDocType()")
			} Else {
				$$$sysTRACE("Using DocType='"_tDocType_"' from schema category '"_tVal_"' for type name '"_tNameFound_"' matching '"_tUName_"' in MessageSchemaCategory list; calling OnResolveDocType()")
				Set tDefCat=tVal
			}
		} ElseIf ""'=tVal {
			$$$sysTRACE("No DocType returned from ResolveSchemaTypeToDocType() using schema category "_tVal_" found for type name '"_tNameFound_"' matching '"_tUName_"' in MessageSchemaCategory list; calling OnResolveDocType()")
		} ElseIf ""'=tDef {
			If tDef[":" {
				Set tDocType=tDef
				$$$sysTRACE("Using default DocType='"_tDocType_"' from MessageSchemaCategory list; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
			} Else {
				Set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(tDef,tNameFound,,..DocTypeResolution)
				If ""'=tDocType {
					$$$sysTRACE("Using DocType='"_tDocType_"' returned from ResolveSchemaTypeToDocType() using default schema category in MessageSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
					Set tDefCat=tDef
				} Else {
					$$$sysTRACE("No DocType returned from ResolveSchemaTypeToDocType() using default schema category '"_tDef_"' in MessageSchemaCategory list '"_tAcceptTypes_"'; type name '"_tNameFound_"' not matched specifically; calling OnResolveDocType()")
				}
			}
		} Else {
			$$$sysTRACE("No match or default DocType found for type name '"_tNameFound_"' in MessageSchemaCategory list '"_tAcceptTypes_"'; calling OnResolveDocType()")
		}
	} Else {
		$$$sysTRACE("Accepted message with DocType='"_tDocType_"'; calling OnResolveDocType()")
	}
	Set ttDocType=tDocType  If ..OnResolveDocType(pDoc,.ttDocType) {
		Set ttDocType=$Get(ttDocType)
		Set tDocType=ttDocType
		$$$sysTRACE("OnResolveDocType returned DocType="_tDocType)
	}
	Do:tDocType=ttDocType&&(""'=tDocType)&&(""'=tDefCat) pDoc.PokeTypeCategory(tDefCat)
	Quit tDocType
}

/// pAppAck=0 means 'Immediate' reply; =-1 means 'Immediate Commit Ack'; =1 means 'Application' reply.
/// Return empty string if no ACK needed for the specified mode, or the code for the appropriate type of reply.
Method getReplyCode(pMSH As EnsLib.HL7.Segment, pSC As %Status, pSCVal As %Status, pAppACK As %Boolean) As %String
{
	If pAppACK>-1&&$IsObject(pMSH) { Set tAckType=pMSH.GetValueAt($S(pAppACK:16,1:15)), tVersionID=pMSH.GetValueAt("12.1") }
	Else { Set (tAckType,tVersionID)="" }
	#; Choose the appropriate Status character
	Set tCode=$S($$$ISERR(pSCVal)&&'$$$StatusEquals(pSCVal,$$$EnsEDIHL7ErrAckSeqNum):$Case(..NackErrorCode,"ContentR":"R","AllR":"R",:"E"), $$$ISERR(pSC):$Case(..NackErrorCode,"ErrorR":"R","AllR":"R",:"E"), 1:"A") ; Reject / Error / Accept
	#; $$$ASSERT('(pAppACK=-1&&'..ImmediateByteAck)) Quit "" ; not needed because we'll never be called with this value
	#; Send no ACK if the MSH requests not to
	Quit:pAppACK>-1&&$Case(..AckMode,"Never":1,"Immed":pAppACK,"App":'pAppACK,"Msh":$Case(tAckType,"AL":0,"ER":(tCode="A"),"SU":(tCode'="A"),:1),:0) ""
	Quit $S(..UseAckCommitCodes&&(+tVersionID>=2.3):"C",1:"A")_tCode ; Commit / Application
}

/// pEarlyAck'=0 means early (commit/immediate) ACK; <0 means Byte ACK.
Method reportReply(pOriginalDoc As EnsLib.EDI.Document, pReplyCode As %String, ByRef pSC As %Status, pEarlyAck As %Integer = 0) As EnsLib.EDI.Document
{
	Set tSC=pSC
	If $IsObject(pReplyCode) {
		Set pSC=$$$OK, tReplyDoc=$S(..AckMode'="Byte":pReplyCode, 1:$S("A"=$E(pReplyCode.GetValueAt("2:1"),2):$C($$$SingleByteAckAcceptAscii),1:$C($$$SingleByteAckErrorAscii)))
		$$$sysTRACE("Reporting reply document "_tReplyDoc_" for document "_pOriginalDoc_$S('$IsObject(pOriginalDoc):"",1:" / "_pOriginalDoc.%Id()))
	} Else {
		Set tReplyDoc=..constructReply(pOriginalDoc,pReplyCode,.pSC,pEarlyAck)  If $$$ISERR(pSC) $$$LOGSTATUS(pSC)  Quit $$$NULLOREF
		$$$sysTRACE("Constructed reply document "_tReplyDoc_" for document "_pOriginalDoc_$S('$IsObject(pOriginalDoc):"",1:" / "_pOriginalDoc.%Id())_"; status: "_$$$StatusDisplayString(tSC))
	}
	Quit:""=tReplyDoc $$$NULLOREF
	If $IsObject(tReplyDoc) && (..SaveReplies '= "None") {
		Set tIsOKACK = $select("ACK"'=$piece(tReplyDoc.GetValueAt("1:9.1"),"_"): 0, 1: $case(..getACKCode(tReplyDoc), "AA":1, "CA":1, :0))
		Set tDoAll = ("All" = $extract(..SaveReplies,*-2,*))
		#; Save the reply if we are saving/indexing all replies, OR this is not an OK ACK
		If tDoAll || ('tIsOKACK){
			#; Index the reply if we are indexing the reply type
			If (""'=..SearchTableClass) && ("Index" = $extract(..SaveReplies,1,5)) {
				Set tSCStore=$classmethod(..SearchTableClass,"IndexDoc",tReplyDoc)
				If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for reply message "_tReplyDoc_" / "_tReplyDoc.%Id()_" with DocType='"_tReplyDoc.DocType_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
			}
			Else {
				Set tSCSave = tReplyDoc.%Save()
				If $$$ISERR(tSCSave) $$$LOGWARNING("Failed to save reply message "_tReplyDoc_" / "_tReplyDoc.%Id()_" with DocType='"_tReplyDoc.DocType_"': "_$$$StatusDisplayString(tSCSave))
			}
		}
	}
	If ""'=pOriginalDoc.ParentId && '..NoBatchReply {
		#; Remember individual reply docs for final batch reply
		Set ..%ReplyDocuments=$G(..%ReplyDocuments)+1, ..%ReplyDocuments(..%ReplyDocuments)=tReplyDoc
	} ElseIf ..NoBatchReply && $IsObject(tReplyDoc) && tReplyDoc.ChildCount {
		Set pSC=tReplyDoc.GetChildIdsArray(.tChildArray,tReplyDoc.%Id(),1)  If $$$ISERR(pSC) $$$LOGSTATUS(pSC)  Quit $$$NULLOREF
		For i=1:1:tChildArray { Set tChildId=tChildArray(i)
			Set tReply=tReplyDoc.%OpenId(tChildId)
			Set pSC=..SendReply(tReply,pOriginalDoc) Quit:$$$ISERR(pSC)
		}
	} ElseIf pEarlyAck {
		Set pSC=..SendEarlyReply(tReplyDoc,pOriginalDoc)
	} Else {
		Set pSC=..SendReply(tReplyDoc,pOriginalDoc)
	}
	If $$$ISERR(pSC) $$$LOGSTATUS(pSC)
	Quit $$$NULLOREF ; default behavior is not to return the reply doc from OnProcessInput()
}

Method constructReply(pOriginalDoc As EnsLib.EDI.Document, pReplyCode As %String, ByRef pSC As %Status, pEarlyAck As %Integer) As EnsLib.EDI.Document
{
	Set tSC=pSC, pSC=..OnConstructReply(.tReplyDoc, pOriginalDoc,.pReplyCode,.tSC,pEarlyAck)  If $$$ISERR(pSC) $$$LOGSTATUS(pSC) Quit $$$NULLOREF
	If '$D(tReplyDoc) {
		If $Case(pOriginalDoc.Name,"FHS":1,"BHS":1,:0) {
			If "" '= pOriginalDoc.ParentId { ; top doc
				Set tReplyDoc=$$$NULLOREF
			} Else {
				If ..%ForwardBatchWhole=1 { ; no need to check for %ForwardBatchWhole>1 because this is runtime
					#; Make ACKs for all children
					If '$Case(..AckMode,"Byte":1 ,:pEarlyAck<0) {
						Set pSC=pOriginalDoc.GetChildIdsArray(.tChildArray,pOriginalDoc.%Id(),1)
						Set i="" For { Set i=$O(tChildArray(i),1,tChildId)  Quit:""=i
							Set tChild=pOriginalDoc.%OpenId(tChildId)
							Set tRepliesArray=i, tRepliesArray(i)=..constructReply(tChild,$S(..UseAckCommitCodes&&(+tChild.GetValueAt("1:12.1")>=2.3):"C",1:"A")_"A",.pSC,pEarlyAck)  If $$$ISERR(pSC) $$$LOGSTATUS(pSC) Quit
						}
					}
				} Else {
					Merge tRepliesArray=..%ReplyDocuments  Kill ..%ReplyDocuments  Set ..%ReplyDocuments=0
				}
				Set:$$$ISOK(pSC) tReplyDoc=..constructBatchReply(pOriginalDoc,.tRepliesArray,.pSC,pEarlyAck)
			}
		} Else {
			Set tIsErr=("A"'=$E(pReplyCode,2))
			If $Case(..AckMode,"Byte":1, :pEarlyAck<0) {
				Set tReplyDoc=$S(tIsErr:$C($$$SingleByteAckErrorAscii),1:$C($$$SingleByteAckAcceptAscii))
			} Else {
				Set tReplyDoc=pOriginalDoc.NewReplyDocument(,..LocalFacilityApplication)
				Set tReplyDoc.Source=pOriginalDoc.%Id()
				Do:..#UseOriginalControlId tReplyDoc.SetValueAt(pOriginalDoc.GetValueAt("1:10"),"1:10") ; copy the control id to the ack control id
				Set tAckMSA=##class(EnsLib.HL7.Segment).%New($LB("",1))
				Set tAckMSA.Separators=tReplyDoc.Separators
				Do tAckMSA.SetValueAt("MSA",0)
				Do tAckMSA.SetValueAt(pReplyCode,1)
				Do tAckMSA.SetValueAt(pOriginalDoc.GetValueAt("1:10"),2)
				Do:$G($$$ExpectedSequenceNumber) tAckMSA.SetValueAt($$$ExpectedSequenceNumber,4)
				#; Deprecated since v2.1 - Do tAckMSA.SetValueAt($S(pForwardMsg:"D",1:"F"),5//"DelayedAcknowledgmentType")
				Do tReplyDoc.AppendSegment(tAckMSA)
				If ..AddNackERR&&tIsErr {
					// Now build an ERR segment in case of error
					Set tAckERR=##class(EnsLib.HL7.Segment).%New($LB("",1))
					Set tAckERR.Separators=tReplyDoc.Separators
					Do tAckERR.SetValueAt("ERR",0)
					#;Do tAckERR.SetValueAt("207"_tAckERR.CS_"Application internal error",3) 
					Do tAckERR.SetValueAt("E",4)  // It's an error
					Do tAckERR.SetValueAt($P($system.Status.GetErrorCodes(tSC),","),5)
					Do tAckERR.SetValueAt(tAckERR.Escape($$$StatusDisplayString(tSC)),8)
					Do tReplyDoc.AppendSegment(tAckERR)
				}
				Set tReplyDoc.IsMutable=0
			}
		}
	}
	Set:$IsObject(tReplyDoc) tReplyDoc.OriginalDocId=pOriginalDoc.%Id()
	$$$sysTRACE("Constructed reply document '"_tReplyDoc_"' for original document "_pOriginalDoc_" / "_pOriginalDoc.%Id()_" reflecting status: "_$$$StatusDisplayString(tSC))
	Quit $G(tReplyDoc,$$$NULLOREF)
}

/// Override this method to construct a customized reply document. Inputs are the original document and
/// the reply code and the status code that the framework produced in processing the original document.
/// If you change the status code but do not construct a reply document, the framework will use the new value to construct a standard reply document. <br/>
/// If you construct a non-HL7 object it must still have a property called 'Envelope'.  Piece:2 of this value will be written verbatim.
Method OnConstructReply(Output pReplyDoc As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document, ByRef pReplyCode As %String, ByRef pSC As %Status, pEarlyAck As %Boolean) As %Status
{
	Quit $$$OK
}

Method constructBatchReply(pOriginalDoc As EnsLib.EDI.Document, ByRef pChildArray, ByRef pSC As %Status, pEarlyAck As %Boolean) As EnsLib.EDI.Document
{
	Set tSC=pSC, pSC=..OnConstructBatchReply(.tReplyDoc,pOriginalDoc,.pChildArray,.tSC,pEarlyAck) If $$$ISERR(pSC) $$$LOGSTATUS(pSC) Quit $$$NULLOREF
	If '$D(tReplyDoc) {
		Quit:0=$G(pChildArray,0) $$$NULLOREF
		If (+pChildArray'=pChildArray) Set pSC=$$$ERROR($$$EnsErrGeneral,"Child Reply Document Array has unexpected top node: '"_pChildArray_"'")  Quit $$$NULLOREF
		If $Case(..AckMode,"Byte":1,:0) {
			Set tNext=1, tIsErr=$$$ISERR(tSC)
		} Else {
			Set tReply1=$G(pChildArray(1))
			Set:'$IsObject(tReply1) tReply1=##class(EnsLib.HL7.Message).%OpenId(tReply1)
			Quit:'$IsObject(tReply1) $$$NULLOREF
			Set tNext=2
			#; construct Batch parent document
			Set tReplyDoc=##class(EnsLib.HL7.Message).%New($LB("",tReply1.Separators,tReply1.Source))
			Set tFS=$E(tReply1.Separators), tCS=$E(tReply1.Separators,3)
			Set tCategory = tReply1.DocTypeCategory
			Set tMsgCat = tReply1.MessageTypeCategory
			Set tBHSType= $S(tCategory="":"",1:tCategory_":BHS")
			Set tBHS=##class(EnsLib.HL7.Segment).%New($LB("",1,tBHSType,tReply1.Separators_"BHS"_tFS))
			Do tReplyDoc.setSegmentByIndex(tBHS,1,0)
			Set tHolder=##class(EnsLib.HL7.Segment).%New($LB("",1,"",tReply1.Separators_"MessageDocsRef"_tFS_2_tFS_$G(pChildArray)))
			Do tReplyDoc.setSegmentByIndex(tHolder,2,0)
			Set tBTSType=$S(tCategory="":"",1:tCategory_":BTS")
			Set tBTS=##class(EnsLib.HL7.Segment).%New($LB("",1,tBTSType,tReply1.Separators_"BTS"_tFS_$G(pChildArray)))
			Do tReplyDoc.setSegmentByIndex(tBTS,3,0)
			If ((""'=tMsgCat)||(""'=tCategory)) {
				Do:""'=tMsgCat tReplyDoc.PokeTypeCategory(tMsgCat)
				Set tReplyBHSType = ##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType($S(""'=tMsgCat:tMsgCat,""'=tCategory:tCategory,1:""),"BHS")
				Do:""'=tReplyBHSType tReplyDoc.PokeDocType(tReplyBHSType)
			}
			Set tReply1.ParentId=tReplyDoc.getId()_":2"
			Do tReply1.%Save()
		}
		For i=tNext:1:pChildArray { Set tReply=pChildArray(i)
			Set:'$IsObject(tReply) tReply=##class(EnsLib.HL7.Message).%OpenId(tReply)  $$$ASSERT($IsObject(tReply))
			If $Case(..AckMode,"Byte":1,:0) {
				Set:'tIsErr tIsErr=("A"'=tReply.GetValueAt("2:1"))
			} Else {
				Set tReply.ParentId=tReplyDoc.getId()_":2"
				Do tReply.%Save()
			}
		}
		If $Case(..AckMode,"Byte":1,:0) {
			Set tReplyDoc=$S('tIsErr:$C($$$SingleByteAckAcceptAscii),1:$C($$$SingleByteAckErrorAscii))
		} Else {
			If pOriginalDoc.Name'="FHS" {
				Do tReplyDoc.%Save()
			} Else {
				#; construct File Batch parent document
				Set tReply=tReplyDoc, tReplyDoc=##class(EnsLib.HL7.Message).%New($LB("",tReply1.Separators,tReply1.Source))
				Set tFHSType=$S(tCategory="":"",1:tCategory_":FHS")
				Set tFHS=##class(EnsLib.HL7.Segment).%New($LB("",1,tFHSType,tReply1.Separators_"FHS"_tFS))
				Do tReplyDoc.setSegmentByIndex(tFHS,1,0)
				Set tHolder=##class(EnsLib.HL7.Segment).%New($LB("",1,"",tReply1.Separators_"BHSDocsRef"_tFS_2_tFS_1))
				Do tReplyDoc.setSegmentByIndex(tHolder,2,0)
				Set tFTSType=$S(tCategory="":"",1:tCategory_":FTS")
				Set tFTS=##class(EnsLib.HL7.Segment).%New($LB("",1,tFTSType,tReply1.Separators_"FTS"_tFS_1))
				Do tReplyDoc.setSegmentByIndex(tFTS,3,0)
				If ((""'=tMsgCat)||(""'=tCategory)) {
					Do:""'=tMsgCat tReplyDoc.PokeTypeCategory(tMsgCat)
					Set tReplyFHSType = ##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType($S(""'=tMsgCat:tMsgCat,""'=tCategory:tCategory,1:""),"FHS")
					Do:""'=tReplyFHSType tReplyDoc.PokeDocType(tReplyFHSType)
				}
				Do tReplyDoc.%Save()
				Set tReply.ParentId=tReplyDoc.%Id()_":2"
				Do tReply.%Save()
			}
		}
	}
	$$$sysTRACE("Constructed batch reply document '"_tReplyDoc_" / "_tReplyDoc.%Id()_"' for original document "_pOriginalDoc_" / "_pOriginalDoc.%Id()_"; status: "_$$$StatusDisplayString(pSC))
	Quit tReplyDoc
}

/// Override this method to construct a customized batch reply document. Inputs are the original document and
/// the child reply array and the status code that the framework produced in processing the original document. <br/>
/// If you construct a non-HL7 object it must still have a property called 'Envelope'.  Piece:2 of this value will be written verbatim.
Method OnConstructBatchReply(Output pReplyDoc As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document, ByRef pChildArray, ByRef pSC As %Status, pEarlyAck As %Boolean) As %Status
{
	Quit $$$OK
}

Method SendReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document) As %Status
{
	Quit $$$EnsError($$$EnsErrGeneral, "Service does not support Reply; Document "_pReplyDocument)
}

Method SendEarlyReply(pReplyDocument As EnsLib.EDI.Document, pOriginalDoc As EnsLib.EDI.Document) As %Status
{
	Quit ..SendReply(.pReplyDocument,.pOriginalDoc)
}

/// Callbacks from Parser:
/// 
/// Called by the Parser at the end of a document
Method OnDocumentEnd(pDocument As EnsLib.EDI.Document, pSource As %String, pStatus As %Status) As %Status
{
	Set tSC=$$$OK
	#;$$$ASSERT(pDocument=..%Parser.%CurrentDocument)
	#; Ignore bad status; let OnProcessInput() do what it can

	// Ignore errors; we use the default Reply Document object
	If ""=pDocument.ParentId { ; top parent
		If ..%ForwardBatchWhole=1 {
			If '..%PreserveSession {
				#; We do not want to clean %SuperSession if set before %SessionId
				If '..%SuperSessionCreatedBeforeSession  Set ..%SuperSession = ""
				Set ..%SessionId=""  Kill $$$JobSessionId
			}
			Set tSC=..standardOnProcessInput(pDocument,.tDocOut)
		} ElseIf '..%ForwardBatchWhole {
			Set tIsHdr=$Case(pDocument.Name, "FHS":1, "BHS":1, :0)
			If 'tIsHdr || ..%ForwardBatchHeaders {
				If tIsHdr {
					If '..%PreserveSession && ('..%SingleBatchSession || ..%isNewBatch) {
						#; We do not want to clean %SuperSession if set before %SessionId
						If '..%SuperSessionCreatedBeforeSession  Set ..%SuperSession = ""
						Set ..%SessionId=""  Kill $$$JobSessionId 
					}
				} Else {
					If '..%PreserveSession {
						#; We do not want to clean %SuperSession if set before %SessionId
						If '..%SuperSessionCreatedBeforeSession  Set ..%SuperSession = ""
						Set ..%SessionId=""  Kill $$$JobSessionId 
					}
				}
				Set tSC=..standardOnProcessInput(pDocument,.tDocOut)
			}
			Else { 
				Do ..reportReply(pDocument,"AA",.tSC) ; top batch doc - reply but don't process
				Set tDocType = ..resolveDocType(pDocument) ; still set docType
				Do pDocument.PokeDocType(tDocType)
				Set tSC = pDocument.%Save()
			}
		} ; Else (If ..%ForwardBatchWhole>1) do nothing; this value means don't let Service process the document; we're in ImportFrom...()
		Set ..%isNewBatch=1
	} ElseIf '..%ForwardBatchWhole && ($Case(pDocument.Name, "FHS":0, "BHS":0, :1) || ..%ForwardBatchHeaders) { ; Not top parent
		If '..%SingleBatchSession || ('..%PreserveSession && ..%isNewBatch) {
			#; We do not want to clean %SuperSession if set before %SessionId
			If '..%SuperSessionCreatedBeforeSession  Set ..%SuperSession = ""
			Set ..%SessionId=""  Kill $$$JobSessionId
		}
		Set tSC=..standardOnProcessInput(pDocument,.tDocOut)
		Set ..%isNewBatch=0
	} ElseIf (""'=pDocument.ParentId && ..%ForwardBatchWhole) || ($Case(pDocument.Name, "FHS":1, "BHS":1, :0) && '..%ForwardBatchHeaders) { ; Still set docType for child documents and unsent headers
		Set tDocType=..resolveDocType(pDocument)
		Do pDocument.PokeDocType(tDocType)
		Set tSC = pDocument.%Save()
	}
	If $$$ISERR(tSC) && $$$StatusEquals(tSC,$$$EnsErrGeneral) Set pStatus=$$$ADDSC(pStatus,tSC) // !!! quit on fatal errors only
	Quit:'..QuitOnError&&$$$ISOK(tSC) $$$OK
	Quit pStatus
}

/// Return the segment terminator string that the Parser and the document.ImportFromIOStream() method will use.
Method GetSegmentTerminator() As %String
{
	Quit $C($$$HL7DefSegTerminatorAscii)
}

ClassMethod GetRequestClassList() As %String [ CodeMode = objectgenerator, GenerateAfter = OnProcessInput ]
{
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"standardOnProcessInput",$$$cMETHformalspecparsed)
	Set tClass=$lg($lg(tSignature,1),2)
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"OnProcessInput",$$$cMETHformalspecparsed)
	Set tClass=tClass_""","""_$lg($lg(tSignature,1),2)
	Do %code.WriteLine(" Quit $lb("""_tClass_""")")
	Quit $$$OK
}

ClassMethod GetResponseClassList(pRequest As %String = "") As %String [ CodeMode = objectgenerator, GenerateAfter = OnProcessInput ]
{
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"standardOnProcessInput",$$$cMETHformalspecparsed)
	Set tRequest1=$lg($lg(tSignature,1),2)
	Set tClass1=$lg($lg(tSignature,2),2)
	Set tSignature=$$$comMemberKeyGet(%class.Name,$$$cCLASSmethod,"OnProcessInput",$$$cMETHformalspecparsed)
	Set tRequest2=$lg($lg(tSignature,1),2)
	Set tClass2=$lg($lg(tSignature,2),2)

	Set tClass12=tClass1_$S(tClass1=tClass2:"",1:""","""_tClass2)
	If tRequest1=tRequest2 {
		Set (tClass1,tClass2)=tClass12
	}
	Do %code.WriteLine(" Quit:pRequest="""" $lb("""_tClass12_""")")
	Do %code.WriteLine(" Quit:pRequest="""_tRequest1_""" $lb("""_tClass1_""")")
	Do %code.WriteLine(" Quit:pRequest="""_tRequest2_""" $lb("""_tClass2_""")")
	Do %code.WriteLine(" Quit $lb("""")")
	Quit $$$OK
}

/// Return an array of connections for drawing lines on the config diagram.
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

/// Add discarded characters to IO Archive.
Method IOLogDiscard(pSC As %Status, pNote As %String, pDiscard As %GlobalCharacterStream)
{
	Set tIOLogEntry = ..IOLogEntry, ..IOLogEntry=$$$NULLOREF ; Save a separate entry for the unexpected input
	$$$NEWINIOLOGENTRY(pSC,pNote,pDiscard)
	$$$CLOSEIOLOGENTRY($$$OK,"",$$$NULLOREF)
	Set ..IOLogEntry = tIOLogEntry
}

/// Helper method to get the ACK code from a response.
Method getACKCode(pReply As EnsLib.HL7.Message = "") As %String [ Private ]
{
	#; Get MSA code if not already cached
	If '$IsObject(pReply) Quit "_"
	Set tReply = pReply
	While $Case(tReply.Name,"FHS":1,"BHS":1,:0) {
		Set tReply=tReply.NextChild()
		If '$IsObject(tReply) Set tReply=pReply Quit
	}
	Set tMSA=tReply.GetSegmentAt(2)
	Set tAckCode=$S($IsObject(tMSA)&&("MSA"=tMSA.GetValueAt(0)):$ZStrip(tMSA.GetValueAt(1),"<>W"), 1:"~NoMSA")
	If ""=tAckCode Set tAckCode="_"
	Quit $ZCVT(tAckCode,"U")
}

}

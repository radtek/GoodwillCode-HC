/// Classname JHIPLIB.HTTP.BS.HTTPService
/// Summary   HTTP入口封装类<br>
/// Version   1.0<br>
/// Date      2019年08月15日 10:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.HTTP.BS.HTTPService Extends JHIPLIB.Util.Base.HL7Service [ ClassType = "", ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

/// 此服务应返回哪种HTTP响应？
/// codeonly:返回HTTP响应代码200表示确定，500表示错误，没有HTTP响应正文文本
/// codewithackbody:返回HTTP响应代码200表示OK，500表示错误，HL7响应消息作为body文本
/// okcodewithackbody:以body文本的形式返回HL7响应消息，如果body存在，则始终返回HTTP响应代码200表示OK
Property HTTPResponseMode As %String(VALUELIST = ",CodeOnly,CodeWithACKBody,OKCodeWithACKBody") [ InitialExpression = "OKCodeWithACKBody" ];

Parameter SETTINGS = "BodyType:Basic,IsSync:Basic";

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

/// 调用地址<br>
/// 设置对外提供的地址，（注意：不用写IP和端口号）
/// Property URL As %String;
/// 如果有消息体，那么请选择消息体的类型<br>
Property BodyType As %String(DISPLAYLIST = ",XML,HL7V2,JSON,String", VALUELIST = ",XML,HL7V2,JSON,String");

Property ReplyStream As %GlobalCharacterStream;

Property ReplyIOStream As %IO.MetaCharacterStream;

/// 结束段标记字符
Property SegTerminator As %String [ InitialExpression = {$C(13,10)} ];

Method OnInit() As %Status
{
	Set tSC=##super()  Quit:$$$ISERR(tSC) tSC
	Set ..ReplyStream=##class(%GlobalCharacterStream).%New()
	;Set ..ReplyStream.Attributes("Content-Type")="text/xml"
	Set ..ReplyIOStream=##class(%IO.MetaCharacterStream).%New(..ReplyStream)
	Set ..ReplyIOStream.Name="HTTP Response"
	Set:""=$ZStrip(..HTTPResponseMode,"<>W") ..HTTPResponseMode="OKCodeWithACKBody"
	IF ..BodyType="HL7V2"{
	Set:..IsSync=1 ..AckMode="App"
	Set:..IsSync=0 ..AckMode="Immed"}
	Quit $$$OK
}

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	Do ..%Parser.Reset()
	Do ..ReplyStream.Clear()
	Set BodyStream=##class(%GlobalCharacterStream).%New()
	Set tSC=BodyStream.CopyFrom(pStreamIn)
	//设置响应消息头Content-Type
	IF ..IsSync=0{
		Set ..ReplyStream.Attributes("Content-Type")="application/json"
	}ELSE{Set ..ReplyStream.Attributes("Content-Type")="text/xml"}
	Set pStreamOut=..ReplyStream
  	Set xml = ##class(EnsLib.EDI.XML.Document).%New()
  	Set Body = BodyStream.Read()
  	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	D Util.Activity(..BusinessPartner,EventName,..%ConfigName,"I")
	//消息体格式判断,如果没有消息体，那么将自动获取消息头中的参数作为消息传输。
	IF $L(Body)=0{
		///进入到了没有消息体
		//参数个数获取
		Set HttpRequest=##class(EnsLib.HTTP.GenericMessage).%New("","",pStreamIn)
  		Set count=HttpRequest.HTTPHeaders.GetAt("IParams")
		Set request="<Request>"
		FOR i=1:1:count{
			Set Params=HttpRequest.HTTPHeaders.GetAt("IParams_"_i)
			Set name=$p(Params,"=",1),value=$p(Params,"=",2)
			Set value=$Replace(value,"""","")
			Set request=request_"<"_name_">"_value_"</"_name_">"
			}
		Set request=request_"</Request>"
		Set xml=xml.ImportFromString(request,.tSC)
		Set tSC=..BaseSend(xml,.tResponse)
		Set:..IsSync=1 tSC= pStreamOut.Write(tResponse)
	}ELSE{
		//消息体为HL7V2
		IF ..BodyType="HL7V2"{
			Set tSC=..%Parser.ParseFramedIOStream(##class(%IO.MetaCharacterStream).%New(pStreamIn),,1)
			Do ..ReplyIOStream.Flush()
			If $$$ISERR(tSC) { $$$LOGSTATUS(tSC) } 
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
		//BODY为V3消息体
		}ELSEIF ..BodyType="XML"{
			Set xml=xml.ImportFromString(Body,.tSC)
			Set xml.OriginalDocId=$E(..%ConfigName,1,6)
			
			IF tSC=0 {$$$LOGERROR("Body不能转为XML，请确认！")}
			If ""'=..SearchTableClass {
				TRY {
					Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",xml)
					If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for message "_xml_"/"_xml.%Id()_" with DocType='"_xml.%ClassName(1)_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
					} CATCH errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_xml_"/"_xml.%Id()_" with DocType='"_xml.%ClassName(1)_"' : "_errobj.AsSystemError()) 
				}
			}	
			Set tResponse="返回值有误！"
			Set tSC=..BaseSend(xml,.tResponse)
			Set:..IsSync=1 tSC= pStreamOut.Write(tResponse)
		//BODY为JSON消息体
		}ELSEIF ..BodyType="JSON"{
			
			
			
			
		//BODY为String消息体	
		}ELSEIF ..BodyType="String"{
			/*Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
			Set Request.action=..Action
			Set tSC=Request.pArg.Insert(Body)*/
			Set request="<Request>"_Body_"</Request>"
			Set xml=xml.ImportFromString(request,.tSC)
			Set xml.OriginalDocId=$E(..%ConfigName,1,6)
			Set tSC=..BaseSend(xml,.tResponse)
			Set:..IsSync=1 tSC= pStreamOut.Write(tResponse)
		}
	}
	IF ..IsSync=0{
		//设定异步返回值格式
		Set tResponse="{""Code"":""200"",""Result"":""平台接收成功""}"
		Set tResponse=$zcvt(tResponse,"O","UTF8")
		Set tSC= pStreamOut.Write(tResponse)
		}ElseIf tResponse.%ClassName()="Message"{
			Set res=##class(EnsLib.HL7.Message).%New()
			Set res.DocType=tResponse.DocType
			Set src=tResponse.OutputToString()
			Set src=$zcvt(src,"O","UTF8")
			Set res=res.ImportFromString(src)
			Set tResponse=res
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

Method BaseSend(pInput As %RegisteredObject, Output tResponse As %String) As %Status
{
	If ""=..TargetConfigNames{$$$LOGWARNING("没有选择接收消息的目标名称，请查看BS前台设置属性")}
	try{
		Set Response=##class(JHIPLIB.Util.ClassAndXML).%New()
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			Set Status=..ProcessMessage(pInput,.Response,$P(..TargetConfigNames,",",iTarget))
		}
		//返回格式如果是EnsLib.EDI.XML.Document这个类进入代码块
		If Response.%ClassName()="Document"{
			Set res=##class(EnsLib.EDI.XML.Document).%New()
			Set res=Response
			Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
			Set tResponse=Util.OutputToString(res)
			Set tResponse=$zcvt(tResponse,"O","UTF8")
			}
		/*可以解析别的格式但是需要转化
		elseif{
				set tResponse="{""Code"":""200"",""Result"":""平台接收成功""}"
				
				}*/
	}catch(ex){		
		$$$LOGERROR(ex.DisplayString())
	}
	Quit Status
}

Method ProcessMessage(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	if ..IsSync=0{
		Set tSC = ..SendRequestAsync(pHint,pInput)
	}else{
		Set tSC = ..SendRequestSync(pHint,pInput,.pOutput)
	}
	Quit tSC
}

}

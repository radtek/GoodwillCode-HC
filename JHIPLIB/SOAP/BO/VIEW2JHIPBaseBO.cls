/// Classname JHIP.SOAP.BO.VIEW2JHIPBaseBO
/// Summary   分发消息到正式环境JHIP的BO
/// Version   1.0
/// Date      2019年8月21日 10:00
/// Copyright 北京嘉和美康信息技术有限公司
/// Accepts HL7 Messages and forwards them to a remote IP address, reading a response HL7 Message object returned from the remote IP address if the GetReply setting is enabled.
Class JHIPLIB.SOAP.BO.VIEW2JHIPBaseBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Parameter SETTINGS = "-Framing,DocTypeResolution";

/* Override inherited InitialExpression */
Property Framing As %String [ InitialExpression = "AsciiLF" ];

Property LibStreamOut As %Stream.GlobalCharacter [ Internal ];

Property IOStreamOut As %IO.MetaCharacterStream [ Internal ];

Property IOStreamReply As %IO.MetaCharacterStream [ Internal ];

/// How to resolve a DocType based on the message type from MSH:9.  The options are: <br/><ul>
/// <li>Standard: Combine the effective MessageSchemaCategory value with a message structure name looked up for the MSH:9 message type value in the corresponding schema category. This is the default. </li>
/// <li>Ignore 9.3: Like 'Standard' but if MSH:9 has 3 or more pieces, ignore the additional ones. The standard behavior is to use piece 3 as part of the type name if it has no sub-pieces because some schemas contain 3-part type names. </li>
/// <li>Use 9.3: Like 'Standard' but if MSH:9 has 3 or more pieces, use the additional piece as the literal name of the document structure within the applicable schema category. Use with caution because messages may arrive with MSH:9.3 values for which no structure is present in the chosen schema category. </li>
/// <li>Literal: Combine the effective MessageSchemaCategory value with the literal MSH:9 message type value interpreted as the name of a message structure. Use only with custom schemas where every message type has a corresponding structure definition. </li></ul>
Property DocTypeResolution As %String(DISPLAYLIST = ",Standard,Ignore 9.3,Use 9.3,Literal", VALUELIST = ",Std,Ign,Use,Lit") [ InitialExpression = "Std", Required ];

Method OnInit() As %Status
{
	Set tSC=##super()
	Set ..LibStreamOut=##class(%Stream.GlobalCharacter).%New()
	Set ..IOStreamOut=##class(%IO.MetaCharacterStream).%New(..LibStreamOut)
	Set ..IOStreamReply=##class(%IO.MetaCharacterStream).%New()
	Set ..IOStreamOut.Name="SOAPRequestStream"
	Quit tSC
}

/// V3消息处理通用方法
Method V3MsgHandle(pInput As EnsLib.EDI.XML.Document, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	
	Set EventName=pInput.OriginalDocId
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set inputStr = Util.OutputToString(pInput)
	Set ..Adapter.WebServiceURL=$p(..Adapter.WebServiceURL,"?",1)_"?CfgItem="_EventName
	Set tSC = ..Adapter.InvokeMethod("HIPMessageServer",.tResult,inputStr)
	If $$$ISERR(tSC){
		$$$LOGERROR("平台的"_EventName_"事件发送给JHIP正式环境的"_EventName_"事件，发送失败。调用失败，可能是由于:1,正式环境接口不通！ 2,前台代理类配置有误!; ")
		Set err="平台的"_EventName_"事件发送给JHIP正式环境的"_EventName_"事件，发送失败。调用失败，可能是由于:1,正式环境接口不通！ 2,前台代理类配置有误!; "
		Set status=..V3MsgHandleF(pInput,err,.pResponse)
	}
	Try{
		Set pResponse=##class(EnsLib.EDI.XML.Document).ImportFromString(tResult,.status)
		}catch(ex){
			$$$LOGERROR(ex.DisplayString())
			Set err="JHIP的"_EventMethod_"事件，返回给平台的应答消息转化xml格式异常，请确认！"
			Set status=..V3MsgHandleF(pInput,err,.pResponse)
		}		
	
	Quit tSC
}

/// 处理V2消息的通用方法
Method HL7V2Message(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status
{
	//MSH|^~\&|UEHIS|UEHIS|MediII|MediII|20150123210520||ACK^A28^ACK|83bc94f0eb82428ea8e7482f7def130e|P|2.4
	//MSA|AA|JHIP201501021124|成功

	
	zw pMsgOut
	//将HL7消息转换成流放入 IOStreamOut
	Set tSC=pMsgOut.OutputToIOStream(..IOStreamOut)  Quit:$$$ISERR(tSC) tSC
	//获取消息的类型如 ADT_A28等
	//获取事件的类型如 JH001患者信息登记 等
	Set EventName=pMsgOut.OriginalDocId
	Set flag=$$$NO
	//获取参数名称
	Set ..Adapter.WebServiceURL=$p(..Adapter.WebServiceURL,"?",1)_"?CfgItem="_EventName
	Set tSC = ..Adapter.InvokeMethod("Send",.tResult, ..LibStreamOut.Read())
			If $$$ISERR(tSC){
				//获取当前时间转换成 20190114 的格式
				Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M")
			   Set tResult="MSH|^~\&|UEHISEnsembleHL7|JHIPVIEW||JHIP|"_NTime_"||"_pMsgOut.GetValueAt("EVN:1")_"|JHIP"_NTime_"|P|2.4"_$C(13,10)_"MSA|AE|JHIP"_NTime_$C(13,10)_"ERR||||E|调用失败可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; "_$C(13,10)
			    Set m=1
			    }
	
	;************************************************************************************************************************************
	If tResult'="" {
		Set tReply=##class(%Stream.GlobalCharacter).%New()
		do tReply.Write(tResult)
		zw tReply
		Quit:$$$ISERR(tSC) tSC
		If $IsObject(tReply) {
			zw tReply
			#; Parse the HL7 ACK object out of the reply stream
			Do tReply.Rewind()
			Do ..IOStreamReply.BindInput(tReply, .tSC)  Quit:$$$ISERR(tSC) tSC
			Set tSC = ..IOStreamReply.BindOutput(tReply)  Quit:$$$ISERR(tSC) tSC
			Set ..IOStreamReply.Name=..%ConfigName_"_ReplyStream"
			zw pMsgOut
			Set pMsgIn=pMsgOut.ImportFromLibraryStream(..IOStreamReply,.tSC,"class||EnsLib.HL7.Service.SOAPService")  Quit:$$$ISERR(tSC) tSC
			try{
				Set pMsgIn.DocType=..resolveDocType(pMsgIn)
				zw tSC
				zw pMsgIn
				Do ..IOStreamReply.Reset(,,.tSC)
			}catch{
				Set tSC=$$$OK
				
			}
			
			
		}
		Quit tSC
		
	}else{
		Quit $$$ERROR()
	}
}

Method V3MsgHandleF(pRequest As EnsLib.EDI.XML.Document, error As %String, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	
	Set guid=##class(%SYSTEM.Util).CreateGUID()
	Set CreateTime=$TRanslate($ZDT($H,3),"-,:, ")
	Set pResponse=##class(EnsLib.EDI.XML.Document).%New()
  	&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='统一答复模版')
  	Set pResponse=pResponse.ImportFromString(FileBody,.status)
  	Set status=pResponse.SetValueAt(guid,"/MCCI_IN000002UV01/id/@extension")
  	Set status=pResponse.SetValueAt(CreateTime,"/MCCI_IN000002UV01/creationTime/@value")
  	Set status=pResponse.SetValueAt("-","/MCCI_IN000002UV01/acknowledgement/targetMessage/id/@extension")
  	Set status=pResponse.SetValueAt(error,"/MCCI_IN000002UV01/acknowledgement/acknowledgementDetail/text")
   	Set status=pResponse.SetValueAt("JHIP","/MCCI_IN000002UV01/receiver/@typeCode")
   	Quit status
}

/// 获取v2返回消息DocType
Method resolveDocType(pDoc As EnsLib.HL7.Message, pMSH As EnsLib.HL7.Segment = {$$$NULLOREF}) As %String
{
	Set tDocType=pDoc.DocType, tDefCat=""
	If ""=tDocType {
		If $IsObject(pMSH) {
			Set tMSHType=pMSH.GetValueAt(9,":_~\&")  Set:""=tMSHType tMSHType=pDoc.Name
		} Else { Set tMSHType=pDoc.Name }
		#; Match with the DocType specified if any in MessageSchemaCategory for the received Message's type name
		Set tAcceptTypes="JH2.4", tNameFound=tMSHType, tUNameFound=$ZCVT(tNameFound,"U")
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

Method OnResolveDocType(pDoc As EnsLib.EDI.Document, ByRef pDocType As %String) As %Boolean
{
	Quit 0
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.HL7.Message"> 
		<Method>HL7V2Message</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.EDI.XML.Document"> 
		<Method>V3MsgHandle</Method>
	</MapItem>
</MapItems>
}

}

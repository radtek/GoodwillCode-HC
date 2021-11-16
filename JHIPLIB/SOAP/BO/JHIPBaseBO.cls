/// Classname JHIPLIB.SOAP.BO.JHIPBaseBO<br>
/// Summary   通用分发消息的BO,可分发V3/V2/字典类型消息
///          V3  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
///          V2  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
/// 字典类型消息  入参 JHIPLIB.Util.MSG.JHRequestMsg 出参 Ens.StringResponse
/// Version   1.0<br>
/// Date      2019年10月12日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.SOAP.BO.JHIPBaseBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "-Framing,EventMethod:Basic,DocTypeResolution";

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

/// 在调用Webservice时，会遇到一个服务里存在多个方法，通过在此处的配置，可以通过一个服务区分事件调用多个方法。一个方法可能有多个参数(最多5个)<br>
/// 配置格式：事件名称:方法名,参数一,参数二,参数三..;事件名称:方法名,参数一,参数二,参数三,参数四;(符号为英文符号)。<br>
/// 注意：平台流转消息入参请配置占位符REQUEST，放在参数位置即可。入参如果为第二个例子如：JH0001:Methodname,参数一,REQUEST,参数三;<br>
/// 注意：前台配置时，符号为全英文且不要出现空格，否则会影响后台的代码<br>
/// 注意：参数配置注意方法中顺序进行配置<br>
Property EventMethod As %String(MAXLEN = 10000);

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
	
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	Set EventName=pInput.OriginalDocId
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	$$$TRACE("..%ConfigName"_..%ConfigName)
	;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
	Set inputStr = Util.OutputToString(pInput)
	Set flag=$$$NO,tSC=$$$NO,num=0
	For i=1:1:($LISTLENGTH(EventMethodList)){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			Set ParameterList=$LISTFROMSTRING($P(EventMethod,":",2),",")
			Set ParameterLen=$LISTLENGTH(ParameterList)
			//取代动态参数占位符
			FOR j=1:1:ParameterLen{Set:$LISTGET(ParameterList,j)="REQUEST" $LIST(ParameterList,j)=inputStr,num=1}
			IF num=0 {$$$LOGERROR(..%ConfigName_"的"_EventName_"方法名未配置动态参数,请确认！")}
			Set MethodName=$P($P(EventMethod,":",2),",",1)
			If $l(MethodName)=0{
				$$$LOGERROR(EventName_"事件对应前台配置的EventMethod模块方法名为空！调用失败！")
				;Set status=..V3MsgHandleF(pInput,err,.pResponse)
				Quit 
			}
			If ParameterLen=2{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"))
			}elseIf ParameterLen=3{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"))
			}elseIf ParameterLen=4{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult, $ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"))
			}elseIf ParameterLen=5{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult, $ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,5)),"<>W"))	
			}elseIf ParameterLen=6{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult, $ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,5)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,6)),"<>W"))	
			}
			If $$$ISERR(tSC){
					$$$LOGERROR("平台的"_EventName_"事件发送给"_..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，调用失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及运用SOAPUI测试三方接口！")
					;Set status=..V3MsgHandleF(pInput,"平台的"_EventName_"事件发送给"_..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，调用失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及运用SOAPUI测试三方接口！",.pResponse)
			}
			Try{
				Set tResult = $replace(tResult,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
				Set pResponse=##class(EnsLib.EDI.XML.Document).ImportFromString(tResult,.status)
				}catch(ex){
					$$$LOGERROR(ex.DisplayString())
					Set err=..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，返回给平台的应答消息转化xml格式异常，请确认！"
					;Set status=..V3MsgHandleF(pInput,err,.pResponse)
				}		
				Set flag=$$$OK
		}
}
	If flag=$$$NO{
			Set err="平台的"_EventName_"事件发送给"_..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，调用失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及运用SOAPUI测试三方接口！"
			$$$LOGERROR(err)
			;Set status=..V3MsgHandleF(pInput,err,.pResponse)
		}
	Quit tSC
}

/// 处理V2消息的通用方法
Method HL7V2Message(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status
{
	
	//将HL7消息转换成流放入 IOStreamOut
	Set tSC=pMsgOut.OutputToIOStream(..IOStreamOut)  Quit:$$$ISERR(tSC) tSC
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	//获取消息的类型如 ADT_A28等
	//获取事件的类型如 JH001患者信息登记 等
	Set EventName=pMsgOut.OriginalDocId
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
	Set flag=$$$NO,num=0
	For i=1:1:$LISTLENGTH(EventMethodList){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			Set ParameterList=$LISTFROMSTRING($P(EventMethod,":",2),",")
			Set ParameterLen=$LISTLENGTH(ParameterList)
			Set MethodName=$P($P(EventMethod,":",2),",",1)
			//取代动态参数占位符
			FOR j=1:1:ParameterLen{Set:$LISTGET(ParameterList,j)="REQUEST" $LIST(ParameterList,j)=..LibStreamOut.Read(),num=1}
			IF num=0 {$$$LOGERROR(..%ConfigName_"的"_EventName_"方法名未配置动态参数,请确认！")}
			Set flag=$$$OK
			If ParameterLen=2{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult ,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"))
			}elseIf ParameterLen=3{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"))
			}elseIf ParameterLen=4{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"), $ZSTRIP(($LISTGET(ParameterList,4)),"<>W"))
			}elseIf ParameterLen=5{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult, $ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,5)),"<>W"))
			}elseIf ParameterLen=6{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,5)),"<>W"), $ZSTRIP(($LISTGET(ParameterList,6)),"<>W"))
			}
			If $$$ISERR(tSC){
				//获取当前时间转换成 20190114 的格式
				Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M")
			   Set tResult="MSH|^~\&|UEHISEnsembleHL7|JHIP||"_..%ConfigName_"|"_NTime_"||"_pMsgOut.GetValueAt("EVN:1")_"|JHIP"_NTime_"|P|2.4"_$C(13,10)_"MSA|AE|JHIP"_NTime_$C(13,10)_"ERR||||E|调用失败可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙"_$C(13,10)
			    Set m=1
			    }
			Set flag=$$$OK
			Quit
			}
		}   
		If flag=$$$NO{
		Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M")
		Set tResult="MSH|^~\&|UEHISEnsembleHL7|JHIP||"_..%ConfigName_"|"_NTime_"||"_pMsgOut.GetValueAt("EVN:1")_"|JHIP"_NTime_"|P|2.4"_$C(13,10)_"MSA|AE|JHIP"_NTime_$C(13,10)_"ERR||||E|调用失败，可能是由于配置的事件错误导致"_$C(13,10)
		Set m=1
	}
	;************************************************************************************************************************************
	If tResult'="" {
		s tReply=##class(%Stream.GlobalCharacter).%New()
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

/// 其他消息的通用方法
/// 调用Web系统接口时最多可向Web接口中传入5个参数
Method MessageList(pInput As JHIPLIB.Util.MSG.MessageList, Output pOutput As Ens.StringResponse) As %Status
{
	$$$TRACE("进入到方法中")
	Set tSC=$$$OK
	Set pOutput=##Class(Ens.StringResponse).%New()
	//获取事件的类型
	Set EventName =pInput.Action
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
	//将前台配置数据存入集合
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	//设置开关
	Set flag=$$$NO,num=0
	For i=1:1:$LISTLENGTH(EventMethodList){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			
			Set ParameterLen=pInput.MessageBody.Size
			Set MethodName=$P($P(EventMethod,":",2),",",1)
			//取代动态参数占位符
			Set flag=$$$OK
			If ParameterLen=1{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult ,pInput.MessageBody.GetAt(1))
			}elseIf ParameterLen=2{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,pInput.MessageBody.GetAt(1),pInput.MessageBody.GetAt(2))
			}elseIf ParameterLen=3{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,pInput.MessageBody.GetAt(1),pInput.MessageBody.GetAt(2),pInput.MessageBody.GetAt(3))
			}elseIf ParameterLen=4{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,pInput.MessageBody.GetAt(1),pInput.MessageBody.GetAt(2),pInput.MessageBody.GetAt(3),pInput.MessageBody.GetAt(4))
			}elseIf ParameterLen=5{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,pInput.MessageBody.GetAt(1),pInput.MessageBody.GetAt(2),pInput.MessageBody.GetAt(3),pInput.MessageBody.GetAt(4),pInput.MessageBody.GetAt(5))
			}
			$$$TRACE("tSC"_tSC)
			If $$$ISERR(tSC){
				//获取当前时间转换成 20190114 的格式
				Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
			    Set tResult=NTime_"调用"_..%ConfigName_"系统失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙！"
			 }
			Quit
		}
	}   
	If flag=$$$NO{
		Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
		Set tResult=NTime_"调用"_..%ConfigName_"系统失败，可能是由于配置的事件错误导致！！"
		
	}
	Set pOutput.StringValue=tResult
	Quit tSC
}

/// 其他消息的通用方法
/// 调用Web系统接口时最多可向Web接口中传入5个参数
Method OthersMessage(pInput As JHIPLIB.Util.MSG.JHRequestMsg, Output pOutput As Ens.StringResponse) As %Status
{
	$$$TRACE("进入到方法中")
	Set tSC=$$$OK
	Set pOutput=##Class(Ens.StringResponse).%New()
	//获取事件的类型
	Set EventName =pInput.action
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
	//将前台配置数据存入集合
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	//设置开关
	Set flag=$$$NO,num=0
	For i=1:1:$LISTLENGTH(EventMethodList){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			Set ParameterList=$LISTFROMSTRING($P(EventMethod,":",2),",")
			Set ParameterLen=$LISTLENGTH(ParameterList)
			Set MethodName=$P($P(EventMethod,":",2),",",1)
			//取代动态参数占位符
			FOR j=1:1:ParameterLen{Set:$LISTGET(ParameterList,j)="REQUEST" $LIST(ParameterList,j)=pInput.pArg.GetAt(1),num=1}
			IF num=0 {$$$LOGERROR(..%ConfigName_"的"_EventName_"方法名未配置动态参数,请确认！")}
			Set flag=$$$OK
			If ParameterLen=2{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult ,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"))
			}elseIf ParameterLen=3{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"))
			}elseIf ParameterLen=4{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"), $ZSTRIP(($LISTGET(ParameterList,4)),"<>W"))
			}elseIf ParameterLen=5{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult, $ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,5)),"<>W"))
			}elseIf ParameterLen=6{
				Set tSC = ..Adapter.InvokeMethod(MethodName,.tResult,$ZSTRIP(($LISTGET(ParameterList,2)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,3)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,4)),"<>W"),$ZSTRIP(($LISTGET(ParameterList,5)),"<>W"), $ZSTRIP(($LISTGET(ParameterList,6)),"<>W"))
			}
			$$$TRACE("tSC"_tSC)
			If $$$ISERR(tSC){
				
				//获取当前时间转换成 20190114 的格式
				Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
			    Set tResult=NTime_"调用"_..%ConfigName_"系统失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台代理类配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙！"
			 }
			Quit
		}
	}   
	If flag=$$$NO{
		Set NTime=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
		Set tResult=NTime_"调用"_..%ConfigName_"系统失败，可能是由于配置的事件错误导致！！"
		
	}
	Set pOutput.StringValue=tResult
	Quit tSC
}

// V3异常响应消息

Method V3MsgHandleF(pRequest As EnsLib.EDI.XML.Document, error As %String, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	
	Set MsgId=pRequest.GetValueAt("/"_pRequest.Name_"/id/@extension")
	Set guid=##class(%SYSTEM.Util).CreateGUID()
	Set CreateTime=$TRanslate($ZDT($H,3),"-,:, ")
	Set pResponse=##class(EnsLib.EDI.XML.Document).%New()
  	&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='统一答复模版')
  	Set pResponse=pResponse.ImportFromString(FileBody,.status)
  	Set status=pResponse.SetValueAt(guid,"/MCCI_IN000002UV01/id/@extension")
  	Set status=pResponse.SetValueAt(CreateTime,"/MCCI_IN000002UV01/creationTime/@value")
  	Set status=pResponse.SetValueAt(MsgId,"/MCCI_IN000002UV01/acknowledgement/targetMessage/id/@extension")
  	Set status=pResponse.SetValueAt(error,"/MCCI_IN000002UV01/acknowledgement/acknowledgementDetail/text")
   	Set status=pResponse.SetValueAt(..%ConfigName,"/MCCI_IN000002UV01/receiver/@typeCode")
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
	<MapItem MessageType="EnsLib.EDI.XML.Document"> 
		<Method>V3MsgHandle</Method>
	</MapItem>
	<MapItem MessageType="EnsLib.HL7.Message"> 
		<Method>HL7V2Message</Method>
	</MapItem>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>OthersMessage</Method>
	</MapItem>
	<MapItem MessageType="JHIPLIB.Util.MSG.MessageList"> 
		<Method>MessageList</Method>
	</MapItem>
</MapItems>
}

}

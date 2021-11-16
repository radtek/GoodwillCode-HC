/// Classname JHIPLIB.TCP.BO.JHIPBaseBO<br>
/// Summary   通用分发消息的BO,可分发V3/V2/字典类型消息
///          V3  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
///          V2  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
/// 字典类型消息  入参 JHIPLIB.Util.MSG.JHRequestMsg 出参 Ens.StringResponse
/// Version   1.0<br>
/// Date      2019年10月12日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.TCP.BO.JHIPBaseBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JHIPLIB.TCP.Adapter.OutAdapter";

Property Adapter As JHIPLIB.TCP.Adapter.OutAdapter;

Parameter SETTINGS = "EventMethod:Basic";

/// 在调用TCP时，一个事件可能对应一个ip和一个端口号，通过在此处的配置，可以通过一个事件区分事件调用哪个IP和端口号。<br>
/// 配置格式：事件名称:IP地址,端口号;事件名称:IP地址,端口号;...(符号为英文符号)。<br>
/// 注意：前台配置时，符号为全英文且不要出现空格，否则会影响后台的代码<br>
/// 注意：配置时注意顺序<br>
Property EventMethod As %String(MAXLEN = 10000);

Property DocTypeResolution As %String(DISPLAYLIST = ",Standard,Ignore 9.3,Use 9.3,Literal", VALUELIST = ",Std,Ign,Use,Lit") [ InitialExpression = "Std", Required ];

/// V3消息处理通用方法
Method V3MsgHandle(pInput As EnsLib.EDI.XML.Document, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	Set EventName=pInput.OriginalDocId
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set inputStr = Util.OutputToString(pInput)
	Set flag=$$$NO,tSC=$$$NO
	For i=1:1:($LISTLENGTH(EventMethodList)){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			Set ParameterList=$LISTFROMSTRING($P(EventMethod,":",2),",")
			Set ParameterLen=$LISTLENGTH(ParameterList)
			Set IPAddress=$P($P(EventMethod,":",2),",",1)
			Set Port=$P($P(EventMethod,":",2),",",2)
			Set tSC=..Send(IPAddress,Port,inputStr,.tResult)
			If $$$ISERR(tSC){$$$LOGERROR("平台的"_EventName_"事件发送给"_..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，调用失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及测试三方接口！")}
			Try{
				Set tResult = $replace(tResult,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
				Set pResponse=##class(EnsLib.EDI.XML.Document).ImportFromString(tResult,.status)
				}catch(ex){
					$$$LOGERROR(ex.DisplayString())
					Set err=..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，返回给平台的应答消息转化xml格式异常，请确认！"
				}		
				Set flag=$$$OK
		}
	}
	Quit tSC
}

/// V2消息处理通用方法
Method V2MsgHandle(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message) As %Status
{
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	Set EventName=pMsgOut.OriginalDocId
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set spl="|^~\&"_$char(13,10)
	Set inputStr = pMsgOut.OutputToString(spl)
	Set flag=$$$NO,tSC=$$$OK
	For i=1:1:($LISTLENGTH(EventMethodList)){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			Set ParameterList=$LISTFROMSTRING($P(EventMethod,":",2),",")
			Set ParameterLen=$LISTLENGTH(ParameterList)
			Set IPAddress=$P($P(EventMethod,":",2),",",1)
			Set Port=$P($P(EventMethod,":",2),",",2)
			Set tSC=..Send(IPAddress,Port,inputStr,.tResult)
			If $$$ISERR(tSC){$$$LOGERROR("平台的"_EventName_"事件发送给"_..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，调用失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及测试三方接口！")}
			Try{
				Set pMsgIn=##class(EnsLib.HL7.Message).ImportFromString(tResult,.status)
				Set pMsgIn.DocType=..resolveDocType(pMsgIn)
				}catch(ex){
					$$$LOGERROR(ex.DisplayString())
					Set err=..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，返回给平台的应答消息转化xml格式异常，请确认！"
				}		
				Set flag=$$$OK
		}
		
	}
	Quit tSC
}

/// 其他消息处理通用方法
Method OthersMessage(pInput As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set EventMethodList=$LISTFROMSTRING(..EventMethod,";")
	Set EventName=pInput.action
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set inputStr = pInput.pArg.GetAt(1)
	Set flag=$$$NO,tSC=$$$NO
	For i=1:1:($LISTLENGTH(EventMethodList)){
		Set EventMethod=$ZSTRIP(($LISTGET(EventMethodList,i)),"<>W")
		If EventName=$p(EventMethod,":",1){
			Set ParameterList=$LISTFROMSTRING($P(EventMethod,":",2),",")
			Set ParameterLen=$LISTLENGTH(ParameterList)
			Set IPAddress=$P($P(EventMethod,":",2),",",1)
			Set Port=$P($P(EventMethod,":",2),",",2)
			Set tSC=..Send(IPAddress,Port,inputStr,.tResult)
			If $$$ISERR(tSC){$$$LOGERROR("平台的"_EventName_"事件发送给"_..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，调用失败，可能是由于:1,事件名称与方法不对应导致!; 2,前台配置有误!; 3,三方接口调不通;  解决方法：请前往查看前台配置，及测试三方接口！")}
			Try{
				Set pResponse=##class(Ens.StringResponse).%New(tResult)
				}catch(ex){
					$$$LOGERROR(ex.DisplayString())
					Set err=..%ConfigName_"的"_$p(EventMethod,":",1)_"事件，返回给平台的应答消息转化xml格式异常，请确认！"
				}		
				Set flag=$$$OK
		}
	}
	Quit tSC
}

// 发送方法

Method Send(IPAddress As %String, Port As %String, pRequestString As %String, Output pResponseString As %String) As %Status
{
	Set ..Adapter.IPAddress=IPAddress,..Adapter.Port=Port
	Set tSC= ..Adapter.SendMessageString(pRequestString,.pResponseString)
	$$$TRACE("返回值为:"_pResponseString)
	Quit tSC
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
		<Method>V2MsgHandle</Method>
	</MapItem>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>OthersMessage</Method>
	</MapItem>
</MapItems>
}

}

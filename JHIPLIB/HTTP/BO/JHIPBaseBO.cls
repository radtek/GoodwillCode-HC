/// Classname JHIPLIB.HTTP.BO.JHIPBaseBO<br>
/// Summary   通用分发消息的BO,可分发V3/V2/字典类型消息
///          V3  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
///          V2  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
/// 字典类型消息  入参 JHIPLIB.Util.MSG.JHRequestMsg 出参 Ens.StringResponse
/// Version   1.0<br>
/// Date      2019年10月12日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.HTTP.BO.JHIPBaseBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

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

/// 数据发送方式<br>
Property SendType As %String(DISPLAYLIST = ",POST,GET,OPTIONS,PUT,DELETE,TRACE,PATCH", VALUELIST = ",POST,GET,OPTIONS,PUT,DELETE,TRACE,PATCH") [ InitialExpression = "GET", Required ];

/// 数据发送类型<br>
Property MediaType As %String(DISPLAYLIST = ",text/plain,text/xml,application/xml,application/json,text/html,multipart/form-data,multipart/mixed", VALUELIST = ",text/plain,text/xml,application/xml,application/json,multipart/form-data,text/html,multipart/mixed") [ InitialExpression = "text/xml", Required ];

/// 当一个IP和端口中有多个地址时，使用该属性。
/// 在调用HTTP地址时，会遇到一个IP和端口中有不同的地址，通过在此处的配置，可以通过一个服务区分事件调用多个地址。其中一个地址可能有多个参数<br>
/// 配置格式：事件名称:业务地址?参数名称=值&参数名称=值;事件名称:业务地址?参数名称=值&参数名称=值;<br>
/// 注意：参数如果为HL7V2/V3的消息中的数据元，那么请在值的位置（等于号后面）填写数据元对应的路径;如:V3(id=/PRPA_IN201314UV02/id/@root),V2(id=PIDgrp.PID>2.1)<br>
///       并且如果调用的地址，如果有参数名，则写参数名，若是没有则不用写?后的数据;<br>
/// 注意: 当发送消息时，平台传入的消息放在BODY中，发送。
/// 注意：前台配置时，符号为全英文且不要出现空格，否则会影响后台的代码<br>
/// 注意：参数配置注意地址中顺序进行配置<br>
Property UrlAction As %String(MAXLEN = 2000);

Parameter SETTINGS = "UrlAction:Basic,SendType:Basic,MediaType:Basic";

Method OnInit() As %Status
{
	Set ..LibStreamOut=##class(%Stream.GlobalCharacter).%New()
	Set ..IOStreamOut=##class(%IO.MetaCharacterStream).%New(..LibStreamOut)
	Set ..IOStreamReply=##class(%IO.MetaCharacterStream).%New()
	Quit $$$OK
}

Method V3MsgHandle(pRequest As EnsLib.EDI.XML.Document, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	Try{
		Set Status=$$$OK,tUrl="",dUtl="",tag="err"
		Set Util = ##class(JHIPLIB.Util.ClassAndXML).%New()
		Set pResponse = ##class(EnsLib.EDI.XML.Document).%New()
		Set inputStr=Util.OutputToString(pRequest)
		Set EventName=pRequest.OriginalDocId
		;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
		Set EventDatas=$LISTFROMSTRING(..UrlAction,";")
		Set counts=$LISTLENGTH(EventDatas)
		Set:counts=0 counts=1
		Set tResponse = ##class(%Net.HttpResponse).%New()
		For i=1:1:counts{
			Set EventData=$ZSTRIP(($LISTGET(EventDatas,i)),"<>W")
			If EventName=$p(EventData,":",1){
				//获取业务地址
				Set dUtl=$P($P(EventData,":",2),"?",1),tag="ok"
				//参数键值对
				Set ParamNames=$P($P(EventData,":",2),"?",2)
				Set ParamNameList = $LISTFROMSTRING(ParamNames,"&")
				//参数个数
				Set ParameterLen=$LISTLENGTH(ParamNameList)
				//真实地址
				Set tUrl = dUtl
				//设置消息的格式
		    	Set tHttpRequestIn = ##class(%Net.HttpRequest).%New()
				Set tHttpRequestIn.ContentType=..MediaType
				Set tHttpRequestIn.ContentCharset="UTF-8"
				Set tHttpRequestIn.ContentEncoding="UTF-8"
				FOR i=1:1:ParameterLen{
					Set Paramet=$P($ZSTRIP(($LISTGET(ParamNameList,i)),"<>W"),"=",1)
					Set Value=$P($ZSTRIP(($LISTGET(ParamNameList,i)),"<>W"),"=",2)
					//v3/v2的路径取值（如果没进IF默认不赋值）
					Set:Value'=$p(Value,"/") Value=pRequest.GetValueAt(Value) 
						D tHttpRequestIn.InsertParam(Paramet,Value)
				}
				Quit	
			}
					
		}
			if tag="err"{$$$LOGERROR("调用失败，由于:事件名称与业务地址不对应导致!; ") Quit }
			Set Status = ..Adapter.SendFormDataURL(tUrl,.tResponse,..SendType,tHttpRequestIn,,,inputStr)
			If 'Status{
				$$$LOGERROR("调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙！")
				Set err="平台的"_EventName_"事件发送给"_..%ConfigName_"的"_tUrl_"地址，发送失败。调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;解决方法：请前往查看前台配置，及查看三方接口是否无恙！"
				$$$LOGERROR(err)
				Quit 
			}
			/*Set HttpResponse=##class(EnsLib.HTTP.GenericMessage).%New("","",tResponse)
			Set count=HttpResponse.HTTPHeaders.Count()
			Set Status=HttpResponse.XMLExportToString(.str)
			Set pResponse = ##class(EnsLib.EDI.XML.Document).%New()
			Set pResponse=pResponse.ImportFromString(str)
			Set Response="<Response>"
			FOR i=1:1:count{
				Set Name=pResponse.GetValueAt("/HTTPMessage/HTTPHeaders/HTTPHeadersItem["_i_"]/@HTTPHeadersKey")
				Set Value=pResponse.GetValueAt("/HTTPMessage/HTTPHeaders/HTTPHeadersItem["_i_"]")
				Set Response=Response_"<"_Name_">"_Value_"</"_Name_">"
			}
			Set Response=Response_"<Body><![CDATA["_Result_"]]></Body></Response>"
			
			*/
			Set Result = tResponse.Data.Read()
			Set Result = $replace(Result,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
			;Set Result=$zcvt(Result,"I","UTF8")
			Set pResponse=pResponse.ImportFromString(Result,.stc)
		If $$$ISERR(stc){
				Set err="三方系统返回值不能转换为XML,请核对！返回值为："_Result
				;Set err=$zcvt(err,"I","UTF8")
				$$$LOGERROR(err)
				Quit 
			}
	}catch (ex){
		$$$LOGERROR(ex.DisplayString())
		$$$LOGERROR(err)
	}
	Quit $$$OK
}

/// 处理V2消息的通用方法
Method HL7V2Message(pMsgOut As EnsLib.HL7.Message, Output pMsgIn As EnsLib.HL7.Message, pExpectedSequenceNumber As %String) As %Status
{
	
 Try{	
 		Set Status=$$$OK,tUrl="",dUtl="",tag="err"
		//将HL7消息转换成流放入 IOStreamOut
		Set tSC=pMsgOut.OutputToIOStream(..IOStreamOut) 
		//获取消息的类型如 ADT_A28等
		//获取事件的类型如 JH001患者信息登记 等
		Set EventName=pMsgOut.OriginalDocId
		Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
		;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
		Set EventDatas=$LISTFROMSTRING(..UrlAction,";")
		Set counts=$LISTLENGTH(EventDatas)
		Set:counts=0 counts=1
		Set tResponse = ##class(%Net.HttpResponse).%New()
		For i=1:1:counts{
			Set EventData=$ZSTRIP(($LISTGET(EventDatas,i)),"<>W")
			If EventName=$p(EventData,":",1){
				//获取业务地址
				Set dUtl=$P($P(EventData,":",2),"?",1),tag="ok"
				//参数键值对
				Set ParamNames=$P($P(EventData,":",2),"?",2)
				Set ParamNameList = $LISTFROMSTRING(ParamNames,"&")
				//参数个数
				Set ParameterLen=$LISTLENGTH(ParamNameList)
				//真实地址
				Set tUrl = dUtl
				//设置消息的格式
		    	Set tHttpRequestIn = ##class(%Net.HttpRequest).%New()
				Set tHttpRequestIn.ContentType=..MediaType
				Set tHttpRequestIn.ContentCharset="UTF-8"
				Set tHttpRequestIn.ContentEncoding="UTF-8"
				FOR i=1:1:ParameterLen{
					Set Paramet=$P($ZSTRIP(($LISTGET(ParamNameList,i)),"<>W"),"=",1)
					Set Value=$P($ZSTRIP(($LISTGET(ParamNameList,i)),"<>W"),"=",2)
					//v3/v2的路径取值（如果没进IF默认不赋值）
					Set:Value'=$p(Value,">") Value=$replace(Value,">",":"),Value=pMsgOut.GetValueAt(Value) 
						D tHttpRequestIn.InsertParam(Paramet,Value)
				}
				Quit	
			}
				 
		}
			if tag="err"{$$$LOGERROR("调用失败，由于:事件名称与业务地址不对应导致!; ") Quit }
			Set Status = ..Adapter.SendFormDataURL(tUrl,.tResponse,..SendType,tHttpRequestIn,,,..LibStreamOut.Read())
			If 'Status{
				$$$LOGERROR("调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙！")
				Set err="平台的"_EventName_"事件发送给"_..%ConfigName_"的"_tUrl_"地址，发送失败。调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;解决方法：请前往查看前台配置，及查看三方接口是否无恙！"
				$$$LOGERROR(err)
				Quit 
			}
			Set tResult = tResponse.Data.Read()
			Set tResult=$zcvt(tResult,"I","UTF8")
			If tResult'="" {
				s tSC=$$$NO
				s tReply=##class(%Stream.GlobalCharacter).%New()
				do tReply.Write(tResult)
				If $IsObject(tReply) {
					#; Parse the HL7 ACK object out of the reply stream
					Do tReply.Rewind()
					Do ..IOStreamReply.BindInput(tReply, .tSC)  
					Set tSC = ..IOStreamReply.BindOutput(tReply)  
					Set ..IOStreamReply.Name=..%ConfigName_"_ReplyStream"
					zw pMsgOut
					Set pMsgIn=pMsgOut.ImportFromLibraryStream(..IOStreamReply,.tSC,"class||EnsLib.HL7.Service.SOAPService")  
					try{
						Set pMsgIn.DocType=..resolveDocType(pMsgIn)
						Do ..IOStreamReply.Reset(,,.tSC)
					}catch{
						Set tSC=$$$OK
						
					}
						
				}
		}
	}catch (ex){
		$$$LOGERROR(ex.DisplayString())
		$$$LOGERROR(err)
	}
	
 Quit tSC
}

/// 其他消息的通用方法
/// 调用Web系统接口时最多可向Web接口中传入5个参数
Method OthersMessage(pInput As JHIPLIB.Util.MSG.JHRequestMsg, Output pOutput As Ens.StringResponse) As %Status
{
	Set tSC=$$$OK
	Set pOutput=##Class(Ens.StringResponse).%New()
	//获取事件的类型
	
	Try{
		Set Status=$$$OK,tUrl="",dUtl="",tag="err"
		Set Util = ##class(JHIPLIB.Util.ClassAndXML).%New()
		Set pResponse = ##class(EnsLib.EDI.XML.Document).%New()
		Set EventName =pInput.action
		;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,EventName,..%ConfigName,"O")
		Set EventDatas=$LISTFROMSTRING(..UrlAction,";")
		Set counts=$LISTLENGTH(EventDatas)
		Set:counts=0 counts=1
		Set tResponse = ##class(%Net.HttpResponse).%New()
		For i=1:1:counts{
			Set EventData=$ZSTRIP(($LISTGET(EventDatas,i)),"<>W")
			If EventName=$p(EventData,":",1){
				//获取业务地址
				Set dUtl=$P($P(EventData,":",2),"?",1),tag="ok"
				//参数键值对
				Set ParamNames=$P($P(EventData,":",2),"?",2)
				Set ParamNameList = $LISTFROMSTRING(ParamNames,"&")
				//参数个数
				Set ParameterLen=$LISTLENGTH(ParamNameList)
				//真实地址
				Set tUrl = dUtl
				//设置消息的格式
		    	Set tHttpRequestIn = ##class(%Net.HttpRequest).%New()
				Set tHttpRequestIn.ContentType=..MediaType
				Set tHttpRequestIn.ContentCharset="UTF-8"
				Set tHttpRequestIn.ContentEncoding="UTF-8"
				FOR i=1:1:ParameterLen{
					Set Paramet=$P($ZSTRIP(($LISTGET(ParamNameList,i)),"<>W"),"=",1)
					Set Value=$P($ZSTRIP(($LISTGET(ParamNameList,i)),"<>W"),"=",2)
					//路径取值未定义（如果没进IF默认不赋值）
					;Set:Value'=$p(Value,"/") Value=pRequest.GetValueAt(Value) 
						D tHttpRequestIn.InsertParam(Paramet,Value)
				}
				Quit	
			}
					
		}
			if tag="err"{$$$LOGERROR("调用失败，由于:事件名称与业务地址不对应导致!; ") Quit }
			Set Status = ..Adapter.SendFormDataURL(tUrl,.tResponse,..SendType,tHttpRequestIn,,,pInput.pArg.GetAt(1))
			If 'Status{
				$$$LOGERROR("调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙！")
				Set err="平台的"_EventName_"事件发送给"_..%ConfigName_"的"_tUrl_"地址，发送失败。调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;解决方法：请前往查看前台配置，及查看三方接口是否无恙！"
				$$$LOGERROR(err)
				Quit 
			}
			Set tResult = tResponse.Data.Read()
			Set tResult=$zcvt(tResult,"I","UTF8")
			Set pOutput.StringValue=tResult
	}catch (ex){
		$$$LOGERROR(ex.DisplayString())
		$$$LOGERROR(err)
	}
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
		<Method>HL7V2Message</Method>
	</MapItem>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>OthersMessage</Method>
	</MapItem>
</MapItems>
}

}

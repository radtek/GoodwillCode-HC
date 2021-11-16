Class JHIPLIB.HTTP.BO.HTTPOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// 数据发送方式<br>
Property SendType As %String(DISPLAYLIST = ",POST,GET,OPTIONS,PUT,DELETE,TRACE,PATCH", VALUELIST = ",POST,GET,OPTIONS,PUT,DELETE,TRACE,PATCH") [ InitialExpression = "GET", Required ];

/// 数据发送类型<br>
Property MediaType As %String(DISPLAYLIST = ",text/plain,text/xml,application/xml,application/json,text/html,multipart/form-data,multipart/mixed", VALUELIST = ",text/plain,text/xml,application/xml,application/json,multipart/form-data,text/html,multipart/mixed") [ InitialExpression = "text/xml", Required ];

/// 当一个IP和端口中有多个地址时，使用该属性。
/// 在调用HTTP地址时，会遇到一个IP和端口中有不同的地址，通过在此处的配置，可以通过一个服务区分事件调用多个地址。其中一个地址可能有多个参数<br>
/// 配置格式：业务名称<业务地址?参数名称=值&参数名称=值;业务名称<业务地址?参数名称=值&参数名称=值;<br>
/// 注意：参数如果为HL7V2/V3的消息中的数据元，那么请在值的位置（等于号后面）填写数据元对应的路径;如:(id=/PRPA_IN201314UV02/id/@root)<br>
///       并且如果调用的地址，如果有参数名，则写参数名，若是没有则不用写?后的数据;<br>
/// 注意: 当发送消息时，地址接受平台传入的消息时，则只写参数名，不用写参数值
/// 注意：此处参数配置不包括平台流转消息入参,平台流转消息入参默认为最后一位<br>
/// 注意：前台配置时，符号为全英文且不要出现空格，否则会影响后台的代码<br>
/// 注意：参数配置注意方法中顺序进行配置<br>
Property UrlAction As %String(MAXLEN = 2000);

Parameter SETTINGS = "UrlAction:Basic,SendType:Basic,MediaType:Basic";

Method V3MsgHandle(pRequest As EnsLib.EDI.XML.Document, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	Try{
		Set Status=$$$OK,tUrl=""
		Set Util = ##class(JHIPLIB.Util.ClassAndXML).%New()
		Set inputStr=Util.OutputToString(pRequest)
		Set EventName=pRequest.OriginalDocId
		D Util.Activity(..BusinessPartner,EventName,..%ConfigName,"O")
		Set EventDatas=$LISTFROMSTRING(..UrlAction,";")
		Set counts=$LISTLENGTH(EventDatas)
		Set:counts=0 counts=1
		Set tResponse = ##class(%Net.HttpResponse).%New()
		For i=1:1:counts{
			Set EventData=$ZSTRIP(($LISTGET(EventDatas,i)),"<>W")
			If EventName=$p(EventData,"<",1){
				//获取业务地址
				Set dUtl=$P($P(EventData,"<",2),"?",1)
				//参数键值对
				Set ParamNames=$P($P(EventData,"<",2),"?",2)
				Set ParamNameList = $LISTFROMSTRING(ParamNames,"&")
				//参数个数
				FOR j=1:1:ParameterLen{Set:$LISTGET(ParameterList,j)="REQUEST" $LIST(ParameterList,j)=inputStr,num=1}
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
				}elseif i=counts{
					$$$LOGERROR("调用失败，由于:事件名称与业务地址不对应导致!; ")
					Set err="平台的"_EventName_"事件发送给"_..%ConfigName_"的"_tUrl_"地址，发送失败。调用失败，由于:事件名称与业务地址不对应导致!"
					$$$LOGERROR(err)
					Quit 
				}
					
			}
			Set Status = ..Adapter.SendFormDataURL(tUrl,.tResponse,..SendType,tHttpRequestIn,,,inputStr)
			If $$$ISERR(Status){
				$$$LOGERROR("调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;  解决方法：请前往查看前台配置，及查看三方接口是否无恙！")
				Set err="平台的"_EventName_"事件发送给"_..%ConfigName_"的"_tUrl_"地址，发送失败。调用失败，可能是由于: 1,前台地址配置有误!; 2,三方接口调不通;解决方法：请前往查看前台配置，及查看三方接口是否无恙！"
				;Set err=$zcvt(err,"I","UTF8")
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
			Set Result=$zcvt(Result,"I","UTF8")
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
	Quit Status
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.EDI.XML.Document"> 
		<Method>V3MsgHandle</Method>
	</MapItem>
</MapItems>
}

}

/// Classname JHIPV5.JHREG.BO.MesRretr.EditResendMessageBO
/// Summary   消息检索——消息编辑重发
/// Explain	  根据 域 和 消息ID，内容 进行重发
/// Version   1.0<br>
/// Date      2021年12月13日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.EditResendMessageBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JHIPV5.JHREG.SOAP.OutboundAdapter";

Property Adapter As JHIPV5.JHREG.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "JHIPWeb服务URL:Basic,JHIPWeb服务客户端类:Basic,HIIWeb服务URL:Basic,HIIWeb服务客户端类:Basic,HIPPWeb服务URL:Basic,HIPPWeb服务客户端类:Basic";

/// Web 服务 URL 用于代理到 JHIP 命名空间 
Property JHIPWeb服务URL As %String(MAXLEN = 200);

/// Web服务客户端类 用于代理到 JHIP 命名空间
Property JHIPWeb服务客户端类 As %String;

/// Web 服务 URL 用于代理到 HII 命名空间
Property HIIWeb服务URL As %String(MAXLEN = 200);

/// Web服务客户端类 用于代理到 HII 命名空间
Property HIIWeb服务客户端类 As %String;

/// Web 服务 URL 用于代理到 HIPP 命名空间
Property HIPPWeb服务URL As %String(MAXLEN = 200);

/// Web服务客户端类 用于代理到 HIPP 命名空间
Property HIPPWeb服务客户端类 As %String;

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		$$$LOGINFO("request"_request)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set NameSpace=json.%Get("NameSpace")
		/** 获取命名空间 **/
		Set DomainName =##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpace)
		/** 依据不同的命名空间来选择代理类 **/
		IF DomainName="JHIP"{
			Set ..Adapter.WebServiceURL=..JHIPWeb服务URL
			Set ..Adapter.WebServiceClientClass=..JHIPWeb服务客户端类
		}ElseIF DomainName="HII"{
			Set ..Adapter.WebServiceURL=..HIIWeb服务URL
			Set ..Adapter.WebServiceClientClass=..HIIWeb服务客户端类
		}ElseIF DomainName="HIPP"{
			Set ..Adapter.WebServiceURL=..HIPPWeb服务URL
			Set ..Adapter.WebServiceClientClass=..HIPPWeb服务客户端类
		}
		Set action="EditResendMessage"
		Set tSC=..Adapter.InvokeMethod("Send",.pOUT,action,request)
		IF tSC=1{
			Set:pOUT=1 str=Result.TResult("")
			Set:pOUT'=1 str=Result.FResult("")
		}ELSE{
			$$$LOGINFO("pOUT:"_pOUT)
			Set str=Result.FResult()
		}
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

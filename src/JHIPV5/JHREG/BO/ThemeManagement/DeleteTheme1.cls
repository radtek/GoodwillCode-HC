/// Summary   主题删除<br>
/// Version   1.0<br>
/// Date      2021年12月07日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.DeleteTheme1 Extends Ens.BusinessOperation
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

Method RemoveItem2(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set jsonObject = ##class(%DynamicObject).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
	Set tSC = $$$OK
	Try{		
			Set ..Adapter.WebServiceURL=..JHIPWeb服务URL
			Set ..Adapter.WebServiceClientClass=..JHIPWeb服务客户端类
			$$$LOGINFO("进入")
			Set action = "RemoveItem2"
			Set tSC=..Adapter.InvokeMethod("Send",.pOUT,action,request)
			$$$LOGINFO("输出")
			$$$LOGINFO(pOUT)
			Set pResponse.StringValue=pOUT
		;Set pResponse.StringValue = res
	}Catch(ex){
		Set tSC=ex.AsStatus()
		Set res = ResultJson.FResult()
	}
	;Set pResponse.StringValue = res
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>RemoveItem2</Method>
	</MapItem>
</MapItems>
}

}

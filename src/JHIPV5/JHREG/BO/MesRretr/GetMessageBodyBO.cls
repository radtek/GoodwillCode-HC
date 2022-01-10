/// Classname JHIPV5.JHREG.BO.MesRretr.GetMessageBodyBO
/// Summary   消息检索获取消息正文
/// Explain	  根据 Session 获取消息正文
/// Version   1.0<br>
/// Date      2021年11月25日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.GetMessageBodyBO Extends Ens.BusinessOperation
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
	Set jsonObject = ##class(%DynamicObject).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set NameSpace = json.%Get("NameSpace")			/** 域ID       **/
		Set MessageType = json.%Get("MessageType")		/** 消息类型 1 请求 2 响应 **/
		Set ThemeName=json.%Get("ThemeName")			/** 主题名称     **/
		Set:MessageType=1 fileName=ThemeName_"-请求"	/** 拼接xslt名称 **/
		Set:MessageType=2 fileName=ThemeName_"-响应"	/** 拼接xslt名称 **/

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
		/** 获取消息内容 **/
		Set action = "MessageDetails"
		Set tSC=..Adapter.InvokeMethod("Send",.pOUT,action,request)
		Set pOutput =""
#;		Set Path="/goodwill/jhip/hc/XSLT/"_fileName_".xslt"
#;		$$$LOGINFO("Path:"_Path)
#;		/** 进行XSLT转换 视图 xml转html **/
#;		Set pXSL =##class(%XML.XSLT.CompiledStyleSheet).%New()
#;		Set tSC = ##class(%XML.XSLT.CompiledStyleSheet).CreateFromFile(Path,.pXSL)
#;		$$$LOGINFO("取值："_tSC)
#;		$$$LOGERROR("pXSL:"_pXSL)
		IF tSC'=0{
			Set pOUT=$replace(pOUT,"xmlns='urn:hl7-org:v3'","")
			$$$LOGINFO("out:"_pOUT)
			Set tsc=..Xslt2String(pOUT,fileName,.pOutput)
#;			Set tSC=##class(%XML.XSLT.Transformer).TransformStringWithCompiledXSL(pOUT,pXSL,.pOutput,.tError,)
#;			$$$LOGINFO("TSC:"_tSC)
#;			Set pOutput = $replace(pOutput,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
#;			Set pOutput = $zcvt(pOutput,"I","UTF8")
			$$$LOGINFO("pOutput:"_pOutput)
			Set pOutput = $replace(pOutput,$C(10),"")
			Set pOutput = $replace(pOutput,$C(13),"")
		}
		Set jsonObject.content=pOUT
		Set jsonObject.html=pOutput
		Set str=Result.STResult(jsonObject)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// xslt 转换
Method Xslt2String(SourceXML As %String, xslType As %String, Output pOutput As %String) As %Status
{
	set tSC = $$$OK
	try{
		Set FileBody=""
		&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:xslType)
		Set msgStream = ##class(%Stream.GlobalCharacter).%New()
		Set status= msgStream.Write(FileBody)
		Set tSC = ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(msgStream,.pXSL)
    	Set tSC=##class(%XML.XSLT.Transformer).TransformStringWithCompiledXSL(SourceXML,pXSL,.pOutput,.tError,) $$$ThrowOnError(tSC)
		Set pOutput = $replace(pOutput,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
		Set pOutput = $zcvt(pOutput,"I","UTF8")
	}
	catch errobj{
		Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","Xslt2String",errobj.DisplayString())
		Set tTSC=$$$ERROR(5001,errobj.DisplayString())
	}		
	Quit tSC
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

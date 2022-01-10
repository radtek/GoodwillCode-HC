/// Summary   主题注册<br>
/// Version   1.0<br>
/// Date      2021年12月06日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.AddTheme1 Extends Ens.BusinessOperation
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

Method addTheme1(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
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
#;		Set:MessageType=1 fileName=ThemeName_"-请求"	/** 拼接xslt名称 **/
#;		Set:MessageType=2 fileName=ThemeName_"-响应"	/** 拼接xslt名称 **/

		/** 获取命名空间 **/
		Set DomainName =##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpace)
		/** 依据不同的命名空间来选择代理类 **/
		IF DomainName="JHIP"{
			Set ..Adapter.WebServiceURL=..JHIPWeb服务URL
			Set ..Adapter.WebServiceClientClass=..JHIPWeb服务客户端类
			$$$LOGINFO("进入")
			Set action = "addTheme1"
			Set tSC=..Adapter.InvokeMethod("Send",.pOUT,action,request)
			$$$LOGINFO("输出")
			$$$LOGINFO(pOUT)
			Set pResponse.StringValue=pOUT
		}ElseIF DomainName="JHIPV5-3"{
		Set Adapter = json.%Get("Adapter")
		$$$LOGINFO(Adapter)
		If Adapter = "SOAP"{
			Set clsName = "JHIPLIB.SOAP.BS.Service"
			}
		If Adapter = "SOAP.HL7V2"{
			Set clsName = "JHIPLIB.SOAP.BS.HL7V2Service"
			}
		If Adapter = "SOAP.HL7V3"{
			Set clsName = "JHIPLIB.SOAP.BS.HL7V3Service"
			}
		If Adapter = "HTTP"{
			Set clsName = "JHIPLIB.HTTP.BS.Service"
			}
		If Adapter = "HTTP.HL7V3"{
			Set clsName = "JHIPLIB.HTTP.BS.HL7V3Service"
			}
		If Adapter = "HTTP.HL7V2"{
			Set clsName = "JHIPLIB.HTTP.BS.HL7V2Service"
			}
		If Adapter = "SQL"{
			Set clsName = "JHIPLIB.SQL.BS.SQLService"
			}
		If Adapter = "MQ"{
			Set clsName = "JHIPLIB.MQ.BS.Service"
			}
		If Adapter = "TCP"{
			Set clsName = "JHIPLIB.TCP.BS.Service"
			}
		$$$LOGINFO(clsName)
		Set NameSpace = json.%Get("NameSpace")
		Set ThemeCode = json.%Get("ThemeCode")
		Set ThemeName = json.%Get("ThemeName")
		Set Name = ThemeCode_ThemeName
		Set Category = json.%Get("Category")
		Set standard = json.%Get("standard")
		Set PoolSize = json.%Get("PoolSize")
		Set Enabled = json.%Get("Enabled")
		Set Comment = json.%Get("Comment")
		Set LogTraceEvents = json.%Get("LogTraceEvents")
		Set production = "JHIPV5d3PKG.FoundationProduction"
		Set prodConf = ##class(Ens.Config.Production).%OpenId(production)
		Set settings =json.%Get("settings")
		$$$LOGINFO(prodConf)
		$$$LOGINFO(prodConf.Name)
#;		ZN NameSpace
#;		WRITE !,"Current namespace is ",$NAMESPACE
    	Set item = ##class(Ens.Config.Item).%New()
    	Set item.PoolSize = PoolSize
    	Set item.Category=Category
    	Set item.ClassName = clsName
    	Set item.Name = Name
    	Set item.LogTraceEvents = LogTraceEvents
    	$$$LOGINFO(Name)
	    Set item.Enabled = Enabled
	    set iter = settings.%GetIterator() 
	   while iter.%GetNext(.key , .value ) {
		   ;#Dim settingItem As Ens.Config.Setting = ##Class(Ens.Config.Setting).%New()
		   set iter1 = value.%GetIterator()
		   while iter1.%GetNext(.key1 , .value1 ) 
		   {
			   #Dim settingItem As Ens.Config.Setting = ##Class(Ens.Config.Setting).%New()
			   If (key1 = "IsSync")||(key1 = "BusinessPartner")||(key1 = "SearchTableClass"){
					Set settingItem.Target = "Host"
				   }
			   Set settingItem.Name = key1
			   Set settingItem.Value = value1
			   D item.Settings.Insert(settingItem)
			   ;$$$LOGINFO("key = "_key1_" , value = "_value1)
		   }  
	   }
	   Set settingItem = ##Class(Ens.Config.Setting).%New()
	   Set settingItem.Name = "TargetConfigNames"
	   Set settingItem.Value = Name_"BP"
	   Set settingItem.Target = "Host"
	    D item.Settings.Insert(settingItem)
#;	    Set sql="SELECT ID FROM Ens_Config.Item where Name = '"_Name_"'"
#;		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
#;		Set ID = tResult.Get("ID")
		Set IsSync = settings.%Get(0).%Get("IsSync")
		Set BusinessPartner = settings.%Get(0).%Get("BusinessPartner")
		Set SearchTableClass = settings.%Get(0).%Get("SearchTableClass")
		Set Port = settings.%Get(0).%Get("Port")
		Set Charset = settings.%Get(0).%Get("Charset")
		Set CallInterval = settings.%Get(0).%Get("CallInterval")
		Set SpaceID = ""
		;Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Theme.ThemeDB (SpaceID,ThemeCode,ThemeName,NameSpace,standard,IsSync,Enabled,Category,BusinessPartner,Adapter,PoolSize,Comment,LogTraceEvents,SearchTableClass,Port,Charset,CallInterval) VALUES('"_SpaceID_"','"_ThemeCode_"','"_ThemeName_"','"_NameSpace_"','"_standard_"','"_IsSync_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"','"_Adapter_"','"_PoolSize_"','"_Comment_"','"_LogTraceEvents_"','"_SearchTableClass_"','"_Port_"','"_Charset_"','"_CallInterval_"')"
		If Adapter = "MQ"{
			Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Theme.ThemeDB (SpaceID,ThemeCode,ThemeName,NameSpace,standard,Enabled,Category,Adapter,PoolSize,Comment,LogTraceEvents) VALUES('"_SpaceID_"','"_ThemeCode_"','"_ThemeName_"','"_NameSpace_"','"_standard_"','"_Enabled_"','"_Category_"','"_Adapter_"','"_PoolSize_"','"_Comment_"','"_LogTraceEvents_"')"
			}ELSE{
			Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Theme.ThemeDB (SpaceID,ThemeCode,ThemeName,NameSpace,standard,IsSync,Enabled,Category,BusinessPartner,Adapter,PoolSize,Comment,LogTraceEvents,SearchTableClass) VALUES('"_SpaceID_"','"_ThemeCode_"','"_ThemeName_"','"_NameSpace_"','"_standard_"','"_IsSync_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"','"_Adapter_"','"_PoolSize_"','"_Comment_"','"_LogTraceEvents_"','"_SearchTableClass_"')"
			}
		If Adapter = "SQL"{
			Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Theme.ThemeDB (SpaceID,ThemeCode,ThemeName,NameSpace,standard,Enabled,Category,BusinessPartner,Adapter,PoolSize,Comment,LogTraceEvents,SearchTableClass) VALUES('"_SpaceID_"','"_ThemeCode_"','"_ThemeName_"','"_NameSpace_"','"_standard_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"','"_Adapter_"','"_PoolSize_"','"_Comment_"','"_LogTraceEvents_"','"_SearchTableClass_"')"
			}
		Set tSC=..Adapter.ExecuteUpdate(.Result,InsertSql)
		$$$LOGINFO(tSC)
		$$$LOGINFO(InsertSql)
		Do ##class(Ens.Util.Auditing).AuditModifyProductionConfig(prodConf.Name,item.Name,"Item added to production using generator in " _ $classname())
		$$$LOGINFO("qqq")
    	Do ##class(EnsPortal.Template.prodConfigSCPage).CallProductionUpdateAndSaveToClass(prodConf,item,"InsertItem") 
    	$$$LOGINFO("........")
		;Do ##class(Ens.Director).UpdateProduction()

		Set res = ResultJson.TResult("Item注册完成！！！")
		Set pResponse.StringValue = res
		Set tSC = ##class(Ens.Director).UpdateProduction()
 		$$$LOGINFO(tSC)
		}
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	;Set pResponse.StringValue=pOUT
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>addTheme1</Method>
	</MapItem>
</MapItems>
}

}

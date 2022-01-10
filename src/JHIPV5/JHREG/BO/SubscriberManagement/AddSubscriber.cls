/// Summary   订户注册<br>
/// Version   1.0<br>
/// Date      2021年12月06日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.AddSubscriber Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method addSubscriber(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set jsonObject = ##class(%DynamicObject).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
		Try{
		Set Adapter = json.%Get("Adapter")
		If Adapter = "SOAP"{
			Set clsName = "JHIPLIB.SOAP.BO.JHIPBaseBO"
			}
		If Adapter = "HTTP"{
			Set clsName = "JHIPLIB.HTTP.BO.JHIPBaseBO"
			}
		If Adapter = "SQL"{
			Set clsName = "JHIPLIB.SQL.BO.SQLOperation"
			}
		If Adapter = "MQ"{
			Set clsName = "JHIPLIB.MQ.BO.JHIPBaseBO"
			}
		If Adapter = "TCP"{
			Set clsName = "JHIPLIB.TCP.BO.JHIPBaseBO"
			}
		$$$LOGINFO(clsName)
		Set NameSpace = json.%Get("NameSpace")
		Set subscriberCode = json.%Get("subscriberCode")
		Set subscriberName = json.%Get("subscriberName")
		Set Name = subscriberCode_subscriberName
		Set SQL="SELECT subscriberCode,subscriberName FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where NameSpace ='"_NameSpace_"' ORDER BY ID"
		$$$LOGINFO(SQL)
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.SQL)
		#Dim tRe As %SQL.StatementResult = qStatement.execute()
		Set total=0
		Set ams = "no"
		while (tRe.%Next()){
			Set subCode = tRe.%Get("subscriberCode")
			Set subName = tRe.%Get("subscriberName")
			Set nam = subCode_subName
			If nam = Name{
				Set ams = "ok"
				Set res = ResultJson.Result("400","","失败","改名称已存在")
				}
			}
		$$$LOGINFO(ams)
		If ams ="ok"{
			Set res = ResultJson.Result("400","","失败","改名称已存在")
			$$$LOGINFO(res)
			;Quit 
			}else{
		Set Category = json.%Get("Category")
		Set standard = json.%Get("standard")
		Set PoolSize = json.%Get("PoolSize")
		Set Enabled = json.%Get("Enabled")
		Set Comment = json.%Get("Comment")
		Set Adapter = json.%Get("Adapter")
		Set LogTraceEvents = json.%Get("LogTraceEvents")
		Set production = "JHIPV5d3PKG.FoundationProduction"
		Set prodConf = ##class(Ens.Config.Production).%OpenId(production)
		Set settings =json.%Get("settings")
		Set Organization =json.%Get("Organization")
		Set WebServiceURL =json.%Get("WebServiceURL")
		$$$LOGINFO(prodConf)
		$$$LOGINFO(prodConf.Name)
		$$$LOGINFO(Name)
    	Set item = ##class(Ens.Config.Item).%New()
    	Set item.PoolSize = PoolSize
    	Set item.Category=Category
    	Set item.ClassName = clsName
    	Set item.Name = Name
    	Set item.LogTraceEvents = LogTraceEvents
	    Set item.Enabled = Enabled
	    set iter = settings.%GetIterator() 
	   while iter.%GetNext(.key , .value ) {
		   set iter1 = value.%GetIterator()
		   while iter1.%GetNext(.key1 , .value1 ) 
		   {
			   #Dim settingItem As Ens.Config.Setting = ##Class(Ens.Config.Setting).%New()
			   If key1 = "BusinessPartner"{
						  Set settingItem.Target = "Host"
				   }
			   Set settingItem.Name = key1
			   Set settingItem.Value = value1
			   D item.Settings.Insert(settingItem)
			   $$$LOGINFO("key = "_key1_" , value = "_value1)
		   }  
	   }
	   	Set settingItem = ##Class(Ens.Config.Setting).%New()
	   Set settingItem.Name = "WebServiceClientClass"
	   Set settingItem.Value = "JHIPV5.JHREG.PROXY.ServiceSoap"
	   Set settingItem.Target = "Adapter"
	    D item.Settings.Insert(settingItem)
	   	Set BusinessPartner = settings.%Get(0).%Get("BusinessPartner")
		Set WebServiceURL = settings.%Get(0).%Get("WebServiceURL")
		$$$LOGINFO(WebServiceURL)
		;$$$LOGINFO("输入")
		;$$$LOGINFO(BusinessPartner)
		Set msg = ##class(JHIPLIB.Util.WSC.MSG.URLRequst).%New()
		Set msg.URL = WebServiceURL
		Set msg.PackageName = NameSpace_BusinessPartner_"WSC"
		Set msg.ReceiverName = BusinessPartner
		;$$$LOGINFO("111")
		;$$$LOGINFO(msg.ReceiverName)
		Set class = ##class(JHIPV5.JHREG.BO.SubscriberManagement.CreateAgent).%New()
	;	$$$LOGINFO(class)
#;		Set cls =  class.CreateAgent(msg)
#;		Set WebServiceClientClass = cls.classname
#;		$$$LOGINFO(WebServiceClientClass)
		Set WebServiceClientClass = "JHIPV5.JHREG.PROXY.ServiceSoap"
		;Set WebServiceClientClass =  NameSpace_"."_BusinessPartner_"."_"WSC"
		Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Subscriber.SubscriberDB (Adapter,subscriberName,subscriberCode,NameSpace,standard,Organization,Enabled,Category,BusinessPartner,WebServiceClientClass,PoolSize,LogTraceEvents,Comment) VALUES('"_Adapter_"','"_subscriberName_"','"_subscriberCode_"','"_NameSpace_"','"_standard_"','"_Organization_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"','"_WebServiceClientClass_"','"_PoolSize_"','"_LogTraceEvents_"','"_Comment_"')"
		;Set UpdateSql="UPDATE JHIPV5_JHREG_DB_Theme.ThemeDB set ThemeName='"_ThemeName_"',ThemeCode='"_ThemeCode_"',NameSpace='"_NameSpace_"',standard='"_standard_"',IsSync='"_IsSync_"',Enabled='"_Enabled_"',Category='"_Category_"',BusinessPartner='"_BusinessPartner_""
		Set tSC=..Adapter.ExecuteUpdate(.Result,InsertSql)	
		Do ##class(Ens.Util.Auditing).AuditModifyProductionConfig(prodConf.Name,item.Name,"Item added to production using generator in " _ $classname())
    	Do ##class(EnsPortal.Template.prodConfigSCPage).CallProductionUpdateAndSaveToClass(prodConf,item,"InsertItem") 
    	$$$LOGINFO(InsertSql)
    	$$$LOGINFO(tSC)
    	Set res = ResultJson.TResult("Item注册完成！！！")
    	Set pResponse.StringValue = res
		Do ##class(Ens.Director).UpdateProduction()
				}
		Set pResponse.StringValue = res
#;		$$$LOGINFO("123")
#;		Set sql="SELECT ID FROM Ens_Config.Item where Name = '"_Name_"'"
#;		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
#;		$$$LOGINFO(tSC)
#;		$$$LOGINFO(sql)
#;		While (rtn.%Next()){
#;			Set subscriberID = tResult.Get("ID")
#;			$$$LOGINFO(subscriberID)
#;			}
		;Set subscriberID = tResult.Get("ID")
#;		Set item = ##class(Ens.Config.Item).%OpenId(subscriberID)
#; 		set item.Enabled = 1
#; 		Do item.%Save()
 		;Set tSC = ##class(Ens.Director).UpdateProduction()
#;		Set BusinessPartner = settings.%Get(0).%Get("BusinessPartner")
#;		Set WebServiceURL = settings.%Get(0).%Get("WebServiceURL")
#;		$$$LOGINFO("输入")
#;		$$$LOGINFO(BusinessPartner)
#;		Set msg = ##class(JHIPLIB.Util.WSC.MSG.URLRequst).%New()
#;		Set msg.URL = WebServiceURL
#;		Set msg.PackageName = NameSpace_BusinessPartner_"WSC"
#;		Set msg.ReceiverName = BusinessPartner
#;		$$$LOGINFO("111")
#;		$$$LOGINFO(msg.ReceiverName)
#;		Set class = ##class(JHIPV5.JHREG.BO.SubscriberManagement.CreateAgent).%New()
#;		Set WebServiceClientClass =  class.CreateAgent(msg)
#;		$$$LOGINFO(WebServiceClientClass)
#;		Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Subscriber.SubscriberDB (subscriberID,subscriberName,subscriberCode,NameSpace,standard,Organization,Enabled,Category,BusinessPartner,WebServiceURL,WebServiceClientClass) VALUES('"_subscriberID_"','"_subscriberName_"','"_subscriberCode_"','"_NameSpace_"','"_standard_"','"_Organization_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"','"_WebServiceURL_"','"_WebServiceClientClass_"')"
#;		;Set UpdateSql="UPDATE JHIPV5_JHREG_DB_Theme.ThemeDB set ThemeName='"_ThemeName_"',ThemeCode='"_ThemeCode_"',NameSpace='"_NameSpace_"',standard='"_standard_"',IsSync='"_IsSync_"',Enabled='"_Enabled_"',Category='"_Category_"',BusinessPartner='"_BusinessPartner_""
#;		Set tSC=..Adapter.ExecuteUpdate(.Result,InsertSql)	
		;Set res = ResultJson.TResult("Item注册完成！！！")
 		$$$LOGINFO(tSC)
	}Catch(ex){
		$$$LOGINFO("测试"_ex.DisplayString())
		Set tSC=ex.AsStatus()
		Set res = ResultJson.FResult()
	}
#;	Set res = jsonObject.%ToJSON()
#;	Set pResponse.StringValue = res
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>addSubscriber</Method>
	</MapItem>
</MapItems>
}

}

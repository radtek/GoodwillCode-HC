/// Summary   主题注册<br>
/// Version   1.0<br>
/// Date      2021年12月06日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.AddTheme Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method addTheme(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set jsonObject = ##class(%DynamicObject).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
		Try{
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
		If Adapter = "TCP.HL7V3"{
			Set clsName = "JHIPLIB.TCP.BS.HL7V3Service"
			}
		If Adapter = "TCP.HL7V2"{
			Set clsName = "JHIPLIB.TCP.BS.HL7V2Service"
			}
		$$$LOGINFO(clsName)
		Set NameSpace = json.%Get("NameSpace")
		Set ThemeCode = json.%Get("ThemeCode")
		Set ThemeName = json.%Get("ThemeName")
		Set Name = ThemeCode_ThemeName
		Set SQL="SELECT ThemeCode,ThemeName FROM JHIPV5_JHREG_DB_Theme.ThemeDB  where NameSpace ='"_NameSpace_"' ORDER BY ID"
		$$$LOGINFO(SQL)
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.SQL)
		#Dim tRe As %SQL.StatementResult = qStatement.execute()
		Set total=0
		Set ams = "no"
		while (tRe.%Next()){
			Set theName = tRe.%Get("ThemeName")
			Set theCode = tRe.%Get("ThemeCode")
			Set nam = theCode_theName
			If nam = Name{
				Set ams = "ok"
				Set res = ResultJson.Result("400","","失败","改名称已存在")
				}
			}
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
		Set itemt = ##class(Ens.Config.Item).%OpenId(66498)
		set itemt.Enabled = 0
 		Do itemt.%Save()
 		Set itemt = ##class(Ens.Config.Item).%OpenId(66498)
		set itemt.Enabled = 1
		Set tSC = ##class(Ens.Director).UpdateProduction()
 		$$$LOGINFO(tSC)	
				}
		Set pResponse.StringValue = res		
		
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
		<Method>addTheme</Method>
	</MapItem>
</MapItems>
}

}

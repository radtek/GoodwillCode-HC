/// Summary   主题更新<br>
/// Version   1.0<br>
/// Date      2021年12月06日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.UpdateTheme Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method UpdateItem(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set jsonObject = ##class(%DynamicObject).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
		Try{
		Set Adapter = json.%Get("Adapter")
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
		Set settings =json.%Get("settings")
		#Dim prodConf As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(production)
		$$$LOGINFO(Name)
		Set sql="SELECT ID FROM Ens_Config.Item where Production = '"_production_"' and Name = '"_Name_"'"
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.sql)
		$$$LOGINFO(tSC)
		#Dim rtn As %SQL.StatementResult = qStatement.execute()
		$$$LOGINFO(rtn.%Get("ID"))
		While (rtn.%Next()){
			$$$LOGINFO(rtn.%Get("ID"))
			Set item = ##Class(Ens.Config.Item).%OpenId(rtn.%Get("ID"))
			Do item.Settings.Clear()
    		Set item.PoolSize = PoolSize
    		Set item.Category=Category
    		Set item.ClassName = clsName
    		Set item.Name = Name
    		Set item.LogTraceEvents = LogTraceEvents
	  		Set item.Enabled = Enabled
	  		Set item.Comment = Comment
	   set iter = settings.%GetIterator() 
	   while iter.%GetNext(.key , .value ) {
		   set iter1 = value.%GetIterator()
		   while iter1.%GetNext(.key1 , .value1 ) 
		   {
			   #Dim settingItem As Ens.Config.Setting = ##Class(Ens.Config.Setting).%New()
			   	If (key1 = "IsSync")||(key1 = "BusinessPartner")||(key1 = "SearchTableClass"){
					Set settingItem.Target = "Host"
				   }
			   Set settingItem.Name = key1
			   Set settingItem.Value = value1
			   ;Set settingItem.Target = "Host"
			   D item.Settings.Insert(settingItem)
		   }  
	   }
    		Do item.%Save()
		}
		$$$LOGINFO("更新")
		Set tSC = ##class(Ens.Director).UpdateProduction()
		$$$LOGINFO("输出")
		Set sql="SELECT ID FROM Ens_Config.Item where Name = '"_Name_"'"
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		Set ThemeID = tResult.Get("ID")
		Set IsSync = settings.%Get(0).%Get("IsSync")
		$$$LOGINFO(IsSync)
		Set BusinessPartner = settings.%Get(0).%Get("BusinessPartner")
		Set Port = settings.%Get(0).%Get("Port")
		;Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Theme.ThemeDB (ThemeID,ThemeCode,ThemeName,NameSpace,standard,IsSync,Enabled,Category,BusinessPartner) VALUES('"_ThemeID_"','"_ThemeCode_"','"_ThemeName_"','"_NameSpace_"','"_standard_"','"_IsSync_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"')"
		Set UpdateSql="UPDATE JHIPV5_JHREG_DB_Theme.ThemeDB set ThemeName='"_ThemeName_"',ThemeCode='"_ThemeCode_"',NameSpace='"_NameSpace_"',standard='"_standard_"',IsSync='"_IsSync_"',Enabled='"_Enabled_"',Category='"_Category_"',BusinessPartner='"_BusinessPartner_"',Adapter='"_Adapter_"',PoolSize='"_PoolSize_"',Port='"_Port_"',Comment='"_Comment_"',LogTraceEvents='"_LogTraceEvents_"' where ThemeCode='"_ThemeCode_"'"
		$$$LOGINFO(UpdateSql)
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.UpdateSql)
		#Dim rs As %SQL.StatementResult = qStatement.execute()
		;Set tSC=..Adapter.ExecuteUpdate(.Result,UpdateSql)
		Set res = ResultJson.TResult("Item更新完成！！！")
		Set pResponse.StringValue = res
	}Catch(ex){
		Set tSC=ex.AsStatus()
		Set res = ResultJson.FResult()
	}
	Kill item
#;	Set res = jsonObject.%ToJSON()
#;	Set pResponse.StringValue = res
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>UpdateItem</Method>
	</MapItem>
</MapItems>
}

}

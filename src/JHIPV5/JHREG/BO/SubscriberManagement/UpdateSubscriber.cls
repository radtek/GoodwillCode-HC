/// Summary   订户更新待修改<br>
/// Version   1.0<br>
/// Date      2021年12月06日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.UpdateSubscriber Extends Ens.BusinessOperation
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
		Set NameSpace = json.%Get("NameSpace")
		Set subscriberCode = json.%Get("subscriberCode")
		Set subscriberName = json.%Get("subscriberName")
		Set Name = subscriberCode_subscriberName
		Set Category = json.%Get("Category")
		Set standard = json.%Get("standard")
		Set PoolSize = json.%Get("PoolSize")
		Set Enabled = json.%Get("Enabled")
		Set Comment = json.%Get("Comment")
		Set LogTraceEvents = json.%Get("LogTraceEvents")
		Set production = "JHIPV5d3PKG.FoundationProduction"
		;Set Organization =json.%Get("Organization")
		#Dim prodConf As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(production)
		Set settings =json.%Get("settings")
		$$$LOGINFO(Name)
		Set sql="SELECT ID FROM Ens_Config.Item where Production = '"_production_"' and Name = '"_Name_"'"
		$$$LOGINFO(sql)
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
	  		$$$LOGINFO(Enabled)
	   set iter = settings.%GetIterator() 
	   while iter.%GetNext(.key , .value ) {
		   set iter1 = value.%GetIterator()
		   while iter1.%GetNext(.key1 , .value1 ) 
		   {
			   #Dim settingItem As Ens.Config.Setting = ##Class(Ens.Config.Setting).%New()
			   Set settingItem.Name = key1
			   Set settingItem.Value = value1
			   	If (key1 = "BusinessPartner")||(key1 = "EventMethod"){
					Set settingItem.Target = "Host"
				   }
			   D item.Settings.Insert(settingItem)
		   }  
	   }
    		Do item.%Save()
		}
		$$$LOGINFO("输出")
		;Set tSC = ##class(Ens.Director).UpdateProduction()
		Set sql="SELECT ID FROM Ens_Config.Item where Name = '"_Name_"'"
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(sql)
		$$$LOGINFO(tSC)
		Set BusinessPartner = settings.%Get(0).%Get("BusinessPartner")
		Set UpdateSql="UPDATE JHIPV5_JHREG_DB_Subscriber.SubscriberDB set subscriberName='"_subscriberName_"',subscriberCode='"_subscriberCode_"',NameSpace='"_NameSpace_"',standard='"_standard_"',Adapter='"_Adapter_"',Enabled='"_Enabled_"',Category='"_Category_"',BusinessPartner='"_BusinessPartner_"',Comment='"_Comment_"',PoolSize='"_PoolSize_"',LogTraceEvents='"_LogTraceEvents_"'where subscriberCode='"_subscriberCode_"'"
		$$$LOGINFO(UpdateSql)
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.UpdateSql)
		#Dim rs As %SQL.StatementResult = qStatement.execute()
		;Set tSC=..Adapter.ExecuteUpdate(.Result,UpdateSql)
		$$$LOGINFO(tSC)
		Set res = ResultJson.TResult("Item更新完成！！！")
		$$$LOGINFO(res)
		;Set tSC = ##class(Ens.Director).UpdateProduction()
		Set pResponse.StringValue = res
		Set tSC = ##class(Ens.Director).UpdateProduction()
	}Catch(ex){
		Set tSC=ex.AsStatus()
		Set res = ResultJson.FResult()
		Set pResponse.StringValue = res
	}
	Kill item
	;Set res = jsonObject.%ToJSON()
	;Set pResponse.StringValue = res
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

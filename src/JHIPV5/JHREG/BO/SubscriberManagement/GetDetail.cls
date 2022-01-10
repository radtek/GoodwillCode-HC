/// Summary   订户详情获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.GetDetail Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getSubscriberDetail(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	;$$$LOGINFO(json)
	$$$LOGINFO(pRequest.pArg.GetAt(1))
	Set NameSpace = ""
	Set Organization = ""
	Set Enabled = ""
	Set standard = ""
	Set BusinessPartner =""
	Set subscriberName =""
	$$$LOGINFO("123")
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		;set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) "	
		set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) WHERE 1=1 "	
		If pRequest.pArg.GetAt(1)'=""{
			#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
			Set NameSpace = json.%Get("NameSpace")
			Set Organization = json.%Get("Organization")
			Set Enabled = json.%Get("Enabled")
			Set standard = json.%Get("standard")
			Set BusinessPartner = json.%Get("BusinessPartner")
			Set subscriberName = json.%Get("subscriberName")
			Set Size=json.%Get("Size")
			Set Page=json.%Get("Page")
			Set PageNumber = Size*(Page-1)+1
			Set PageSize = Size * Page
			If subscriberName'=""{
				$$$LOGINFO("213123")
				set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where  subscriberName like'%"_subscriberName_"%'"
			If NameSpace '=""{
				set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where NameSpace='"_NameSpace_"' and subscriberName like'%"_subscriberName_"%'"	
			}
			ELSEIf Organization '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where Organization='"_Organization_"' and subscriberName like '%"_subscriberName_"%'"	
			}
			ELSEIf Enabled '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where Enabled='"_Enabled_"' and subscriberName like '%"_subscriberName_"%'"	
			}
			ELSEIf standard '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where standard='"_standard_"' and subscriberName like '%"_subscriberName_"%'"	
			}
			ELSEIf BusinessPartner '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where BusinessPartner='"_BusinessPartner_"' and subscriberName like '%"_subscriberName_"%'"	
			}
		}else{
			If NameSpace '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where NameSpace='"_NameSpace_"'"	
			}
			If Organization '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where Organization='"_Organization_"'"	
			}
			If Enabled '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where Enabled='"_Enabled_"'"	
			}
			If standard '=""{
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT* FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where standard='"_standard_"'"	
			}
			If BusinessPartner '=""{
			set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB) where BusinessPartner='"_BusinessPartner_"'"	
			}
		}
			}
		Set sql=sql_" AND %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' ORDER BY ID"
		$$$LOGINFO(sql)
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(tSC)
		$$$LOGINFO(tResult)
		$$$LOGINFO(tResult.%Get("subscriberName"))
		Set total=0
		Set production = "JHIPV5d3PKG.FoundationProduction"
			while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set subscriberName = tResult.%Get("subscriberName")
			Set subscriberCode = tResult.%Get("subscriberCode")
			Set Name = subscriberCode_subscriberName
			Set sql="SELECT ID FROM Ens_Config.Item where Production = '"_production_"' and Name = '"_Name_"'"
			Set qStatement = ##class(%SQL.Statement).%New()
			Set tSC = qStatement.%Prepare(.sql)
			$$$LOGINFO(tSC)
			#Dim rtn As %SQL.StatementResult = qStatement.execute()
				While (rtn.%Next()){
				$$$LOGINFO(rtn.%Get("ID"))
				Set item = ##Class(Ens.Config.Item).%OpenId(rtn.%Get("ID"))
				Set settings =  item.Settings
				;$$$LOGINFO("settings"_settings)	
				;$$$LOGINFO("输出集合")		
				;$$$LOGINFO($LISTLENGTH(settings))
			 		For i=1:1:(settings.Size){
	 				DO NewFiled.%Set(settings.GetAt(i).Name,settings.GetAt(i).Value)
	 				;w "name为"_settings.GetAt(i).Name,!
	 				;w "value为"_settings.GetAt(i).Value,!
	 				}
				}
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("Category",tResult.%Get("Category"))
			DO NewFiled.%Set("Organization",tResult.%Get("Organization"))
			DO NewFiled.%Set("subscriberName",tResult.%Get("subscriberName"))
			DO NewFiled.%Set("subscriberCode",tResult.%Get("subscriberCode"))
			DO NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			DO NewFiled.%Set("standard",tResult.%Get("standard"))
			;DO NewFiled.%Set("BusinessPartner",tResult.%Get("BusinessPartner"))
			DO NewFiled.%Set("Enabled",tResult.%Get("Enabled"),"number")
			DO NewFiled.%Set("Adapter",tResult.%Get("Adapter"))
			DO NewFiled.%Set("PoolSize",tResult.%Get("PoolSize"))
			DO NewFiled.%Set("Comment",tResult.%Get("Comment"))
			DO NewFiled.%Set("LogTraceEvents",tResult.%Get("LogTraceEvents"))
			Set total=total+1
			Do dataArr.%Push(NewFiled)
		}
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total
		Set str=ResultJson.STResult(jsonObject)
		;Set res = ResultJson.TResult(str)
		Set pResponse.StringValue = str
		Set pResponse.StringValue = $REPLACE(str,"\u0000","")
		}
	catch{
		Set res = ResultJson.CResult()
		Set pResponse.StringValue = res
		}
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>getSubscriberDetail</Method>
	</MapItem>
</MapItems>
}

}

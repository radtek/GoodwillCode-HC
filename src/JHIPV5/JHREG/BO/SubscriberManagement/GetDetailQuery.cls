/// Summary   订户详情获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.GetDetailQuery Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getSubscriberDetailQuery(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set NameSpace = ""
	Set Organization = ""
	Set Enabled = ""
	Set standard = ""
	Set BusinessPartner =""
	Set subscriberName =""
	Set NameSpace = json.%Get("NameSpace")
	Set Organization = json.%Get("Organization")
	Set Enabled = json.%Get("Enabled")
	Set standard = json.%Get("standard")
	Set BusinessPartner = json.%Get("BusinessPartner")
	Set subscriberName = json.%Get("subscriberName")
	Set jsonObject = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		If subscriberName'=""{
			If NameSpace '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where NameSpace='"_NameSpace_"' and subscriberName like'%"_subscriberName_"%'"	
			}
			ELSEIf Organization '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where Organization='"_Organization_"' and subscriberName like '%"_subscriberName_"%'"	
			}
			ELSEIf Enabled '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where NameSpace='"_Enabled_"' and Enabled like '%"_subscriberName_"%'"	
			}
			ELSEIf standard '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where standard='"_standard_"' and subscriberName like '%"_subscriberName_"%'"	
			}
			ELSEIf BusinessPartner '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where BusinessPartner='"_BusinessPartner_"' and subscriberName like '%"_subscriberName_"%'"	
			}
		}else{
			If NameSpace '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where NameSpace='"_NameSpace_"'"	
			}
			If Organization '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where Organization='"_Organization_"'"	
			}
			If Enabled '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where NameSpace='"_Enabled_"'"	
			}
			If standard '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where standard='"_standard_"'"	
			}
			If BusinessPartner '=""{
			set sql = "SELECT subscriberName,NameSpace,standard,BusinessPartner,Organization,Enabled FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB where BusinessPartner='"_BusinessPartner_"'"	
			}
		}	
		$$$LOGINFO(sql)		
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(tSC)
		Set total=0
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
#;			Set Organization = tResult.Get("Organization")
#;			Set subscriberName = tResult.Get("subscriberName")
#;			Set NameSpace = tResult.Get("NameSpace")
#;			Set standard = tResult.Get("standard")
#;			Set BusinessPartner = tResult.Get("BusinessPartner")
#;			Set Enabled = tResult.Get("Enabled")
			DO NewFiled.%Set("Organization",tResult.%Get("Organization"))
			DO NewFiled.%Set("subscriberName",tResult.%Get("subscriberName"))
			DO NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			DO NewFiled.%Set("standard",tResult.%Get("standard"))
			DO NewFiled.%Set("BusinessPartner",tResult.%Get("BusinessPartner"))
			DO NewFiled.%Set("Enabled",tResult.%Get("Enabled"),"number")
			Set total=total+1
			Do dataArr.%Push(NewFiled)
	}
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total
		Set str=ResultJson.STResult(jsonObject)
		;Set res = ResultJson.TResult(str)
		Set pResponse.StringValue = str
		}
	catch{
		Set res = ResultJson.FResult()
		Set pResponse.StringValue = res
		}
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>getSubscriberDetailQuery</Method>
	</MapItem>
</MapItems>
}

}

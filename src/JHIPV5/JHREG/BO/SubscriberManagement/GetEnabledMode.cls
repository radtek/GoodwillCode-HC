/// Summary   订户启用状态编辑<br>
/// Version   1.0<br>
/// Date      2021年12月14日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.GetEnabledMode Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getEnabledMode(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set Enabled=json.%Get("Enabled")
	Set subscriberCode=json.%Get("subscriberCode")
	Set subscriberName=json.%Get("subscriberName")
	Set ID=json.%Get("id")
	Set Name = subscriberCode_subscriberName
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		Set sql = "UPDATE JHIPV5_JHREG_DB_Subscriber.SubscriberDB set Enabled='"_Enabled_"'where subscriberCode = '"_subscriberCode_"' and subscriberName='"_subscriberName_"'"	
		$$$LOGINFO(sql)	
		Set tSC = ..Adapter.ExecuteUpdateParmArray(.tResult,sql)
		$$$LOGINFO(tSC)	
		Set sql = "UPDATE Ens_Config.Item set Enabled='"_Enabled_"'where Name = '"_Name_"'"	
		$$$LOGINFO(sql)
		Set tSC = ..Adapter.ExecuteUpdateParmArray(.tResult,sql)
		$$$LOGINFO(tSC)	
		Set res = ResultJson.TResult("修改成功")
		Set pResponse.StringValue = res
		}
	catch{
		Set res = ResultJson.FResult()
		Set pResponse.StringValue = res
		}
	Quit $$$OK
}

Method GetSync(tItemName As %String) As %String
{
	Set outPut = ""
	Set xSettings =""
	Set tFoundItems(1)=""
	Set tProductionName = "JHIP.Production.JHIPV3"
	Set pSettingName = "IsSync"
	Set sql = "Select ClassName as xClassName,Comment as xComment,Enabled as xEnabled,$List(Settings,1,20) as xSettings From Ens_Config.Item Where Production='"_tProductionName_"' and Name='"_tItemName_"' Order By ID"

	Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
	
	if tResult.Next(){
	
		Set xSettings = tResult.Get("xSettings")
		Set tFoundItems(1)=xSettings
	}
	Set tPref=$O(tFoundItems(""),1,tFoundSettings) 
	Set pSettingsList = tFoundSettings
	For i=$LL(pSettingsList):-1:1{
		Set tSetting=$LG($LI(pSettingsList,i))
		if ($LI(tSetting,1) = pSettingName){
			Set outPut = $LI(tSetting,3)
			quit
		}
	}
	
	quit outPut
}

Method GetPartner(tItemName As %String) As %String
{
	Set outPut = ""
	Set xSettings =""
	Set tFoundItems(1)=""
	Set tProductionName = "JHIP.Production.JHIPV3"
	Set pSettingName = "BusinessPartner"
	Set sql = "Select ClassName as xClassName,Comment as xComment,Enabled as xEnabled,$List(Settings,1,20) as xSettings From Ens_Config.Item Where Production='"_tProductionName_"' and Name='"_tItemName_"' Order By ID"

	Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
	
	if tResult.Next(){
	
		Set xSettings = tResult.Get("xSettings")
		Set tFoundItems(1)=xSettings
	}
	Set tPref=$O(tFoundItems(""),1,tFoundSettings) 
	Set pSettingsList = tFoundSettings
	For i=$LL(pSettingsList):-1:1{
		Set tSetting=$LG($LI(pSettingsList,i))
		if ($LI(tSetting,1) = pSettingName){
			Set outPut = $LI(tSetting,3)
			quit
		}
	}
	
	quit outPut
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>getEnabledMode</Method>
	</MapItem>
</MapItems>
}

}

/// Summary   业务场景获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetCommunicationMode Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getCommunicationMode(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set ThemeCode=json.%Get("ThemeCode")
	Set ThemeName=json.%Get("ThemeName")
	Set IsSync=json.%Get("IsSync")
	Set Name = ThemeCode_ThemeName
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()	
		;Set sync = ..GetSync(Name)
		Set sql = "UPDATE JHIPV5_JHREG_DB_Theme.ThemeDB set IsSync='"_IsSync_"'where ThemeCode = '"_ThemeCode_"' and ThemeName='"_ThemeName_"'"	
		$$$LOGINFO(sql)	
		Set tSC = ..Adapter.ExecuteUpdateParmArray(.tResult,sql)
#;		$$$LOGINFO(tSC)	
#;		Set sql="SELECT ID FROM Ens_Config.Item where Name = '"_Name_"'"
#;		$$$LOGINFO(sql)	
#;		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
#;		$$$LOGINFO(tResult)	
#;		$$$LOGINFO(tSC)	
#;		$$$LOGINFO(tResult.%Get("ID"))	
#;		while (tResult.Next()){
#;			Set ID = tResult.%Get("ID")
#;			}
#;		Set item = ##class(Ens.Config.Item).%OpenId(ID)
#;		$$$LOGINFO("第二步")
#;		$$$LOGINFO(item)		
#; 		Set settings = item.Settings
#; 		$$$LOGINFO("输入")	
#; 		$$$LOGINFO(settings)	
#; 		;set settings.Target="Host"
#; 		set settings.Name="IsSync"
#; 		set settings.Value=IsSync
#; 		$$$LOGINFO("输出")	
#; 		;Do item.%Save()
		Set sql="SELECT ID FROM Ens_Config.Item where Name = '"_Name_"'"
		Set res = ResultJson.TResult("修改成功")
		;Set pResponse.StringValue = res
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.sql)
		$$$LOGINFO(tSC)	
		#Dim rtn As %SQL.StatementResult = qStatement.execute()
		While (rtn.%Next()){
			Set id = rtn.%Get("ID")
			}
		Set item = ##class(Ens.Config.Item).%OpenId(id)
		Set settings = item.Settings
		for i=1:1:(settings.Size){	
			If settings.GetAt(i).Name = "IsSync"{
				Set settings.GetAt(i).Value = IsSync
				}
			}
		Do item.%Save()		
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
		<Method>getCommunicationMode</Method>
	</MapItem>
</MapItems>
}

}

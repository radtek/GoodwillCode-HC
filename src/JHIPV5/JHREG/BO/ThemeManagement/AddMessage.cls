/// Classname JHIPV5.JHREG.BO.ThemeManagement.AddMessage
/// Summary   主题管理<br>
/// Version   1.0<br>
/// Date      2021年11月20日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.AddMessage Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getMessage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Try{
	Set NameSpace = $NAMESPACE
	set sql = "SELECT ID,NAME,Production ,Enabled,Category,ClassName,Settings FROM Ens_Config.Item WHERE  Production = 'JHIP.Production.JHIPV3' and Name like '%JH0%'"
	Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
	$$$LOGINFO(tSC)
	Set strs = ""
	Set pResponse = ##class(Ens.StringResponse).%New()
		while (tResult.Next()){
		;Set ThemeID = tResult.Get("ID")
		Set NAME = tResult.Get("NAME")
		Set ThemeCode = $E(NAME,1,6)
		Set ThemeName = $E(NAME,7,20)
		Set Enabled = tResult.Get("Enabled")
		Set Category = tResult.Get("Category")
		Set IsSync = ..GetSync(NAME)
		Set BusinessPartner = ..GetPartner(NAME)
		Set Enabled = tResult.Get("Enabled")
		Set ClassName = tResult.Get("ClassName")
		set standard = $P(ClassName,".",4)
		Set InsertSql="INSERT INTO JHIPV5_JHREG_DB_Theme.ThemeDB (ThemeCode,ThemeName,NameSpace,standard,IsSync,Enabled,Category,BusinessPartner) VALUES('"_ThemeCode_"','"_ThemeName_"','"_NameSpace_"','"_standard_"','"_IsSync_"','"_Enabled_"','"_Category_"','"_BusinessPartner_"')"
		;$$$LOGINFO(InsertSql)
		Set tSC=..Adapter.ExecuteUpdate(.Result,InsertSql)
	}
		Set res = ResultJson.TResult("插入成功")
		Set pResponse.StringValue = res}
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
		<Method>getMessage</Method>
	</MapItem>
</MapItems>
}

}

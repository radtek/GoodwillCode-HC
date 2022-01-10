/// Classname JHIPV5.JHREG.BO.MessageMonitor.SubpubChart
/// Summary   消息监控 -获取订阅关系
/// Explain	  获取订阅关系数据
/// Version   1.0<br>
/// Date      2021年12月1日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MessageMonitor.GetSubpubInfo Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		// 清空表  JHIPV5_JHREG_DB.SubscriptionDB
		kill ^JHIPV5.JHRECB30.SubscriptionDBD
		// 调用获取DSN
		Set JHIPDSN =##class(JHIPV5.JHREG.Common.NameSpace).JHIPConfig()
		DO ..Adapter.DSNSet(JHIPDSN)
		// 获取 主题
		Set SelectSql="SELECT Name,Category,ClassName FROM Ens_Config.Item where ClassName in(SELECT ID FROM %Dictionary.CompiledClass where PrimarySuper like '%Ens.BusinessService%') and Production !='JHIP.Production.NEWJHIPV3'"
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSql)
		Set total=0
		While tResult.%Next(){
			Set Category=tResult.%Get("Category")
			Set ClassName=tResult.%Get("ClassName")
			Set ThemeName=tResult.%Get("Name")		/** 主题名称 **/
			Set ServiceType=$P(Category,",",1)		/** 集成场景 **/
			Set Scope=$P(Category,",",2)			/** 联通方式 **/
			Set AccessWay = $P(ClassName,".",2)		/** 通讯标准 **/
			Set Publish= ..GetPartern(ThemeName)	/** 发布系统 **/
			// 获取 订户名称  订阅系统
			Set TargetSQL="SELECT count(1) as total, Name FROM Ens_Config.Item where Name in(SELECT distinct TargetConfigName FROM Ens.MessageHeader Where SessionId IN (SELECT top 10000  SessionId FROM Ens.MessageHeader where SourceConfigName = '"_ThemeName_"' ) and TargetBusinessType ='3') and Production !='JHIP.Production.NEWJHIPV3' "
			Set tSC=..Adapter.ExecuteQuery(.TargetResult,TargetSQL)
			While TargetResult.%Next(){
				Set total=TargetResult.%Get("total")
				IF total '=0{
					Set TargetName=TargetResult.%Get("Name")	/** 订户名称 **/
					Set Subscribe=..GetPartern(TargetName)		/** 订阅系统 **/
					// 本地添加数据
					Set InsertSql="INSERT INTO JHIPV5_JHREG_DB.SubscriptionDB ( AccessWay, Publish, Scope, ServiceType, Subscribe, TargetName, ThemeName)VALUES('"_AccessWay_"','"_Publish_"','"_Scope_"','"_ServiceType_"','"_Subscribe_"','"_TargetName_"','"_ThemeName_"')"
				}
				Set tSC = tStatment.%Prepare(InsertSql)
				Set tResult1 = tStatment.%Execute()
			}
		}
		Set str=Result.STResult("")
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }


	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// 获取业务合作伙伴
Method GetPartern(tItemName As %String) As %String
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
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

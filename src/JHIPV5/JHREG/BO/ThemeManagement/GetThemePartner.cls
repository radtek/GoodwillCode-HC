/// Summary   主题系统名称获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetThemePartner Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getThemeNamePartner(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set BusinessPartner = json.%Get("BusinessPartner")
		Set pResponse = ##class(Ens.StringResponse).%New()
		set sql = "SELECT ID,ThemeName FROM JHIPV5_JHREG_DB_Theme.ThemeDB WHERE  BusinessPartner = '"_BusinessPartner_"'"
		$$$LOGINFO(sql)
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(tSC)
		Set strs = ""
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("Name",tResult.%Get("ThemeName"))
			Do dataArr.%Push(NewFiled)
	}
		Set res = ResultJson.STResult(dataArr)
		Set pResponse.StringValue = res
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
		<Method>getThemeNamePartner</Method>
	</MapItem>
</MapItems>
}

}

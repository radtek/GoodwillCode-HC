/// Summary   主题域名称获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetTheme Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getThemeName(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set NameSpace=json.%Get("NameSpace")
	$$$LOGINFO(NameSpace)
	Set dataArr = ##class(%DynamicArray).%New()
	;Set NewFiled = ##class(%DynamicObject).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		set sql = "SELECT ID,ThemeName FROM JHIPV5_JHREG_DB_Theme.ThemeDB WHERE  NameSpace = '"_NameSpace_"'"
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(tSC)
		Set strs = ""
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("Name",tResult.%Get("ThemeName"))
			Do dataArr.%Push(NewFiled)
	}
#;		Set strs = "{"_strs_"}"
#;		Set strs = $replace(strs,",}","}")
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
		<Method>getThemeName</Method>
	</MapItem>
</MapItems>
}

}

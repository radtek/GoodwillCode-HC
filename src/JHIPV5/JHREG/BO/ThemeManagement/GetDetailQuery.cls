/// Summary   订户详情获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetDetailQuery Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getThemeDetailQuery(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set NameSpace = ""
	Set Category = ""
	Set Enabled = ""
	Set standard = ""
	Set BusinessPartner =""
	Set ThemeName =""
	Set NameSpace = json.%Get("NameSpace")
	Set Category = json.%Get("Category")
	Set Enabled = json.%Get("Enabled")
	Set standard = json.%Get("standard")
	Set BusinessPartner = json.%Get("BusinessPartner")
	Set subscriberName = json.%Get("subscriberName")
	Set ThemeName = json.%Get("ThemeName")
	Set jsonObject = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	$$$LOGINFO("00")
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		If ThemeName'=""{
			$$$LOGINFO("11")
			set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where  ThemeName like'%"_ThemeName_"%'"
			If (NameSpace '=""){
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where NameSpace='"_NameSpace_"' and ThemeName like'%"_ThemeName_"%'"	
			}
			ELSEIf Organization '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where Category'"_Category_"' and ThemeName like '%"_ThemeName_"%'"	
			}
			ELSEIf Enabled '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where NameSpace='"_Enabled_"' and ThemeName like '%"_ThemeName_"%'"	
			}
			ELSEIf standard '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where standard='"_standard_"' and ThemeName like '%"_ThemeName_"%'"	
			}
			ELSEIf BusinessPartner '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where BusinessPartner='"_BusinessPartner_"' and ThemeName like'%"_ThemeName_"%'"	
			}
		$$$LOGINFO("0011")
		}
		else{
			$$$LOGINFO("22")
			$$$LOGINFO(NameSpace)
			If NameSpace '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where NameSpace='"_NameSpace_"'"	
			}
			ELSEIf Organization '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where Category='"_Category_"'"	
			}
			ELSEIf Enabled '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where NameSpace='"_Enabled_"'"	
			}
			ELSEIf standard '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where standard='"_standard_"'"	
			}
			ELSEIf BusinessPartner '=""{
				set sql = "SELECT ThemeName,NameSpace,standard,BusinessPartner,ThemeCode,Enabled,IsSync FROM JHIPV5_JHREG_DB_Theme.ThemeDB where BusinessPartner='"_BusinessPartner_"'"	
			}
		}	
		$$$LOGINFO("123")	
		$$$LOGINFO(sql)	
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(tSC)
		Set total=0
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set Organization = tResult.Get("Organization")
			Set subscriberName = tResult.Get("ThemeName")
			Set NameSpace = tResult.Get("NameSpace")
			Set standard = tResult.Get("standard")
			Set BusinessPartner = tResult.Get("BusinessPartner")
			Set Enabled = tResult.Get("Enabled")
			DO NewFiled.%Set("ThemeName",tResult.%Get("ThemeName"))
			DO NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			DO NewFiled.%Set("standard",tResult.%Get("standard"))
			DO NewFiled.%Set("BusinessPartner",tResult.%Get("BusinessPartner"))
			DO NewFiled.%Set("Enabled",tResult.%Get("Enabled"),"number")
			DO NewFiled.%Set("IsSync",tResult.%Get("IsSync"),"number")
			Set total=total+1
			Do dataArr.%Push(NewFiled)
	}
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total
		Set str=ResultJson.STResult(jsonObject)
		;Set res = ResultJson.TResult(str)
		Set pResponse.StringValue = $REPLACE(str,"\u0000","")
		;Set pResponse.StringValue = str
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
		<Method>getThemeDetailQuery</Method>
	</MapItem>
</MapItems>
}

}

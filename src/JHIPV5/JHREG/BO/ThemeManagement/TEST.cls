/// Summary   主题详情获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.TEST Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getThemeDetailTest(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set tStatment = ##class(%SQL.Statement).%New()
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		set SQL = "SELECT %VID AS ContentID ,* FROM (SELECT ID,ThemeCode,ThemeName,NameSpace,standard,IsSync,Enabled,Adapter,PoolSize,Comment,LogTraceEvents,SearchTableClass,Port,Charset,CallInterval FROM JHIPV5_JHREG_DB_Theme.ThemeDB ) ORDER BY ContentID"
		Set tSC = ..Adapter.ExecuteQuery(.tResult,SQL)
#;		Set tSC = tStatment.%Prepare(SQL)
#;		Set tResult = tStatment.%Execute()
		Set total=0
		Set production = "JHIPV5d3PKG.FoundationProduction"
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set ThemeName = tResult.%Get("ThemeName")
			Set ThemeCode = tResult.%Get("ThemeCode")
			Set Name = ThemeCode_ThemeName
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
			DO NewFiled.%Set("ThemeName",tResult.%Get("ThemeName"))
			DO NewFiled.%Set("ThemeCode",tResult.%Get("ThemeCode"))
			DO NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			DO NewFiled.%Set("standard",tResult.%Get("standard"))
			;DO NewFiled.%Set("IsSync",tResult.%Get("IsSync"),"number")
			DO NewFiled.%Set("Enabled",tResult.%Get("Enabled"),"number")
			DO NewFiled.%Set("Adapter",tResult.%Get("Adapter"))
			DO NewFiled.%Set("PoolSize",tResult.%Get("PoolSize"))
			DO NewFiled.%Set("Comment",tResult.%Get("Comment"))
			DO NewFiled.%Set("LogTraceEvents",tResult.%Get("LogTraceEvents"),"number")
			;DO NewFiled.%Set("SearchTableClass",tResult.%Get("SearchTableClass"))
			;DO NewFiled.%Set("Port",tResult.%Get("Port"),"number")
			;DO NewFiled.%Set("Charset",tResult.%Get("Charset"))
			DO NewFiled.%Set("CallInterval",tResult.%Get("CallInterval"))
			Set total=total+1
			Do dataArr.%Push(NewFiled)
	}
		$$$LOGINFO("111")
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total
		Set str=ResultJson.TResult(jsonObject)
		;Set res = ResultJson.TResult(dataArr)
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
		<Method>getThemeDetailTest</Method>
	</MapItem>
</MapItems>
}

}

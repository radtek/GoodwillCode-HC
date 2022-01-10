/// Summary   主题详情获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetDetail Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getThemeDetail(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set tStatment = ##class(%SQL.Statement).%New()
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set NameSpace = ""
	Set Category = ""
	Set Enabled = ""
	Set standard = ""
	Set BusinessPartner =""
	Set ThemeName =""
	Try{
		;Set sql="SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB ORDER BY ID"
		set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) WHERE 1=1 "
		If pRequest.pArg.GetAt(1) '=""{
			#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
			Set NameSpace = json.%Get("NameSpace")
			Set Category = json.%Get("Category")
			Set Enabled = json.%Get("Enabled")
			Set standard = json.%Get("standard")
			Set BusinessPartner = json.%Get("BusinessPartner")
			Set ThemeName = json.%Get("ThemeName")
			Set Size=json.%Get("Size")
			Set Page=json.%Get("Page")
			Set PageNumber = Size*(Page-1)+1
			Set PageSize = Size * Page
			Set SearchType = json.%Get("SearchType")
			Set SearchValue = json.%Get("SearchValue")
			If SearchType = "1"{
				Set NameSpace = SearchValue
				}
			Set:SearchType=2 Category=SearchValue	
			Set:SearchType=3 Enabled=SearchValue
			Set:SearchType=4 standard=SearchValue
			Set:SearchType=5 BusinessPartner=SearchValue	
			If ThemeName'=""{
			$$$LOGINFO("11")
			set sql = "SELECT %VID AS ContentID , * FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where  ThemeName like'%"_ThemeName_"%'"
			$$$LOGINFO(sql)
			If (NameSpace '=""){
				set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where NameSpace='"_NameSpace_"' and ThemeName like'%"_ThemeName_"%'"
			}
			ELSEIf Category '=""{
				set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where Category='"_Category_"' and ThemeName like'%"_ThemeName_"%'"	
			}
			ELSEIf Enabled '=""{
				set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where Enabled='"_Enabled_"' and ThemeName like'%"_ThemeName_"%'"
			}
			ELSEIf standard '=""{
				set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where standard='"_standard_"' and ThemeName like'%"_ThemeName_"%'"
			}
			ELSEIf BusinessPartner '=""{
				set sql = "SELECT %VID AS ContentID ,* FROM (SELECT * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where BusinessPartner='"_BusinessPartner_"' and ThemeName like'%"_ThemeName_"%'"	
			}
			$$$LOGINFO("0011")
		}else{
			$$$LOGINFO("22")
			If NameSpace '=""{
				set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where NameSpace='"_NameSpace_"'"		
			$$$LOGINFO(sql)
			}
			ELSEIf Category '=""{
				set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where Category='"_Category_"'"		
			}
			ELSEIf Enabled '=""{
				set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where Enabled='"_Enabled_"'"		
			}
			ELSEIf standard '=""{
				set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where standard='"_standard_"'"			
			}
			ELSEIf BusinessPartner '=""{
				set sql = "SELECT %VID AS ContentID , * FROM (SELECT  * FROM JHIPV5_JHREG_DB_Theme.ThemeDB) where BusinessPartner='"_BusinessPartner_"'"		
			}
		}
	}
		Set sql=sql_" AND %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' ORDER BY ID"
		$$$LOGINFO("0000")
		$$$LOGINFO(sql)
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.sql)
		#Dim tResult As %SQL.StatementResult = qStatement.execute()
		Set total=0
		while (tResult.%Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set ThemeName = tResult.%Get("ThemeName")
			Set ThemeCode = tResult.%Get("ThemeCode")
			Set NameSpace = tResult.%Get("NameSpace")
			Set Name = ThemeCode_ThemeName
			;Set NameSpace = "JHIPV5-3"
				Set production = "JHIPV5d3PKG.FoundationProduction"
				Set sql="SELECT ID FROM Ens_Config.Item where Production = '"_production_"' and Name = '"_Name_"'"
				Set qStatement = ##class(%SQL.Statement).%New()
				Set tSC = qStatement.%Prepare(.sql)
				#Dim rsn As %SQL.StatementResult = qStatement.execute()
				While (rsn.%Next()){
				;$$$LOGINFO(rsn.%Get("ID"))
				Set item = ##Class(Ens.Config.Item).%OpenId(rsn.%Get("ID"))
				Set settings =  item.Settings
			 		For i=1:1:(settings.Size){
	 				;DO NewFiled.%Set(settings.GetAt(i).Name,settings.GetAt(i).Value)
	 				If settings.GetAt(i).Name = "IsSync"{
		 				DO NewFiled.%Set(settings.GetAt(i).Name,settings.GetAt(i).Value,"number")
		 				}else{
			 				DO NewFiled.%Set(settings.GetAt(i).Name,settings.GetAt(i).Value)
			 				}
	 				}
				}
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("Category",tResult.%Get("Category"))
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
		Set str=ResultJson.STResult(jsonObject)
		;Set res = ResultJson.TResult(dataArr)
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
		<Method>getThemeDetail</Method>
	</MapItem>
</MapItems>
}

}

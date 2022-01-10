/// Summary   主题详情分页获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetDetailPage Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method getThemeDetailPage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		$$$LOGINFO("进入")	
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
		Set NameSpace=json.%Get("NameSpace")			/* 域名称   */
		Set Category=json.%Get("Category")				/* 类别名称   */
		Set Enabled=json.%Get("Enabled")				/* 发布状态名称   */
		Set standard=json.%Get("standard")				/* 通讯标准名称   */
		Set BusinessPartner=json.%Get("BusinessPartner")		/* 发布系统名称   */
		Set Size=json.%Get("Size")						/* 每页条数 */
		Set Page=json.%Get("Page")						/* 第几页   */
		// 页码
		Set PageNumber = Size*(Page-1)+1
		Set PageSize = Size * Page
		$$$LOGINFO("11")	
		set SQL = "SELECT %VID AS ContentID ,* FROM (SELECT ID,ThemeCode,ThemeName,NameSpace,standard,IsSync,Enabled,Adapter FROM JHIPV5_JHREG_DB_Theme.ThemeDB) "
		$$$LOGINFO("22")	
		Set:$L(NameSpace)'=0 SQL=SQL_" WHERE NameSpace = '"_NameSpace_"'"	
		$$$LOGINFO("44")	
		Set:$L(Category)'=0 SQL=SQL_" WHERE Category = '"_Category_"'"	
		$$$LOGINFO("55")	
		Set:$L(Enabled)'=0 SQL=SQL_" WHERE Enabled = '"_Enabled_"'"	
		Set:$L(standard)'=0 SQL=SQL_" WHERE standard = '"_standard_"'"	
		Set:$L(BusinessPartner)'=0 SQL=SQL_" WHERE BusinessPartner = '"_BusinessPartner_"'"	
		$$$LOGINFO("33")	
		Set SQL=SQL_" WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"		
		$$$LOGINFO(SQL)	
		Set tSC = ..Adapter.ExecuteQuery(.tResult,SQL)
		$$$LOGINFO(tSC)
		$$$LOGINFO("输出")
		Set total=0
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("ThemeName",tResult.%Get("ThemeName"))
			DO NewFiled.%Set("ThemeCode",tResult.%Get("ThemeCode"))
			DO NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			DO NewFiled.%Set("standard",tResult.%Get("standard"))
			DO NewFiled.%Set("IsSync",tResult.%Get("IsSync"))
			DO NewFiled.%Set("Enabled",tResult.%Get("Enabled"))
			DO NewFiled.%Set("Adapter",tResult.%Get("Adapter"))
			Set total=total+1
			Do dataArr.%Push(NewFiled)
	}
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total
		Set str=ResultJson.STResult(jsonObject)
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
		<Method>getThemeDetailPage</Method>
	</MapItem>
</MapItems>
}

}

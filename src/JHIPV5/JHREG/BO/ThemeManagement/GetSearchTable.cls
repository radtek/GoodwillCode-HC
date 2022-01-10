/// Classname JHIPV5.JHREG.BO.ThemeManagement.GetSearchTable
/// Summary   主题管理 
/// Explain	  获取搜索表类名称
/// Version   1.0<br>
/// Date      2021年12月21日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetSearchTable Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetSearchtable(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set NameSpace=json.%Get("NameSpace")
		// 设置 DSN 
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		DO ..Adapter.DSNSet(GetDSN)
		$$$TRACE("NameSpace:"_NameSpace)
		$$$TRACE("DSN:"_GetDSN)
		//获取域名称
		Set domainName = ##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpace)
		IF domainName="JHIP"{
			Set value="JHIPLIB.SearchTable%"
		}ELSEIF domainName="HII"{
			Set value="HII.Util.SearchTable%"
		}Else{
			Set value="%SearchTable%"
		}
		$$$TRACE("Valeu:"_value)
		Set SelectSQL="Select distinct substring(parent,0,charindex('||',parent)) as ClassName FROM %Dictionary.CompiledStorageDataValue where parent like '"_value_"' "
		$$$TRACE("SQL:"_SelectSQL)
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSQL)		
		While tResult.%Next(){ 
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("value", tResult.%Get("ClassName"))
			Do dataArr.%Push(NewFiled)
		}	
		Set str=Result.STResult(dataArr)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>GetSearchtable</Method>
	</MapItem>
</MapItems>
}

}

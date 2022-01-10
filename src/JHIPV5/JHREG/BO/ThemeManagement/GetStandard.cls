/// Summary   通讯标准获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.GetStandard Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method queryStandard(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	;Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	;#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	;Set NewFiled = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		set sql = "SELECT ID,Standed FROM JHIPV5_JHREG_DB.AdapterDB group by Standed "			
		;Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		;$$$LOGINFO(tSC)
		Set strs = ""
		Set qStatement = ##class(%SQL.Statement).%New()
		Set tSC = qStatement.%Prepare(.sql)
		$$$LOGINFO(tSC)
		#Dim rtn As %SQL.StatementResult = qStatement.execute()
		$$$LOGINFO(rtn)
		While (rtn.%Next()){
		;while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			DO NewFiled.%Set("ID",rtn.%Get("ID"))
			DO NewFiled.%Set("Name",rtn.%Get("Standed"))
			Do dataArr.%Push(NewFiled)
	}
#;		$$$LOGINFO(strs)
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
		<Method>queryStandard</Method>
	</MapItem>
</MapItems>
}

}

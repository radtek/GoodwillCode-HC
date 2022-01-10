/// Summary   业务场景获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.GetStandard Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method queryStandard(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	;#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		set sql = "SELECT ID,Standard FROM JHIPV5_JHREG_DB.AdapterDB  group by Standard"			
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		$$$LOGINFO(tSC)
		Set strs = ""
		while tResult.%Next(){
			$$$LOGINFO(tResult.%Get("ID"))
			;Set Category = tResult.Get("Category")
			Set NewFiled = ##class(%DynamicObject).%New()
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("Name",tResult.%Get("Standard"))			
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
		<Method>queryStandard</Method>
	</MapItem>
</MapItems>
}

}

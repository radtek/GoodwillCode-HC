/// Summary   业务场景获取<br>
/// Version   1.0<br>
/// Date      2021年11月30日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.GetPartner Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method queryPartner(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	;Set NewFiled = ##class(%DynamicObject).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Try{
		Set pResponse = ##class(Ens.StringResponse).%New()
		set sql = "SELECT ID,BusinessPartner FROM JHIPV5_JHREG_DB_Subscriber.SubscriberDB"				
		Set tSC = ..Adapter.ExecuteQuery(.tResult,sql)
		while (tResult.Next()){
			Set NewFiled = ##class(%DynamicObject).%New()
			DO NewFiled.%Set("ID",tResult.%Get("ID"))
			DO NewFiled.%Set("Name",tResult.%Get("BusinessPartner"))
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
		<Method>queryPartner</Method>
	</MapItem>
</MapItems>
}

}

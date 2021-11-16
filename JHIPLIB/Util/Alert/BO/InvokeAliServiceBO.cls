/// 调用阿里云消息接收服务，将警告信息推送出去<br/>
/// 其中，请选择接收目标，是钉钉群还是微信服务号<br/>
Class JHIPLIB.Util.Alert.BO.InvokeAliServiceBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "HospitalName:Data";

/// 医院名称，填写医院全称，一个字也不能错，否则无法正确发送。
Property HospitalName As %String [ Required ];

/// 发送告警消息
/// 
Method SendMsg(pRequest As Ens.AlertRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set tSC=..Adapter.InvokeMethod("MessageService",.result,..HospitalName,"","1",pRequest.AlertText,
			pRequest.AlertTime,pRequest.SessionId,pRequest.SourceConfigName,pRequest.AlertDestination)
	s pResponse=##class(Ens.StringResponse).%New()
	s pResponse.StringValue=result
	quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.AlertRequest"> 
		<Method>SendMsg</Method>
	</MapItem>
</MapItems>
}

}

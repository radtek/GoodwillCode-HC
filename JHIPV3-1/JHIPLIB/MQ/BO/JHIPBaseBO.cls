Class JHIPLIB.MQ.BO.JHIPBaseBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.MQSeries.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method Send(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
    Set string=pRequest.StringValue    
	Set string=$zcvt(string,"O","GB18030")
    Set status=..Adapter.SendMessage(string)
    $$$TRACE(status)
    If $$$ISERR(status) {
        Do $System.Status.DisplayError(status)
        Quit $$$ERROR($$$GeneralError,"消息发送异常！")
    }
 	Set pResponse=##class(Ens.StringResponse).%New()
    Set pResponse.StringValue="发送成功！"
    Quit status
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Ens.StringRequest">
        <Method>Send</Method>
    </MapItem>
</MapItems>
}

}

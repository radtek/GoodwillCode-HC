Class JHIPLIB.JHIPV5.SubScriber.BO.PSubScribersBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pInput As JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG, Output pOutput As Ens.StringResponse) As %Status
{
	Set pResponse=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
	Set pResponse.ResultCode="false"
	Set pResponse.ResultContent="失败"
	&Sql(DELETE from JHIPLIB_JHIPV5_EMUI_DB.Subscribers)
	    Set DictName=pInput.DictName
		Set SubscriberSystems=pInput.SubscriberSystems
		Set PublishSystems=pInput.PublishSystems
		&Sql(INSERT INTO JHIPLIB_JHIPV5_EMUI_DB.Subscribers
		VALUES (:DictName,:SubscriberSystems,:PublishSystems))
		Set pResponse.ResultCode="true"
		Set pResponse.ResultContent="成功"
	Do pResponse.XMLExportToString(.xmlString)
	Set pOutput=##class(Ens.StringResponse).%New()
	Set pOutput.StringValue=xmlString
	
	Quit $$$OK
}

}

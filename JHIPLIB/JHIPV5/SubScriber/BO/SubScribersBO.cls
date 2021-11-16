Class JHIPLIB.JHIPV5.SubScriber.BO.SubScribersBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pInput As JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG, Output pOutput As Ens.StringResponse) As %Status
{
	Set pResponse=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
	Set number = 1
	Set pResponse.ResultCode="false"
	Set pResponse.ResultContent="失败"
	&Sql(DELETE from JHIPLIB_JHIPV5_Term_DB.Subscribers)
	While number <= pInput.Item.Size
	{
        Set scribers=pInput.Item.GetAt(number)
		Set DictId =scribers.DictID
		Set DictName=scribers.DictName
		Set SubscriberSystems=scribers.SubscriberSystems
		Set PublishSystems=scribers.PublishSystems
		Set Remarks=scribers.Remarks
		&Sql(INSERT INTO JHIPLIB_JHIPV5_Term_DB.Subscribers
		VALUES (:DictId,:DictName,:PublishSystems,:Remarks,:SubscriberSystems))
		Set pResponse.ResultCode="true"
		Set pResponse.ResultContent="成功"
		Set number=number + 1	
	}
	Do pResponse.XMLExportToString(.xmlString)
	Set pOutput=##class(Ens.StringResponse).%New()
	Set pOutput.StringValue=xmlString
	
	Quit $$$OK
}

}

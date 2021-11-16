/// Classname JHIPLIB.SOAP.Operation.SyncPartnerBO
/// Summary   同步合作伙伴信息的BO
/// Version   1.0
/// Date      2019年1月17日 18:00
/// Author    李健
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.JHIPV5.SyncPartner.BO.SyncPartnerBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pInput As JHIPLIB.JHIPV5.SyncPartner.MSG.SyncPartnerMSG, Output pOutput As Ens.StringResponse) As %Status
{
	Set pResponse=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
	Set number = 1
	Set pResponse.ResultCode="false"
	Set pResponse.ResultContent="失败"
	&Sql(DELETE from Ens_Config.BusinessPartner)
	While number <= pInput.Item.Size
	{
		Set pResponse.ResultCode="false"
		Set pResponse.ResultContent="失败"
		Set Partner=pInput.Item.GetAt(number)
		Set ID = Partner.PartnerName
		Set Description = Partner.Description
		Set PartnerName	= Partner.PartnerName
		Set PrimaryContactName = Partner.PrimaryContactName
		Set PrimaryContactTitle = Partner.PrimaryContactTitle
		Set PrimaryContactPhoneNumber = Partner.PrimaryContactPhoneNumber
		Set PrimaryContactMobileNumber = Partner.PrimaryContactMobileNumber
		Set PrimaryContactNotes = Partner.PrimaryContactNotes
		Set PrimaryContactEmail = Partner.PrimaryContactEmail
		Set AlternativeContactName = Partner.AlternativeContactName
		Set AlternativeContactTitle = Partner.AlternativeContactTitle
		Set AlternativeContactNotes = Partner.AlternativeContactNotes
		Set AlternativeContactPhoneNumber = Partner.AlternativeContactPhoneNumber
		Set AlternativeContactEmail = Partner.AlternativeContactEmail
		&Sql(INSERT INTO Ens_Config.BusinessPartner
		VALUES (:ID,:Description,:PartnerName,:AlternativeContactEmail,:AlternativeContactMobileNumber,:AlternativeContactName,:AlternativeContactNotes,:AlternativeContactPhoneNumber,:AlternativeContactTitle,:PrimaryContactEmail,:PrimaryContactMobileNumber,:PrimaryContactName,:PrimaryContactNotes,:PrimaryContactPhoneNumber,:PrimaryContactTitle))
		Set number=number + 1
		Set pResponse.ResultCode="true"
		Set pResponse.ResultContent="成功"
	}
	Do pResponse.XMLExportToString(.xmlString)
	Set pOutput=##class(Ens.StringResponse).%New()
	Set pOutput.StringValue=xmlString
	
	Quit $$$OK
}

}

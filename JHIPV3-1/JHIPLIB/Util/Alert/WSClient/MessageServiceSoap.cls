Class JHIPLIB.Util.Alert.WSClient.MessageServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method MessageService(hospitalName As %String, userID As %String, type As %String, context As %String, createTime As %String, sessionId As %String, sourceConfigName As %String, destination As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("MessageService").Invoke($this,"http://goodwillcis.com/JHIPLIB.Util.Project.BS.MessageService.MessageService",.hospitalName,.userID,.type,.context,.createTime,.sessionId,.sourceConfigName,.destination)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://101.200.35.32/csp/healthshare/jhip/service/JHIPLIB.Util.Project.BS.MessageService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://goodwillcis.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "MessageService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}

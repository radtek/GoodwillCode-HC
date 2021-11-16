Class JHIP.JHIPV5.PORTAL.WS.PermissionWebserviceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
/// Parameter LOCATION = "http://172.18.10.121:8080/portal/services/permission";
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://portal.webserver.jhip.goodwillcis.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "PermissionWebserviceImpl";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method permissionAdd(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("permissionAdd").Invoke($this,"",.inputParam)
}

Method permissionDelete(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("permissionDelete").Invoke($this,"",.inputParam)
}

Method permissionUpdate(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("permissionUpdate").Invoke($this,"",.inputParam)
}

}

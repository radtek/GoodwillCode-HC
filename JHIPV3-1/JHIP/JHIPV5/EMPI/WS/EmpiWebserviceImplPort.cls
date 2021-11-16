Class JHIP.JHIPV5.EMPI.WS.EmpiWebserviceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method PIXAdd(arg0 As %String) As %String(ELEMENTQUALIFIED=1,XMLNAME="paramXml") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("PIXAdd").Invoke($this,"",.arg0)
}

Method PIXQuery(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("PIXQuery").Invoke($this,"",.arg0)
}

Method PIXQueryGroup(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("PIXQueryGroup").Invoke($this,"",.arg0)
}

Method PIXUpdate(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("PIXUpdate").Invoke($this,"",.arg0)
}

Method addPatient(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("addPatient").Invoke($this,"",.arg0)
}

Method getById(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getById").Invoke($this,"",.arg0)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// 这是服务使用的命名空间
Parameter NAMESPACE = "http://empi.webservice.jhip.goodwillcis.com/";

/// 这是服务的名称
Parameter SERVICENAME = "EmpiWebservice";

/// 这是该服务支持的SOAP版本.
Parameter SOAPVERSION = 1.1;

}

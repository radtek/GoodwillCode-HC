Class JHIPLIB.JHIPV5.DictDataWebserviceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method addDict(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("addDict").Invoke($this,"",.arg0)
}

Method conditionalQueryDict(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("conditionalQueryDict").Invoke($this,"",.arg0)
}

Method deleteDict(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deleteDict").Invoke($this,"",.arg0)
}

Method queryDict(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("queryDict").Invoke($this,"",.arg0)
}

Method updateDict(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("updateDict").Invoke($this,"",.arg0)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// 这是服务使用的命名空间
Parameter NAMESPACE = "http://webservice.jhip.goodwillcis.com/";

/// 这是服务的名称
Parameter SERVICENAME = "DictDataWebservice";

/// 这是该服务支持的SOAP版本.
Parameter SOAPVERSION = 1.1;

}

Class JHIP.SHUYU.DictStructureWebServiceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method StructureCreate(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StructureCreate").Invoke($this,"",.arg0)
}

Method StructureQuery(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StructureQuery").Invoke($this,"",.arg0)
}

Method StructureStop(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StructureStop").Invoke($this,"",.arg0)
}

Method StructureUpdate(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("StructureUpdate").Invoke($this,"",.arg0)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// 这是服务使用的命名空间
Parameter NAMESPACE = "http://webservice.jhip.goodwillcis.com/";

/// 这是服务的名称
Parameter SERVICENAME = "DictStructureWebService";

/// 这是该服务支持的SOAP版本.
Parameter SOAPVERSION = 1.1;

}

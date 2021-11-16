Class JHIPLIB.JHIPV5.DEPARTMENT.DeptMaintainWebserviceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method addDept(paramXml As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("addDept").Invoke($this,"",.paramXml)
}

Method deleteDept(paramXml As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deleteDept").Invoke($this,"",.paramXml)
}

Method queryDept(paramXml As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("queryDept").Invoke($this,"",.paramXml)
}

Method updateDept(paramXml As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("updateDept").Invoke($this,"",.paramXml)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// 这是服务使用的命名空间
Parameter NAMESPACE = "http://emdi.webserver.jhip.goodwillcis.com/";

/// 这是服务的名称
Parameter SERVICENAME = "DeptWebserviceImpl";

/// 这是该服务支持的SOAP版本.
Parameter SOAPVERSION = 1.1;

}

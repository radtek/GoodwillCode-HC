Class JHIPLIB.JHIPV5.PEOPLE.PeopleDataWebserviceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method createPeople(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("createPeople").Invoke($this,"",.inputParam)
}

Method deletePeople(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deletePeople").Invoke($this,"",.inputParam)
}

Method queryPeople(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("queryPeople").Invoke($this,"",.inputParam)
}

Method updatePeople(inputParam As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("updatePeople").Invoke($this,"",.inputParam)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// 这是服务使用的命名空间
Parameter NAMESPACE = "http://emui.webservice.jhip.goodwillcis.com/";

/// 这是服务的名称
Parameter SERVICENAME = "PeopleDataWebserviceImpl";

/// 这是该服务支持的SOAP版本.
Parameter SOAPVERSION = 1.1;

}

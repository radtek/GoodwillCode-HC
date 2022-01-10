/// 
Class JHIPV5.JHREG.WSDL.HII.ns2.JiaheSecurity Extends %SOAP.Header [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://goodwillcis.com";

Parameter XMLFORMAT = "literal";

Parameter XMLNAME = "JiaheSecurity";

Parameter XMLSEQUENCE = 1;

Property UserName As %String(MAXLEN = "", XMLNAME = "UserName");

Property Password As %String(MAXLEN = "", XMLNAME = "Password");

Property Timestamp As %String(MAXLEN = "", XMLNAME = "Timestamp");

Property FromSYS As %String(MAXLEN = "", XMLNAME = "FromSYS");

Property IV As %String(MAXLEN = "", XMLNAME = "IV");

}

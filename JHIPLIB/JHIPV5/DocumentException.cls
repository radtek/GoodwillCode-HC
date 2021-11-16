/// 创建自: http://192.168.7.114:10007/mdm/mdmWebservice/MasterDataRetrieve?wsdl
Class JHIPLIB.JHIPV5.DocumentException Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "DocumentException";

Parameter XMLSEQUENCE = 1;

Property message As %String(MAXLEN = "", XMLNAME = "message");

}

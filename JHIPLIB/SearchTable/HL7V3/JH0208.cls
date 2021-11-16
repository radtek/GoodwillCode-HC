Class JHIPLIB.SearchTable.HL7V3.JH0208 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过检验申请单号和患者ID进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0208) As %Status [ SqlProc ]
{
	
	
		Set path="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/actId/value/item[1]/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.ApplicationID = name
		Set idPath="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/patientId/value/item[3]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0208DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>ApplicationID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0208D</DataLocation>
<DefaultData>JH0208DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0208D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0208I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0208S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

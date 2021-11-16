Class JHIPLIB.SearchTable.HL7V3.JH0412 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和申请单ID进行查询
Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0412) As %Status [ SqlProc ]
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
<Data name="JH0412DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApplicationID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>DocId</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0412D</DataLocation>
<DefaultData>JH0412DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0412D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0412I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0412S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

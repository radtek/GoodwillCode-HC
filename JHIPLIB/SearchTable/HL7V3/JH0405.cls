Class JHIPLIB.SearchTable.HL7V3.JH0405 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和申请单号进行查询
Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0405) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200902UV/controlActProcess/subject/placerGroup/component2/observationRequest/id/item/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.ApplicationID = name
		Set idPath="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/patientId/value/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0405DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0405D</DataLocation>
<DefaultData>JH0405DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0405D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0405I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0405S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

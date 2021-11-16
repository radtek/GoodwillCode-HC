Class JHIPLIB.SearchTable.HL7V3.JH0107 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0107) As %Status [ SqlProc ]
{
	
	
		
		Set idPath="/PRPA_IN900300UV02/controlActProcess/queryByParameterPayload/patientId/value/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0107DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0107D</DataLocation>
<DefaultData>JH0107DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0107D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0107I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0107S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

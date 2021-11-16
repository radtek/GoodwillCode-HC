Class JHIPLIB.SearchTable.HL7V3.JH0503 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0503) As %Status [ SqlProc ]
{
	
	
		
		Set idPath="/PRPA_IN900300UV/controlActProcess/queryByParameter/patientId/semanticsText/@value"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0503DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0503D</DataLocation>
<DefaultData>JH0503DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0503D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0503I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0503S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

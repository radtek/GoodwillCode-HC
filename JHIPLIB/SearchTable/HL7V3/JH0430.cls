Class JHIPLIB.SearchTable.HL7V3.JH0430 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0430) As %Status [ SqlProc ]
{
	
		Set path="/ClinicalDocument/recordTarget/patientRole/patient/name"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0430DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0430D</DataLocation>
<DefaultData>JH0430DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0430D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0430I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0430S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

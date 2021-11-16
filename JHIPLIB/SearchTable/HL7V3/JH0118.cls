Class JHIPLIB.SearchTable.HL7V3.JH0118 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和住院号进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property HospitalizationID As %String(COLLATION = "EXACT");

Index HospitalizationIDIdx On HospitalizationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0118) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN302012UV/controlActProcess/subject/encounterEvent/id/item/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.HospitalizationID = name
		Set idPath="/PRPA_IN302012UV/controlActProcess/subject/encounterEvent/subject/patient/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0118DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>HospitalizationID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0118D</DataLocation>
<DefaultData>JH0118DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0118D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0118I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0118S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

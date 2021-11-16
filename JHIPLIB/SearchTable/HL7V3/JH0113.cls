Class JHIPLIB.SearchTable.HL7V3.JH0113 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和住院号进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property HospitalizationID As %String(COLLATION = "EXACT");

Index HospitalizationIDIdx On HospitalizationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0113) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN900300UV/controlActProcess/queryByParameter/patientId/value/item[1]/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientID = name
		Set idPath="/PRPA_IN900300UV/controlActProcess/queryByParameter/careEventID/value/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0113DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0113D</DataLocation>
<DefaultData>JH0113DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0113D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0113I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0113S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

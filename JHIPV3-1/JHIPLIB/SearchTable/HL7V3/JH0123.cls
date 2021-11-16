Class JHIPLIB.SearchTable.HL7V3.JH0123 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和住院号进行查询
Property HospitalizationID As %String(COLLATION = "EXACT");

Index HospitalizationIDIdx On HospitalizationID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0123) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN900300UV/controlActProcess/queryByParameter/careEventID/value/item/@extension"
		Set Hid = pDocObj.GetValueAt(path)
		Set pSearchTable.HospitalizationID = Hid
		Set idPath="/PRPA_IN900300UV/controlActProcess/queryByParameter/patientId/value/item[1]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0123DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>HospitalizationID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0123D</DataLocation>
<DefaultData>JH0123DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0123D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0123I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0123S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

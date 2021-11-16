Class JHIPLIB.SearchTable.HL7V3.JH0121 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、住院号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property HospitalizationID As %String(COLLATION = "EXACT");

Index HospitalizationIDIdx On HospitalizationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0121) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN400003UV/controlActProcess/subject/encounterEvent/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN400003UV/controlActProcess/subject/encounterEvent/subject/patient/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set HospitalizationIDPath="/PRPA_IN400003UV/controlActProcess/subject/encounterEvent/id/item/@extension"
		Set Hid = pDocObj.GetValueAt(HospitalizationIDPath)
		Set pSearchTable.HospitalizationID = Hid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0121DefaultData">
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
<Value name="5">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0121D</DataLocation>
<DefaultData>JH0121DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0121D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0121I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0121S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

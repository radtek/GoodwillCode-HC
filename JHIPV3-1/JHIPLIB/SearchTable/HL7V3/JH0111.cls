Class JHIPLIB.SearchTable.HL7V3.JH0111 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过住院号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property HospitalizationID As %String(COLLATION = "EXACT");

Index HospitalizationIDIdx On HospitalizationID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0111) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.HospitalizationID = id
		Set PatientIDPath ="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/id/item/@extension"
	Set pid =pDocObj.GetValueAt(PatientIDPath)
	Set pSearchTable.PatientID =pid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0111DefaultData">
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
<Value name="5">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0111D</DataLocation>
<DefaultData>JH0111DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0111D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0111I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0111S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

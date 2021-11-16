Class JHIPLIB.SearchTable.HL7V3.JH0003 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0003) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN201304UV02/controlActProcess/subject/registrationEvent/subject1/patient/patientPerson/name"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN201304UV02/controlActProcess/subject/registrationEvent/subject1/patient/id/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0003DefaultData">
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
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0003D</DataLocation>
<DefaultData>JH0003DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0003D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0003I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0003S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

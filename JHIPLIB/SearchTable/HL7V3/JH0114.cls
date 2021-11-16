Class JHIPLIB.SearchTable.HL7V3.JH0114 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过住院号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property HospitalizationID As %String(COLLATION = "EXACT");

Index HospitalizationIDIdx On HospitalizationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0114) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.HospitalizationID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0114DefaultData">
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
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0114D</DataLocation>
<DefaultData>JH0114DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0114D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0114I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0114S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

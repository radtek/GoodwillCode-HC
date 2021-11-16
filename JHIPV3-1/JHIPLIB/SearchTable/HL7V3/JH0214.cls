Class JHIPLIB.SearchTable.HL7V3.JH0214 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、申请单号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0214) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200902UV/controlActProcess/subject/procedureRequest/componentOf1/encounter/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/POOR_IN200902UV/controlActProcess/subject/procedureRequest/componentOf1/encounter/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set vidPath="/POOR_IN200902UV/controlActProcess/subject/procedureRequest/id/item/@extension"
		Set vid = pDocObj.GetValueAt(vidPath)
		Set pSearchTable.ApplicationID = vid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0214DefaultData">
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
<Value>ApplicationID</Value>
</Value>
<Value name="5">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0214D</DataLocation>
<DefaultData>JH0214DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0214D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0214I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0214S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

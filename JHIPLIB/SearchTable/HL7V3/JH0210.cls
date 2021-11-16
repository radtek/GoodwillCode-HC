Class JHIPLIB.SearchTable.HL7V3.JH0210 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、申请单号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0210) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200901UV/controlActProcess/subject/observationRequest/componentOf1/encounter/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/POOR_IN200901UV/controlActProcess/subject/observationRequest/componentOf1/encounter/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set vidPath="/POOR_IN200901UV/controlActProcess/subject/observationRequest/id/item/@extension"
		Set vid = pDocObj.GetValueAt(vidPath)
		Set pSearchTable.ApplicationID = vid
	Quit $$$OK
}

Storage Default
{
<Data name="JH0210DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0210D</DataLocation>
<DefaultData>JH0210DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0210D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0210I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0210S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class JHIPLIB.SearchTable.HL7V3.JH0404 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、申请单号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0402) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200902UV/controlActProcess/subject/placerGroup/componentOf1/encounter/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/POOR_IN200902UV/controlActProcess/subject/placerGroup/componentOf1/encounter/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set aidPath="/POOR_IN200902UV/controlActProcess/subject/placerGroup/component2/observationRequest/id/item/@extension"
		Set aid = pDocObj.GetValueAt(aidPath)
		Set pSearchTable.ApplicationID = aid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0404DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0404D</DataLocation>
<DefaultData>JH0404DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0404D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0404I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0404S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

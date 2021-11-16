Class JHIPLIB.SearchTable.HL7V3.JH0302 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、医嘱号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property OrderID As %String(COLLATION = "EXACT");

Index OrderIDIdx On OrderID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0302) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200902UV/controlActProcess/subject/placerGroup/componentOf1/encounter/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/POOR_IN200902UV/controlActProcess/subject/placerGroup/componentOf1/encounter/subject/patient/id/item[3]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set oidPath="/POOR_IN200902UV/controlActProcess/subject/placerGroup/component2/substanceAdministrationRequest/id/@extension"
		Set oid = pDocObj.GetValueAt(oidPath)
		Set pSearchTable.OrderID = oid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0302DefaultData">
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
<Value>OrderID</Value>
</Value>
<Value name="5">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0302D</DataLocation>
<DefaultData>JH0302DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0302D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0302I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0302S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class JHIPLIB.SearchTable.HL7V3.JH0401 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、申请单号和医嘱号进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

Property OrderID As %String(COLLATION = "EXACT");

Index OrderIDIdx On OrderID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0401) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200901UV/controlActProcess/subject/placerGroup/component2/observationRequest/id/item[2]/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.ApplicationID = name
		Set idPath="/POOR_IN200901UV/controlActProcess/subject/placerGroup/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set oidPath="/POOR_IN200901UV/controlActProcess/subject/placerGroup/component2/observationRequest/id/item[1]/@extension"
		Set Oid = pDocObj.GetValueAt(oidPath)
		Set pSearchTable.PatientID = Oid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0401DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>ApplicationID</Value>
</Value>
<Value name="4">
<Value>OrderID</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0401D</DataLocation>
<DefaultData>JH0401DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0401D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0401I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0401S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

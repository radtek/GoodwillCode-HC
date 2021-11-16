Class JHIPLIB.SearchTable.HL7V3.JH0403 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和医嘱号进行查询
Property OrderID As %String(COLLATION = "EXACT");

Index OrderIDIdx On OrderID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0402) As %Status [ SqlProc ]
{
	
	
		Set path="/POOR_IN200901UV/controlActProcess/subject/placerGroup/component2/substanceAdministrationRequest/id/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.OrderID = name
		Set idPath="/POOR_IN200901UV/controlActProcess/subject/placerGroup/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0403DefaultData">
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
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0403D</DataLocation>
<DefaultData>JH0403DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0403D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0403I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0403S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

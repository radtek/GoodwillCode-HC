Class JHIPLIB.SearchTable.HL7V3.JH0120 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、医嘱号和就诊号进行查询
Property VisitedID As %String(COLLATION = "EXACT");

Index VisitedIDIdx On VisitedID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property OrderID As %String(COLLATION = "EXACT");

Index OrderIDIdx On OrderID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0120) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN302011UV/controlActProcess/subject/encounterEvent/subject/patient/id/item[3]/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.VisitedID = name
		Set idPath="/PRPA_IN302011UV/controlActProcess/subject/encounterEvent/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set ridPath="/PRPA_IN302011UV/controlActProcess/subject/encounterEvent/subject/patient/id/item[2]/@extension"
		Set rid = pDocObj.GetValueAt(ridPath)
		Set pSearchTable.OrderID = rid
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0120DefaultData">
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
<Value>VisitedID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0120D</DataLocation>
<DefaultData>JH0120DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0120D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0120I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0120S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

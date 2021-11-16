Class JHIPLIB.SearchTable.HL7V3.JH0106 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和患者姓名进行查询
Property OutpatientID As %String(COLLATION = "EXACT");

Index OutpatientIDIdx On OutpatientID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0106) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN900300UV/controlActProcess/queryByParameter/careEventID/value/item/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.OutpatientID = name
		Set idPath="/PRPA_IN900300UV/controlActProcess/queryByParameter/patientId/value/item[1]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0106DefaultData">
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
<Value>OutpatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0106D</DataLocation>
<DefaultData>JH0106DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0106D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0106I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0106S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

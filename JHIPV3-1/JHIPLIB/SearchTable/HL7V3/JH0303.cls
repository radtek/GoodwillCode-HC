Class JHIPLIB.SearchTable.HL7V3.JH0303 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和医嘱号进行查询
Property OrderID As %String(COLLATION = "EXACT");

Index OrderIDIdx On OrderID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0302) As %Status [ SqlProc ]
{
	
	
		Set path="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/actId/value/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.OrderID = name
		Set idPath="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/patientId/value/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0303DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0303D</DataLocation>
<DefaultData>JH0303DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0303D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0303I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0303S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

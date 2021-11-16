Class JHIPLIB.SearchTable.HL7V3.JH0215 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和申请单号进行查询
Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0215) As %Status [ SqlProc ]
{
	
	
		Set path="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/actId/value/item/@extension"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.ApplicationID = name
		Set idPath="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/patientId/value/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0215DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApplicationID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>DocId</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0215D</DataLocation>
<DefaultData>JH0215DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0215D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0215I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0215S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

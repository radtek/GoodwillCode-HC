Class JHIPLIB.SearchTable.HL7V3.JH0704 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过科室id和科室名称进行查询
Property DoctorName As %String(COLLATION = "EXACT");

Index DoctorNameIdx On DoctorName;

Property DoctorID As %String(COLLATION = "EXACT");

Index DoctorIDIdx On DoctorID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0602) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPM_IN306010UV01/controlActProcess/queryByParameterPayload/providerName/value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.DoctorName = name
		Set idPath="/PRPM_IN306010UV01/controlActProcess/queryByParameterPayload/providerID/value/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.DoctorID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0704DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>DoctorID</Value>
</Value>
<Value name="4">
<Value>DoctorName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0704D</DataLocation>
<DefaultData>JH0704DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0704D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0704I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0704S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

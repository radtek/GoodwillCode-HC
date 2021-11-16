Class JHIPLIB.SearchTable.HL7V3.JH0604 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过科室id和科室名称进行查询
Property DepartmentName As %String(COLLATION = "EXACT");

Index DepartmentNameIdx On DepartmentName;

Property DepartmentID As %String(COLLATION = "EXACT");

Index DepartmentIDIdx On DepartmentID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0602) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPM_IN406010UV01/controlActProcess/queryByParameterPayload/organizationName/value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.DepartmentName = name
		Set idPath="/PRPM_IN406010UV01/controlActProcess/queryByParameterPayload/organizationID/value/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.DepartmentID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0604DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepartmentName</Value>
</Value>
<Value name="3">
<Value>DepartmentID</Value>
</Value>
<Value name="4">
<Value>DocId</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0604D</DataLocation>
<DefaultData>JH0604DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0604D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0604I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0604S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class JHIPLIB.SearchTable.HL7V3.JH0603 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过科室id进行查询
Property DepartmentID As %String(COLLATION = "EXACT");

Index DepartmentIDIdx On DepartmentID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0602) As %Status [ SqlProc ]
{
	
		Set idPath="/PRPM_IN403010UV01/controlActProcess/subject/registrationRequest/subject1/assignedEntity/id/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.DepartmentID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0603DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepartmentID</Value>
</Value>
<Value name="3">
<Value>DocId</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0603D</DataLocation>
<DefaultData>JH0603DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0603D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0603I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0603S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

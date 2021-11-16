Class JHIPLIB.SearchTable.HL7V3.JH0701 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过科室id进行查询
Property DoctorID As %String(COLLATION = "EXACT");

Index DoctorIDIdx On DoctorID;

Property DoctorName As %String(COLLATION = "EXACT");

Index DoctorNameIdx On DoctorName;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0602) As %Status [ SqlProc ]
{
	
		Set idPath="/PRPM_IN301010UV01/controlActProcess/subject/registrationRequest/subject1/healthCareProvider/id/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.DoctorID = id
	Set DoctorNamePath ="/PRPM_IN301010UV01/controlActProcess/subject/registrationRequest/subject1/healthCareProvider/healthCarePrincipalPerson/name"
	Set Nameid =pDocObj.GetValueAt(DoctorNamePath)
	Set pSearchTable.DoctorName =Nameid
	Quit $$$OK
}

Storage Default
{
<Data name="JH0701DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>DoctorName</Value>
</Value>
<Value name="4">
<Value>DoctorID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0701D</DataLocation>
<DefaultData>JH0701DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0701D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0701I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0701S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

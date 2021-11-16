Class JHIPLIB.SearchTable.HL7V3.JH0703 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过科室id进行查询
Property DoctorID As %String(COLLATION = "EXACT");

Index DoctorIDIdx On DoctorID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0602) As %Status [ SqlProc ]
{
	
		Set idPath="/PRPM_IN303010UV01/controlActProcess/subject/registrationRequest/subject1/healthCareProvider/id/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.DoctorID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0703DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>DoctorID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0703D</DataLocation>
<DefaultData>JH0703DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0703D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0703I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0703S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

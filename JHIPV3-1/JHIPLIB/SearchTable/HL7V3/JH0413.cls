Class JHIPLIB.SearchTable.HL7V3.JH0413 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 域ID=01门诊时为PATIENTID
/// 域ID=02住院时为PATIENTID
/// 域ID=03体检时为体检档案号 
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0413) As %Status [ SqlProc ]
{
	
	
		
		Set idPath="/POOR_IN200901UV/controlActProcess/subject/placerGroup/subject/patient/id/item[2]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0413DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0413D</DataLocation>
<DefaultData>JH0413DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0413D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0413I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0413S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

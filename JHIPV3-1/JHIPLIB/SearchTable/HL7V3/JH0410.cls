Class JHIPLIB.SearchTable.HL7V3.JH0410 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0410) As %Status [ SqlProc ]
{
	
	
		Set path="/ClinicalDocument/recordTarget/patientRole/patient/name"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/ClinicalDocument/informant/realmCode"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set AidPath="/ClinicalDocument/recordTarget/patientRole/id[4]/@extension"
	    Set Aid = pDocObj.GetValueAt(AidPath)
		Set pSearchTable.ApplicationID = Aid
		
	Quit $$$OK
}

Storage Default
{
<Data name="JH0410DefaultData">
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
<Value>PatientName</Value>
</Value>
<Value name="5">
<Value>ApplicationID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0410D</DataLocation>
<DefaultData>JH0410DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0410D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0410I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0410S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

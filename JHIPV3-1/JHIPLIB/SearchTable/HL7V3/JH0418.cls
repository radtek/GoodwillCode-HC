Class JHIPLIB.SearchTable.HL7V3.JH0418 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0418) As %Status [ SqlProc ]
{
	
	
		Set path="/RCMR_IN000002UV02/controlActProcess/subject/clinicalDocument/recordTarget/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/RCMR_IN000002UV02/controlActProcess/subject/clinicalDocument/recordTarget/patient/id/item[1]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0418DefaultData">
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
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0418D</DataLocation>
<DefaultData>JH0418DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0418D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0418I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0418S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

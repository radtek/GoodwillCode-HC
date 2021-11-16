Class JHIPLIB.SearchTable.HL7V3.JH0104 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者门急诊号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property OutpatientID As %String(COLLATION = "EXACT");

Index OutpatientIDIdx On OutpatientID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0102) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.OutpatientID = id
	Set PatientIDPath ="/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/id/item/@extension"
	Set pid =pDocObj.GetValueAt(PatientIDPath)
	Set pSearchTable.PatientID =pid
	Quit $$$OK
}

Storage Default
{
<Data name="JH0104DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>OutpatientID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0104D</DataLocation>
<DefaultData>JH0104DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0104D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0104I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0104S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

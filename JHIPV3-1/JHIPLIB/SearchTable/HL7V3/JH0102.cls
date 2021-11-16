Class JHIPLIB.SearchTable.HL7V3.JH0102 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者就诊卡id和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property VisitingCardID As %String(COLLATION = "EXACT");

Index VisitingCardIDIdx On VisitingCardID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0102) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.VisitingCardID = id
	Set PatientIDPath ="/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension"
	Set pid =pDocObj.GetValueAt(PatientIDPath)
	Set pSearchTable.PatientID =pid
	Quit $$$OK
}

Storage Default
{
<Data name="JH0102DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>VisitingCardID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0102D</DataLocation>
<DefaultData>JH0102DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0102D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0102I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0102S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

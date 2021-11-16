Class JHIPLIB.SearchTable.HL7V3.JH0101 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过就诊卡id和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property VisitingCardID As %String(COLLATION = "EXACT");

Index VisitingCardIDIdx On VisitingCardID;

Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0101) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.VisitingCardID = id
		Set PatientIDpath="/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension"
		Set patientid =pDocObj.GetValueAt(PatientIDpath)
		Set pSearchTable.PatientID = patientid
		
	Quit $$$OK
}

Storage Default
{
<Data name="JH0101DefaultData">
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
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0101D</DataLocation>
<DefaultData>JH0101DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0101D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0101I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0101S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

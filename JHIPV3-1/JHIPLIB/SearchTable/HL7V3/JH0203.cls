Class JHIPLIB.SearchTable.HL7V3.JH0203 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者id、检查申请单编号进行查询
Property PatientID As %String(COLLATION = "EXACT");

Index PatientIDIdx On PatientID;

Property ApplicationID As %String(COLLATION = "EXACT");

Index ApplicationIDIdx On ApplicationID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0202) As %Status [ SqlProc ]
{
	
	
		
		Set idPath="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/patientId/value/item[3]/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.PatientID = id
		Set cidPath="/QUMT_IN020030UV01/controlActProcess/queryByParameter/queryByParameterPayload/actId/value/item[1]/@extension"
		Set CheckID = pDocObj.GetValueAt(cidPath)
		Set pSearchTable.ApplicationID = CheckID
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0203DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>ApplicationID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0203D</DataLocation>
<DefaultData>JH0203DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0203D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0203I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0203S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

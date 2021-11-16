Class JHIPLIB.SearchTable.HL7V3.JH0103 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过患者身份证号和患者姓名进行查询
Property PatientName As %String(COLLATION = "EXACT");

Index PatientNameIdx On PatientName;

Property IDCard As %String(COLLATION = "EXACT");

Index IDCardIdx On IDCard;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0102) As %Status [ SqlProc ]
{
	
	
		Set path="/PRPA_IN201305UV02/controlActProcess/queryByParameter/parameterList/livingSubjectName/value/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.PatientName = name
		Set idPath="/PRPA_IN201305UV02/controlActProcess/queryByParameter/parameterList/livingSubjectId/value/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.IDCard = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0103DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>IDCard</Value>
</Value>
<Value name="4">
<Value>PatientName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0103D</DataLocation>
<DefaultData>JH0103DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0103D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0103I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0103S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

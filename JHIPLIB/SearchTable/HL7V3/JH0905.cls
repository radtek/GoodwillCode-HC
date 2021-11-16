Class JHIPLIB.SearchTable.HL7V3.JH0905 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过术语id和术语姓名进行查询
Property TermName As %String(COLLATION = "EXACT");

Index TermNameIdx On TermName;

Property TermID As %String(COLLATION = "EXACT");

Index TermIDIdx On TermID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0901) As %Status [ SqlProc ]
{
	
	
		Set path="/PRVS_IN000003UV01/controlActProcess/queryByParameter/valueSet/desc/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.TermName = name
		Set idPath="/PRVS_IN000003UV01/controlActProcess/queryByParameter/valueSet/id/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.TermID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0905DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>TermID</Value>
</Value>
<Value name="4">
<Value>TermName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0905D</DataLocation>
<DefaultData>JH0905DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0905D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0905I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0905S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

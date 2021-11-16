Class JHIPLIB.SearchTable.HL7V3.JH0109 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过操作人员id和操作人员姓名进行查询
Property OperatorName As %String(COLLATION = "EXACT");

Index OperatorNameIdx On OperatorName;

Property OperatorID As %String(COLLATION = "EXACT");

Index OperatorIDIdx On OperatorID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0109) As %Status [ SqlProc ]
{
	
	
		Set path="/PRSC_IN030102UV/controlActProcess/dataEnterer/assignedPerson/assignedPerson/name/item/part/@value"
		Set name = pDocObj.GetValueAt(path)
		Set pSearchTable.OperatorName = name
		Set idPath="/PRSC_IN030102UV/controlActProcess/dataEnterer/assignedPerson/id/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.OperatorID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0109DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>OperatorID</Value>
</Value>
<Value name="4">
<Value>OperatorName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0109D</DataLocation>
<DefaultData>JH0109DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0109D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0109I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0109S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

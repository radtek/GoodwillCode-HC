Class JHIPLIB.SearchTable.HL7V3.JH0110 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

/// 通过排班标识进行查询
Property SchedulingID As %String(COLLATION = "EXACT");

Index SchedulingIDIdx On SchedulingID;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.HL7V3.JH0110) As %Status [ SqlProc ]
{
	
	
		
		Set idPath="/PRSC_IN100000UV/controlActProcess/queryByParameter/scheduleId/value/item/@extension"
		Set id = pDocObj.GetValueAt(idPath)
		Set pSearchTable.SchedulingID = id
	
	Quit $$$OK
}

Storage Default
{
<Data name="JH0110DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>SchedulingID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0110D</DataLocation>
<DefaultData>JH0110DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0110D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0110I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0110S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

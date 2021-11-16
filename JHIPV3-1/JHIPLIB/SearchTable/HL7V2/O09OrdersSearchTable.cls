/// Defines a set of properties derived from Document objects of class 'EnsLib.HL7.Message'
/// that can be used in SQL to locate and join to messages of interest.
Class JHIPLIB.SearchTable.HL7V2.O09OrdersSearchTable Extends (%Persistent, Ens.VDoc.SearchTable) [ ClassType = persistent, CompileAfter = EnsLib.HL7.Message, Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS = "EnsLib.HL7.Message";

Parameter EXTENTSIZE = 4000000;

/* Re-declare indices because the superclass is abstract */
Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<Item DocType="JH2.4:OMP_O09"  PropName="MSHTypeName" Unselective="true">{1:9.1}_"_"_{1:9.2}</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="MSHControlID" PropType='String:CaseSensitive' >{1:10}</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="患者ID"   >[PID:2.1]</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="住院次数"   >[PV1:1.1]</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="住院号"   >[PID:4.1]</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="医嘱ID" >[ORC:2.1]</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="医嘱名称" >[ORC:3.1]</Item>
<Item DocType="JH2.4:OMP_O09"  PropName="患者姓名" >[PID:5.2]</Item>
</Items>
}

Storage Default
{
<Data name="O09OrdersSearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.Searc79E9.O09OrdersSeEE92D</DataLocation>
<DefaultData>O09OrdersSearchTableDefaultData</DefaultData>
<ExtentSize>4000000</ExtentSize>
<IdLocation>^JHIPLIB.Searc79E9.O09OrdersSeEE92D</IdLocation>
<IndexLocation>^JHIPLIB.Searc79E9.O09OrdersSeEE92I</IndexLocation>
<StreamLocation>^JHIPLIB.Searc79E9.O09OrdersSeEE92S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

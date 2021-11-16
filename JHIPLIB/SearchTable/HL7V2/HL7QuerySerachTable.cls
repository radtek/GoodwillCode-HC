/// Defines a set of properties derived from Document objects of class 'EnsLib.HL7.Message'
/// that can be used in SQL to locate and join to messages of interest.
Class JHIPLIB.SearchTable.HL7V2.HL7QuerySerachTable Extends (%Persistent, Ens.VDoc.SearchTable) [ ClassType = persistent, CompileAfter = EnsLib.HL7.Message, Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS = "EnsLib.HL7.Message";

Parameter EXTENTSIZE = 4000000;

/* Re-declare indices because the superclass is abstract */
Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<Item DocType=""  PropName="MSHTypeName" Unselective="true">{1:9.1}_"_"_{1:9.2}</Item>
<Item DocType=""  PropName="MSHControlID" PropType='String:CaseSensitive' >{1:10}</Item>
<Item DocType=""  PropName="卡号">[QRD:8.1]</Item>
</Items>
}

Storage Default
{
<Data name="HL7QuerySerachTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.Searc79E9.HL7QuerySer6ED0D</DataLocation>
<DefaultData>HL7QuerySerachTableDefaultData</DefaultData>
<ExtentSize>4000000</ExtentSize>
<IdLocation>^JHIPLIB.Searc79E9.HL7QuerySer6ED0D</IdLocation>
<IndexLocation>^JHIPLIB.Searc79E9.HL7QuerySer6ED0I</IndexLocation>
<StreamLocation>^JHIPLIB.Searc79E9.HL7QuerySer6ED0S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

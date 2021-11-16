/// Defines a set of properties derived from Document objects of class 'EnsLib.HL7.Message'
/// that can be used in SQL to locate and join to messages of interest.
Class JHIPLIB.SearchTable.HL7V2.A01PatientSearchTable Extends (%Persistent, Ens.VDoc.SearchTable) [ ClassType = persistent, CompileAfter = EnsLib.HL7.Message, Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS = "EnsLib.HL7.Message";

Parameter EXTENTSIZE = 4000000;

/* Re-declare indices because the superclass is abstract */
Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<Item DocType="JH2.4:ADT_A01"  PropName="MSHTypeName" Unselective="true">{1:9.1}_"_"_{1:9.2}</Item>
<Item DocType="JH2.4:ADT_A01"  PropName="MSHControlID" PropType='String:CaseSensitive' >{1:10}</Item>
<Item DocType="JH2.4:ADT_A01"  PropName="患者ID">[PID:2.1]</Item>
<Item DocType="JH2.4:ADT_A01"  PropName="患者名称" >[PID:5.2]</Item>
<Item DocType="JH2.4:ADT_A01"  PropName="身份证号" >[PID:19]</Item>
<Item DocType="JH2.4:ADT_A01"  PropName="住院次数" >[PV1:1.1]</Item>
<Item DocType="JH2.4:ADT_A01"  PropName="住院号" >[PID:4.1]</Item>
</Items>
}

Storage Default
{
<Data name="A01PatientSearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SeED36.A01PatientSDBCAD</DataLocation>
<DefaultData>A01PatientSearchTableDefaultData</DefaultData>
<ExtentSize>4000000</ExtentSize>
<IdLocation>^JHIPLIB.SeED36.A01PatientSDBCAD</IdLocation>
<IndexLocation>^JHIPLIB.SeED36.A01PatientSDBCAI</IndexLocation>
<StreamLocation>^JHIPLIB.SeED36.A01PatientSDBCAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

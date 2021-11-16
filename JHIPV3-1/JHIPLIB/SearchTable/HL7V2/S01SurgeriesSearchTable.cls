/// Defines a set of properties derived from Document objects of class 'EnsLib.HL7.Message'
/// that can be used in SQL to locate and join to messages of interest.
Class JHIPLIB.SearchTable.HL7V2.S01SurgeriesSearchTable Extends (%Persistent, Ens.VDoc.SearchTable) [ ClassType = persistent, CompileAfter = EnsLib.HL7.Message, Inheritance = right, ProcedureBlock, System = 4 ]
{

Parameter DOCCLASS = "EnsLib.HL7.Message";

Parameter EXTENTSIZE = 4000000;

/* Re-declare indices because the superclass is abstract */
Index indexValue On (PropId, PropValue, DocId) [ IdKey, Unique ];

Index indexDocId On (DocId, PropId, PropValue) [ Unique ];

XData SearchSpec [ XMLNamespace = "http://www.intersystems.com/EnsSearchTable" ]
{
<Items>
<Item DocType="JH2.4:SRM_S01"  PropName="MSHTypeName" Unselective="true">{1:9.1}_"_"_{1:9.2}</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="MSHControlID" PropType='String:CaseSensitive' >{1:10}</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="患者ID">[PID:2.1]</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="住院次数">[PV1:1.1]</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="住院号">[PID:4.1]</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="患者姓名">[PID:5.2]</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="手术编码">[ARQ:8.1]</Item>
<Item DocType="JH2.4:SRM_S01"  PropName="手术名称">[ARQ:8.2]</Item>
</Items>
}

Storage Default
{
<Data name="S01SurgeriesSearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.Searc79E9.S01Surgerie8D3BD</DataLocation>
<DefaultData>S01SurgeriesSearchTableDefaultData</DefaultData>
<ExtentSize>4000000</ExtentSize>
<IdLocation>^JHIPLIB.Searc79E9.S01Surgerie8D3BD</IdLocation>
<IndexLocation>^JHIPLIB.Searc79E9.S01Surgerie8D3BI</IndexLocation>
<StreamLocation>^JHIPLIB.Searc79E9.S01Surgerie8D3BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

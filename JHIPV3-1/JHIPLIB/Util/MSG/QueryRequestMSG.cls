/// 患者查询请求消息
Class JHIPLIB.Util.MSG.QueryRequestMSG Extends Ens.Request
{

Parameter XMLNAME = "REQUEST";

Property MPIID As %String(XMLNAME = "MPI_ID");

Property PATIENTID As %String(XMLNAME = "PATIENT_ID");

Property CARDNUMBER As %String(XMLNAME = "CARD_NUMBER");

Property CARDTYPE As %String(XMLNAME = "CARD_TYPE");

Storage Default
{
<Data name="QueryRequestMSGDefaultData">
<Subscript>"QueryRequestMSG"</Subscript>
<Value name="1">
<Value>MPIID</Value>
</Value>
<Value name="2">
<Value>PATIENTID</Value>
</Value>
<Value name="3">
<Value>CARDNUMBER</Value>
</Value>
<Value name="4">
<Value>CARDTYPE</Value>
</Value>
</Data>
<DefaultData>QueryRequestMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

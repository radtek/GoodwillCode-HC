Class JHIPLIB.Util.MSG.Item.PatientsMSG Extends (%SerialObject, %XML.Adaptor)
{

Property PATIENTINFO As list Of JHIPLIB.Util.MSG.Item.CardsMSG(XMLNAME = "PATIENT_INFO");

Storage Default
{
<Data name="PatientsMSGState">
<Value name="1">
<Value>PATIENTINFO</Value>
</Value>
</Data>
<State>PatientsMSGState</State>
<StreamLocation>^JHIPLIB.Util.MSGD24E.PatientsMSGS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

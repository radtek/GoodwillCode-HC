/// 患者注册及更新请求消息
Class JHIPLIB.Util.MSG.PatientInfoMSG Extends Ens.Request
{

Parameter XMLNAME = "PATIENT_INFO";

Property PATIENTID As %String(XMLNAME = "PATIENT_ID");

Property HOSPITALNUMBER As %String(XMLNAME = "HOSPITAL_NUMBER");

Property HOSPITALNAME As %String(XMLNAME = "HOSPITAL_NAME");

Property NAME As %String(XMLNAME = "NAME");

Property PYNAME As %String(XMLNAME = "PYNAME");

Property SEX As %String(XMLNAME = "SEX");

Property BIRTHDAY As %String(XMLNAME = "BIRTHDAY");

Property IDCARD As %String(XMLNAME = "ID_CARD");

Property COMPANY As %String(XMLNAME = "COMPANY");

Property STREETADDRESS As %String(XMLNAME = "STREET_ADDRESS");

Property ZONE As %String(XMLNAME = "ZONE");

Property CITY As %String(XMLNAME = "CITY");

Property PROVINCE As %String(XMLNAME = "PROVINCE");

Property POSTCODE As %String(XMLNAME = "POST_CODE");

Property COUNTRYCODE As %String(XMLNAME = "COUNTRY_CODE");

Property PHONEHOME As %String(XMLNAME = "PHONE_HOME");

Property PHONEBUSINESS As %String(XMLNAME = "PHONE_BUSINESS");

Property MARRIAGE As %String(XMLNAME = "MARRIAGE");

Property MOTHERPID As %String(XMLNAME = "MOTHER_PID");

Property NATION As %String(XMLNAME = "NATION");

Property BIRTHPLACE As %String(XMLNAME = "BIRTH_PLACE");

Property BLOODTYPE As %String(XMLNAME = "BLOOD_TYPE");

Property NATIONALITY As %String(XMLNAME = "NATIONALITY");

Property DEATHDATE As %String(XMLNAME = "DEATHDATE");

Property DEATHID As %String(XMLNAME = "DEATHID");

Property PROFESSION As %String(XMLNAME = "PROFESSION");

Property CONTACTNAME1 As %String(XMLNAME = "CONTACT_NAME1");

Property CONTACTPHONE1 As %String(XMLNAME = "CONTACT_PHONE1");

Property CONTACTRELATION1 As %String(XMLNAME = "CONTACT_RELATION1");

Property CONTACTNAME2 As %String(XMLNAME = "CONTACT_NAME2");

Property CONTACTPHONE2 As %String(XMLNAME = "CONTACT_PHONE2");

Property CONTACTRELATION2 As %String(XMLNAME = "CONTACT_RELATION2");

Property GMTCREATE As %String(XMLNAME = "GMT_CREATE");

Property GMTMODIFIED As %String(XMLNAME = "GMT_MODIFIED");

Property DATASOURCE As %String(XMLNAME = "DATA_SOURCE");

Property SYSTEMID As %String(XMLNAME = "SYSTEM_ID");

Property DOMIANID As %String(XMLNAME = "DOMIAN_ID");

Property CARDS As JHIPLIB.Util.MSG.Item.CardsMSG(XMLNAME = "CARDS");

Storage Default
{
<Data name="PatientInfoMSGDefaultData">
<Subscript>"PatientInfoMSG"</Subscript>
<Value name="1">
<Value>PATIENTID</Value>
</Value>
<Value name="2">
<Value>HOSPITALNUMBER</Value>
</Value>
<Value name="3">
<Value>HOSPITALNAME</Value>
</Value>
<Value name="4">
<Value>NAME</Value>
</Value>
<Value name="5">
<Value>PYNAME</Value>
</Value>
<Value name="6">
<Value>SEX</Value>
</Value>
<Value name="7">
<Value>BIRTHDAY</Value>
</Value>
<Value name="8">
<Value>IDCARD</Value>
</Value>
<Value name="9">
<Value>COMPANY</Value>
</Value>
<Value name="10">
<Value>STREETADDRESS</Value>
</Value>
<Value name="11">
<Value>ZONE</Value>
</Value>
<Value name="12">
<Value>CITY</Value>
</Value>
<Value name="13">
<Value>PROVINCE</Value>
</Value>
<Value name="14">
<Value>POSTCODE</Value>
</Value>
<Value name="15">
<Value>COUNTRYCODE</Value>
</Value>
<Value name="16">
<Value>PHONEHOME</Value>
</Value>
<Value name="17">
<Value>PHONEBUSINESS</Value>
</Value>
<Value name="18">
<Value>MARRIAGE</Value>
</Value>
<Value name="19">
<Value>MOTHERPID</Value>
</Value>
<Value name="20">
<Value>NATION</Value>
</Value>
<Value name="21">
<Value>BIRTHPLACE</Value>
</Value>
<Value name="22">
<Value>BLOODTYPE</Value>
</Value>
<Value name="23">
<Value>NATIONALITY</Value>
</Value>
<Value name="24">
<Value>DEATHDATE</Value>
</Value>
<Value name="25">
<Value>DEATHID</Value>
</Value>
<Value name="26">
<Value>PROFESSION</Value>
</Value>
<Value name="27">
<Value>CONTACTNAME1</Value>
</Value>
<Value name="28">
<Value>CONTACTPHONE1</Value>
</Value>
<Value name="29">
<Value>CONTACTRELATION1</Value>
</Value>
<Value name="30">
<Value>CONTACTNAME2</Value>
</Value>
<Value name="31">
<Value>CONTACTPHONE2</Value>
</Value>
<Value name="32">
<Value>CONTACTRELATION2</Value>
</Value>
<Value name="33">
<Value>GMTCREATE</Value>
</Value>
<Value name="34">
<Value>GMTMODIFIED</Value>
</Value>
<Value name="35">
<Value>DATASOURCE</Value>
</Value>
<Value name="36">
<Value>SYSTEMID</Value>
</Value>
<Value name="37">
<Value>DOMIANID</Value>
</Value>
<Value name="38">
<Value>CARDS</Value>
</Value>
</Data>
<DefaultData>PatientInfoMSGDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

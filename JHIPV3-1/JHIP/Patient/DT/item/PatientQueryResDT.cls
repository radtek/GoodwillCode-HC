Class JHIP.Patient.DT.item.PatientQueryResDT Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, EnsLib.EDI.XML.Document) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.EDI.XML.Document' sourceDocType='JH2.4:RSP_K21' create='new' language='objectscript' >
<annotation>患者查询请求消息转换</annotation>
<if condition='source.{MSA:AcknowledgmentCode}="AA"' >
<true>
<code>
<![CDATA[ 
  
   
	Set guid=##class(%SYSTEM.Util).CreateGUID()
	Set CreateTime=$TRanslate($ZDT($H,3),"-,:, ")
	Set pResponse=##class(EnsLib.EDI.XML.Document).%New()
	
 
  	&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='患者基本信息查询服务T')
  	Set pResponse=pResponse.ImportFromString(FileBody,.status)
  	Set status=pResponse.SetValueAt(guid,"/PRPA_IN201306UV02/id/@extension")
  	Set status=pResponse.SetValueAt(CreateTime,"/PRPA_IN201306UV02/creationTime/@value")
  	
  	Set target=pResponse]]></code>
<assign value='target.SetValueAt(source.{MSH:ProcessingID.processingID},"/PRPA_IN201306UV02/processingCode/@code")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{MSA:AcknowledgmentCode},"/PRPA_IN201306UV02/acknowledgement/@typeCode")' property='Status' action='set' />
<foreach property='source.{PIDgrp.PID()}' key='k1' >
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientID.ID},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):BirthPlace},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/birthPlace/addr/part/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):Profession},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asEmployee/occupationCode/displayName/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):Citizenship(1).identifierST},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asCitizen/politicalNation/name")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):EthnicGroup(1).identifierST},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/ethnicGroupCode/item/displayName/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):MaritalStatus.identifierST},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/maritalStatusCode/displayName/@value")' property='Status' action='set' />
<if condition='source.{PIDgrp.PID(k1):MaritalStatus.identifierST}="未婚"' >
<true>
<assign value='target.SetValueAt("10","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/maritalStatusCode/@code")' property='Status ' action='set' />
</true>
<false>
<if condition='source.{PIDgrp.PID(k1):MaritalStatus.identifierST}="已婚"' >
<true>
<assign value='target.SetValueAt("20","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/maritalStatusCode/@code")' property='Status ' action='set' />
</true>
<false>
<assign value='target.SetValueAt("90","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/maritalStatusCode/@code")' property='Status ' action='set' />
</false>
</if>
</false>
</if>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PhoneNumberHome(1).Phonenumber},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/telecom/item/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1).addresstype},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/birthPlace/addr/@use")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1).ziporpostalcode},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/addr/item/part[8]/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1).city},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/addr/item/part[3]/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1).stateorprovince},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/addr/item/part[2]/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1).otherdesignation},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/addr/item/part[4]/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1).streetaddressSAD.streetname},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/addr/item/part[5]/@value")' property='Status' action='set' />
<foreach property='source.{PIDgrp.PID(k1):PatientIdentifierList()}' key='k' >
<if condition='source.{PIDgrp.PID(k1):PatientIdentifierList(k).identifiertypecodeID}="PID"' >
<true>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientIdentifierList(k).ID},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")' property='Status' action='set' />
</true>
<false>
<if condition='source.{PIDgrp.PID(k1):PatientIdentifierList(k).identifiertypecodeID}="PN" ' >
<true>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientIdentifierList(k).ID},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/id/item/@extension")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientIdentifierList(k).identifiertypecodeID},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/idCategory/displayName/@value")' property='Status ' action='set' />
</true>
<false>
<if condition='source.{PIDgrp.PID(k1):PatientIdentifierList(k).identifiertypecodeID}="HCN" ' >
<true>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientIdentifierList(k).ID},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asOtherIDs[1]/id/item/@extension")' property='Status' action='set' />
</true>
<false>
<if condition='source.{PIDgrp.PID(k1):PatientIdentifierList(k).identifiertypecodeID}="HPFN" ' >
<true>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientIdentifierList(k).ID},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asOtherIDs[2]/id/item/@extension")' property='Status' action='set' />
</true>
</if>
</false>
</if>
</false>
</if>
</false>
</if>
</foreach>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientName(1).familyname.surname},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/name/item/part/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):DateTimeOfBirth.timeofanevent},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/birthTime/@value")' property='Status' action='set' />
<if condition='source.{PIDgrp.PID(k1):AdministrativeSex}="F"' >
<true>
<assign value='target.SetValueAt("女性","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")' property='Status' action='set' />
<assign value='target.SetValueAt("2","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/@code")' property='Status' action='set' />
</true>
<false>
<if condition='source.{PIDgrp.PID(k1):AdministrativeSex}="M"' >
<true>
<assign value='target.SetValueAt("1","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/@code")' property='Status ' action='set' />
<assign value='target.SetValueAt("男性","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")' property='Status' action='set' />
</true>
<false>
<assign value='target.SetValueAt("9","/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/@code")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):AdministrativeSex},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")' property='Status' action='set' />
</false>
</if>
</false>
</if>
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PatientAddress(1)},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/addr/item/part[1]/@value")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{PIDgrp.PID(k1):PhoneNumberBusiness().Phonenumber},"/PRPA_IN201306UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asEmployee/employerOrganization/contactParty/telecom/item/@value")' property='Status' action='set' />
</foreach>
</true>
<false>
<code>
<![CDATA[ 
  
   
	Set guid=##class(%SYSTEM.Util).CreateGUID()
	Set CreateTime=$TRanslate($ZDT($H,3),"-,:, ")
	Set pResponse=##class(EnsLib.EDI.XML.Document).%New()
	
 
  	&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='患者基本信息查询服务F')
  	Set pResponse=pResponse.ImportFromString(FileBody,.status)
  	Set status=pResponse.SetValueAt(guid,"/PRPA_IN201306UV02/id/@extension")
  	Set status=pResponse.SetValueAt(CreateTime,"/PRPA_IN201306UV02/creationTime/@value")
  	
  	Set target=pResponse]]></code>
<assign value='target.SetValueAt("没有查询到该患者信息，请确认！","/PRPA_IN201306UV02/acknowledgement/acknowledgementDetail/text")' property='Status' action='set' />
</false>
</if>
<assign value='target.SetValueAt(source.{MSH:SendingApplication.namespaceID},"/PRPA_IN201306UV02/sender/device/id/item/@extension")' property='Status' action='set' />
<assign value='target.SetValueAt(source.{MSH:ReceivingApplication.namespaceID},"/PRPA_IN201306UV02/receiver/device/id/item/@extension")' property='Status' action='set' />
</transform>
}

}

Class JHIP.Patient.DT.item.itemPatientAddDT Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, JHIPLIB.Util.MSG.PatientInfoMSG) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='JHIPLIB.Util.MSG.PatientInfoMSG' create='new' language='objectscript' >
<annotation>患者信息注册DT</annotation>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")' property='target.PATIENTID' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/providerOrganization/id/item/@extension")' property='target.HOSPITALNUMBER' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/providerOrganization/name/item/part/@value")' property='target.HOSPITALNAME' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/name/item/part/@value")' property='target.NAME' action='set' />
<assign value='##class(Ens.Util.FunctionSet).ConvertDateTime(source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/birthTime/@value"), "%Y%m%d","%Y-%m-%d ")' property='target.BIRTHDAY' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/telecom/item/@value")' property='target.PHONEHOME' action='set' />
<assign value='0' property='SEX' action='set' />
<if condition='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")="男性"' >
<true>
<assign value='"M"' property='target.SEX' action='set' />
<assign value='1' property='SEX' action='set' />
</true>
</if>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asEmployee/employerOrganization/contactParty/telecom/item/@value")' property='target.PHONEBUSINESS' action='set' />
<if condition='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")="女性"' >
<true>
<assign value='"F"' property='target.SEX' action='set' />
<assign value='2' property='SEX' action='set' />
</true>
</if>
<if condition='SEX=0' >
<true>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")' property='target.SEX' action='set' />
</true>
</if>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/maritalStatusCode/displayName/@value")' property='target.MARRIAGE' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/id/item/@extension")' property='target.IDCARD' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asEmployee/employerOrganization/name/item/part/@value")' property='target.COMPANY' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asCitizen/politicalNation/name")' property='target.NATIONALITY' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/ethnicGroupCode/item/displayName/@value")' property='target.NATION' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/birthPlace/addr/part/@value")' property='target.BIRTHPLACE' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asEmployee/occupationCode/displayName/@value")' property='target.PROFESSION' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/personalRelationship/relationshipHolder1/name/item/part/@value")' property='target.CONTACTNAME1' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/personalRelationship/telecom/item/@value")' property='target.CONTACTPHONE1' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/sender/device/id/item/@extension")' property='target.DATASOURCE' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")' property='target.SYSTEMID' action='set' />
<assign value='##class(Ens.Util.FunctionSet).ConvertDateTime(source.GetValueAt("/PRPA_IN201311UV02/creationTime/@value"), "%Y%m%d%H%M%S","%Y-%m-%d %H:%M:%S")' property='target.GMTCREATE' action='set' />
<assign value='1' property='a' action='set' />
<if condition='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")&apos;=""' >
<true>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")' property='target.CARDS.CARDINFO.(a).IDNUMBER' action='set' />
<assign value='"PI"' property='target.CARDS.CARDINFO.(a).CARDTYPE' action='set' />
<assign value='a+1' property='a' action='set' />
</true>
</if>
<if condition='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/id/item/@extension")&apos;=""' >
<true>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/id/item/@extension")' property='target.CARDS.CARDINFO.(a).IDNUMBER' action='set' />
<assign value='"PN"' property='target.CARDS.CARDINFO.(a).CARDTYPE' action='set' />
<assign value='a+1' property='a' action='set' />
</true>
</if>
<if condition='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asOtherIDs[1]/id/item/@extension")&apos;=""' >
<true>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asOtherIDs[1]/id/item/@extension")' property='target.CARDS.CARDINFO.(a).IDNUMBER' action='set' />
<assign value='"HCN"' property='target.CARDS.CARDINFO.(a).CARDTYPE' action='set' />
<assign value='a+1' property='a' action='set' />
</true>
</if>
<if condition='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asOtherIDs[2]/id/item/@extension")&apos;=""' >
<true>
<assign value='source.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/asOtherIDs[2]/id/item/@extension")' property='target.CARDS.CARDINFO.(a).IDNUMBER' action='set' />
<assign value='"HPFN"' property='target.CARDS.CARDINFO.(a).CARDTYPE' action='set' />
<assign value='a+1' property='a' action='set' />
</true>
</if>
</transform>
}

}

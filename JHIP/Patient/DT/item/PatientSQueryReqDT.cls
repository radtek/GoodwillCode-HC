Class JHIP.Patient.DT.item.PatientSQueryReqDT Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, JHIPLIB.Util.MSG.QueryRequestMSG) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='JHIPLIB.Util.MSG.QueryRequestMSG' create='new' language='objectscript' >
<annotation>患者查询请求消息转换</annotation>
<assign value='source.GetValueAt("/PRPA_IN201305UV02/controlActProcess/queryByParameter/parameterList/id/@extension")' property='target.PATIENTID' action='set' />
<assign value='source.GetValueAt("/PRPA_IN201305UV02/controlActProcess/queryByParameter/parameterList/livingSubjectId/value/item/@extension")' property='target.CARDNUMBER' action='set' />
<assign value='"PN"' property='target.CARDTYPE' action='set' />
</transform>
}

}

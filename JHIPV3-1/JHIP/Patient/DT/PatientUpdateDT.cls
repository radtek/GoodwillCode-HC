Class JHIP.Patient.DT.PatientUpdateDT Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, JHIPLIB.Util.MSG.JHRequestMsg) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='JHIPLIB.Util.MSG.JHRequestMsg' create='new' language='objectscript' >
<annotation>患者信息更新DT</annotation>
<subtransform class='JHIP.Patient.DT.item.itemPatientUpDateDT' targetObj='parg' sourceObj='source' />
<code>
<![CDATA[ Set tSC=parg.XMLExportToString(.pargStr)]]></code>
<assign value='"JH0002"' property='target.action' action='set' />
<assign value='pargStr' property='target.pArg.(1)' action='set' />
</transform>
}

}

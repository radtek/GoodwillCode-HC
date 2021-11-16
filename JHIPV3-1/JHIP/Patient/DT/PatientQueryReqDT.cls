Class JHIP.Patient.DT.PatientQueryReqDT Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, JHIPLIB.Util.MSG.JHRequestMsg) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='JHIPLIB.Util.MSG.JHRequestMsg' create='new' language='objectscript' >
<annotation>2.4转患者查询XML</annotation>
<subtransform class='JHIP.Patient.DT.item.PatientSQueryReqDT' targetObj='parg' sourceObj='source' />
<assign value='"JH0004"' property='target.action' action='set' />
<code>
<![CDATA[ Set tSC=parg.XMLExportToString(.pargStr)]]></code>
<assign value='pargStr' property='target.pArg.(1)' action='set' />
</transform>
}

}

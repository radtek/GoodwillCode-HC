Class JHIPLIB.MY.DT.HL7V24 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.EDI.XML.Document, EnsLib.HL7.Message) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.HL7.Message' targetDocType='2.4:RSP_K21' create='new' language='objectscript' >
<assign value='"|"' property='target.{MSH:FieldSeparator}' action='set' />
<assign value='"^~\&amp;"' property='target.{MSH:EncodingCharacters}' action='set' />
<assign value='"10004"' property='target.{PIDgrp.PID:PatientID.ID}' action='set' />
</transform>
}

}

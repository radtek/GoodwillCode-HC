Class JHIPLIB.MY.DT.HL7V2 Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, EnsLib.EDI.XML.Document) ]
{

/// DTL Definition.
XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform targetClass='EnsLib.EDI.XML.Document' targetDocType='' sourceClass='EnsLib.HL7.Message' sourceDocType='2.4:RSP_K24' create='new' language='objectscript'>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

}

/// 00.患者管理服务的BP
Class JHIPLIB.JHIPV5.SyncPartner.BP.SyncPartnerBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' component='1' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<call name='调用同步合作伙伴BO' target='JHIP同步合作伙伴BO' async='0' xpos='200' ypos='250' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</process>
}

}

/// 
Class JHIPV5.JHREG.BP.Domain.DomainManagementBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2015' >
<context>
<property name='Method' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action="addNameSpace"' name='新增域' >
<call name='新增域' target='域管理域信息新增BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getNameSpace"' name='域名称获取' >
<call name='域名称获取' target='域管理域名称获取BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getNameSpaceDetails"' name='域详情' >
<call name='域详细信息获取' target='域管理域详情获取BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="DeleteNameSpace"' name='删除域' >
<call name='删除域' target='域管理域信息删除BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="editNameSpace"' name='编辑域' >
<call name='编辑域' target='域管理域信息编辑BO' async='0' xpos='1415' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

}

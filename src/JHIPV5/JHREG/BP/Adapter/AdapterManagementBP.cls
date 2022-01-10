/// 
Class JHIPV5.JHREG.BP.Adapter.AdapterManagementBP Extends Ens.BusinessProcessBPL
{

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
<case condition='request.action="addAdapterName"' name='新增适配器' >
<call name='新增适配器' target='适配器管理适配器信息新增BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getAdapter"' name='适配器名称获取' >
<call name='适配器名称获取' target='适配器管理适配器名称获取BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getAdapterNameDetails"' name='适配器详情' >
<call name='适配器详细信息获取' target='适配器管理详情获取BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="deleteAdapterName"' name='删除适配器' >
<call name='删除适配器' target='适配器管理适配器信息删除BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="editAdapterName"' name='编辑适配器' >
<call name='编辑适配器' target='适配器管理适配器信息编辑BO' async='0' xpos='1415' ypos='400' >
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

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

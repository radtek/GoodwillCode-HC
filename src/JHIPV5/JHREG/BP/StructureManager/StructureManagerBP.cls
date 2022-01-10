/// 
Class JHIPV5.JHREG.BP.StructureManager.StructureManagerBP Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='3635' >
<context>
<property name='Method' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='分发' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action="getAllFiles"' name='查询' >
<call name='结构管理获取所有文件BO' target='结构管理获取所有文件BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="deleteFiles"' >
<call name='结构管理删除所选文件BO' target='结构管理删除所选文件BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="addSchema"' >
<call name='结构管理导入xml结构BO' target='结构管理导入xml结构BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getXMLSchema"' >
<call name='结构管理xml结构查询BO' target='结构管理xml结构查询BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getHL7Schema"' >
<call name='结构管理hl7结构查询BO' target='结构管理hl7结构查询BO' async='0' xpos='1415' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="deleteSchema"' >
<call name='结构管理删除xml结构BO' target='结构管理删除xml结构BO' async='0' xpos='1685' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="editSchema"' >
<call name='结构管理编辑结构BO' target='结构管理编辑结构BO' async='0' xpos='1955' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getSchema"' >
<call name='结构管理获取结构BO' target='结构管理获取结构BO' async='0' xpos='2225' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getSchemaDetail"' >
<call name='结构管理获取结构详情BO' target='结构管理获取结构详情BO' async='0' xpos='2495' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getSearchValue"' >
<call name='结构管理获取结构名称BO' target='结构管理获取结构名称BO' async='0' xpos='2765' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="editStatus"' >
<call name='结构管理启停状态BO' target='结构管理启停状态BO' async='0' xpos='3035' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<default/>
</switch>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

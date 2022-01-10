/// 
Class JHIPV5.JHREG.BP.StructureManagement.StrManagerBp Extends Ens.BusinessProcessBPL
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
<switch name='分发' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action="hl7select"' name='查询' >
<call name='hl7结构查询BO' target='HL7结构查询' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="xmlselect"' name='订阅关系创建查询等' >
<call name='XML结构查询BO' target='XML结构查询' async='0' xpos='605' ypos='400' >
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

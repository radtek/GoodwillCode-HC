/// 1
Class JHIPV5.JHREG.BP.RuleTranslation.RuleTranslationBp Extends Ens.BusinessProcessBPL
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
<case condition='request.action="getRuleTrunslationName"' name='查询' >
<call name='规则转换获取规则转换名BO' target='规则转换获取规则转换名BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="addDT"' >
<call name='规则转换创建DTBO' target='规则转换创建DTBO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getRuleTrunsDetail"' >
<call name='规则转换获取规则转换详情BO' target='规则转换获取规则转换详情BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="deleteRule"' >
<call name='规则转换删除规则转换BO' target='规则转换删除规则转换BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getStandard"' >
<call name='规则转换获取标准BO' target='规则转换获取标准BO' async='0' xpos='1415' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getRuleTrunslationNameSearch"' >
<call name='规则转换获取规则转换查询BO' target='规则转换获取规则转换查询BO' async='0' xpos='1685' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getRuleTrunslationMessage"' >
<call name='规则转换获取消息类型BO' target='规则转换获取消息类型BO' async='0' xpos='1955' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="addXslt"' >
<call name='规则转换添加xslt文件BO' target='规则转换添加xslt文件BO' async='0' xpos='2225' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="editRule"' >
<call name='规则转换编辑规则BO' target='规则转换编辑规则BO' async='0' xpos='2495' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getFileBody"' >
<call name='规则转换获取fileBodyBO' target='规则转换获取fileBodyBO' async='0' xpos='2765' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getNameSpace"' >
<call name='规则转换获取使用的域BO' target='规则转换获取使用的域BO' async='0' xpos='3035' ypos='400' >
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

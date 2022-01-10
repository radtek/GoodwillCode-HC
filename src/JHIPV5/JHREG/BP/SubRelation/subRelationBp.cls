/// 
Class JHIPV5.JHREG.BP.SubRelation.subRelationBp Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2555' >
<context>
<property name='Method' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='700' >
<code xpos='200' ypos='250' >
<![CDATA[     $$$TRACE(request.action)
 
    IF (request.action'="getSubRelate")&&(request.action'="getSearchTheme")&&(request.action'="selectSub")&&(request.action'="getSearchSubscriber")&&(request.action'="getTrunsRules")&&(request.action'="getSearchValue")
    {
    
       SET TSC=request.pArg.Insert("other") 
     
        
     
     }
     else {
     
      SET TSC=request.pArg.Insert(request.action) 
     
     }]]>
</code>
<switch name='分发' xpos='200' ypos='350' xend='200' yend='600' >
<case condition='request.pArg.GetAt(2)="getSubRelate"' name='查询' >
<call name='订阅关系查询BO' target='订阅关系查询BO' async='0' xpos='335' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.pArg.GetAt(2)="other"' name='订阅关系创建查询等' >
<call name='订阅关系BO' target='订阅关系BO' async='0' xpos='605' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.pArg.GetAt(2)="getSearchTheme"' >
<call name='订阅关系获取未配置主题BO' target='订阅关系获取未配置主题BO' async='0' xpos='875' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.pArg.GetAt(2)="selectSub"' >
<call name='订阅关系获取订户BO' target='订阅关系获取订户BO' async='0' xpos='1145' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.pArg.GetAt(2)="getSearchSubscriber"' >
<call name='订阅关系获取订户列表BO' target='订阅关系获取订户列表BO' async='0' xpos='1415' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.pArg.GetAt(2)="getTrunsRules"' >
<call name='订阅关系获取规则转换BO' target='订阅关系获取规则转换BO' async='0' xpos='1685' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.pArg.GetAt(2)="getSearchValue"' >
<call name='订阅关系获取查询条件BO' target='订阅关系获取查询条件BO' async='0' xpos='1955' ypos='500' >
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

}

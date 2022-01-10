/// 
Class JHIPV5.JHREG.BP.MesRretr.MessageRetrievalBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='4445' >
<context>
<property name='Method' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='分发' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action="getActivityTheme"' name='获取活动主题' >
<call name='消息检索获取活动主题BO' target='消息检索获取活动主题BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getNumOfnewPatient"' name='当日患者获取' >
<call name='消息检索当日患者获取BO' target='消息检索当日患者获取BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="MessageSearch"' name='消息检索消息内容获取BO' >
<call name='消息检索消息内容获取BO' target='消息检索消息内容获取BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="MessageDetails"' name='消息检索获取消息正文BO' >
<call name='消息检索获取消息正文BO' target='消息检索获取消息正文BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="GetMessageTrack"' name='消息检索消息跟踪获取BO' >
<call name='消息检索消息跟踪获取BO' target='消息检索消息跟踪获取BO' async='0' xpos='1415' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="GetThemeName"' name='消息检索服务名称获取BO' >
<call name='消息检索服务名称获取BO' target='消息检索服务名称获取BO' async='0' xpos='1685' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="ResendMessage"' name='消息检索批量消息重发BO' >
<call name='消息检索批量消息重发BO' target='消息检索批量消息重发BO' async='0' xpos='1955' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="ConditionalExpansion"' name='消息检索查询条件获取BO' >
<call name='消息检索查询条件获取BO' target='消息检索查询条件获取BO' async='0' xpos='2225' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="SaveCollectMessage"' name='消息检索收藏' >
<call name='消息检索查询条件收藏BO' target='消息检索查询条件收藏BO' async='0' xpos='2495' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="DelCollectMessage"' name='取消收藏' >
<call name='取消收藏' target='消息检索取消收藏条件BO' async='0' xpos='2765' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="GetCollectMessage"' name='收藏列表' >
<call name='消息检索获取收藏列表BO' target='消息检索获取收藏列表BO' async='0' xpos='3035' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="GetCollectMessageByID"' name='收藏详情' >
<call name='消息检索获取收藏详情BO' target='消息检索获取收藏详情BO' async='0' xpos='3305' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="GetResendMessage"' name='重发消息获取' >
<call name='重发消息获取' target='消息检索编辑重发获取BO' async='0' xpos='3575' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="EditResendMessage"' name='编辑重发' >
<call name='编辑重发' target='消息检索编辑重发BO' async='0' xpos='3845' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getPatientList"' name='患者列表' >
<call name='患者列表' target='消息检索患者列表获取BO' async='0' xpos='376' ypos='157' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getMessageByDocID"' name='根据DOCID获取消息' >
<call name='docID' target='消息检索根据DocId获取消息BO' async='0' xpos='677' ypos='124' >
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

/// 
Class JHIP.JHIPV5.MDM.BP.SendTermBP Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='JHIPLIB.Util.MSG.JHRequestMsg' response='Ens.StringResponse' height='2000' width='2015' >
<context>
<property name='Sub' type='%String' instantiate='0' >
<annotation><![CDATA[订阅系统]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='len' type='%Integer' instantiate='0' >
<annotation><![CDATA[订阅系统集合长度]]></annotation>
</property>
<property name='key' type='%Integer' initialexpression='1' instantiate='0' />
<property name='msgXml' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='ALIASNAME' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='PublishSystems' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
<property name='DICTMessage' type='JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG' instantiate='0' />
<property name='subname' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='判断消息类型' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action="JH0705"' name='字典订阅发布' >
<sequence name='字典订阅发布' xpos='335' ypos='400' xend='200' yend='550' >
<assign name="获取消息字符串" property="msgXml" value="request.pArg.GetAt(1)" action="set" xpos='200' ypos='250' />
<code name='字典订阅信息转换' xpos='200' ypos='350' >
<annotation><![CDATA[将字典订阅信息由String串转换为对应的Message消息]]></annotation>
<![CDATA[ $$$TRACE("msgXml"_msgXml)
 ;Set SubscribersMSG=##class(JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG).%New()
 Set tSC= ##Class(JHIPLIB.Util.ClassAndXML).Xml2Object(msgXml,"REQUEST","JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG",.SubscribersMSG)
 Set context.DICTMessage=SubscribersMSG
 $$$TRACE("tSC"_tSC)]]>
</code>
<call name='调用字典订阅发布BO' target='JHIPV5字典订阅发布信息同步BO' async='0' xpos='200' ypos='450' >
<request type='JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG' >
<assign property="callrequest" value="context.DICTMessage" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='request.action="JH0704"' name='字典查询' >
<call name='主数据字典查询' target='JHIPV5主数据服务BO' async='1' xpos='605' ypos='400' >
<annotation><![CDATA[主数据字典查询]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='(request.action="JH0701") || (request.action="JH0702") || (request.action="JH0703")' name='字典同步' >
<sequence name='字典增删改服务' xpos='875' ypos='400' xend='200' yend='650' >
<annotation><![CDATA[字典增删改服务，需要解析订阅系统]]></annotation>
<code name='获取消息中字典名称' xpos='200' ypos='250' >
<annotation><![CDATA[获取消息中字典名称,查询字典对应的订阅系统]]></annotation>
<![CDATA[ Set xmlStr=request.pArg.GetAt(1)
 $$$TRACE("xmlStr"_xmlStr)
 Set DictMessage=##Class(JHIPLIB.Util.MSG.GetDictMSG).%New()
 Set tSC=##Class(JHIPLIB.Util.ClassAndXML).Xml2Object(xmlStr,"REQUEST","JHIPLIB.Util.MSG.GetDictMSG",.DictMessage)
 Set context.ALIASNAME=DictMessage.ALIASNAME
 $$$TRACE(context.ALIASNAME)]]>
</code>
<sql name='查询订阅系统' xpos='200' ypos='350' >
<annotation><![CDATA[查询订阅系统]]></annotation>
<![CDATA[SELECT PublishSystems INTO :context.PublishSystems FROM JHIPLIB_JHIPV5_Term_DB.Subscribers WHERE DictName=:context.ALIASNAME]]>
</sql>
<code name='插入订阅系统并获取长度' xpos='200' ypos='450' >
<annotation><![CDATA[将字典增删改消息中的系统修改为与数据库相同，并获取系统集合的长度，以便后续处理]]></annotation>
<![CDATA[ if context.PublishSystems=""{
 }else{
 Set DictMessage.SUBSCRIBERS= context.PublishSystems
 }
 
 Set context.len=$LISTLENGTH($LISTFROMSTRING(DictMessage.SUBSCRIBERS,","))
 Set tSC=##Class(JHIPLIB.Util.ClassAndXML).Object2Xml(DictMessage,"REQUEST",.xmlStr)
 Do request.pArg.RemoveAt(1)
 Do request.pArg.InsertAt(xmlStr,1)
 Set context.subname=DictMessage.SUBSCRIBERS]]>
</code>
<while name='遍历订阅系统发布消息' condition='context.key&lt;=context.len' xpos='200' ypos='550' xend='200' yend='900' >
<annotation>遍历订阅系统发布消息</annotation>
<assign name="获取订阅系统" property="context.Sub" value="$ZSTRIP( ($LISTGET($LISTFROMSTRING(context.subname,&quot;,&quot;),context.key)),&quot;&lt;&gt;W&quot;)" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[获取订阅系统]]></annotation>
</assign>
<code xpos='200' ypos='350' >
<![CDATA[ $$$TRACE("sub"_context.Sub)]]>
</code>
<switch name='判断订阅系统调用对应服务' xpos='200' ypos='450' xend='200' yend='700' >
<annotation><![CDATA[判断订阅系统调用对应服务]]></annotation>
<case condition='context.Sub="bis"' name='BIS' >
<call name='调用BO' target='调用BIS接口BO' async='0' xpos='335' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="emr"' name='EMR' >
<call name='调用EMR' target='电子病历接收BO' async='0' xpos='605' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="li&apos;s"' name='LIS' >
<call name='调用LIS' target='调用LIS接口BO' async='0' xpos='875' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="pacs"' name='PACS' >
<call name='调用PACS' target='调用PACS接口BO' async='1' xpos='1145' ypos='600' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
</case>
<case condition='context.Sub="jhip"' name='JHIP' >
<call name='字典同步' target='JHIPV5主数据服务BO' async='0' xpos='1415' ypos='600' >
<annotation><![CDATA[字典变更时，将消息推给主数据]]></annotation>
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
<code xpos='200' ypos='800' >
<![CDATA[ Set context.key=context.key+1]]>
</code>
</while>
</sequence>
</case>
<case condition='request.action="JH0706"' name='全字典发布' >
<sequence name='字典增删改服务' xpos='1145' ypos='400' xend='200' yend='650' >
<annotation><![CDATA[字典增删改服务，需要解析订阅系统]]></annotation>
<code name='获取消息中字典名称' xpos='200' ypos='250' >
<annotation><![CDATA[获取消息中字典名称,查询字典对应的订阅系统]]></annotation>
<![CDATA[ Set xmlStr=request.pArg.GetAt(1)
 $$$TRACE("xmlStr"_xmlStr)
 Set DictMessage=##Class(JHIPLIB.Util.MSG.GetDictMSG).%New()
 Set tSC=##Class(JHIPLIB.Util.ClassAndXML).Xml2Object(xmlStr,"REQUEST","JHIPLIB.Util.MSG.GetDictMSG",.DictMessage)
 Set context.ALIASNAME=DictMessage.ALIASNAME
 $$$TRACE(context.ALIASNAME)]]>
</code>
<sql name='查询订阅系统' xpos='200' ypos='350' >
<annotation><![CDATA[查询订阅系统]]></annotation>
<![CDATA[SELECT PublishSystems INTO :context.PublishSystems FROM JHIPLIB_JHIPV5_Term_DB.Subscribers WHERE DictName=:context.ALIASNAME]]>
</sql>
<code name='插入订阅系统并获取长度' xpos='200' ypos='450' >
<annotation><![CDATA[将字典增删改消息中的系统修改为与数据库相同，并获取系统集合的长度，以便后续处理]]></annotation>
<![CDATA[ if context.PublishSystems=""{
 }else{
 Set DictMessage.SUBSCRIBERS= context.PublishSystems
 }
 
 Set context.len=$LISTLENGTH($LISTFROMSTRING(DictMessage.SUBSCRIBERS,","))
 Set tSC=##Class(JHIPLIB.Util.ClassAndXML).Object2Xml(DictMessage,"REQUEST",.xmlStr)
 Do request.pArg.RemoveAt(1)
 Do request.pArg.InsertAt(xmlStr,1)
 Set context.subname=DictMessage.SUBSCRIBERS]]>
</code>
<while name='遍历订阅系统发布全字典消息' condition='context.key&lt;=context.len' xpos='200' ypos='550' xend='200' yend='900' >
<annotation>遍历订阅系统发布消息</annotation>
<assign name="获取订阅系统" property="context.Sub" value="$ZSTRIP( ($LISTGET($LISTFROMSTRING(context.subname,&quot;,&quot;),context.key)),&quot;&lt;&gt;W&quot;)" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[获取订阅系统]]></annotation>
</assign>
<code xpos='200' ypos='350' >
<![CDATA[ $$$TRACE("sub"_context.Sub)]]>
</code>
<switch name='判断订阅系统调用对应服务' xpos='200' ypos='450' xend='200' yend='700' >
<annotation><![CDATA[判断订阅系统调用对应服务]]></annotation>
<case condition='context.Sub="bis"' name='BIS' >
<call name='调用测试BO' target='调用BIS接口BO' async='0' xpos='335' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="emr"' name='EMR' >
<call name='调用EMR系统' target='电子病历接收BO' async='0' xpos='605' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="LIS"' name='LIS测试' >
<call name='调用测试LIS' target='EMR接收测试服务BO' async='0' xpos='875' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="pacs"' name='PACS' >
<call name='调用PACS' target='调用PACS接口BO' async='1' xpos='1145' ypos='600' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
</case>
<case condition='context.Sub="jhip"' name='JHIP' >
<call name='字典同步测试' target='JHIPV5主数据服务BO' async='0' xpos='1415' ypos='600' >
<annotation><![CDATA[字典变更时，将消息推给主数据]]></annotation>
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
<code xpos='200' ypos='800' >
<![CDATA[ Set context.key=context.key+1]]>
</code>
</while>
</sequence>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

}

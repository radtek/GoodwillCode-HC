/// 
Class JHIP.Doctor.BP.Doctor Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2015' >
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
<property name='SubscriberSystems' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='SUBSCRIBERS' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='判断消息类型' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='$classname(request)="JHIPLIB.Util.MSG.JHRequestMsg"' name='订阅信息发布' >
<sequence name='人员订阅发布' xpos='335' ypos='400' xend='200' yend='550' >
<assign name="获取消息字符串" property="msgXml" value="request.pArg.GetAt(1)" action="set" xpos='200' ypos='250' />
<code name='字典订阅信息转换' xpos='200' ypos='350' >
<annotation><![CDATA[将字典订阅信息由String串转换为对应的Message消息]]></annotation>
<![CDATA[ $$$TRACE("msgXml"_msgXml)
 Set tSC=##Class(JHIPLIB.Util.ClassAndXML).Xml2Object(msgXml,"REQUEST","JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG",.SubscribersMSG)
 Set context.DICTMessage=SubscribersMSG
 $$$TRACE("SubscribersMSG"_SubscribersMSG.DictName)]]>
</code>
<call name='JHIPV5人员订阅发布信息同步BO' target='JHIPV5人员订阅发布信息同步BO' async='0' xpos='200' ypos='450' >
<request type='JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG' >
<assign property="callrequest" value="context.DICTMessage" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='(request.OriginalDocId="JH0704")||(request.OriginalDocId="JH0709")' name='人员查询' >
<call name='人员查询' target='JHIPV5人员主索引BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='(request.OriginalDocId="JH0701")||(request.OriginalDocId="JH0702")||(request.OriginalDocId="JH0703")||(request.OriginalDocId="JH0706") || (request.OriginalDocId="JH0707") || (request.OriginalDocId="JH0708")' name='人员同步增删改' >
<sequence name='人员同步' xpos='875' ypos='400' xend='200' yend='450' >
<annotation><![CDATA[字典增删改服务，需要解析订阅系统]]></annotation>
<code name='获取消息中字典名称' xpos='200' ypos='250' >
<annotation><![CDATA[获取消息中字典名称,查询字典对应的订阅系统]]></annotation>
<![CDATA[
  &sql(SELECT PublishSystems INTO :context.PublishSystems FROM JHIPLIB_JHIPV5_EMUI_DB.SUBSCRIBERS) 
  $$$TRACE("context.PublishSystems"_context.PublishSystems)                                        
  ;Set context.PublishSystems = "JHIP"
  if context.PublishSystems =""{}else{
  //将订阅系统存放标准消息中
 Set Tsc= request.SetValueAt(context.PublishSystems,"/"_request.Name_"/receiver/device/id/@extension")
 }
 //获取消息中的订阅系统
 Set SUBSCRIBERS=request.GetValueAt("/"_request.Name_"/receiver/device/id/@extension") 
 Set context.len=$LISTLENGTH($LISTFROMSTRING(SUBSCRIBERS,","))
 $$$TRACE("订阅系统个数为："_context.len)
 Set context.SUBSCRIBERS=SUBSCRIBERS
]]>
</code>
<while name='遍历订阅系统发布消息' condition='context.key&lt;=context.len' xpos='200' ypos='350' xend='200' yend='900' >
<annotation>遍历订阅系统发布消息</annotation>
<assign name="获取订阅系统" property="context.Sub" value="$ZSTRIP( ($LISTGET($LISTFROMSTRING(context.SUBSCRIBERS,&quot;,&quot;),context.key)),&quot;&lt;&gt;W&quot;)" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[获取订阅系统]]></annotation>
</assign>
<code xpos='200' ypos='350' >
<![CDATA[ $$$TRACE("sub"_context.Sub)]]>
</code>
<switch name='判断订阅系统调用对应服务' xpos='200' ypos='450' xend='200' yend='700' >
<annotation><![CDATA[判断订阅系统调用对应服务]]></annotation>
<case condition='context.Sub="pacs"' name='PACS' >
<call name='调用PACS' target='调用PACS接口BO' async='1' xpos='335' ypos='600' >
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
<case condition='context.Sub="lis"' name='LIS' >
<call name='调用LIS' target='调用LIS接口BO' async='0' xpos='875' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="bis"' name='BIS' >
<call name='调用bis' target='调用BIS接口BO' async='0' xpos='1145' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="jhip"' name='JHIP' >
<call name='jhip' target='JHIPV5人员主索引BO' async='0' xpos='1415' ypos='600' >
<annotation><![CDATA[发送信息给JHIPV5]]></annotation>
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

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

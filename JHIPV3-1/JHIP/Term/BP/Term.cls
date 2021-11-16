/// 术语管理服务的BP
Class JHIP.Term.BP.Term Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' component='1' height='2000' width='2015' >
<context>
<property name='filename' type='%String' instantiate='0' >
<annotation><![CDATA[设置文件名称载体（注意是否已经存储到库中）]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='target' type='EnsLib.EDI.XML.Document' instantiate='0' >
<annotation><![CDATA[XSL转换后载体对象]]></annotation>
</property>
<property name='ALIASNAME' type='%String' instantiate='0' >
<annotation><![CDATA[字典分发系统载体]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='SUBSCRIBERS' type='%String' instantiate='0' >
<annotation><![CDATA[订阅系统]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='100' />
</parameters>
</property>
<property name='SubscriberSystems' type='%String' instantiate='0' >
<annotation><![CDATA[维护方系统简写]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='key' type='%Integer' initialexpression='1' instantiate='0' />
<property name='len' type='%Integer' instantiate='0' >
<annotation><![CDATA[订阅系统集合长度]]></annotation>
</property>
<property name='Sub' type='%String' instantiate='0' >
<annotation><![CDATA[订阅系统]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='DICTMessage' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='判断服务类别' xpos='200' ypos='250' xend='200' yend='500' >
<annotation><![CDATA[判断服务类别]]></annotation>
<case condition='$classname(request)="JHIPLIB.Util.MSG.JHRequestMsg"' name='术语订阅发布' >
<sequence name='术语订阅发布' xpos='200' ypos='400' xend='200' yend='550' >
<assign name="获取消息字符串" property="msgXml" value="request.pArg.GetAt(1)" action="set" xpos='200' ypos='250' />
<code name='字典订阅信息转换' xpos='200' ypos='350' >
<annotation><![CDATA[将字典订阅信息由String串转换为对应的Message消息]]></annotation>
<![CDATA[ $$$TRACE("msgXml"_msgXml)
 ;Set SubscribersMSG=##class(JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG).%New()
 Set tSC= ##Class(JHIPLIB.Util.ClassAndXML).Xml2Object(msgXml,"REQUEST","JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG",.SubscribersMSG)
 Set context.DICTMessage=SubscribersMSG
 $$$TRACE("tSC"_tSC)]]>
</code>
<call name='调用字典订阅发布BO' target='JHIPV5术语订阅发布信息同步BO' async='0' xpos='200' ypos='450' >
<request type='JHIPLIB.JHIPV5.SubScriber.MSG.SubscribersMSG' >
<assign property="callrequest" value="context.DICTMessage" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='(request.OriginalDocId="JH0901")||(request.OriginalDocId="JH0902")||(request.OriginalDocId="JH0903")||(request.OriginalDocId="JH0906")||(request.OriginalDocId="JH0907")||(request.OriginalDocId="JH0908")||(request.OriginalDocId="JH0911")' name='术语信息同步服务' >
<sequence name='术语同步服务' xpos='470' ypos='400' xend='200' yend='450' >
<code name='获取消息中字典名称' xpos='200' ypos='250' >
<annotation><![CDATA[获取消息中字典名称,查询字典对应的订阅系统]]></annotation>
<![CDATA[
  Set context.ALIASNAME=request.GetValueAt("/"_request.Name_"/controlActProcess/subject/registrationRequest/subject1/valueSet/desc/@value") 
  $$$TRACE("需要同步的字典名称为："_context.ALIASNAME)
  //查询该字典的订阅系统
  &sql(SELECT SubscriberSystems INTO :context.SubscriberSystems FROM JHIPLIB_JHIPV5_Term_DB.Subscribers WHERE DictName=:context.ALIASNAME)
  if context.SubscriberSystems=""{}else{
  $$$TRACE(context.ALIASNAME_"的订阅系统为："_context.SubscriberSystems)
  //将订阅系统存放标准消息中
 Set Tsc= request.SetValueAt(context.SubscriberSystems,"/"_request.Name_"/receiver/device/id/item/@extension")
 }
 //获取消息中的订阅系统
 Set SUBSCRIBERS=request.GetValueAt("/"_request.Name_"/receiver/device/id/item/@extension") 
 Set context.len=$LISTLENGTH($LISTFROMSTRING(SUBSCRIBERS,","))
 $$$TRACE("订阅系统个数为："_context.len)
 Set context.SUBSCRIBERS=SUBSCRIBERS]]>
</code>
<while name='遍历订阅系统发布全字典消息' condition='context.key&lt;=context.len' xpos='200' ypos='350' xend='200' yend='900' >
<annotation>遍历订阅系统发布消息</annotation>
<assign name="获取订阅系统" property="context.Sub" value="$ZSTRIP( ($LISTGET($LISTFROMSTRING(context.SUBSCRIBERS,&quot;,&quot;),context.key)),&quot;&lt;&gt;W&quot;)" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[获取订阅系统]]></annotation>
</assign>
<code name='订阅系统追踪' xpos='200' ypos='350' >
<annotation><![CDATA[订阅系统追踪]]></annotation>
<![CDATA[ $$$TRACE("sub"_context.Sub)]]>
</code>
<switch name='判断订阅系统调用对应服务' xpos='200' ypos='450' xend='200' yend='700' >
<annotation><![CDATA[判断订阅系统调用对应服务]]></annotation>
<case condition='context.Sub="healthconnect"' name='BIS' >
<call name='调用测试BO' target='JHIPV5主数据内容服务BO' async='0' xpos='335' ypos='600' >
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
<call name='调用测试LIS' target='EMR接收测试服务BO' async='1' xpos='875' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='context.Sub="pacs"' name='PACS' >
<call name='调用PACS' target='JHIPV5主数据结构服务BO' async='1' xpos='1145' ypos='600' >
<request type='Ens.Request' />
<response type='Ens.Response' />
</call>
</case>
<case condition='context.Sub="JHIP"' name='JHIP' >
<call name='字典同步测试' target='JHIPV5主数据结构服务BO' async='1' xpos='1415' ypos='600' >
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
<code name='下标移动' xpos='200' ypos='800' >
<annotation><![CDATA[方便获取到订阅系统]]></annotation>
<![CDATA[ Set context.key=context.key+1]]>
</code>
</while>
</sequence>
</case>
<case condition='(request.OriginalDocId="JH0904")||(request.OriginalDocId="JH0905")||(request.OriginalDocId="JH0909")' name='术语查询服务' >
<call name='术语查询服务' target='JHIPV5主数据服务BO' async='1' xpos='740' ypos='400' >
<annotation><![CDATA[术语查询服务]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<default>
<code name='告警块(勿动)' xpos='1010' ypos='400' >
<annotation><![CDATA[如果没有进入任何一个分支进行告警提示。]]></annotation>
<![CDATA[
  $$$LOGERROR(request.OriginalDocId_"该事件没有进入到本流程内任何一个分支中！请确认有该服务分支！")]]>
</code>
</default>
</switch>
</sequence>
</process>
}

}

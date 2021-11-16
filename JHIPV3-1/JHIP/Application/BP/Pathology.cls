/// 00.患者管理服务的BP
Class JHIP.Application.BP.Pathology Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' component='1' height='2000' width='2000' >
<sequence xend='200' yend='700' >
<switch name='判断服务类别' xpos='200' ypos='250' xend='200' yend='600' >
<annotation><![CDATA[判断服务类别]]></annotation>
<case condition='request.OriginalDocId="PatientRegistryAddRequest"' name='满足条件信息发送给三方' >
<call name='发送样例消息给LIS测试BO' target='LIS接收测试服务BO' async='0' xpos='335' ypos='400' >
<annotation><![CDATA[发送样例消息给LIS测试BO]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.OriginalDocId="111"' name='满足条件信息发送给三方' >
<call name='发送样例消息给EMR测试BO' target='EMR接收测试服务BO' async='0' xpos='605' ypos='400' >
<annotation><![CDATA[发送样例消息给EMR测试BO]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<call name='发送样例消息给HIS测试BO' target='HIS接收测试服务BO' async='0' xpos='605' ypos='500' >
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

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

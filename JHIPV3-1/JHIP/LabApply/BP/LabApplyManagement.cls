/// 00.患者管理服务的BP
Class JHIP.LabApply.BP.LabApplyManagement Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' component='1' height='2000' width='2000' >
<context>
<property name='target' type='EnsLib.EDI.XML.Document' instantiate='0' />
</context>
<sequence name='检验' xpos='200' ypos='250' xend='200' yend='700' >
<switch xpos='200' ypos='250' xend='200' yend='600' >
<case condition='request.OriginalDocId="LabApplyRequest"' name='检验申请单开立' >

<call name='检验申请单开立' target='LIS接收测试服务BO' async='1' xpos='335' ypos='500' >
<request type='EnsLib.EDI.XML.Document' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='EnsLib.EDI.XML.Document' >
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

/// 
Class JHIPLIB.Util.Alert.BP.AlertBP Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='target' type='EnsLib.EDI.XML.Document' instantiate='0' />
</context>
<sequence xend='200' yend='700' >
<if name='判断类型' condition='$CLASSNAME(request)="EnsLib.EDI.XML.Document"' xpos='200' ypos='250' xend='200' yend='500' >
<false>
<code name='告警消息处理' xpos='338' ypos='403' >
<![CDATA[
  Set util = ##class(JHIPLIB.Util.ClassAndXML).%New()
  Set tSC = util.Object2Xml(request,"AlertRequest",.result)
  Set target = ##class(EnsLib.EDI.XML.Document).%New()
  Set target = target.ImportFromString(result,.status)
  Set tSC=target.SetValueAt($system.SQL.DATEADD("hh",+8,$$$timeUTC),"/AlertRequest/AlertTime")
  Set target.OriginalDocId = request.SourceConfigName
  Set context.target = target]]>
</code>
</false>
</if>
<call name='调用告警BO' target='JHIP推送告警服务BO' async='1' xpos='200' ypos='600' >
<request type='Ens.Request' >
<assign property="callrequest" value="context.target" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</process>
}

}

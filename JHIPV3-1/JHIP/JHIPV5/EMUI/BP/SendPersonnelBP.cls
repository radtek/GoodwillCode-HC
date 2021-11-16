/// 00.患者管理服务的BP
Class JHIP.JHIPV5.EMUI.BP.SendPersonnelBP Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' component='1' height='2000' width='2150' >
<context>
<property name='filename' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='target' type='EnsLib.EDI.XML.Document' instantiate='0' />
<property name='poutput' type='EnsLib.HL7.Message' instantiate='0' />
<property name='JHIPRequest' type='JHIPLIB.Util.MSG.JHRequestMsg' instantiate='0' />
<property name='StringResponse' type='Ens.StringResponse' instantiate='0' />
<property name='ALIASNAME' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='len' type='%Integer' instantiate='0' />
<property name='key' type='%Integer' initialexpression='1' instantiate='0' />
<property name='DICTMessage' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Sub' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
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
<property name='PublishSystems' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='450' >
<code name='XSL转换封装(勿动)' xpos='200' ypos='250' >
<annotation><![CDATA[封装好的转换类(勿动)]]></annotation>
<![CDATA[  Set context.filename = $Case(request.OriginalDocId,"JH0706":"医疗卫生人员注册","JH0707":"医疗卫生人员更新","JH0708":"医疗卫生人员删除","JH0709":"医疗卫生人员查询")
  try{
    	
    	Set xslutil= ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set tSC= xslutil.Xslt2String(request,context.filename,.pOutput)
	Set target=##class(EnsLib.EDI.XML.Document).%New()
	Set target=target.ImportFromString(pOutput,.status)
	Set target.OriginalDocId=request.OriginalDocId
	Set context.target=target
   }catch err{
     $$$LOGERROR(context.filename_"XSLT转换失败"_err.DisplayString())
   }]]>
</code>
<call name='发送标准医疗卫生人员消息给医疗人员处理流程' target='07.1医疗卫生人员信息服务BP' async='1' xpos='200' ypos='350' >
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

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

/// 00.患者管理服务的BP
Class JHIP.Visited.BP.Hospitalization Extends Ens.BusinessProcessBPL
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
<property name='filename' type='%String' instantiate='0' >
<annotation><![CDATA[设置文件名称载体（注意是否已经存储到库中）]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='target' type='EnsLib.EDI.XML.Document' instantiate='0' >
<annotation><![CDATA[XSL转换后载体对象]]></annotation>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='判断服务类别' xpos='200' ypos='250' xend='200' yend='500' >
<annotation><![CDATA[判断服务类别]]></annotation>
<case condition='request.OriginalDocId="JH0111"' name='JH0111住院就诊信息登记服务流程处理' >
<sequence name='住院就诊信息登记服务发送到数据中心' xpos='200' ypos='400' xend='200' yend='550' >
<annotation><![CDATA[住院就诊信息登记服务发送到数据中心]]></annotation>
<assign name="设置xsl文件名称" property="context.filename" value="&quot;JH0111住院就诊信息登记服务&quot;" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[设置xsl文件名称（注意是否已经存储到库中）]]></annotation>
</assign>
<code name='XSL转换封装(勿动)' xpos='200' ypos='350' >
<annotation><![CDATA[封装好的转换类(勿动)]]></annotation>
<![CDATA[
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
<call name='发送住院就诊信息登记服务消息给HDR' target='HDR数据中心EDI服务BO' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[发送住院就诊信息登记服务消息给HDR]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.target" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='request.OriginalDocId="JH0112"' name='JH0112住院就诊信息更新服务流程处理' >
<sequence name='住院就诊信息登记服务发送到数据中心' xpos='470' ypos='400' xend='200' yend='550' >
<annotation><![CDATA[住院就诊信息更新服务发送到数据中心]]></annotation>
<assign name="设置xsl文件名称" property="context.filename" value="&quot;JH0112住院就诊信息更新服务&quot;" action="set" xpos='200' ypos='250' >
<annotation><![CDATA[设置xsl文件名称（注意是否已经存储到库中）]]></annotation>
</assign>
<code name='XSL转换封装(勿动)' xpos='200' ypos='350' >
<annotation><![CDATA[封装好的转换类(勿动)]]></annotation>
<![CDATA[
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
<call name='发送住院就诊信息更新服务消息给HDR' target='HDR数据中心EDI服务BO' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[发送住院就诊信息更新服务消息给HDR]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.target" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<default>
<code name='告警块(勿动)' xpos='740' ypos='400' >
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

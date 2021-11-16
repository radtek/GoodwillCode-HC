/// 术语管理服务的BP
Class JHIP.Term.BP.SQLTerm Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.EDI.XML.Document' response='Ens.Response' component='1' height='2000' width='2015' >
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
<sequence xend='200' yend='550' >
<assign name="设置xsl文件名称" property="context.filename" value="$Case(request.OriginalDocId,&quot;JH0901&quot;:&quot;JH0901&quot;_request.GetValueAt(&quot;/Request/JH0901/DICT_VALUE&quot;),&quot;JH0902&quot;:&quot;JH0902&quot;_request.GetValueAt(&quot;/Request/JH0902/DICT_VALUE&quot;),&quot;JH0903&quot;:&quot;JH0903术语内容停用服务&quot;,&quot;JH0906&quot;:&quot;JH0906术语结构注册服务&quot;,&quot;JH0907&quot;:&quot;JH0907术语结构更新服务&quot;,&quot;JH0908&quot;:&quot;JH0908术语结构停用服务&quot;)" action="set" xpos='200' ypos='250' >
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
<call name='发送标准术语消息给术语处理流程' target='09.1术语信息服务BP' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[发送标准术语消息给术语处理流程]]></annotation>
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

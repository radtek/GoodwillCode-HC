/// 00.患者管理服务的BP
Class JHIP.Patient.BP.Manage Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' component='1' height='2000' width='2420' >
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
<property name='poutput' type='EnsLib.HL7.Message' instantiate='0' >
<annotation><![CDATA[查询返回的2.4消息]]></annotation>
</property>
<property name='JHIPRequest' type='JHIPLIB.Util.MSG.JHRequestMsg' instantiate='0' />
<property name='StringResponse' type='Ens.StringResponse' instantiate='0' >
<annotation><![CDATA[JHIPV5返回值载体]]></annotation>
</property>
</context>
<sequence xend='200' yend='700' >
<switch name='判断服务类别' xpos='200' ypos='250' xend='200' yend='600' >
<annotation><![CDATA[判断服务类别]]></annotation>
<case condition='request.OriginalDocId="JH0006"' name='满足条件信息发送给三方（单个发送样例）' >
<call name='信息发送（单个发送样例）' target='LIS接收测试服务BO' async='0' xpos='200' ypos='400' >
<annotation><![CDATA[发送样例消息给LIS测试BO]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.OriginalDocId="JH0005"' name='满足条件XSL' >
<sequence name='XSL转换信息样例' xpos='470' ypos='400' xend='200' yend='550' >
<annotation><![CDATA[BP中XSL转换信息样例]]></annotation>
<assign name="设置xsl文件名称" property="context.filename" value="&quot;XSL存储库中文件名称&quot;" action="set" xpos='200' ypos='250' >
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
<call name='发送患者注册消息给JHIPV5' target='JHIPV5患者主索引BO' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[发送患者注册消息给JHIPV5]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.target" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='request.OriginalDocId="JH0004"' name='查询患者基本消息服务' >
<sequence name='患者查询发送给JHIPV5' xpos='743' ypos='397' xend='200' yend='650' >
<annotation><![CDATA[患者注册DT转换信息后发送给JHIPV5]]></annotation>
<transform name='转化为JHIPV5患者查询请求' class='JHIP.Patient.DT.PatientQueryReqDT' source='request' target='context.JHIPRequest' xpos='200' ypos='250' >
<annotation><![CDATA[将标准信息转化为JHIPV5患者查询请求]]></annotation>
</transform>
<call name='发送患者查询消息给JHIPV5' target='JHIPV5患者主索引BO' async='0' xpos='200' ypos='350' >
<annotation><![CDATA[发送患者查询消息给JHIPV5]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.JHIPRequest" action="set" />
</request>
<response type='Ens.Response' >
<assign property="context.StringResponse" value="callresponse" action="set" />
</response>
</call>
<code name='返回值转换为V2' xpos='200' ypos='450' >
<annotation><![CDATA[返回值转换为V2]]></annotation>
<![CDATA[
   Set HL7=##class(EnsLib.HL7.Message).%New()
   Set msgStream = ##class(%Stream.GlobalCharacter).%New()
   D msgStream.Write(context.StringResponse.StringValue)
   S HL7=HL7.ImportFromLibraryStream(msgStream)
   S HL7.DocType="JH2.4:RSP_K21"
   S context.poutput=HL7
   ]]>
</code>
<transform name='转换DT' class='JHIP.Patient.DT.item.PatientQueryResDT' source='context.poutput' target='response' xpos='200' ypos='550' >
<annotation><![CDATA[转换DT2.4转标准xml]]></annotation>
</transform>
</sequence>
</case>
<case condition='request.OriginalDocId="JH0001"' name='患者注册服务' >
<sequence name='患者注册发送给JHIPV5' xpos='1280' ypos='400' xend='200' yend='450' >
<annotation><![CDATA[患者注册DT转换信息后发送给JHIPV5]]></annotation>
<transform name='转化为JHIPV5患者注册' class='JHIP.Patient.DT.PatientAddDT' source='request' target='context.JHIPRequest' xpos='200' ypos='250' >
<annotation><![CDATA[将标准信息转化为JHIPV5患者注册]]></annotation>
</transform>
<call name='发送患者注册消息给JHIPV5' target='JHIPV5患者主索引BO' async='1' xpos='200' ypos='350' >
<annotation><![CDATA[发送患者注册消息给JHIPV5]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.JHIPRequest" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
<sequence name='患者注册发送到数据中心' xpos='1280' ypos='500' xend='200' yend='550' >
<annotation><![CDATA[患者注册发送到数据中心]]></annotation>
<assign name="设置xsl文件名称" property="context.filename" value="&quot;新增患者信息服务&quot;" action="set" xpos='200' ypos='250' >
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
<call name='发送患者注册消息给HDR' target='HDR数据中心EDI服务BO' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[发送患者注册消息给HDR]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.target" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='request.OriginalDocId="JH0002"' name='患者更新服务' >
<sequence name='患者更新消息发送给JHIPV5' xpos='1550' ypos='400' xend='200' yend='450' >
<annotation><![CDATA[患者更新DT转换信息后发送给JHIPV5]]></annotation>
<transform name='转化为JHIPV5患者更新' class='JHIP.Patient.DT.PatientUpdateDT' source='request' target='context.JHIPRequest' xpos='200' ypos='250' >
<annotation><![CDATA[将标准信息转化为JHIPV5患者更新]]></annotation>
</transform>
<call name='发送患者更新消息给JHIPV5' target='JHIPV5患者主索引BO' async='1' xpos='200' ypos='350' >
<annotation><![CDATA[发送患者更新消息给JHIPV5]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.JHIPRequest" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
<sequence name='患者更新发送到数据中心' xpos='1550' ypos='500' xend='200' yend='550' >
<annotation><![CDATA[患者更新发送到数据中心]]></annotation>
<assign name="设置xsl文件名称" property="context.filename" value="&quot;患者信息更新服务&quot;" action="set" xpos='200' ypos='250' >
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
<call name='发送患者注册消息给HDR' target='HDR数据中心EDI服务BO' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[发送患者注册消息给JHIPV5]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="context.target" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</case>
<case condition='request.OriginalDocId="JH0003"' name='信息发送（多个发送样例）' >
<call name='信息发送（多个个发送样例）' target='EMR接收测试服务BO' async='1' xpos='1820' ypos='400' >
<annotation><![CDATA[信息发送（多个个发送样例），接受方1]]></annotation>
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<call name='信息发送（多个个发送样例）' target='HIS接收测试服务BO' async='1' xpos='1820' ypos='500' >
<annotation><![CDATA[信息发送（多个个发送样例），接受方2]]></annotation>
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

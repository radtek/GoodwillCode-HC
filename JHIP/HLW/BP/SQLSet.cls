/// 省健康平台
Class JHIP.HLW.BP.SQLSet Extends Ens.BusinessProcessBPL
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
<property name='sqlparameter' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='sqltype' type='%String' initialexpression='"Query"' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='sqlstatement' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='300' />
</parameters>
</property>
<property name='tablename' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='sql' type='EnsLib.EDI.XML.Document' instantiate='0' />
<property name='sqlresponse' type='EnsLib.EDI.XML.Document' instantiate='0' />
<property name='id' type='%Integer' instantiate='0' />
<property name='outer' type='EnsLib.EDI.XML.Document' instantiate='0' />
</context>
<sequence xend='200' yend='350' >
<sequence name='获取json中的id，并返回json' xpos='200' ypos='250' xend='200' yend='950' >
<code name='取出json中的字段' xpos='200' ypos='250' >
<annotation><![CDATA[取出json中的字段
]]></annotation>
<![CDATA[    Set xmlStr=request.pArg.GetAt(1)
    $$$TRACE("xmlStr"_xmlStr)
    Set StrJSON={}.%FromJSON(xmlStr)
    Set context.id= StrJSON.hospitalId
   ]]>
</code>
<assign name="设定查询语句" property="context.sqlstatement " value="&quot;select  * from jhip_patient_infos WHERE patient_id='?'&quot;" action="set" xpos='200' ypos='350' >
<annotation><![CDATA[设定sql]]></annotation>
</assign>
<assign name="设定数据库表明" property="context.tablename" value="&quot;jhip_patient_infos&quot;" action="set" xpos='200' ypos='450' />
<assign name="设定语句类型" property="context.sqltype" value="&quot;Query&quot;" action="set" xpos='200' ypos='550' />
<code name='拼接传送BO' xpos='200' ypos='650' >
<annotation><![CDATA[666]]></annotation>
<![CDATA[ Set sqlreq=##class(JHIPLIB.SQL.MSG.SQLMessage).%New()
 Set context.sqlstatement=$replace(context.sqlstatement,"?",context.id)
 Set sqlreq.sqlreq=context.sqlstatement
 Set sqlreq.sqltype=context.sqltype
 Set sqlreq.tablename=context.tablename
 Set context.sql=sqlreq
 
 
 
  

 
 
]]>
</code>
<code name='将消息发送到BO' xpos='200' ypos='750' >
<annotation><![CDATA[将消息发送到BO]]></annotation>
<![CDATA[  
   Set status = process.SendRequestSync("将JSON数据插入到数据库",context.sql,.output)
   Set context.outer = output]]>
</code>
<code name='将数据库查询查来的xml转化成JSON' xpos='200' ypos='850' >
<annotation><![CDATA[转化成JSON
]]></annotation>
<![CDATA[ 

  Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
  $$$TRACE(context.outer)
  Set json = Util.XMLTOJSON(context.outer)
  
  Set Output=##class(Ens.StringResponse).%New()
  
  Set Output.StringValue = json
  
  Set response = Output
  ]]>
</code>
</sequence>
</sequence>
</process>
}

}

/// 权限初始化
Class JHIP.JHIPV5.PORTAL.BP.PermissionBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2015' >
<context>
<property name='PermissionsMSG' type='JHIPLIB.Util.MSG.PermissionsMSG' instantiate='0' />
<property name='key' type='%Integer' initialexpression='1' instantiate='0' >
<annotation><![CDATA[用于轮询系统]]></annotation>
</property>
<property name='len' type='%Integer' instantiate='0' />
<property name='Name' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='RespMSG' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2000' />
</parameters>
</property>
<property name='HisCode' type='%String' initialexpression='1' instantiate='0' >
<annotation><![CDATA[用于处理返回结果]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='LisCode' type='%String' initialexpression='1' instantiate='0' >
<annotation><![CDATA[用于处理返回结果]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='EMRCode' type='%String' initialexpression='1' instantiate='0' >
<annotation><![CDATA[用于处理返回结果]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='PacsCode' type='%String' initialexpression='1' instantiate='0' >
<annotation><![CDATA[用于处理返回结果]]></annotation>
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='StrCode' type='%String' initialexpression='1' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='100' />
</parameters>
</property>
<property name='StrName' type='%String' initialexpression='1' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='XMLResp' type='JHIPLIB.Util.MSG.PermissionsRespMSG' instantiate='0' />
<property name='BisCode' type='%String' initialexpression='1' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch name='判断权限业务流程' xpos='200' ypos='250' xend='200' yend='500' >
<annotation><![CDATA[判断权限业务流程，不同服务进入不同处理流程。]]></annotation>
<case condition='(request.action="JH0801")||(request.action="JH0802")||(request.action="JH0803")' name='用户权限同步' >
<call name='用户权限同步' target='调用权限BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="JH0804"' name='权限初始化' >
<sequence name='权限初始化' xpos='605' ypos='400' xend='200' yend='900' >
<code name='转换权限消息' xpos='200' ypos='250' >
<![CDATA[ Set str=request.pArg.GetAt(1)
 Set tResponse=##class(JHIPLIB.Util.MSG.PermissionsMSG).%New()
 Set tSC=##class(JHIPLIB.Util.ClassAndXML).Xml2Object(str,"REQUEST","JHIPLIB.Util.MSG.PermissionsMSG",.tResponse)
 $$$TRACE("3"_tResponse.SYSTEMCODE)
 Set context.PermissionsMSG=tResponse
 $$$TRACE("4"_context.PermissionsMSG.SYSTEMCODE)

 Set context.len=$LISTLENGTH($LISTFROMSTRING(tResponse.SYSTEMCODE,","))


 
]]>
</code>
<if name='判断是否有订阅系统' condition='context.PermissionsMSG.SYSTEMCODE&apos;=""' xpos='200' ypos='350' xend='200' yend='600' >
<true>
<while name='分发消息' condition='context.key&lt;=context.len' xpos='335' ypos='500' xend='200' yend='900' >
<code name='转换' xpos='200' ypos='250' >
<![CDATA[ $$$TRACE("context.Key"_context.key)
 Set context.Name=$ZSTRIP(($LISTGET($LISTFROMSTRING(context.PermissionsMSG.SYSTEMCODE,","),context.key)),"<>W")
 $$$TRACE("5"_context.Name)

 

 ]]>
</code>
<switch name='分发消息' xpos='200' ypos='350' xend='200' yend='700' >
<case condition='context.Name="his"' name='his' >
<call name='调用HISBO' target='调用His接收BO' async='0' xpos='335' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="context.RespMSG" value="callresponse.StringValue" action="set" />
</response>
</call>
<code name='处理HIS返回结果' xpos='335' ypos='600' >
<![CDATA[ Set tResponsez=##class(JHIPLIB.Util.MSG.PermissionsRespMSG).%New()
 Set tSC=##class(JHIPLIB.Util.ClassAndXML).Xml2Object(context.RespMSG,"RESPONSE","JHIPLIB.Util.MSG.PermissionsRespMSG",.tResponse)
 if (tResponse.RESULTCODE'="true"){
 Set context.HisCode=tResponse.SYSTEMCODE
 $$$LOGINFO("his权限维护失败")
 }
 ]]>
</code>
</case>
<case condition='context.Name="lis"' name='lis' >
<call name='调用LISBO' target='调用LIS接口BO' async='0' xpos='605' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<code name='处理LIS返回结果' xpos='605' ypos='600' >
<![CDATA[
 if (response.GetValueAt("/RESPONSE/RESULT_CODE")'="true"){
 Set context.LisCode=tResponse.SYSTEMCODE
 $$$LOGINFO("Lis权限维护失败")
 }]]>
</code>
</case>
<case condition='context.Name="emr"' name='emr' >
<call name='调用EMRBO' target='电子病历接收BO' async='0' xpos='875' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="context.RespMSG" value="callresponse.StringValue" action="set" />
</response>
</call>
<code name='处理EMR返回结果' xpos='875' ypos='600' >
<![CDATA[ Set tResponsez=##class(JHIPLIB.Util.MSG.PermissionsRespMSG).%New()
 Set tSC=##class(JHIPLIB.Util.ClassAndXML).Xml2Object(context.RespMSG,"RESPONSE","JHIPLIB.Util.MSG.PermissionsRespMSG",.tResponse)
 if (tResponse.RESULTCODE'="true"){
 Set context.EMRCode=tResponse.SYSTEMCODE
 $$$LOGINFO("EMR权限维护失败")
 }]]>
</code>
</case>
<case condition='context.Name="pacs"' name='pacs' >
<call name='调用pacsBO' target='调用PACS接口BO' async='0' xpos='1145' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="context.RespMSG" value="callresponse.StringValue" action="set" />
</response>
</call>
<code name='处理PACS返回结果' xpos='1145' ypos='600' >
<![CDATA[ Set tResponsez=##class(JHIPLIB.Util.MSG.PermissionsRespMSG).%New()
 Set tSC=##class(JHIPLIB.Util.ClassAndXML).Xml2Object(context.RespMSG,"RESPONSE","JHIPLIB.Util.MSG.PermissionsRespMSG",.tResponse)
 if (tResponse.RESULTCODE'="true"){
 Set context.PacsCode=tResponse.SYSTEMCODE
 $$$LOGINFO("Pasc权限维护失败")
 }]]>
</code>
</case>
<case condition='context.Name="bis"' name='bis' >
<call name='调用BISBO' target='调用BIS接口BO' async='0' xpos='1415' ypos='500' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.StringResponse' >
<assign property="context.RespMSG" value="callresponse.StringValue" action="set" />
</response>
</call>
<code name='处理PACS返回结果' xpos='1415' ypos='600' >
<![CDATA[ Set tResponsez=##class(JHIPLIB.Util.MSG.PermissionsRespMSG).%New()
 Set tSC=##class(JHIPLIB.Util.ClassAndXML).Xml2Object(context.RespMSG,"RESPONSE","JHIPLIB.Util.MSG.PermissionsRespMSG",.tResponse)
 if (tResponse.RESULTCODE'="true"){
 Set context.BisCode=tResponse.SYSTEMCODE
 $$$LOGINFO("Pasc权限维护失败")
 }]]>
</code>
</case>
<default name='default' />
</switch>
<code name='Key+1' xpos='200' ypos='800' >
<![CDATA[ Set context.key=context.key+1
 $$$LOGINFO("key+1"_context.key)
]]>
</code>
</while>
</true>
</if>
<code name='处理返回结果' xpos='200' ypos='700' >
<annotation><![CDATA[流程处理]]></annotation>
<![CDATA[ Set context.XMLResp=##class(JHIPLIB.Util.MSG.PermissionsRespMSG).%New()
 if (context.HisCode'=1)||(context.LisCode'=1)||(context.EMRCode'=1)||(context.PacsCode'=1)||(context.BisCode'=1){
 if context.HisCode'=1{
  Set context.StrCode=context.HisCode
  Set context.Name="HIS系统"
 }
 if context.LisCode'=1{
   if context.StrCode'=1{
     Set context.StrCode=context.StrCode_","_context.LisCode
     Set context.Name=context.Name_",LIS系统"
   }else{
     Set context.StrCode=context.LisCode
     Set context.Name="LIS系统"
   }
  }
  if context.EMRCode'=1{
   if context.StrCode'=1{
     Set context.StrCode=context.StrCode_","_context.EMRCode
     Set context.Name=context.Name_",电子病历系统"
   }else{
     Set context.StrCode=context.EMRCode
     Set context.Name="电子病历系统"
   }
  }
  if context.PacsCode'=1{
   if context.StrCode'=1{
     Set context.StrCode=context.StrCode_","_context.PacsCode
     Set context.Name=context.Name_",Pacs系统"
   }else{
     Set context.StrCode=context.LisCode
     Set context.Name="Pacs系统"
   }
  }
  if context.BisCode'=1{
   if context.StrCode'=1{
     Set context.StrCode=context.StrCode_","_context.BisCode
     Set context.Name=context.Name_",Bis系统"
   }else{
     Set context.StrCode=context.BisCode
     Set context.Name="Bis系统"
   }
  }
  Set context.XMLResp.RESULTCODE="false"
  Set context.XMLResp.RESULTCONTENT="失败"
  Set context.XMLResp.SYSTEMCODE=context.Code
  Set context.XMLResp.SYSTEMNAME=context.Name
 }else{
 Set context.XMLResp.RESULTCODE="true"
 Set context.XMLResp.RESULTCONTENT="成功"
 Set context.XMLResp.SYSTEMCODE="ALL"
 Set context.XMLResp.SYSTEMNAME="ALL"
 }]]>
</code>
<code name='返回消息处理' xpos='200' ypos='800' >
<![CDATA[ Set context.XMLResp.DATETIME=##class(Ens.Util.FunctionSet).ConvertDateTime($zdt($h,3), "%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
 Set tResult=##class(Ens.StringResponse).%New()
 Set str="返回结果context.XMLResp转化失败"
 Set tSC=context.XMLResp.XMLExportToString(.str)
 $$$LOGINFO("str"_str)
 Set tResult.StringValue=str
 $$$LOGINFO("tResult:"_tResult.StringValue)
 Set response=tResult
 $$$TRACE("Response.StringValue"_response.StringValue)]]>
</code>
</sequence>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

}

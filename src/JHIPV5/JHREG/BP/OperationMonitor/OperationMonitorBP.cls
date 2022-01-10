/// 
Class JHIPV5.JHREG.BP.OperationMonitor.OperationMonitorBP Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2555' >
<context>
<property name='Method' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='600' >
<switch xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action="UnicomRange"' name='运行监控联通范围图表' >
<call name='联通范围图表' target='运行监控联通范围图表BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getMonitoringData"' name='运行监控基本数据获取' >
<call name='运行监控基本数据获取BO' target='运行监控基本数据获取BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="getAverageTime"' name='运行监控平均耗时获取BO' >
<call name='运行监控平均耗时获取BO' target='运行监控平均耗时获取BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="ExceptionLog"' name='异常日志' >
<call name='运行监控异常日志获取BO' target='运行监控异常日志获取BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="ActiveThemeTop10"' name='活跃主题TOP10' >
<call name='运行监控活跃主题获取BO' target='运行监控活跃主题获取BO' async='0' xpos='1415' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="QueueMonitor"' name='队列监控' >
<call name='运行监控队列监控获取BO' target='运行监控队列监控获取BO' async='0' xpos='1685' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="SystemVendor"' name='系统厂商' >
<call name='运行监控系统厂商获取BO' target='运行监控系统厂商获取BO' async='0' xpos='1955' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action="RunStatusTrend"' name='运行状态趋势' >
<call name='运行监控运行状态趋势BO' target='运行监控运行状态趋势BO' async='0' xpos='2225' ypos='400' >
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
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

/// 
Class JHIPV5.JHREG.BP.Theme.ThemeManagementBP Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='6065' >
<sequence xend='200' yend='600' >
<switch xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.action ="getThemeName"' >
<call name='主题名称' target='主题管理名称获取BO' async='0' xpos='335' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getThemeDetail"' >
<call name='主题详情' target='主题管理详情获取BO' async='0' xpos='605' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="queryCategory"' >
<call name='业务场景' target='主题管理场景获取BO' async='0' xpos='875' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="addTheme"' >
<call name='主题注册' target='主题管理注册主题BO' async='0' xpos='1145' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="queryEnabled"' >
<call name='主题状态' target='主题管理状态获取BO' async='0' xpos='1415' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="queryPartner"' >
<call name='发布系统' target='主题管理发布系统BO' async='0' xpos='1685' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="UpdateItem"' name='主题修改' >
<call name='主题修改' target='主题管理修改主题BO' async='0' xpos='1955' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="RemoveItem"' >
<call name='主题删除' target='主题管理删除主题BO' async='0' xpos='2225' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="queryStandard"' >
<call name='通讯标准' target='主题管理通讯标准BO' async='0' xpos='2495' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getThemeNameCategory"' >
<call name='主题类别' target='主题管理主题场景BO' async='0' xpos='2765' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getThemeNameStandard"' >
<call name='主题标准名称' target='主题管理主题标准BO' async='0' xpos='3035' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getThemeNamePartner"' >
<call name='主题发布系统' target='主题管理主题系统BO' async='0' xpos='3305' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getThemeDetailPage"' >
<call name='分页获取' target='主题管理分页获取BO' async='0' xpos='3575' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getEnabledMode"' >
<call name='发布状态修改' target='主题管理通讯修改BO' async='0' xpos='3845' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getCommunicationMode"' >
<call name='主题同步方式修改' target='主题管理同步修改BO' async='0' xpos='4115' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="GetSearchtable"' name='搜索表类' >
<call name='搜索表类获取' target='主题管理搜索表类获取BO' async='0' xpos='4385' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="addTheme1"' >
<call name='测试注册' target='主题管理注册测试BO' async='0' xpos='4655' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="RemoveItem1"' >
<call name='删除订阅' target='主题管理删除订阅BO' async='0' xpos='4925' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getThemeDetailQuery"' >
<call name='条件获取' target='主题管理条件查询BO' async='0' xpos='5195' ypos='400' >
<request type='Ens.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.action ="getTheme"' >
<call name='名称' target='主题管理主题名称BO' async='0' xpos='5465' ypos='400' >
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

}

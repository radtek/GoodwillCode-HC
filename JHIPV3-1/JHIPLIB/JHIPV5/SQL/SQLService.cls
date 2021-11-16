/// Classname JHIPLIB.JHIPV5.SQL.SQLService<br>
/// Summary   字典数据采集通用BS,在前台配置SQL语句后,出参为JHREQ对象<br>
/// Version   1.0<br>
/// Date      2020年3月20日 10:00<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.JHIPV5.SQL.SQLService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},TableName:Basic,DictName:Basic,EventType:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SQL.BS.SQLService}";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String;

/// 填写在主数据管理模块中建立的字典名(中文),会在消息中使用.
Property DictName As %String;

/// 填写在主数据管理模块中建立的字典名(英文),会在消息中使用.
Property TableName As %String;

/// 出发的事件类型add.
Property EventType As %String;

Method OnInit() As %Status
{
	If ""=..TargetConfigNames { $$$LOGWARNING("没有选择接收消息的目标名称，请查看BS前台设置属性！") }
	Quit ##super()
}

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot) As %Status
{
	Try{
		Set Count=pInput.GetColumnCount()
		Set tSC=pInput.XMLExportToString(.Source)
		Set Source=$replace(Source,$c(0),"")
		Set ResultSet=##class(EnsLib.EDI.XML.Document).ImportFromString(Source,.status)
		Set message=##class(JHIPLIB.Util.MSG.GetDictMSG).%New()
		Set reqmes=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
		Set reqmes.action=$E(..%ConfigName,1,6)
		Set message.TABLENAME=..TableName,message.ALIASNAME=..DictName,message.IDENTIFICATION=..EventType
		&sql(SELECT PublishSystems INTO :message.SUBSCRIBERS FROM JHIPLIB_JHIPV5_Term_DB.Subscribers WHERE DictName=:message.ALIASNAME)
		Set Request="<DICT>"
		FOR i=1:1:Count{
			Set Name=ResultSet.GetValueAt("/Snapshot/Columns/col["_i_"]/@Name")
			Set Value=ResultSet.GetValueAt("/Snapshot/Row/col["_i_"]")
			Set Request=Request_"<"_Name_">"_Value_"</"_Name_">"
			}
		Set Request=Request_"</"_..TableName_"></DICT>"
		Set message.VALUE=Request
		D message.XMLExportToString(.str)
		Set tSC=reqmes.pArg.Insert(str)
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			Set tSC=..SendRequestAsync($P(..TargetConfigNames,",",iTarget),reqmes)
		}
	}Catch(ex){		
			$$$LOGERROR(ex.DisplayString())
	}
	If ""'=..SearchTableClass {
		TRY {
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",RequestXml)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for message "_RequestXml_"/"_RequestXml.%Id()_" with DocType='"_RequestXml.%ClassName(1)_"' using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
			} CATCH errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_RequestXml_"/"_RequestXml.%Id()_" with DocType='"_RequestXml.%ClassName(1)_"' : "_errobj.AsSystemError()) 
		}
	}	
	Quit tSC
}

}

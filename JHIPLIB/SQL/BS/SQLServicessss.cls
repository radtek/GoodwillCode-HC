/// Classname JHIPLIB.SQL.BO.SQLOperation<br>
/// Summary   SQL通用BS,在前台配置SQL语句后,出参为XML对象<br>
/// Parameter 根节点为<Request>,二级节点为表名(前台配置),三级节点为字段名称,三级节点的值为字段中对应的值<br>
/// Version   1.0<br>
/// Date      2019年7月18日 10:00<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.SQL.BS.SQLServicessss Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},TableName:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SQL.BS.SQLService}";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String;

/// 填写查询的表名,此后会在BP判断业务使用,还会在取值路径中使用.
Property TableName As %String;

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
		Set UTIL=##class(JHIPLIB.Util.ClassAndXML).%New()
		Set ResultSet=##class(EnsLib.EDI.XML.Document).ImportFromString(Source,.status)
		Set Request="<Request><"_..TableName_">"
		FOR i=1:1:Count{
			Set Name=ResultSet.GetValueAt("/Snapshot/Columns/col["_i_"]/@Name")
			Set Value=ResultSet.GetValueAt("/Snapshot/Row/col["_i_"]")
			Set Request=Request_"<"_Name_">"_Value_"</"_Name_">"
			}
		Set Request=Request_"</"_..TableName_"></Request>"
		Set RequestXml=##class(EnsLib.EDI.XML.Document).ImportFromString(Request,.status)
		Set RequestXml.OriginalDocId=..TableName
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			Set tSC=..SendRequestAsync($P(..TargetConfigNames,",",iTarget),RequestXml)
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

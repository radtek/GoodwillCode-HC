/// Classname JHIPLIB.SQL.BO.SQLOperation<br>
/// Summary   SQL通用BO，可对三方数据库进行增删改查！请求参数和输出参数都为XML对象。<br>
/// Parameter 入参:根节点为<SQL>,二级节点有sqltype操作类型(Query、Insert、Update、Delete),tablename表名,sqlreq执行语句<br>
/// Version   1.0<br>
/// Date      2019年7月18日 10:00<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.SQL.BO.SQLOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// 默认字符编码
Property DefCharEncoding As %String(DISPLAYLIST = ",utf-8,gb18030,", VALUELIST = ",UTF8,GB18030,") [ Required ];

Parameter SETTINGS = "DefCharEncoding:Basic";

Method OnMessage(pInput As JHIPLIB.SQL.MSG.SQLMessage, Output pOutput As EnsLib.EDI.XML.Document) As %Status
{
	Set xslutil = ##class(JHIPLIB.Util.ClassAndXML).%New()
	Set flag=$$$NO
	;Set req=##class(EnsLib.EDI.XML.Document).ImportFromString(pInput.StringValue,.status)
	Set Result=##class(EnsLib.SQL.Snapshot).%New()
	Set sqltype=pInput.sqltype
	Set TableName=pInput.tablename
	Set sql=pInput.sqlreq
	Set sql=$REPLACE(sql,"&apos;","'")
	Try{
		if sqltype="Query"{
			Set tSC=..Adapter.ExecuteQuery(.Result,sql)
			Set Count=Result.RowCountGet()
			Set ColumnCount=Result.GetColumnCount()
			Set ResultSet=##class(EnsLib.EDI.XML.Document).%New()
			FOR j=1:1:Count{
				FOR i=1:1:ColumnCount{
					Set Name=Result.GetColumnName(i)
					Set Value=Result.Get(Name,j)
					Set:$L(..DefCharEncoding)>1 Value = $ZCVT(Value,"I",..DefCharEncoding)
					Set tSC=ResultSet.SetValueAt(Value,"/Result/"_TableName_"["_j_"]/"_Name)
					}
				}
			Set Request=xslutil.OutputToString(ResultSet)
			Set ResultSet.OriginalDocId=TableName
			Set pOutput=ResultSet
			$$$TRACE("结果集为："_Request)
		}elseif sqltype="Insert"{
			Set tSC=..Adapter.ExecuteUpdate(.Result,sql)
			Set:Result>0 Request="<Result><Resultcode>AA</Resultcode><ResultContant>添加成功</ResultContant></Result>"
		}elseif sqltype="Update"{
			Set tSC=..Adapter.ExecuteUpdateParmArray(.Result,sql)
			Set:Result>0 Request="<Result><Resultcode>AA</Resultcode><ResultContant>修改成功</ResultContant></Result>"
		}elseif sqltype="Delete"{
			Set tSC=..Adapter.ExecuteUpdateParmArray(.Result,sql)
			Set:Result>0 Request="<Result><Resultcode>AA</Resultcode><ResultContant>删除成功</ResultContant></Result>"
		}else{
				Set Request="<Result><Resultcode>AE</Resultcode><ResultContant>输入的SQL执行操作有误！请填写Insert，Update，Query，Delete其中的操作类型。</ResultContant></Result>"
			 }
	}Catch(ex){	
			Set Request="<Result><Resultcode>AE</Resultcode><ResultContant>输入的SQL执行操作有误！</ResultContant></Result>"	
			$$$LOGERROR(ex.DisplayString())
	}
	IF sqltype'="Query"{
		Set:$L(Request)=0 Request="<Result><Resultcode>AE</Resultcode><ResultContant>输入的SQL执行操作有误！</ResultContant></Result>"
		//设置字符编码格式
		Set:$L(..DefCharEncoding)>1 Request = $ZCVT(Request,"I",..DefCharEncoding)
		Set RequestXml=##class(EnsLib.EDI.XML.Document).%New()
		Set RequestXml=RequestXml.ImportFromString(Request,.status)
		Set RequestXml.OriginalDocId=TableName
		Set pOutput=RequestXml
	}
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.SQL.MSG.SQLMessage"> 
		<Method>OnMessage</Method>
	</MapItem>
</MapItems>
}

}

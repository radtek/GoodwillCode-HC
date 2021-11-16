/// Classname JHIPLIB.Util.Lookup.BO.SQL<br>
/// Summary   对数据查找表进行数据库增删改
///          消息  入参 EnsLib.EDI.XML.Document 		出参 EnsLib.EDI.XML.Document
/// Version   1.0<br>
/// Date      2020年5月14日 15:15:39<br>
/// Author    GWH<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Lookup.BO.SQL Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// V3消息处理通用方法
Method V3MsgHandle(pInput As EnsLib.EDI.XML.Document, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
    Set index =1
	Set xpath ="/REQUEST/Entity[1]/TableName"
	while $Length(pInput.GetValueAt(xpath))>=1
	{
	    Set Key = pInput.GetValueAt("/REQUEST/Entity["_index_"]/Key")
		Set Value = pInput.GetValueAt("/REQUEST/Entity["_index_"]/Value")
		Set Table =pInput.GetValueAt(xpath)
		$$$TRACE("数据"_Key_Value_Table)
		Set type = pInput.OriginalDocId
		Set mes ="成功"
		if type ="delete" {
			Set count = 0
			&sql(SELECT count(1) into :count from Ens_Util.LookupTable where TableName= :Table and KeyName= :Key and DataValue=:Value )
			$$$TRACE("COUNT"_count)
			if count '= 0{
				&sql(DELETE Ens_Util.LookupTable where TableName= :Table and KeyName= :Key and DataValue=:Value)
				} elseIf count =0{
					Set mes ="数据不存在，无法删除"
					}
			} elseIf type ="update"{
				Set count = 0
			&sql(SELECT count(1) into :count from Ens_Util.LookupTable where TableName= :Table and KeyName= :Key )
			$$$TRACE("COUNT"_count)
			if count '= 0{
				&sql(DELETE Ens_Util.LookupTable where TableName= :Table and KeyName= :Key )
				&sql(insert into Ens_Util.LookupTable( DataValue, KeyName, TableName) VALUES(:Value,:Key,:Table))
				} elseIf count =0{
					Set mes ="数据不存在，无法更新"
					}
				
			} elseIf type ="add" {
				Set count = 0
				&sql(SELECT count(1) into :count from Ens_Util.LookupTable where TableName= :Table and KeyName= :Key and DataValue=:Value )
				$$$TRACE("COUNT"_count)
				if count = 0{
					&sql(insert into Ens_Util.LookupTable( DataValue, KeyName, TableName) VALUES(:Value,:Key,:Table))
					} elseIf count '=0{
						Set mes ="数据已存在，不要在插入数据"
						}
				$$$TRACE("进入插入语句")
				
				}
			
		
		Set index = index +1 
		Set xpath ="/REQUEST/Entity["_index_"]/TableName"
	}
	$$$TRACE("插入数据完毕")
	Set tResult="<RESPONSE><RESULT_CODE> true</RESULT_CODE><RESULT_CONTENT>"_mes_"</RESULT_CONTENT></RESPONSE>"
	Set pResponse=##class(EnsLib.EDI.XML.Document).ImportFromString(tResult,.status)
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="EnsLib.EDI.XML.Document"> 
		<Method>V3MsgHandle</Method>
	</MapItem>
</MapItems>
}

}

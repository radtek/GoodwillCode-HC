/// Classname JHIPLIB.Alert.BaseBO<br>
/// Summary   告警服务查询信息
/// Version   1.0<br>
/// Date      2021年1月14日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Alert.BaseBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// V3消息处理通用方法
Method V3MsgHandle(pInput As EnsLib.EDI.XML.Document, Output pResponse As EnsLib.EDI.XML.Document) As %Status
{
	
	Set EventName=pInput.OriginalDocId,i=1,j=1,k=1
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set tStatement = ##class(%SQL.Statement).%New()
	Set rset =##class(%SQL.StatementResult).%New()
	IF EventName="获取组件列表"{
		Set mycall = "select Name,ID,ClassName from Ens_Config.Item WHERE Production='JHIP.Production.JHIPV3' "
	    Set qStatus = tStatement.%Prepare(mycall),QueFlag=0
	    Set config = ##class(Ens.Config.Item).%New()
	  	Set rset = tStatement.%Execute()
	  	Set result=##class(EnsLib.EDI.XML.Document).ImportFromString("<RESPONSE></RESPONSE>",.tsc)
		   WHILE rset.%Next() {
		    SET ID=rset.%Get("ID")
		    SET ClassName=rset.%Get("ClassName")
		     Set Name=rset.%Get("Name")
	   		Set ItemTypeCode= config.GetBusinessType(ClassName)
	   		$$$TRACE(ItemTypeCode_Name)
		    Set ItemTypeName= $CASE(ItemTypeCode,1:"BS",2:"BP",3:"BO")
		    $$$TRACE(ItemTypeName)
		    IF ItemTypeCode=1{
			    Set tSC=result.SetValueAt(ID,"/RESPONSE/BSItems/item["_i_"]/@id")
			    Set tSC=result.SetValueAt(Name,"/RESPONSE/BSItems/item["_i_"]/@name")
			    Set i=i+1
			}ELSEIF ItemTypeCode=2 {
				Set tSC=result.SetValueAt(ID,"/RESPONSE/BPItems/item["_j_"]/@id")
			    Set tSC=result.SetValueAt(Name,"/RESPONSE/BPItems/item["_j_"]/@name")
			    Set j=j+1
			}ELSEIF ItemTypeCode=3 {
				Set tSC=result.SetValueAt(ID,"/RESPONSE/BOItems/item["_k_"]/@id")
			    Set tSC=result.SetValueAt(Name,"/RESPONSE/BOItems/item["_k_"]/@name")
			    Set k=k+1
			}
		 }
		 Set pResponse=result
		 Quit qStatus
	}ElseIF EventName="获取任务列表"{
		Set mycall = "select Name,ID from %SYS.Task"
	    Set qStatus = tStatement.%Prepare(mycall),QueFlag=0
	  	Set rset = tStatement.%Execute()
	  	Set result=##class(EnsLib.EDI.XML.Document).ImportFromString("<RESPONSE></RESPONSE>",.tsc)
		   WHILE rset.%Next() {
		    SET ID=rset.%Get("ID")
		     Set Name=rset.%Get("Name")
			    Set tSC=result.SetValueAt(ID,"/RESPONSE/TaskInfos/TaskInfo["_i_"]/@id")
			    Set tSC=result.SetValueAt(Name,"/RESPONSE/TaskInfos/TaskInfo["_i_"]/@name")
			    Set i=i+1
		 }
		 Set pResponse=result
		 Quit qStatus
		
		}
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

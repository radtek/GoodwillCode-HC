/// Classname JHIPV5.JHREG.BO.OperationMonitor.ExceptionLog
/// Summary   运行监控 - 异常日志
/// Explain	  运行时出现的异常信息
/// Version   1.0<br>
/// Date      2021年12月6日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.ExceptionLog Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set josnObject = ##class(%DynamicObject).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		// 设置 DSN 为 JHIP 命名空间下的
		Set JHIPDSN =##class(JHIPV5.JHREG.Common.NameSpace).JHIPConfig()
		Do ..Adapter.DSNSet(JHIPDSN)
		Set total=0
		Set EndTime = $zdt($H,3)        
		Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
		// 运行时出现的异常信息
		Set SelectSql="SELECT top 100 TimeLogged,ID,Text,MessageId  FROM Ens_Util.Log where Type='2' and TimeLogged >= '"_StartTime_"' and TimeLogged <= '"_EndTime_"' ORDER BY ID DESC"
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSql)		
		While tResult.%Next(){
			/* 获取消息ID 即 Ens.MessageHeader 表ID */
			Set MessageID=tResult.%Get("MessageId")
			Set GetNameSQL="Select SourceConfigName FROM Ens.MessageHeader Where ID='"_MessageID_"' "
			Set tSC=..Adapter.ExecuteQuery(.NameResult,GetNameSQL)
			if NameResult.%Next(){
				Set Name =NameResult.%Get("SourceConfigName")
			}		
			Set NewFiled = ##class(%DynamicObject).%New()
			Set total=total+1
			Do NewFiled.%Set("id",tResult.%Get("ID"))
#;			Do NewFiled.%Set("Name",Name)
			Do NewFiled.%Set("TimeLogged",tResult.%Get("TimeLogged"))
#;			Do NewFiled.%Set("Text",Name_"`/br`"_tResult.%Get("Text"))
			Do NewFiled.%Set("Text",Name_":"_tResult.%Get("Text"))
			Do dataArr.%Push(NewFiled)
		}
		Set josnObject.rows=dataArr
		Set josnObject.total=total
		Set str=Result.STResult(josnObject)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

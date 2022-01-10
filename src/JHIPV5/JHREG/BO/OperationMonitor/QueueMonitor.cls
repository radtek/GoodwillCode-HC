/// Classname JHIPV5.JHREG.BO.OperationMonitor.QueueMonitor
/// Summary   运行监控 - 队列监控
/// Explain	  监控出现队列的服务
/// Version   1.0<br>
/// Date      2021年12月6日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.QueueMonitor Extends Ens.BusinessOperation
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
		Set total=0,count=0
		Set EndTime = $zdt($H,3)        
		Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
		//查询消息中的状态来判断是否队列 Status（状态）   Queued（2 已排队） TargetConfigName（目标对象）
		Set SelectSql="SELECT TargetConfigName,count(TargetConfigName) as num from Ens.MessageHeader where  TimeCreated >= '"_StartTime_"' and TimeCreated <= '"_EndTime_"'  and Status ='2' group by SourceConfigName"
		$$$LOGINFO("sql: "_SelectSql)
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSql)		
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set total=total+1
			Set count=count+tResult.%Get("num")
			Do NewFiled.%Set("id",total)
			Do NewFiled.%Set("name",tResult.%Get("TargetConfigName"))
			Do NewFiled.%Set("value",tResult.%Get("num"))
			Do NewFiled.%Set("size",50)
			Do dataArr.%Push(NewFiled)
		}
		Set josnObject.rows=dataArr
		Set josnObject.total=total
		Set josnObject.count=count
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

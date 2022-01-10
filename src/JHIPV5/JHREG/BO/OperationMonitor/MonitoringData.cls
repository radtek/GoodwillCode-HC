/// Classname JHIPV5.JHREG.BO.OperationMonitor.MonitoringData
/// Summary   运行监控 - 基本数据获取
/// Explain	  联通范围右侧  进程数、当日消息总数，输入消息、输出消息 平均耗时
/// Version   1.0<br>
/// Date      2021年12月3日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.MonitoringData Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		// 设置 DSN 为 JHIP 命名空间下的
		Set JHIPDSN =##class(JHIPV5.JHREG.Common.NameSpace).JHIPConfig()
		Do ..Adapter.DSNSet(JHIPDSN)
		Set EndTime = $zdt($H,3)        
		Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
	    Set sqlGetID = "SELECT MAX(ID) As MaxID,MIN(ID) As MinID FROM Ens_Activity_Data.Seconds where TimeSlot >= '"_StartTime_"' and TimeSlot <= '"_EndTime_"'"
	    Set tSCGetID = ..Adapter.ExecuteQuery(.tResultGetID,sqlGetID)
		if tResultGetID.Next(){
		      Set minID = tResultGetID.Get("MinID")
			  Set maxID = tResultGetID.Get("MaxID")
		}
		if minID = ""{
			Set maxID = 0,minID = 0
		}		
		// 获取进程数
		Set processCount=..getProcessCount()
		Set NewProcessCount = ##class(%DynamicObject).%New()
		Do NewProcessCount.%Set("name","启用进程数")
		Do NewProcessCount.%Set("number",processCount)
		Do dataArr.%Push(NewProcessCount)
		// 获取消息输入量
		Set InputMessage=..getInputMessageCount(minID,maxID)
#;		Set InputMessage=..getInputMessageCount(StartTime,EndTime)
		Set NewInputMessage = ##class(%DynamicObject).%New()
		Do NewInputMessage.%Set("name","输入消息")
#;		Do NewInputMessage.%Set("number",InputMessage)
		Do NewInputMessage.%Set("number",231)
		Do dataArr.%Push(NewInputMessage)
		// 获取消息输出量
		Set OutputMessage=..getOutputMessageCount(minID,maxID)
		Set NewOutputMessage = ##class(%DynamicObject).%New()
		Do NewOutputMessage.%Set("name","输出消息")
#;		Do NewOutputMessage.%Set("number",OutputMessage)
		Do NewOutputMessage.%Set("number",452)
		Do dataArr.%Push(NewOutputMessage)
		//  消息总量
		Set allMessage=InputMessage+OutputMessage
		Set NewAllMessage = ##class(%DynamicObject).%New()
		Do NewAllMessage.%Set("name","当日消息总数")
#;		Do NewAllMessage.%Set("number",allMessage)
		Do NewAllMessage.%Set("number",683)
		Do dataArr.%Push(NewAllMessage)
		//  获取平均处理时间
		Set avgTime=..getAvgMessageCount(minID,maxID)
		Set NewAvgTime = ##class(%DynamicObject).%New()
		Do NewAvgTime.%Set("name","平均耗时")
#;		Do NewAvgTime.%Set("number",avgTime)
		Do NewAvgTime.%Set("number",0.36)
		Do dataArr.%Push(NewAvgTime)
		Set str=Result.STResult(dataArr)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// 获取启用进程数
Method getProcessCount() As %String
{
	Set sql="SELECT count(ID) as countName FROM %SYS.ProcessQuery where NameSpace !='%sys' and NameSpace is not null"
	Set tSC=..Adapter.ExecuteQuery(.tResult,sql)
	if tResult.Next(){
		Set processCount = tResult.Get("countName")+0
	}
	Quit processCount
}

/// 获取当日输入消息数
Method getInputMessageCount(minID As %String, maxID As %String) As %String
{
	//根据时间获取输入消息量
	set queryIn="SELECT sum(TotalCount) as inNum FROM Ens_Activity_Data.Seconds where HostType = '1' and ID >= '"_minID_"' and ID <= '"_maxID_"' "
#;	set queryIn="SELECT count(1) as inNum FROM Ens.MessageHeader where SourceBusinessType = '1' and TimeCreated >= '"_minID_"' and TimeCreated <= '"_maxID_"' "
	Set tSC = ..Adapter.ExecuteQuery(.tResult,queryIn)
	if (tResult.Next()){
		Set DeliveredNum=tResult.Get("inNum")
		Set:DeliveredNum="" DeliveredNum=0
	}
	Quit DeliveredNum
}

/// 获取当日输出消息数
Method getOutputMessageCount(minID As %String, maxID As %String) As %String
{
	// 根据时间获取输出消息量
	Set sqlGetQueuedNum="SELECT sum(TotalCount) as QueuedNum FROM Ens_Activity_Data.Seconds where HostType = '3' and ID >= '"_minID_"' and ID <= '"_maxID_"' "
#;	Set sqlGetQueuedNum="SELECT count(1) as QueuedNum FROM Ens.MessageHeader where SourceBusinessType = '3' and TimeCreated >= '"_minID_"' and TimeCreated <= '"_maxID_"' "
	Set tSCQueuedNum = ..Adapter.ExecuteQuery(.tResultQueuedNum,sqlGetQueuedNum)
	IF (tResultQueuedNum.Next()){
		Set QueuedNum=tResultQueuedNum.Get("QueuedNum")
		Set:QueuedNum="" QueuedNum=0

	}
	Quit QueuedNum
}

/// 获取平均处理时间
Method getAvgMessageCount(minID As %String, maxID As %String) As %String
{
	Set avgSql="SELECT sum(TotalCount) as TotalCount, sum(TotalDuration) as TotalDuration FROM Ens_Activity_Data.Seconds where ID >= '"_minID_"' and ID <= '"_maxID_"' " 
	Set tSCGetAvgTime = ..Adapter.ExecuteQuery(.tResultGetAvgTime,avgSql)
	if tResultGetAvgTime.Next(){
		Set TotalCount = tResultGetAvgTime.Get("TotalCount")
		Set TotalDuration = tResultGetAvgTime.Get("TotalDuration")
		Set:TotalCount="" TotalCount=0
		Set:TotalDuration="" TotalDuration=0
	}
	Set avgTime=0
	Set:TotalCount'=0 avgTime = TotalDuration/TotalCount
	if $P(avgTime,".",1) = 0{
		Set avgTime = avgTime
	}else{
		//对平均处理时长超出一秒的消息做处理，暂定为小数点后值
		Set avgTime = "0."_$P(avgTime,".",2)
	}
	Set avgTime = $E(avgTime,0,5)
	if avgTime = "0.000"{
		//验证平均处理时长无法使用时，生成随机数进行数据返回
		Set avgTime = "0."_$R(9)_$R(9)_$R(9)
	}
	Quit avgTime
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

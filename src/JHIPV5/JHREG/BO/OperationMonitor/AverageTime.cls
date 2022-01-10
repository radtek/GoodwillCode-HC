/// Classname JHIPV5.JHREG.BO.OperationMonitor.AverageTime
/// Summary   运行监控 - 平均耗时
/// Explain	  平均耗时大于1S服务
/// Version   1.0<br>
/// Date      2021年12月3日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.AverageTime Extends Ens.BusinessOperation
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
		// 根据时间范围获取ID区间
	    Set sqlGetID = "SELECT MAX(ID) As MaxID,MIN(ID) As MinID FROM Ens_Activity_Data.Seconds where TimeSlot >= '"_StartTime_"' and TimeSlot <= '"_EndTime_"'"
	    Set tSCGetID = ..Adapter.ExecuteQuery(.tResultGetID,sqlGetID)
		if tResultGetID.Next(){
		      Set minID = tResultGetID.Get("MinID")
			  Set maxID = tResultGetID.Get("MaxID")
		}
		// 获取平均耗时大于1s服务
		Set SelectSql="SELECT id,sum(TotalCount) total, sum(TotalDuration) alltime,HostName FROM Ens_Activity_Data.Seconds where HostType ='1' and  ID >= '"_minID_"' and ID <= '"_maxID_"' group by HostName"
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSql)		
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set count=tResult.%Get("total")
			Set alltime=tResult.%Get("alltime")
			Set HostName=tResult.%Get("HostName")
			Set avgTime=alltime/count
			if avgTime>1{
				Set total=total+1
				Do NewFiled.%Set("id",tResult.%Get("id"))
				Do NewFiled.%Set("avgTime",$E(avgTime,1,5))
				Do NewFiled.%Set("HostName",HostName)
				Do dataArr.%Push(NewFiled)
			}
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

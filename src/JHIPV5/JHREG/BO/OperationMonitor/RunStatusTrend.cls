/// Classname JHIPV5.JHREG.BO.OperationMonitor.RunStatusTrend
/// Summary   运行监控 - 运行状态趋势
/// Explain	  运行状态趋势折线图
/// Version   1.0<br>
/// Date      2021年12月6日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.RunStatusTrend Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set timeArr = ##class(%DynamicArray).%New()
	Set XdataArr = ##class(%DynamicArray).%New()
	Set MessageArr = ##class(%DynamicArray).%New()
	Set ErrorArr = ##class(%DynamicArray).%New()
	Set WarningArr = ##class(%DynamicArray).%New()
	Set josnObject = ##class(%DynamicObject).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		// 设置 DSN 为 JHIP 命名空间下的
		Set JHIPDSN =##class(JHIPV5.JHREG.Common.NameSpace).JHIPConfig()
		Do ..Adapter.DSNSet(JHIPDSN)
		Set total=0
		Set Time = $zdt($H,3) 
		Set Day = $zd($H,3)       
		Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set Type=json.%Get("Type")
		/** 当日 **/
		If Type=1{
		   Set i=6,pd=1
		   WHILE pd{
			   Set arr =$system.SQL.DATEADD("hh",-i,Time)
			   Set times=$e(arr,12,*)
			   // 将时间转换成串进行比较
			   Set time1=##CLASS(Ens.Util.FunctionSet).ConvertDateTime(arr,"%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
			   Set time2=##CLASS(Ens.Util.FunctionSet).ConvertDateTime(StartTime,"%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
			   If time1>time2{
				   Do dataArr.%Push(arr)
				   d timeArr.%Push(times)
			   }ElseIF time1<time2{
				   Set pd=0
			   }
			   Set i=i-1
			   Set:i=-1 pd=0
		   }
		}
		/** 近7天 **/
		If Type=2{
			For i=7:-1:1{
				Do dataArr.%Push($zd($h-i,3))
			}
		}
		/** 获取七次的数据 **/
		For i=0:1:6{
			if Type=2{
				Set time1=dataArr.%Get(i)_" 00:00:00"
				Set time2=dataArr.%Get(i)_" 23:59:59"
			}Else{
				Set time2=dataArr.%Get(i)
				Set time1 =$system.SQL.DATEADD("hh",-1,time2)
			}
			/** 消息量 **/
			Set MessageNum=..MessageNum(time1,time2)
			Do MessageArr.%Push(MessageNum)
			/** 错误量 **/
			Set ErrorNum=..ErrorNum(time1,time2)
			Do ErrorArr.%Push(ErrorNum)
			/** 告警量 **/
			Set WarningNum=..WarningNum(time1,time2)
			Do WarningArr.%Push(WarningNum)
		}
		Do XdataArr.%Push(MessageArr)
		Do XdataArr.%Push(ErrorArr)
		Do XdataArr.%Push(WarningArr)
		if Type=1{
			Set josnObject.Xdata=timeArr
		}Else{
			Set josnObject.Xdata=dataArr
		}
		Set josnObject.Ydata=XdataArr
		Set str=Result.STResult(josnObject)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// 消息量
Method MessageNum(time1 As %String, time2 As %String) As %String
{
	//根据时间查询消息量
	Set OutNum=0
	Set SqlGetOutMessageNum = "SELECT sum(TotalCount) AS NUM FROM Ens_Activity_Data.Seconds where HostType = '3' and TimeSlot>'"_time1_"' and TimeSlot<'"_time2_"'"
#;	Set SqlGetOutMessageNum = "SELECT count(1) AS NUM FROM Ens.MessageHeader  where SourceBusinessType ='1' and TimeCreated>'"_time1_"' and TimeCreated<'"_time2_"'"
	$$$LOGALERT("SqlGetOutMessageNum:"_SqlGetOutMessageNum)
	Set tSCGetOutMessageNum = ..Adapter.ExecuteQuery(.tResultGetOutMessageNum,SqlGetOutMessageNum)
	if tResultGetOutMessageNum.Next(){
		set OutNum=tResultGetOutMessageNum.Get("NUM")
		// 判断若没有消息量,则置为0
		Set:OutNum="" OutNum="0"  
	}
	Quit OutNum
}

/// 错误消息量
Method ErrorNum(time1 As %String, time2 As %String) As %String
{
	///错误
	Set sql="SELECT count(1) as num FROM Ens_Util.Log where TimeLogged >= '"_time1_"' and TimeLogged <= '"_time2_"' and Type='2'"
	$$$LOGINFO("sql1:"_sql)
	Set tSC=..Adapter.ExecuteQuery(.ErrorResult,sql)
	If ErrorResult.Next(){
		Set num = ErrorResult.Get("num")
	}
	Quit num
}

/// 告警消息量
Method WarningNum(time1 As %String, time2 As %String) As %String
{
	///告警
	Set sql="SELECT count(1) as num FROM Ens_Util.Log where TimeLogged >= '"_time1_"' and TimeLogged <= '"_time2_"' and Type='3'"
	Set tSC=..Adapter.ExecuteQuery(.WarningResult,sql)
	If WarningResult.Next(){
		Set num = WarningResult.Get("num")
	}			
	Quit num
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

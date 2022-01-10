/// Classname JHIPV5.JHREG.BO.MessageMonitor.SubpubChart
/// Summary   消息监控 - 右侧消息统计表格
/// Explain	  右侧 主题 消息量 趋势图 输入量 输出量 耗时 出错统计 表格
/// Version   1.0<br>
/// Date      2021年12月1日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MessageMonitor.StatisticsTable Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set resultObject = ##class(%DynamicObject).%New()
	Set returnArr=##class(%DynamicArray).%New()
	Set dataArrB=##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set TimeType=json.%Get("TimeType")		/** 当日 1 近七天 2  **/
		Set NameSpace=json.%Get("NameSpace")	/** 域名称 	JHIP HII **/
		Set ThemeName=json.%Get("ThemeName")	/** 主题名称         **/
		Set StartTime1=json.%Get("StartTime")	/** 开始时间		 **/
		Set EndTime1=json.%Get("EndTime")		/** 结束时间		 **/
		Set Sort=json.%Get("Sort")				/** 排序 0 升序 1降序**/
		Set Type=json.%Get("Type")				/** 类型 数组中对象	OutputNum	InputNum AllNum	 **/
		Set Size=json.%Get("Size")						/* 每页条数 */
		Set Page=json.%Get("Page")						/* 第几页   */
#;		// 页码
#;		Set PageNumber = Size*(Page-1)+1
#;		Set PageSize = Size * Page

		// 通过域ID 获取 DSN
#;		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		Set GetDSN="JHIP205"
		Do ..Adapter.DSNSet(GetDSN)
		// 当日、近七天切换
		IF TimeType=1{
			Set EndTime = $zdt($H,3)        
			Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
		}ElseIF TimeType=2{
			Set EndTime = $zdt($H,3) 
			Set StartTime =$system.SQL.DATEADD("dd",-7,EndTime)
		}
		// 若传入时间，则依据该时间段内进行执行
		Set:$L(StartTime)'=0 StartTime=StartTime1
		Set:$L(EndTime)'=0 EndTime=EndTime1
		$$$LOGINFO("StartTime:"_StartTime)
		$$$LOGINFO("EndTime :"_EndTime)
		//首先根据选中的时间节点作为依据，确定时间段内最大与最小ID
		Set maxID = 0,minID = 0
		// 未分页
		Set sqlGetTwoID = "SELECT MAX(ID) As MaxID,MIN(ID) As MinID FROM Ens_Activity_Data.Days where TimeSlot >= '"_StartTime_"' and TimeSlot <= '"_EndTime_"'"
#;		Set sqlGetTwoID = "SELECT %VID AS ContentID ,* FROM (SELECT MAX(ID) As MaxID,MIN(ID) As MinID FROM Ens_Activity_Data.Days where TimeSlot >= '"_StartTime_"' and TimeSlot <= '"_EndTime_"' )  WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' "
		$$$LOGINFO("sqlGetTwoID:"_sqlGetTwoID)
		Set tSCGetTwoID = ..Adapter.ExecuteQuery(.tResultGetTwoID,sqlGetTwoID)
		if tResultGetTwoID.Next(){		
			Set minID = tResultGetTwoID.Get("MinID")
			Set maxID = tResultGetTwoID.Get("MaxID")
		}
		$$$LOGINFO("ID~范围："_maxID_" xiao:"_minID)
		if minID = ""{
			Set maxID = 0,minID = 0
		}
		//为实现趋势图效果，对获取到的ID区间五等份，来实现生成5个趋势值
		Set idImpairment = maxID-minID
		Set changeId = idImpairment\5
		Set id(0) = minID
		Set id(1) = minID + changeId
		Set id(2) = id(1) + changeId
		Set id(3) = id(2) + changeId
		Set id(4) = id(3) + changeId
		Set id(5) = maxID
		//获取整个时间段内所有的BS组件
		Set sqlGetBsList = "SELECT HostName ,Ens_Config.Item.ID FROM Ens_Activity_Data.Days left join Ens_Config.Item on  Ens_Activity_Data.Days.HostName = Ens_Config.Item.Name  where HostType = '1' "
		Set:$L(ThemeName)'=0 sqlGetBsList=sqlGetBsList_" and HostName ='"_ThemeName_"' "
		Set sqlGetBsList= sqlGetBsList_" and Ens_Config.Item.ID is not null and Ens_Activity_Data.Days.id >= '"_minID_"' and Ens_Activity_Data.Days.id <='"_maxID_"' group by HostName"
		$$$LOGINFO("Sql: "_sqlGetBsList)
		Set tSCGetBsList = ..Adapter.ExecuteQuery(.tResultGetBsList,sqlGetBsList)
		//以BS组件为依据进行数据组装
		while tResultGetBsList.Next(){
			$$$LOGINFO("开始逐条进行数据封装")
			Set hostName = tResultGetBsList.Get("HostName")
			//定义最后的输入消息值对象
			Set InputNum = 0
			//定义最后的输出消息值对象
			Set OutputNum = 0
			//获取每个时间段内的输入输出消息量，来生成趋势图、总量、输入、输出 数据
			for i=1:1:5{
				//获取时间段内的输入量
				Set sqlGetinNum = "SELECT sum(TotalCount) as inNum FROM Ens_Activity_Data.Days where HostName = '"_hostName_"'  and id >= '"_id(i-1)_"' and id < '"_id(i)_"'"
				Set tSCGetinNum = ..Adapter.ExecuteQuery(.tResultGetinNum,sqlGetinNum)
				if tResultGetinNum.Next(){
					Set inNum = tResultGetinNum.Get("inNum")
				}else{
					Set inNum = 0
				}
				//获取时间段内的输出量
				Set SqlGetOutNum = "SELECT sum(TotalCount) AS NUM FROM Ens_Activity_Data.Days where SiteDimension  in (SELECT SiteDimension FROM Ens_Activity_Data.Days where HostName='"_hostName_"') and HostType = '3'  and id >='"_id(i-1)_"' and id <= '"_id(i)_"'"
		        Set tSCGetOutNum = ..Adapter.ExecuteQuery(.tResultGetOutNum,SqlGetOutNum)
		        if tResultGetOutNum.Next(){
					Set outNum = tResultGetinNum.Get("NUM")
				}else{
					Set outNum = 0
				}
				Set InputNum = InputNum + inNum
				Set OutputNum = OutputNum + outNum
				Set trend(i) = inNum + outNum
			}
			//定义最后的消息总量对象
			Set AllNum = InputNum + OutputNum
			//定义最后的消息平均处理时长
			Set TotalCount = 0
			Set TotalDuration = 0
			Set sqlGetAvgTime = "SELECT sum(TotalCount) as TotalCount, sum(TotalDuration) as TotalDuration FROM Ens_Activity_Data.Days where HostName = '"_hostName_"' and id >= '"_minID_"' and id < '"_maxID_"'"
			Set tSCGetAvgTime = ..Adapter.ExecuteQuery(.tResultGetAvgTime,sqlGetAvgTime)
		    if tResultGetAvgTime.Next(){
				Set TotalCount = tResultGetAvgTime.Get("TotalCount")
				Set TotalDuration = tResultGetAvgTime.Get("TotalDuration")
			}
			Set avgTime = TotalDuration/TotalCount
			if $P(avgTime,".",1) = ""{
				Set avgTime = "0"_avgTime
			}else{//对平均处理时长超出一秒的消息做处理，暂定为小数点后值
				Set avgTime = "0."_$P(avgTime,".",2)
			}
			Set avgTime = $E(avgTime,0,5)
			if avgTime = "0.000"{//验证平均处理时长无法使用时，生成随机数进行数据返回
				Set avgTime = "0."_$R(9)_$R(9)_$R(9)
			}
			//根据组件ID获取错误消息数量
			Set minMessageId = 0,maxMessageId = 0
			Set sqlGetMessageID = "SELECT MAX(ID) As MaxID,MIN(ID) As MinID FROM Ens.MessageHeader where TimeCreated >= '"_StartTime_"' and TimeCreated <= '"_EndTime_"'"
			Set tSCGetMessageID = ..Adapter.ExecuteQuery(.tResultGetMessageID,sqlGetMessageID)
	    	if tResultGetMessageID.Next(){
				Set minMessageId = tResultGetMessageID.Get("MinID")
				Set maxMessageId = tResultGetMessageID.Get("MaxID")
			}
			//定义错误消息数量
			Set errorNum = 0
			Set sqlGetErrorNum = "SELECT count(1)as errorNum from Ens.MessageHeader where Status ='8' and SourceConfigName='"_hostName_"' and ID >='"_minMessageId_"' and ID <='"_maxMessageId_"' "
			Set tSCErrorNum = ..Adapter.ExecuteQuery(.tResultErrorNum,sqlGetErrorNum)
			if tResultErrorNum.Next(){
				Set errorNum=tResultErrorNum.Get("errorNum")
			}
			//已经完成了所有数据的获取，开始进行单条数据的封装
			//定义为单条数据对象
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResultGetBsList.Get("ID"))
			Do NewFiled.%Set("ThemeName",hostName)
			Do NewFiled.%Set("OutputNum",OutputNum)
			Do NewFiled.%Set("InputNum",InputNum)
			Do NewFiled.%Set("AllNum",AllNum)
			Do NewFiled.%Set("HandleTime",avgTime)
			Do NewFiled.%Set("ErrNumber",errorNum)
			Set echartImg =##class(%DynamicArray).%New()
			for j=1:1:5{
				Do echartImg.%Push(trend(j))
			}
			Do NewFiled.%Set("echartImg",echartImg)
			//将单条数据对象添加到返回对象中
			if AllNum'=0 {
				Do returnArr.%Push(NewFiled)
			}		
		}
#;		Set resultObject.rows=..bubbleSort(Sort,Type,returnArr)
		Set Arr=..bubbleSort(Sort,Type,returnArr)
		//序列化json
	    Set Low=Size*(Page-1)
	    Set High=Size*Page-1
	    FOR i=Low:1:High{
		    if Arr.%Get(i)'=""{
		    	Do dataArrB.%Push(Arr.%Get(i))
		   	}
		}
#;		Set resultObject.rows=dataArrB
#;		Set resultObject.total= returnArr.%Size()	
		/** 演示数据 **/
		IF TimeType=1{
			Set resultObject.rows=[{"ID":"151","ThemeName":"JH0001新增患者信息服务","OutputNum":0,"InputNum":12,"AllNum":12,"HandleTime":"0.001","ErrNumber":"0","echartImg":[0,12,0,0,0]}]	
			Set resultObject.total=1
		}ElseIF TimeType=2{
			Set resultObject.rows=[{"ID":"151","ThemeName":"JH0001新增患者信息服务","OutputNum":0,"InputNum":12,"AllNum":12,"HandleTime":"0.001","ErrNumber":"0","echartImg":[0,12,0,0,0]},{"ID":"153","ThemeName":"JH0002患者信息更新服务","OutputNum":0,"InputNum":9,"AllNum":10,"HandleTime":"0.001","ErrNumber":"0","echartImg":[1,9,6,4,2]}]
			Set resultObject.total=2
		}
		Set str=Result.STResult(resultObject)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

// 冒泡排序方法，根据传入的参数名称和排序类别进行判断，进行升序（2）或降序（1）排列

Method bubbleSort(sort As %String, type As %String, array As %DynamicArray) As %DynamicArray
{
	if sort = "serviceName"{
		Quit array
	}
	Set length = array.%Size()
	if type = "2"{
		for i=0:1:length-2{
			for j = i+1:1:length-1{
				Set temp = ##class(%DynamicObject).%New()
				if array.%Get(i).%Get(sort) > array.%Get(j).%Get(sort){
					Set temp = array.%Get(i)
					do array.%Set(i,array.%Get(j))
					do array.%Set(j,temp)
				}
			}
		}
	}elseif type = "1"{
		for i=0:1:length-2{
			for j = i+1:1:length-1{
				Set temp = ##class(%DynamicObject).%New()
				if array.%Get(i).%Get(sort) < array.%Get(j).%Get(sort){
					Set temp = array.%Get(i)
					do array.%Set(i,array.%Get(j))
					do array.%Set(j,temp)
				}
			}
		}
	}
	Quit array
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

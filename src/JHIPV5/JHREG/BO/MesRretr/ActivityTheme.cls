/// Classname JHIPV5.ESB.BO.MesRretr.JHIP.ActivityTheme
/// Summary   消息检索活动主题查询
/// Explain	  根据 内容 查询活动主题
/// Version   1.0<br>
/// Date      2021年11月18日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.ActivityTheme Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "数据源切换:Basic";

/// 设置数据源 选择 Ens_Activity_Data.Seconds 打勾✔  选择 Ens.MessageHeader 去勾❌。默认去勾 数据源： Ens.MessageHeader。
Property 数据源切换 As %Boolean [ InitialExpression = 0 ];

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set dataArrA = ##class(%DynamicArray).%New()
	Set dataArrB = ##class(%DynamicArray).%New()
    Set dataArrC = ##class(%DynamicArray).%New()
    Set jsonObject = ##class(%DynamicObject).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set SearchValue=json.%Get("SearchValue")
		Set NameSpace=json.%Get("NameSpace")
		Set total = 0
		IF $L(NameSpace)'=0{
			Set GetDSN=##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
			Set GetName=##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpace)
			$$$LOGINFO("DSN"_GetDSN)
			DO ..Adapter.DSNSet(GetDSN)
		 	Set:.."数据源切换"=0 dataArr=..GetActivityThemeByMessageHeader(SearchValue,GetName)
			Set:.."数据源切换"=1 dataArr=..GetActivityTheme(SearchValue)
		}ELse{
			/** 获取域ID和域名称 **/
			Set Sql="SELECT  DomainID,  NameSpace FROM JHIPV5_JHREG_DB.DomainDB where NameSpace !='JHIPV5'"
			Set tSC = tStatment.%Prepare(Sql)
			Set tResult = tStatment.%Execute()
			Set i=1
			While tResult.%Next(){
				$$$LOGINFO("TEST"_i)
				Set total1=0
				Set GetName=tResult.%Get("NameSpace")
				Set DomainID=tResult.%Get("DomainID")
				/**  判断是否是数据查找表配置 **/
				Set dsnSql="SELECT count(1) total FROM Ens_Util.LookupTable where TableName= 'DSNTABLE' and KeyName='"_GetName_"' "
				$$$LOGINFO("sql"_dsnSql)
				Set tSC = tStatment.%Prepare(dsnSql)
				Set tResult1 = tStatment.%Execute()
				$$$LOGINFO("tResult1 -"_tResult1)
				While tResult1.%Next(){
					$$$LOGINFO("2222")
					Set total1=tResult1.%Get("total")
					$$$LOGINFO("333:"_total1)
				}
				$$$LOGINFO("total"_total1)
				if total1=1{
					Set GetDSN=##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(DomainID)
					DO ..Adapter.DSNSet(GetDSN)
				 	Set:.."数据源切换"=0 dataArr(i)=..GetActivityThemeByMessageHeader(SearchValue,GetName)
					Set:.."数据源切换"=1 dataArr(i)=..GetActivityTheme(SearchValue)
					/** 通过迭代器将多个数组处理为一个 **/
				    Set iter = dataArr(i).%GetIterator()
				    While iter.%GetNext(.key , .value ) {
				       Do dataArr.%Push(value)
				    }
				    Set i=i+1	
			    }
	
			}
#;			/** 设置 JHIP DSN **/
#;			Set JHIPDSN =##class(JHIPV5.JHREG.Common.NameSpace).JHIPConfig()
#;			DO ..Adapter.DSNSet(JHIPDSN)
#;		 	Set:.."数据源切换"=0 dataArrA=..GetActivityThemeByMessageHeader(SearchValue,"JHIP")
#;			Set:.."数据源切换"=1 dataArrA=..GetActivityTheme(SearchValue)
#;			/** 设置 HII DSN **/
#;			Set HIIDSN =##class(JHIPV5.JHREG.Common.NameSpace).HIIConfig()
#;			DO ..Adapter.DSNSet(HIIDSN)
#;			Set:.."数据源切换"=0 dataArrB=..GetActivityThemeByMessageHeader(SearchValue,"HII")
#;			Set:.."数据源切换"=1 dataArrB=..GetActivityTheme(SearchValue)
#;			/** 设置 HIPP DSN **/
#;			Set HIPPDSN =##class(JHIPV5.JHREG.Common.NameSpace).HIPPConfig()
#;			DO ..Adapter.DSNSet(HIPPDSN)
#;			Set:.."数据源切换"=0 dataArrC=..GetActivityThemeByMessageHeader(SearchValue,"HIPP")
#;			Set:.."数据源切换"=1 dataArrC=..GetActivityTheme(SearchValue)
#;			/** 通过迭代器将多个数组处理为一个 **/
#;		    Set iter = dataArrA.%GetIterator()
#;		    While iter.%GetNext(.key , .value ) {
#;		       Do dataArr.%Push(value)
#;		    }		
#;			Set iter = dataArrB.%GetIterator()
#;		    While iter.%GetNext(.key , .value ) {
#;		       Do dataArr.%Push(value)
#;		    }
#;		    Set iter = dataArrC.%GetIterator()
#;		    While iter.%GetNext(.key , .value ) {
#;		       Do dataArr.%Push(value)
#;		    }
		    // 排序	
			Set dataArr=..bubbleSort("Time",dataArr)
			Set total=dataArr.%Size()
		}
		Set jsonObject.rows=dataArr
		Set jsonObject.total=total
		Set str=Result.STResult(jsonObject)
		
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// 获取 当日 活跃主题 Ens_Activity_Data.Seconds
Method GetActivityTheme(SearchValue As %String) As %DynamicArray
{
	Set dataArr = ##class(%DynamicArray).%New()
	Set EndTime = $zdt($H,3)        
	Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
	// 通过SearchValue来判断初始化和查询时情况
	Set SelectSQL="SELECT  HostName,Namespace ,TimeSlot FROM Ens_Activity_Data.Seconds where HostType=1 and TimeSlot>='"_StartTime_"' and  TimeSlot<='"_EndTime_"' and HostName in(SELECT  Name FROM Ens_Config.Item "
	IF $L(SearchValue)'=0{
		Set SelectSQL=SelectSQL_" where Name  like '%"_SearchValue_"%' "	
	}
	Set SelectSQL=SelectSQL_" ) group by HostName order by ID desc"	
	$$$LOGINFO("SelectSQL: "_SelectSQL)
	Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSQL)
	While tResult.%Next(){ 
		Set NewFiled = ##class(%DynamicObject).%New()
		Set HostName= tResult.%Get("HostName")
		Do NewFiled.%Set("Code",$E(HostName,1,6))
		Do NewFiled.%Set("Value",$E(HostName,7,*))
		Do NewFiled.%Set("NameSpace",tResult.%Get("Namespace"))
		Do NewFiled.%Set("Time",tResult.%Get("TimeSlot"))
		Do dataArr.%Push(NewFiled)
	}
	
	Quit dataArr
}

/// 获取 当日 活跃主题 Ens.MessageHeader
Method GetActivityThemeByMessageHeader(SearchValue As %String, NameSpace As %String) As %DynamicArray
{
	Set dataArr = ##class(%DynamicArray).%New()
	Set EndTime = $zdt($H,3)        
	Set StartTime = $zd($HOROLOG,3)_" 00:00:00"
	//
	Set tSC=..GetExtremeTime(StartTime,EndTime,.MaxID,.MinID)
	// 通过SearchValue来判断初始化和查询时情况
#;	Set SelectSQL="SELECT  SourceConfigName,  TimeCreated FROM Ens.MessageHeader  where SourceBusinessType = '1'  and ID >='"_MinID_"' and  ID <='"_MaxID_"' and SourceConfigName in(SELECT  Name FROM Ens_Config.Item "
#;	Set:MaxID=0 SelectSQL="SELECT  SourceConfigName,  TimeCreated FROM Ens.MessageHeader  where SourceBusinessType = '1'  and ID >='"_MinID_"'  and SourceConfigName in(SELECT  Name FROM Ens_Config.Item "
	Set SelectSQL="SELECT  SourceConfigName,  TimeCreated FROM Ens.MessageHeader  where SourceBusinessType = '1'  and TimeCreated >='"_StartTime_"' and  TimeCreated <='"_EndTime_"' and SourceConfigName in(SELECT  Name FROM Ens_Config.Item "
	IF $L(SearchValue)'=0{
#;		Set SelectSQL=SelectSQL_" where Name  like '%"_SearchValue_"%' "	
		Set SelectSQL=SelectSQL_" where Name  like '"_SearchValue_"%' "	
	}
	Set SelectSQL=SelectSQL_" ) group by SourceConfigName  order by ID desc"
	$$$LOGINFO("SQL: "_SelectSQL)	
	Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSQL)
	While tResult.%Next(){ 
		Set NewFiled = ##class(%DynamicObject).%New()
		Set HostName= tResult.%Get("SourceConfigName")
		Do NewFiled.%Set("Code",$E(HostName,1,6))
		Do NewFiled.%Set("Value",$E(HostName,7,*))
		Do NewFiled.%Set("NameSpace",NameSpace)
		Do NewFiled.%Set("Time",tResult.%Get("TimeCreated"))
		Do dataArr.%Push(NewFiled)
	}
	
	Quit dataArr
}

///  冒泡排序、依据时间 降序
Method bubbleSort(sort As %String, array As %DynamicArray) As %DynamicArray
{
	Set length = array.%Size()
	for i=0:1:length-2{
		for j = i+1:1:length-1{
			// 将时间转成串
			Set timeI=##CLASS(Ens.Util.FunctionSet).ConvertDateTime(array.%Get(i).%Get(sort),"%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
			Set timeJ=##CLASS(Ens.Util.FunctionSet).ConvertDateTime(array.%Get(j).%Get(sort),"%Y-%m-%d %H:%M:%S","%Y%m%d%H%M%S")
			Set temp = ##class(%DynamicObject).%New()
			if timeI < timeJ{				
				Set temp = array.%Get(i)
				do array.%Set(i,array.%Get(j))
				do array.%Set(j,temp)
			}
		}
	}
	Quit array
}

/// 根据时间段内获取ID的最大最小值
Method GetExtremeTime(StartTime As %String, EndTime As %String, Output MaxID As %String, Output MinID As %String) As %Status
{
	
	Set MaxID=0,MinID=0
	/** 获取最大ID **/
	Set MaxSQL = "Select top 1 ID From Ens.MessageHeader Where TimeCreated >='"_EndTime_"' "
	Set tSC=..Adapter.ExecuteQuery(.MaxResult,MaxSQL)
	IF MaxResult.%Next(){
		Set MaxID=MaxResult.%Get("ID")
	}
	/** 获取最小ID **/
	Set MinSQL = "Select top 1 ID From Ens.MessageHeader Where TimeCreated >='"_StartTime_"' "
	Set tSC=..Adapter.ExecuteQuery(.MinResult,MinSQL)
	IF MinResult.%Next(){
		Set MinID=MinResult.%Get("ID")
	}
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

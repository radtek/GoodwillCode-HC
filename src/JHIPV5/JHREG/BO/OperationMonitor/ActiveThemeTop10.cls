/// Classname JHIPV5.JHREG.BO.OperationMonitor.ActiveThemeTop10
/// Summary   运行监控 - 活跃主题TOP10
/// Explain	  活跃度前10的主题
/// Version   1.0<br>
/// Date      2021年12月6日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.ActiveThemeTop10 Extends Ens.BusinessOperation
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
		// 活跃度前10的主题 确保 HostName为production中的Name
		Set SelectSql="select top 10 HostName, num from(SELECT Top all HostName,sum(TotalCount) as num FROM Ens_Activity_Data.Seconds where HostType = '1'and TimeSlot>'"_StartTime_"' and TimeSlot<'"_EndTime_"' group by HostName order by num desc ) where HostName in (SELECT Name FROM Ens_Config.Item)"
#;		$$$LOGINFO("sql: "_SelectSql)
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSql)		
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set total=total+1
			Do NewFiled.%Set("id",total)
			Do NewFiled.%Set("HostName",tResult.%Get("HostName"))
			Do NewFiled.%Set("Number",tResult.%Get("num"))
			Do dataArr.%Push(NewFiled)
		}
		Set dataArr=[{"id":"1","HostName":"JH0001新增患者信息服务","Number":"452"},{"id":"2","HostName":"JH0002患者信息更新服务","Number":"302"},{"id":"3","HostName":"JH0003患者合并服务","Number":"286"},{"id":"4","HostName":"JH0004患者基本信息查询服务","Number":"273"},{"id":"5","HostName":"JH0102就诊卡信息更新服务","Number":"253"},{"id":"6","HostName":"JH0601医疗卫生机构信息注册服务","Number":"232"},{"id":"7","HostName":"JH0604医疗卫生机构信息查询服务","Number":"164"},{"id":"8","HostName":"JH0701医疗卫生人员信息注册服务","Number":"132"},{"id":"9","HostName":"JH0704医疗卫生人员信息查询服务","Number":"86"},{"id":"10","HostName":"JH0901术语内容注册服务","Number":"25"}]
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

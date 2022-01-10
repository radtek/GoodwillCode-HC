/// Classname JHIPV5.JHREG.BO.OperationMonitor.QueueMonitor
/// Summary   运行监控 - 系统厂商
/// Explain	  系统厂商 饼图 条形图
/// Version   1.0<br>
/// Date      2021年12月6日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.SystemVendor Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set josnObject = ##class(%DynamicObject).%New()
	try{
		// 设置 DSN 为 JHIPV5 命名空间下的 查询MYSQL库
		Set JHIPV5DSN =##class(JHIPV5.JHREG.Common.NameSpace).JHIPV5Config()
		Do ..Adapter.DSNSet(JHIPV5DSN)
		//系统厂商  获取JHIPV5数据
		Set count =0
		Set SelectSql="SELECT count(1) num,system_company  FROM register_system_info  GROUP BY system_company order by num DESC"
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSql)		
		While tResult.%Next(){
			Set count = count +tResult.%Get("num")
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("name",tResult.%Get("system_company")) /** 系统厂商名称 **/
			Do NewFiled.%Set("value",tResult.%Get("num"))			/**  系统数量    **/		
			Do dataArr.%Push(NewFiled)
		}
		Set josnObject.rows=dataArr
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

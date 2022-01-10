/// Classname JHIPV5.JHREG.BO.MessageMonitor.SubpubChart
/// Summary   消息监控 -订阅关系详情下载
/// Explain	  订阅关系详情
/// Version   1.0<br>
/// Date      2021年12月2日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MessageMonitor.DownloadSubscription Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()

	try{
		Set total=0
		// 获取源 发布系统
		Set SelectSql="Select  ID, ThemeName,ServiceType,Publish,Subscribe,AccessWay,Scope from JHIPV5_JHREG_DB.SubscriptionDB   order by ThemeName " 
		Set tSC = tStatment.%Prepare(SelectSql)
		Set tResult = tStatment.%Execute()
		Set fileName="C:\服务统计详情.xls"
	 	Set stream=##class(%FileCharacterStream).%New()
	    Set stream.Filename=fileName
	    Do stream.Clear()
	 	Do stream.MoveToEnd()
	 	Do stream.Write("接入方式	")
	 	Do stream.Write("联通范围	")
	 	Do stream.Write("发布系统	")
	 	Do stream.Write("服务名称	")
	 	Do stream.Write("服务类型	")
	 	Do stream.Write("订阅系统	")
	 	Do stream.WriteLine()
		While tResult.%Next(){
			Do stream.Write(""_tResult.%Get("AccessWay")_"	")
			Do stream.Write(""_tResult.%Get("Scope")_"	")
			Do stream.Write(""_tResult.%Get("Publish")_"	")
			Do stream.Write(""_tResult.%Get("ThemeName")_"	")
			Do stream.Write(""_tResult.%Get("ServiceType")_"	")
			Do stream.Write(""_tResult.%Get("Subscribe")_"	")
	    	Do stream.WriteLine()
		}
		Set jsonObject=stream.Read()
		Set str=jsonObject
#;		Set str=Result.TResult(jsonObject)
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

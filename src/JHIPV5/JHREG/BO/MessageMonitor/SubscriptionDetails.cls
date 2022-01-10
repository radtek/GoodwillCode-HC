/// Classname JHIPV5.JHREG.BO.MessageMonitor.SubpubChart
/// Summary   消息监控 -订阅关系详情
/// Explain	  订阅关系详情
/// Version   1.0<br>
/// Date      2021年12月2日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MessageMonitor.SubscriptionDetails Extends Ens.BusinessOperation
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
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set Publish=json.%Get("Publish")		/** 发布系统 **/
		Set Subscribe=json.%Get("Subscribe")	/** 订阅系统 **/
		Set total=0
		// 获取源 发布系统
		Set SelectSql="Select count(1) total, ID, ThemeName,ServiceType,Publish,Subscribe from JHIPV5_JHREG_DB.SubscriptionDB  where 1=1 "
		Set:$L(Publish)'=0 SelectSql=SelectSql_" and Publish = '"_Publish_"'" 
		Set:$L(Subscribe)'=0 SelectSql=SelectSql_" and Subscribe = '"_Subscribe_"'"
		Set SelectSql=SelectSql_" order by ThemeName " 
		Set tSC = tStatment.%Prepare(SelectSql)
		Set tResult = tStatment.%Execute()
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set total = tResult.%Get("total")
			Do NewFiled.%Set("ID",tResult.%Get("ID"))
			Do NewFiled.%Set("ThemeName",tResult.%Get("ThemeName"))          /** 主题名称 **/
			Do NewFiled.%Set("ServiceType",tResult.%Get("ServiceType"))		 /** 集成场景 **/
			Do NewFiled.%Set("Publish",tResult.%Get("Publish"))				 /** 发布系统 **/
			Do NewFiled.%Set("Subscribe",tResult.%Get("Subscribe"))		 	 /** 订阅系统 **/
			do dataArr.%Push(NewFiled)
		}
		Set jsonObject.row=dataArr
		Set jsonObject.total=total
		Set str=Result.STResult(jsonObject)
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

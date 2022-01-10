/// Classname JHIPV5.JHREG.BO.MessageMonitor.SubpubChart
/// Summary   运行监控 -联通范围
/// Explain	  联通范围 内联 外联
/// Version   1.0<br>
/// Date      2021年12月3日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.OperationMonitor.UnicomRange Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set josnObject = ##class(%DynamicObject).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		Set sum=0,id=0
		// 获取联通范围个数 内联，外联
		Set SelectSql="SELECT count(Scope) Number, Scope FROM JHIPV5_JHREG_DB.SubscriptionDB where Scope !='' group by Scope "
		Set tSC = tStatment.%Prepare(SelectSql)
		Set tResult = tStatment.%Execute()
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Set id=id+1
			Set Number=tResult.%Get("Number")
			Set Scope=tResult.%Get("Scope")
			Do NewFiled.%Set("id",id)
			Do NewFiled.%Set("name",Scope)
			Do NewFiled.%Set("number",Number)
			Set sum=sum+Number
			Do dataArr.%Push(NewFiled)
		}
		Set josnObject.id=id+1
		Set josnObject.name="联通总数"
		Set josnObject.number=sum
		Do dataArr.%Push(josnObject)
		Set str=Result.STResult(dataArr)
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

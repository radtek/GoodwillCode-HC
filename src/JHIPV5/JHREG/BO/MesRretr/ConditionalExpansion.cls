/// Classname JHIPV5.JHREG.BO.MesRretr.ConditionalExpansion
/// Summary   消息检索—— 条件扩展
/// Explain	  根据 内容 获取
/// Version   1.0<br>
/// Date      2021年11月29日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.ConditionalExpansion Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set NewFiled = ##class(%DynamicObject).%New()		
		Do NewFiled.%Set("0","患者ID")		
		Do NewFiled.%Set("1","患者姓名")		
		Do NewFiled.%Set("2","主题名称")		
		Do NewFiled.%Set("3","申请单号")		
		Do NewFiled.%Set("4","医嘱号")		
		Do NewFiled.%Set("5","住院号")		
		Do NewFiled.%Set("6","门诊号")		
		Do NewFiled.%Set("7","字典内容")		
		Do NewFiled.%Set("8","消息ID")		
		Do NewFiled.%Set("9","时间筛选")
		Set str=Result.TResult(NewFiled)
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

/// Classname JHIPV5.JHREG.BO.Adapter.GetAdapter
/// Summary   获取适配器  
/// Explain	  获适配器编号、名称 表 JHIPV5_JHREG_DB.AdapterDB
/// Version   1.0<br>
/// Date      2021年12月06日 
/// Author    LHX
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Adapter.GetAdapter Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/*  	 
			 AdapterID					    适配器编号
  			 AdapterName				 	适配器名称
	
*/
Method getAdapter(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set SelectSQL="SELECT Description, AdapterID, IpAdderss, AdapterName FROM JHIPV5_JHREG_DB.AdapterDB Where 1=1 "
		// 获取适配器
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("AdapterID"))
			Do NewFiled.%Set("Name",tResult.%Get("AdapterName"))
			Do dataArr.%Push(NewFiled)		
		}
		Set str=Result.TResult(dataArr)
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
		<Method>getAdapter</Method>
	</MapItem>
</MapItems>
}

}

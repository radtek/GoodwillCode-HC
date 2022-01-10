/// Classname JHIPV5.JHREG.BO.Adapter.GetAdapterNameDetails
/// Summary   查询适配器列表 
/// Explain	  查询适配器列表 JHIPV5_JHREG_DB.AdapterDB
/// Version   1.0<br>
/// Date      2021年12月06日 
/// Author    LHX
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Adapter.GetAdapterNameDetails Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/*  
			  AdapterID					    适配器编号
  			  AdapterName					适配器名称
			  ClassName					    类名称
			  Standed						适配器标准
			  Type							类型（主题 订户）
*/
Method getAdapterNameDetails(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set AdapterName=json.%Get("AdapterName")			/* 适配器名称 */
		Set Size=json.%Get("Size")							/* 每页条数   */
		Set Page=json.%Get("Page")							/* 第几页     */
		// 页码
		Set PageNumber = Size*(Page-1)+1
		Set PageSize = Size * Page
		Set total=0
		Set SelectSQL="SELECT %VID AS ContentID ,* FROM (SELECT count(1) total,AdapterID, AdapterName, ClassName, Standed, Type FROM JHIPV5_JHREG_DB.AdapterDB Where 1=1 "
		// 判空，SQL拼接
		Set:$L(AdapterName)'=0 SelectSQL=SelectSQL_" AND AdapterName = '"_AdapterName_"'"	
		Set SelectSQL=SelectSQL_" ) WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("AdapterID"))
			Do NewFiled.%Set("AdapterName",tResult.%Get("AdapterName"))
			Do NewFiled.%Set("ClassName",tResult.%Get("ClassName"))
			Do NewFiled.%Set("Standed",tResult.%Get("Standed"))
			Do NewFiled.%Set("Type",tResult.%Get("Type"))
			Set total=total+1
			Do dataArr.%Push(NewFiled)		
		}
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total
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
		<Method>getAdapterNameDetails</Method>
	</MapItem>
</MapItems>
}

}

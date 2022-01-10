/// Classname JHIPV5.JHREG.BO.Adapter.EditAdapterName
/// Summary   编辑适配器 
/// Explain	  适配器编辑功能 JHIPV5_JHREG_DB.AdapterDB
/// Version   1.0<br>
/// Date      2021年12月06日 
/// Author    LHX
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Adapter.EditAdapterName Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/*  
			  ID							ID
			  AdapterID					    适配器编号
  			  AdapterName					适配器名称
			  IpAdderss					    适配器地址
			  Description					适配器描述
	
*/
Method editAdapterName(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set str=Result.FResult()
		Set request =pRequest.pArg.GetAt(1)
		$$$LOGINFO("request:"_request)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set ID=json.%Get("ID")
		Set AdapterID=json.%Get("AdapterID")
		Set AdapterName=json.%Get("AdapterName")
		Set IpAdderss=json.%Get("IpAdderss")
		Set Description=json.%Get("Description")
		// 更新
		Set UpdateSql="UPDATE JHIPV5_JHREG_DB.AdapterDB Set Description ='"_Description_"', AdapterID ='"_AdapterID_"', IpAdderss ='"_IpAdderss_"' , AdapterName ='"_AdapterName_"' where ID = '"_ID_"'"
		Set tSC = tStatment.%Prepare(UpdateSql)
		Set tResult1 = tStatment.%Execute()
		Set:tSC=1 str=Result.TResult("")
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
		<Method>editAdapterName</Method>
	</MapItem>
</MapItems>
}

}

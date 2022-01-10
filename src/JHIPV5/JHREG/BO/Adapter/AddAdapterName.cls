/// Classname JHIPV5.JHREG.BO.Adapter.AddAdapterName
/// Summary   新增适配器
/// Explain	  新增功能， 适配器管理表 JHIPV5_JHREG_DB.AdapterDB
/// Version   1.0<br>
/// Date      2021年12月06日 
/// Author    LHX
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Adapter.AddAdapterName Extends Ens.BusinessOperation
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
Method addAdapterName(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		$$$LOGINFO("request:"_request)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set AdapterID=json.%Get("AdapterID")
		Set AdapterName=json.%Get("AdapterName")
		Set IpAdderss=json.%Get("IpAdderss")
		Set Description=json.%Get("Description")
		
		// 查询消息，保证其唯一值
		Set SelectSQL="SELECT AdapterName FROM JHIPV5_JHREG_DB.AdapterDB Where AdapterName = '"_AdapterName_"'"		
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		//设置开关factor，当factor为1时，允许收藏，通过遍历FileBody来改变factor
		Set factor =1
		While tResult.%Next(){ Set factor=0 }
		if factor=0{
			Set str=Result.Result(201,"",$$$NO,"该适配器已存在，请勿重复添加")
		}elseIf factor=1{
			Set InsertSql="INSERT INTO JHIPV5_JHREG_DB.AdapterDB (AdapterID,AdapterName,IpAdderss,Description) VALUES('"_AdapterID_"','"_AdapterName_"','"_IpAdderss_"','"_Description_"')"
			Set tSC = tStatment.%Prepare(InsertSql)
			Set tResult1 = tStatment.%Execute()
			Set str=Result.TResult("")
		}
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
		<Method>addAdapterName</Method>
	</MapItem>
</MapItems>
}

}

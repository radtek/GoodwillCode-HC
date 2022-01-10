/// Classname JHIPV5.ESB.BO.MesRretr.JHIP.GetCollectByIDBO
/// Summary   消息检索查询收藏功能
/// Explain	  根据 ID 查询已收藏的检索条件详情
/// Version   1.0<br>
/// Date      2021年11月18日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.GetCollectByIDBO Extends Ens.BusinessOperation
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
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set ID=json.%Get("ID")
		// 根据ID获取收藏的详细信息
		Set SelectSQL="SELECT ID, EndTime, FileBody, MessageStatus, MessageType, MessageValue, NameSpace,SaveTime, SearchType, SearchValue, StartTime, ThemeName FROM JHIPV5_JHREG_DB.CollectionDB WHERE ID = '"_ID_"'"	
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()
		While tResult.%Next(){ 
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("ID"))
			Do NewFiled.%Set("SearchValue",tResult.%Get("SearchValue"))
			Do NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			Do NewFiled.%Set("SearchType",tResult.%Get("SearchType"))
			Do NewFiled.%Set("ThemeName",tResult.%Get("ThemeName"))
			Do NewFiled.%Set("StartTime",tResult.%Get("StartTime"))
			Do NewFiled.%Set("EndTime",tResult.%Get("EndTime"))
			Do NewFiled.%Set("SaveTime",tResult.%Get("SaveTime"))
			Do NewFiled.%Set("MessageValue",tResult.%Get("MessageValue"))
			Do NewFiled.%Set("MessageStatus",tResult.%Get("MessageStatus"))
			Do NewFiled.%Set("MessageType",tResult.%Get("MessageType"))
			Do NewFiled.%Set("FileBody",tResult.%Get("FileBody"))
			Do dataArr.%Push(NewFiled)
		}	
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

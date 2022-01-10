/// Classname JHIPV5.JHREG.BO.MesRretr.PatientList
/// Summary   消息检索——患者信息列表
/// Explain	  根据 搜索条件 进行消息检索
/// Version   1.0<br>
/// Date      2021年11月23日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.GetMessageByDocID Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetMessageByDocID(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		/*-----参数------*/
		Set NameSpace = json.%Get("NameSpace")			/* 域       */
		Set DocId = json.%Get("DocId")					/* 搜索内容 */
		Set Size=json.%Get("Size")						/* 每页条数 */
		Set Page=json.%Get("Page")						/* 第几页   */
		// 页码
		Set PageNumber = Size*(Page-1)+1
		Set PageSize = Size * Page
		/** 获取DSN **/
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		Set tSC= ..Adapter.DSNSet(GetDSN)
		Set Sql="SELECT %VID AS ContentID ,* FROM (SELECT top all count(1) total, id, Type,SessionId, Status, SourceConfigName,TargetConfigName,TimeCreated  ,TimeProcessed ,SourceBusinessType,TargetBusinessType FROM Ens.MessageHeader Where SessionId in (SELECT SessionId FROM Ens.MessageHeader WHERE MessageBodyId ='"_DocId_"') and (SourceBusinessType='1'or TargetBusinessType='1') order by id desc )WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' "
		Set tSC=..Adapter.ExecuteQuery(.tResult,Sql)
		Set total=0
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("id"))
			Do NewFiled.%Set("SessionId",tResult.%Get("SessionId"))
			Set Type=tResult.%Get("Type")
			IF Type=1{
				Set SourceConfigName=tResult.%Get("SourceConfigName")
				Set TargetConfigName=tResult.%Get("TargetConfigName")
			} Else{
				Set SourceConfigName=tResult.%Get("TargetConfigName")
				Set TargetConfigName=tResult.%Get("SourceConfigName")
			}
			Do NewFiled.%Set("ThemeName",SourceConfigName)
			Do NewFiled.%Set("TargetConfigName",TargetConfigName)				
			Do NewFiled.%Set("MessageStatus",tResult.%Get("Status"))
		    Set TimeProcessed=$TRanslate(tResult.%Get("TimeProcessed"),"-, ,:,.")
			Set TimeCreated=$TRanslate(tResult.%Get("TimeCreated"),"-, ,:,.")
			Set total=tResult.%Get("total")
			Set SpendTime=TimeProcessed-TimeCreated
			Do NewFiled.%Set("StartTime",tResult.%Get("TimeCreated"))
			Do NewFiled.%Set("SpendTime",SpendTime)
			Do NewFiled.%Set("MessageType",tResult.%Get("Type"))
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
		<Method>GetMessageByDocID</Method>
	</MapItem>
</MapItems>
}

}

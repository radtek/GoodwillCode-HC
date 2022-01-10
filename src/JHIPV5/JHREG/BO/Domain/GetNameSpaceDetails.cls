/// Classname JHIPV5.JHREG.BO.Domain.GetNameSpaceDetails
/// Summary   获取命名空间详情 
/// Explain	  获取命名空间列表   域管理界面列表  表 JHIPV5_JHREG_DB.DomainDB
/// Version   1.0<br>
/// Date      2021年11月29日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Domain.GetNameSpaceDetails Extends Ens.BusinessOperation
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
		Set NameSpace=json.%Get("NameSpace")			/* 域名称   */
		Set Size=json.%Get("Size")						/* 每页条数 */
		Set Page=json.%Get("Page")						/* 第几页   */
		// 页码
		Set PageNumber = Size*(Page-1)+1
		Set PageSize = Size * Page
		Set total=0
		// 分页获取 域列表
		Set SelectSQL="SELECT %VID AS ContentID ,* FROM (SELECT count(1) total,ID, Description, DomainID, IpAdderss, NameSpace FROM JHIPV5_JHREG_DB.DomainDB Where 1=1 "
		Set:$L(NameSpace)'=0 SelectSQL=SelectSQL_" AND NameSpace = '"_NameSpace_"'"	
		Set SelectSQL=SelectSQL_" ) WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"
		// 拼接查询消息，保证其唯一值
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("ID"))
			Do NewFiled.%Set("DomainID",tResult.%Get("DomainID"))
			Do NewFiled.%Set("NameSpace",tResult.%Get("NameSpace"))
			Do NewFiled.%Set("IpAdderss",tResult.%Get("IpAdderss"))
			Do NewFiled.%Set("Description",tResult.%Get("Description"))
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
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

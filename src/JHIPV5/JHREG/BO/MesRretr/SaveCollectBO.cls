/// Classname JHIPV5.JHREG.BO.MesRretr.SaveCollectBO
/// Summary   消息检索收藏功能
/// Explain	  收藏功能， 禁止重复添加收藏 收藏表 JHIPV5_JHREG_DB.CollectionDB
/// Version   1.0<br>
/// Date      2021年11月18日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.SaveCollectBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/*  
			  SearchValue					搜索内容
  			  NameSpace					 	域ID
  			  NameSpaceValue				域名称
			  SearchType					搜索条件
			  ThemeName						主题名称
			  StartTime						开始时间
			  EndTime						结束时间
			  MessageValue					消息内容
			  MessageStatus					消息状态
			  MessageType					消息类型
*/
Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set SearchValue=json.%Get("SearchValue")
		Set NameSpace=json.%Get("NameSpace")
		Set NameSpaceValue=json.%Get("NameSpaceValue")
		Set SearchType=json.%Get("SearchType")
		Set ThemeName=json.%Get("ThemeName")
		Set StartTime=json.%Get("StartTime")
		Set EndTime=json.%Get("EndTime")
		Set MessageValue=json.%Get("MessageValue")
		Set MessageStatus=json.%Get("MessageStatus")
		Set MessageType=json.%Get("MessageType")
		Set SaveTime=$ZDT($H,3)
		// 拼接查询消息，保证其唯一值
		Set FileBody=SearchValue_","_NameSpace_","_NameSpaceValue_","_SearchType_","_ThemeName_","_StartTime_","_EndTime_","_MessageValue_","_MessageStatus_","_MessageType
		Set SelectSQL="SELECT ID FROM JHIPV5_JHREG_DB.CollectionDB Where FileBody = '"_FileBody_"'"		
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		//设置开关factor，当factor为1时，允许收藏，通过遍历FileBody来改变factor
		Set factor =1
		While tResult.%Next(){ Set factor=0 }
		if factor=0{
			Set str=Result.Result(201,"",$$$NO,"该收藏已存在，重复收藏")
		}elseIf factor=1{
			Set InsertSql="INSERT INTO JHIPV5_JHREG_DB.CollectionDB (FileBody,SearchValue,NameSpace,NameSpaceValue,SearchType,ThemeName,StartTime,EndTime,SaveTime,MessageValue,MessageStatus,MessageType) VALUES('"_FileBody_"','"_SearchValue_"','"_NameSpace_"','"_NameSpaceValue_"','"_SearchType_"','"_ThemeName_"','"_StartTime_"','"_EndTime_"','"_SaveTime_"','"_MessageValue_"','"_MessageStatus_"','"_MessageType_"')"
			Set tSC = tStatment.%Prepare(InsertSql)
			Set tResult1 = tStatment.%Execute()
			Set str=Result.Result(200,"",$$$OK,"收藏成功")
		}
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=str
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

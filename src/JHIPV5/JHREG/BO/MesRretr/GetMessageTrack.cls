/// Classname JHIPV5.ESB.BO.MesRretr.JHIP.GetMessageTrack
/// Summary   消息检索 获取跟踪
/// Explain	  根据 ID 获取跟踪
/// Version   1.0<br>
/// Date      2021年11月25日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.GetMessageTrack Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	set jsonObject = ##class(%DynamicObject).%New()
	set DataArr=##class(%DynamicArray).%New()
	Set type=1,num=0,total=0,INTIME=""
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set SessionId = json.%Get("ID")
		Set NameSpace = json.%Get("NameSpace")
		// 获取DSN
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		DO ..Adapter.DSNSet(GetDSN)
		// 根据ID获取收藏的详细信息
		Set SelectSQL = "SELECT Type,SessionId,SourceConfigName,TargetBusinessType,ID, COUNT(*) AS CID, TimeCreated, TimeProcessed FROM Ens.MessageHeader where SessionId= '"_SessionId_"' "
		$$$LOGINFO("sql:"_SelectSQL)
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSQL)
		//遍历结果集并将分页查询显示SQL获取到的数据放至json
		WHILE tResult.Next(){
			Set num=num+1
			Set NewFiled = ##class(%DynamicObject).%New()
			//第一次请求BS发出
			if num="1"{
				Set total=tResult.%Get("CID")
		 		DO NewFiled.%Set("ID",tResult.Get("ID"))
		 		DO NewFiled.%Set("name",tResult.Get("SourceConfigName"))
				DO NewFiled.%Set("inputVal","")
				DO NewFiled.%Set("outputVal",tResult.Get("TimeCreated")_"</br>会话ID："_SessionId)
				Set INTIME=tResult.Get("TimeCreated")
				DO NewFiled.%ToJSON()
				Do DataArr.%Push(NewFiled)
		   	}elseIf num="2"{
			   	//第二次请求
			 	Set total=tResult.%Get("CID")
		 		DO NewFiled.%Set("ID",tResult.Get("ID"))
		 		DO NewFiled.%Set("name",tResult.Get("SourceConfigName"))
				DO NewFiled.%Set("inputVal","")
		 		DO NewFiled.%Set("outputVal","")
		 		// type 空值是否存在流程
				if tResult.Get("TargetBusinessType")=3{
					Set type=1
				}else{
					Set type=2
				}
				DO NewFiled.%ToJSON()
				Do DataArr.%Push(NewFiled)
			}else{
				If tResult.Get("Type")=2{
			 		Set total=tResult.Get("CID")
					DO NewFiled.%Set("ID",tResult.Get("ID"))
					DO NewFiled.%Set("name",tResult.Get("SourceConfigName"))
					DO NewFiled.%Set("inputVal",INTIME)
					Set aa = tResult.Get("TimeCreated")
					Set hs=$TRanslate(aa,"-,:, ,.")-$TRanslate(INTIME,"-,:, ,.")
					DO NewFiled.%Set("outputVal",aa_"<BR>耗时："_hs_"毫秒")
					DO NewFiled.%ToJSON()
					Do DataArr.%Push(NewFiled)
				}
			 }
		}
		Set jsonObject.rows = DataArr
		Set jsonObject.total = total	
		Set jsonObject.type = type
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

/// Classname JHIPV5.ESB.BO.MesRretr.JHIP.DeleteCollectBO
/// Summary   消息检索删除已收藏检索条件收藏功能
/// Explain	  
/// Version   1.0<br>
/// Date      2021年11月18日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.DeleteCollectBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set ID=json.%Get("ID")
		// 查询该ID是否已被删除
		Set factor =1
		Set SelectSQL="SELECT ID,FileBody FROM JHIPV5_JHREG_DB.CollectionDB  WHERE ID= "_ID_""
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()
		While tResult.%Next(){ Set factor=0 }
		IF factor =0{
			Set DelSQL="DELETE FROM JHIPV5_JHREG_DB.CollectionDB WHERE ID= "_ID_""
			Set tSC = tStatment.%Prepare(DelSQL)
			Set tResult = tStatment.%Execute()
			Set str=Result.TResult("")
		}Else{
			Set str=Result.Result(201,"",$$$NO,"该收藏条件不存在,请检查是否删除成功")
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

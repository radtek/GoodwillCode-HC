/// Classname JHIPV5.JHREG.BO.Domain.DeleteNameSpace
/// Summary   删除域  
/// Explain	  删除域 根据ID 表 JHIPV5_JHREG_DB.DomainDB
/// Version   1.0<br>
/// Date      2021年11月29日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Domain.DeleteNameSpace Extends Ens.BusinessOperation
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
		Set SelectSQL="SELECT ID FROM JHIPV5_JHREG_DB.DomainDB  WHERE ID= "_ID_""
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()
		While tResult.%Next(){ Set factor=0 }
		IF factor =0{
			Set DelSQL="DELETE FROM JHIPV5_JHREG_DB.DomainDB WHERE ID= "_ID_""
			Set tSC = tStatment.%Prepare(DelSQL)
			Set tResult = tStatment.%Execute()
			Set str=Result.TResult("")
		}Else{
			Set str=Result.Result(201,"",$$$NO,"该域不存在,请检查是否删除成功")
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
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

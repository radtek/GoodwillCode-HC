/// Classname JHIPV5.JHREG.BO.Domain.GetNameSpace
/// Summary   获取命名空间  
/// Explain	  获取命名空间编号、名称 表 JHIPV5_JHREG_DB.DomainDB
/// Version   1.0<br>
/// Date      2021年11月29日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Domain.GetNameSpace Extends Ens.BusinessOperation
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
		Set SelectSQL="SELECT Description, DomainID, IpAdderss, NameSpace FROM JHIPV5_JHREG_DB.DomainDB Where 1=1 "
		// 获取其命名空间
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("DomainID"))
			Do NewFiled.%Set("Name",tResult.%Get("NameSpace"))
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

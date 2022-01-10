/// Classname JHIPV5.JHREG.BO.Domain.AddNameSpace
/// Summary   编辑域 
/// Explain	  编辑功能，域管理表 JHIPV5_JHREG_DB.DomainDB
/// Version   1.0<br>
/// Date      2021年11月29日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Domain.EditNameSpace Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/*  
			  ID							ID
			  DomainID					    域编号
  			  NameSpace					 	域名称
			  IpAdderss					    域地址
			  Description					域描述
	
*/
Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set str=Result.FResult()
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set ID=json.%Get("ID")
		Set DomainID=json.%Get("DomainID")
		Set NameSpace=json.%Get("NameSpace")
		Set IpAdderss=json.%Get("IpAdderss")
		Set Description=json.%Get("Description")
		// 更新
		Set UpdateSql="UPDATE JHIPV5_JHREG_DB.DomainDB Set Description ='"_Description_"', DomainID ='"_DomainID_"', IpAdderss ='"_IpAdderss_"' , NameSpace ='"_NameSpace_"' where ID = '"_ID_"'"
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
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

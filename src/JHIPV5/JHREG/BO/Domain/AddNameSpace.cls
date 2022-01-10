/// Classname JHIPV5.JHREG.BO.Domain.AddNameSpace
/// Summary   新增域 
/// Explain	  新增功能， 禁止重复域 域管理表 JHIPV5_JHREG_DB.DomainDB
/// Version   1.0<br>
/// Date      2021年11月29日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.Domain.AddNameSpace Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

/*  
			  DomainID						域ID
  			  NameSpace					 	域名称
			  IpAdderss						IP地址
			  Description					域描述
*/
Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set DomainID=json.%Get("DomainID")
		Set NameSpace=json.%Get("NameSpace")
		Set IpAdderss=json.%Get("IpAdderss")
		Set Description=json.%Get("Description")
		
		// 查询消息，保证其唯一值
		Set SelectSQL="SELECT NameSpace FROM JHIPV5_JHREG_DB.DomainDB Where NameSpace = '"_NameSpace_"'"		
		Set tSC = tStatment.%Prepare(SelectSQL)
		Set tResult = tStatment.%Execute()				
		//设置开关factor，当factor为1时，允许添加，通过遍历NameSpace来改变factor
		Set factor =1
		While tResult.%Next(){ Set factor=0 }
		If factor=0{
			Set str=Result.Result(201,"",$$$NO,"该域已存在，请勿重复添加")
		}elseIf factor=1{
			Set InsertSql="INSERT INTO JHIPV5_JHREG_DB.DomainDB (DomainID,NameSpace,IpAdderss,Description) VALUES('"_DomainID_"','"_NameSpace_"','"_IpAdderss_"','"_Description_"')"
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
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

/// Classname JHIPV5.ESB.BO.MesRretr.JHIP.ThemeMessageRetrieval
/// Summary   消息检索——根据主题检索
/// Explain	  根据 内容 查询活动主题
/// Version   1.0<br>
/// Date      2021年11月22日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.GetThemeName Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set NameSpace=json.%Get("NameSpace")
		Set total=0 ,dataArr=[]
		// 设置 DSN
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		DO ..Adapter.DSNSet(GetDSN)
		Set SqlName=" SELECT ClassName,Name FROM Ens_Config.Item where  Production != 'JHIP.Production.NEWJHIPV3' order by Name "
		Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
		WHILE tResult.%Next(){
			// 判读服务是否为BS
#;			IF NameSpace'=2{
				If ..GetBusinessType(tResult.%Get("ClassName"))="BS"{
					Set NewFiled = ##class(%DynamicObject).%New()
					Set total=total+1
					Set Name=tResult.%Get("Name")
					// 处理code不唯一 
#;					Do NewFiled.%Set("Code",$E(Name,1,6))
					Do NewFiled.%Set("Code",Name)
					Do NewFiled.%Set("Value",$E(Name,7,*))
					$$$LOGINFO("Name"_Name)
					Do dataArr.%Push(NewFiled)
				}		
#;			}Else{
#;				If ..GetBusinessType(tResult.%Get("ClassName"))="BP"{
#;					Set NewFiled = ##class(%DynamicObject).%New()
#;					Set total=total+1
#;					Set Name=tResult.%Get("Name")
#;					Do NewFiled.%Set("Code",$E(Name,1,5))
#;					Do NewFiled.%Set("Value",$E(Name,6,*))
#;					Do dataArr.%Push(NewFiled)
#;				}
#;			}
		}		
		Set jsonObject.rows=dataArr
		Set jsonObject.total=total	
		Set str=Result.STResult(jsonObject)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// 判断 服务为BS BP BO
Method GetBusinessType(pClassname As %String) As %String
{
	Set tValue=""
	#Dim tResultbs As EnsLib.SQL.GatewayResultSet
	#Dim tResultbp As EnsLib.SQL.GatewayResultSet
	#Dim tResultbo As EnsLib.SQL.GatewayResultSet
	Set sqlbs="SELECT PrimarySuper FROM %Dictionary.CompiledClass where ID = '"_pClassname_"' AND PrimarySuper like '%Ens.BusinessService%'"
	Set sqlbp="SELECT PrimarySuper FROM %Dictionary.CompiledClass where ID = '"_pClassname_"' AND PrimarySuper like '%Ens.BusinessProcess%'"
	Set sqlbo="SELECT PrimarySuper FROM %Dictionary.CompiledClass where ID = '"_pClassname_"' AND PrimarySuper like '%Ens.BusinessOperation%'"
	Do {
		Set tSC=..Adapter.ExecuteQuery(.tResultbs,sqlbs)
		IF tResultbs.Next() Set tValue="BS" 	 Quit 
		Set tSC=..Adapter.ExecuteQuery(.tResultbp,sqlbp)
		IF tResultbp.Next() Set tValue="BP"  	 Quit
		Set tSC=..Adapter.ExecuteQuery(.tResultbo,sqlbp)
		IF tResultbo.Next() Set tValue="BO" 	 Quit
		;Set tValue="BO"  Quit
	} While 0
	Quit $G(tValue)
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

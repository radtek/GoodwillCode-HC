/// Classname JHIPV5.JHREG.BO.MesRretr.NumNewPatientBO
/// Summary   消息检索 当日新增患者
/// Explain	  根据 内容 查询当日新增患者
/// Version   1.0<br>
/// Date      2021年11月18日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.NumNewPatientBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		Set SearchValue=json.%Get("SearchValue")		
		Set NameSpace=json.%Get("NameSpace")
		Set PatientID=json.%Get("PatientID")
		// 设置 DSN 为 JHIP
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		DO ..Adapter.DSNSet(GetDSN)
		Set Day =$ZD($H,3)_" 00:00:00"
		// 根据ID获取域名称
		Set SpaceName=##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpace)
		IF SpaceName="JHIP"{
			// 通过SearchValue来判断初始化和查询时情况
			Set SelectSQL="SELECT DocId, PatientID, PatientName, RegTime FROM JHIPLIB_SearchTable_HL7V3.JH0001 where RegTime >'"_Day_"' "
			IF $L(SearchValue)'=0{
				Set SelectSQL=SelectSQL_" and PatientName like '%"_SearchValue_"%' "	
			}ElseIF $L(PatientID)'=0{
				Set SelectSQL=SelectSQL_" AND PatientID='"_PatientID_"' "
			}
		}ElseIF SpaceName="HII"{
			Set SelectSQL="SELECT  DocId, PID PatientID, PName PatientName FROM HII_Util_SearchTable.PatientInfoRegister  where RegTime >'"_Day_"' "
			IF $L(SearchValue)'=0{
				Set SelectSQL=SelectSQL_" and PName like '%"_SearchValue_"%' "	
			}ElseIF $L(PatientID)'=0{
				Set SelectSQL=SelectSQL_" AND PID'"_PatientID_"' "
			}
		}
		Set SelectSQL=SelectSQL_" order by ID desc"	
		$$$LOGINFO("sql:"_SelectSQL)
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSQL)		
		While tResult.%Next(){ 
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID", tResult.%Get("DocId"))
			Do NewFiled.%Set("PatientID", tResult.%Get("PatientID"))
			Do NewFiled.%Set("PatientName", tResult.%Get("PatientName"))
			Do NewFiled.%Set("RegTime", tResult.%Get("RegTime"))
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

/// Classname JHIPV5.JHREG.BO.MesRretr.PatientList
/// Summary   消息检索——患者信息列表
/// Explain	  根据 搜索条件 进行消息检索
/// Version   1.0<br>
/// Date      2021年11月23日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.PatientList Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetPatientList(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		/*-----参数------*/
		Set NameSpace = json.%Get("NameSpace")			/* 域       */
		Set SearchValue = json.%Get("SearchValue")		/* 搜索内容（患者姓名） */
		Set PatientID=json.%Get("PatientID")			/* 患者ID　 */
		/** 获取DSN **/
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		Set tSC= ..Adapter.DSNSet(GetDSN)
		/** 获取患者列表SQL **/
		Set tSC=..GetSearchTableByNameSpace(SearchValue,NameSpace,PatientID,.TableSql,.parment)
		$$$LOGINFO("sql"_TableSql)
		Set tSC=..Adapter.ExecuteQuery(.TableResult,TableSql)
		$$$LOGINFO("tsc"_tSC)
		Set total=0
		Set num =$ll($LISTFROMSTRING(parment,","))
		While TableResult.%Next(){
			Set total=total+1
			Set NewFiled = ##class(%DynamicObject).%New()
			for i=1:1:num{
				Set Name=$REPLACE($PIECE(parment,",",i)," ","")
				IF Name="PID" {
					Set Key="PatientID"
				}ElseIF Name="PName"{
					Set Key="PatientName"
				}Else{
					Set Key=Name
				}
				Do NewFiled.%Set(Key,TableResult.%Get(Name))
			}
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

/// 根据 搜索条件 获取 Searchtable 除 SearchType =2 和 8
Method GetSearchTableByNameSpace(SearchValue As %String, NameSpace As %String, PatientID As %String, Output pResponse As %RegisteredObject, Output Parameter As %RegisteredObject) As %Status
{
	Set GetNameSpace =##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpace)
	// 	通过命名空间来判断 Searchtable 表名 
	Set:GetNameSpace="JHIP" STableName="JHIPLIB_SearchTable_HL7V3.JH0001"   		,SearchTypeName=" DocId, PatientID, PatientName,Sex, RegTime " ,Condition="PatientName"	,Condition2="PatientID"			/* JHIP */
	Set:GetNameSpace="HII" STableName="HII_Util_SearchTable.PatientInfoRegister"	,SearchTypeName=" DocId, PID,       PName,      Sex, RegTime"	    ,Condition="PName"	,Condition2="PID"				/* HII	*/
	Set:GetNameSpace="HIPP" STableName="JHIPLIB_SearchTable_HL7V3.JH0001"			,SearchTypeName=" DocId, PatientID, PatientName,Sex, RegTime "	,Condition="PatientName",Condition2="PatientID"			/* HIPP */ 
	Set TableSql=" SELECT top 1000 "_SearchTypeName_" FROM "_STableName_" order by id desc"
	Set:SearchValue'="" TableSql=" SELECT top 1000 "_SearchTypeName_" FROM "_STableName_" Where "_Condition_" = '"_SearchValue_"' order by id desc"
	Set:PatientID'="" TableSql=" SELECT top 1000 "_SearchTypeName_" FROM "_STableName_" Where "_Condition2_" = '"_PatientID_"' order by id desc"
	Set pResponse=TableSql
	Set Parameter=SearchTypeName
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>GetPatientList</Method>
	</MapItem>
</MapItems>
}

}

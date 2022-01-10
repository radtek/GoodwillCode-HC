/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.bpSelect1 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
		set ..Adapter.IsUnicodeDLL=0
        set SelectSQL="SELECT  Name FROM Ens_Config.Item"
        Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSQL)		
		While tResult.%Next(){ 
			Set NewFiled = ##class(%DynamicObject).%New()
	
			Set PatientName=tResult.%Get("Name")
			$$$LOGINFO("中文："_PatientName)
			set a1=$zcvt(PatientName,"O","UTF8")
			set a2=$zcvt(a1,"O","UTF8")
			$$$LOGINFO("转码2："_$zcvt(PatientName,"O","UTF8"))
			$$$LOGINFO("转码1："_a2)
			//Do NewFiled.%Set("RegTime", tResult.%Get("RegTime"))
			//Do dataArr.%Push(NewFiled)
		}
	//
	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue="222"
	  Quit $$$OK
}

}

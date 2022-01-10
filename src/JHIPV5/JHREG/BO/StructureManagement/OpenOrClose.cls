/// Classname 
/// Summary   获取具体Schema
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.OpenOrClose Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
  	 SET A1           =pRequest.pArg.GetAt(1)
	 set request      =##class(%DynamicArray).%New()
     set result       =##class(%DynamicArray).%New()
      //xml查询
     SET REQUEST      =##class(%DynamicObject).%New()
     SET REQUEST      =REQUEST.%FromJSON(A1)
     set ID=REQUEST.ID
     set status=REQUEST.status

	 
	   
	&SQL(UPDATE JHIPV5_JHREG_DB.StructureManagement set openStatus=:status where ID=:ID)  
     Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	 Set pResponse=##class(Ens.StringResponse).%New()
	 //Set pResponse.StringValue=Result.TResult(result)  
	 	Set pResponse.StringValue=Result.Result("200","",1,"操作成功")
     Quit $$$OK
}

}

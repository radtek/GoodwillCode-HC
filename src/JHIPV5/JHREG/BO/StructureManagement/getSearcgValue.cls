/// Classname 
/// Summary   获取具体Schema
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.getSearcgValue Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
  	 SET A1           =pRequest.pArg.GetAt(1)
	 set request      =##class(%DynamicArray).%New()
     set result       =##class(%DynamicArray).%New()
      //xml查询
     SET REQUEST      =##class(%DynamicObject).%New()
     SET REQUEST      =REQUEST.%FromJSON(A1)
     set type=REQUEST.Type
     set sql=""
     if (type'=""){
	     set sql="where StandardType='"_type_"'"
	     
	     }
	 //hl7_v2
	   
	 set queryStr  ="select * from JHIPV5_JHREG_DB.StructureManagement "_sql_"group by StandardName"
	 $$$TRACE(queryStr)
	 SET rset=##class(%ResultSet).%New()
     SET qStatus=rset.Prepare(queryStr)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
     WHILE rset.Next() {
				Set name  = rset.%Get("StandardName")
				SET RESULT=##class(%DynamicObject).%New()
				set RESULT.ID=rset.%Get("ID")
				set RESULT.name=name
			    Do result.%Push(RESULT)
			
	    }      
     Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	 Set pResponse=##class(Ens.StringResponse).%New()
	 //Set pResponse.StringValue=Result.TResult(result)  
	 	Set pResponse.StringValue=Result.Result("200",result,1,"")
     Quit $$$OK
}

}

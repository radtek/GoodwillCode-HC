/// Classname 
/// Summary   jhipv5 结构管理导入
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.initializationSchema Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	      //导入
	     
	    
	     
	     
	     //set tsc = ..addSchema(request,.response)
	     //调用对应域的存储过程
	     
	        //set NameSpaceId=input.NameSpaceId
	        set RESULT=##class(%DynamicArray).%New()
	        //set RESULTArray=##class(%DynamicArray).%New()
            set NameSpaceID=33
        
        	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	
            DO ..Adapter.DSNSet(GetDSN)
            
           
             //hl7初始化
	     	 Set SqlName="call %Library.Global_Get('HIPP','^EnsHL7.Schema()',,,,)"
	     	 
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
	       
		     while tResult.%Next(){
			   Set name = $REPLACE($E(tResult.%Get("Name"),16,*-1),"""","")
		       Do RESULT.%Push(name)
		     
	         }
	         SET ITER=RESULT.%GetIterator()
	         while ITER.%GetNext(.key, .value) { 
	          Set SqlName2="call %Library.Global_Get('HIPP','^EnsHL7.Schema("_value_",base)',,,,)"
	     	  $$$TRACE(SqlName2)
	         Set tSC=..Adapter.ExecuteQuery(.tResult2,SqlName2)
	         set flag=1
		     if tResult2.%Next(){
			   set flag=""
	          } 
	         
	           set time=$zdt($H,3)
	         &sql(insert into JHIPV5_JHREG_DB.StructureManagement (FileName,ManagerTime,NameSpaceID,StandardName,StandardType,openStatus,standard) values(:value,:time,:NameSpaceID,:value,2,1,:flag))
	         }
	         
	     	 Set SqlName3="call %Library.Global_Get('HIPP','^EnsEDI.XML.Schema()',,,,)"
	     	 
	         Set tSC3=..Adapter.ExecuteQuery(.tResult3,SqlName3)
	       
		     while tResult3.%Next(){
			       	Set name  = $e(tResult3.%Get("Name"),21,*-2)
		   	//Do result.%Push($e(name,21,*-2))
			   &sql(insert into JHIPV5_JHREG_DB.StructureManagement (FileName,ManagerTime,NameSpaceID,StandardName,StandardType,openStatus) values(:name,:time,:NameSpaceID,:name,1,1))
	     
			   
		       Do RESULT.%Push(name)
	         }
	 Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	 Set pResponse=##class(Ens.StringResponse).%New()
	 Set pResponse.StringValue=Result.TResult("初始化完成") 
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

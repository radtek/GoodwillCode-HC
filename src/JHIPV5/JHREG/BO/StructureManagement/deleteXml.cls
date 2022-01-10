/// Classname 
/// Summary   jhipv5 结构管理删除
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.deleteXml Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
 
        Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
        Set pResponse=##class(Ens.StringResponse).%New()
	    SET A1     =pRequest.pArg.GetAt(1)
	    set request=##class(%DynamicArray).%New()
	    set request=request.%FromJSON(A1)
	    set ID     =request.ID
	    //查询规则中有无正在使用的
	    
	    &sql(select ID,StandardName,FileName,StandardType,NameSpaceID into :standardID,:StandardName,:FileName,:StandardType,:NameSpaceID FROM JHIPV5_JHREG_DB.StructureManagement WHERE ID = :ID )
	    &sql(select Count(1) INTO :num from JHIPV5_JHREG_DB.RuleTranslationDB where SourceStandard=:standardID OR  TargetStandard=:standardID) 
	    IF (num'=0){
		     Set pResponse.StringValue=Result.Result(400,"",1,"已用使用该标准的规则转换，请先删除相关规则转换")
		     Quit $$$OK
		    }
		    //判断是否为标准
		    set standard=""
		    &sql(select standard into :standard from JHIPV5_JHREG_DB.StructureManagement where ID =:ID)
		    if (standard'=""){
			    Set pResponse.StringValue=Result.Result(400,"",1,"该标准为标准Schema，不可删除")
		        Quit $$$OK  
			    
			 }
	        Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	
            DO ..Adapter.DSNSet(GetDSN)
         
	     	 Set SqlName="call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_DeleteStructureManager('"_FileName_"','"_StandardType_"')"
	         $$$TRACE(SqlName)
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
	         $$$TRACE(tSC)
		     while tResult.%Next(){
			     set tsc=tResult.%Get("Status")
			     set response=tResult.%Get("Value")
	         }
	   
	 
	    if (tsc=1){   
	       &sql(delete from JHIPV5_JHREG_DB.StructureManagement where ID = :ID) 
	       set re  ="删除成功"
	       Set pResponse.StringValue=Result.TResult(re)  
	    }else{
		   set re  ="删除失败"  
		   Set pResponse.StringValue=Result.FResult()
		}
	   
	  //	set t1= tResult.Close()
		//$$$TRACE(t1)
		// set tsc= ..Adapter.DisconnectJ()
         
   
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

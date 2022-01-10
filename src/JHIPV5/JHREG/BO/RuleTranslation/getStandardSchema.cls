/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.getStandardSchema Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	 SET A1           =pRequest.pArg.GetAt(1)
	 set request      =##class(%DynamicArray).%New()
     set result       =##class(%DynamicArray).%New()
      //xml查询
     SET REQUEST      =##class(%DynamicObject).%New()
     SET REQUEST      =REQUEST.%FromJSON(A1)
     
     set ID=REQUEST.ID
  
     if (ID'=""){
	     
	 &sql(select StandardName,FileName,StandardType,NameSpaceID into :StandardName,:FileName,:StandardType,:NameSpaceID FROM JHIPV5_JHREG_DB.StructureManagement WHERE ID = :ID )
	 Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	 DO ..Adapter.DSNSet(GetDSN)
	 set tResult=##class(EnsLib.SQL.GatewayResultSet).%New()
	 set NameSpace=##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpaceID)

	 //hl7_v2
	   
	      set queryStr  ="call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_getSchema('"_FileName_"','"_StandardType_"')"
	      Set tSC=..Adapter.ExecuteQuery(.tResult,queryStr)
          $$$TRACE(queryStr)
         $$$TRACE(tSC)
	     while tResult.%Next(){
				Set name  = tResult.%Get("Status")
				set re=##class(%DynamicObject).%New()
				set re.name=name
			    Do result.%Push(re)
	     }   
	     Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()   
       Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("200",result,1,"") 
	     
	     
	 }else{
		 
		
			set re=##class(%DynamicObject).%New()
			set re.name="当前标准已被删除，请修改标准"
			Do result.%Push(re) 
			 Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	 Set pResponse=##class(Ens.StringResponse).%New()
	 Set pResponse.StringValue=Result.Result("400",result,1,"当前标准已被删除，请修改标准") 
		 
	}
     
 
	 
     Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>bpSelect</Method>
	</MapItem>
</MapItems>
}

}

/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.getNameSpace Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

	
	//Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(input.NameSpaceId)
    //set nameSpaceTemp=##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(input.NameSpaceId)
    //DO ..Adapter.DSNSet(GetDSN)
    SET RESULT=##class(%DynamicArray).%New()
	//Set Status=rc.InstantiateQuery(.rs,"%SYSTEM.License","Summary") break:'Status
	    set queryStr   ="select nameSpaceId   from JHIPV5_JHREG_DB.RuleTranslationDB group by nameSpaceId"		
		Set statement  = ##class(%SQL.Statement).%New()
		Set qStatus    = statement.%Prepare(queryStr)
		Set rset       = statement.%Execute()
	    while rset.%Next(){	
	      set resultOb      =##class(%DynamicObject).%New()
	      Set resultOb.ID   =rset.%Get("nameSpaceId")
	      Set resultOb.Name =##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(resultOb.ID)
	
		  Do RESULT.%Push(resultOb)   
	    }
    Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
    Set pResponse=##class(Ens.StringResponse).%New()
    	Set pResponse.StringValue=Result.Result("200",RESULT,1,"")

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

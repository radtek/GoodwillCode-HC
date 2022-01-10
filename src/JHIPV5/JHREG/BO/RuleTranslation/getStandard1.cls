/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.getStandard1 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(pRequest.pArg.GetAt(1))
	set NameSpaceId=input.NameSpaceId
	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(input.NameSpaceId)
    set nameSpaceTemp=##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(input.NameSpaceId)
    DO ..Adapter.DSNSet(GetDSN)
    SET RESULT=##class(%DynamicArray).%New()
	//Set Status=rc.InstantiateQuery(.rs,"%SYSTEM.License","Summary") break:'Status
    set StandardType=input.StandardType
    if (StandardType=2){
	//获取hl7的结构及标准名    
	set queryStr ="call %Library.Global_Get('"_nameSpaceTemp_"','^EnsHL7.Schema()')"
	Set tSC=..Adapter.ExecuteQuery(.tResult,queryStr)
	while tResult.%Next(){
		SET RESULT2=##class(%DynamicArray).%New()
		set name= $REPLACE($E(tResult.%Get("Name"),16,*-1),"""","")
	    set queryStr2 ="call %Library.Global_Get('"_nameSpaceTemp_"','^EnsHL7.Schema("_name_",MT,)')"
	    Set tSC2=..Adapter.ExecuteQuery(.tResult2,queryStr2)
	    while tResult2.%Next(){
		    Set name2  = tResult2.%Get("Value")
		    Do RESULT2.%Push(name2)
	    }
	    set RESULT2OB=##class(%DynamicObject).%New()
	    set RESULT2OB.name=name
	    set RESULT2OB.Array=RESULT2
		Do RESULT.%Push(RESULT2OB)
	  }
    }else{
	    //获取xml的结构及标准名	
		set queryStr="call %Library.Global_Get('"_nameSpaceTemp_"','^EnsEDI.XML.Schema()')"
		Set tSC=..Adapter.ExecuteQuery(.tResult,queryStr)
	    SET RESULT2=##class(%DynamicArray).%New()
	  	while tResult.%Next(){
		set name= $e(tResult.%Get("Name"),21,*-2)
		set queryStr2="call %Library.Global_Get('"_nameSpaceTemp_"','^EnsEDI.XML.Schema("""_name_""",""TYPE"",)')"
	    Set tSC=..Adapter.ExecuteQuery(.tResult2,queryStr2)
	  	while tResult2.%Next(){
		  	Set name2 =$e($p(name,"^EnsEDI.XML.Schema("""_name_""",""DS"",",2),2,*-2)
		    Do RESULT2.%Push(name2)
		}	
		set RESULT2OB=##class(%DynamicObject).%New()
	    set RESULT2OB.name=name
	    set RESULT2OB.Array=RESULT2
		Do RESULT.%Push(RESULT2OB)
	  }	
    }
    Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
    Set pResponse=##class(Ens.StringResponse).%New()
	Set pResponse.StringValue=Result.TResult(RESULT)
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

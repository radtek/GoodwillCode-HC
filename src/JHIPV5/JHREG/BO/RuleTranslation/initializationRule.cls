/// Classname 
/// Summary   jhipv5 规则转换初始化数据
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.initializationRule Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

	        set RESULT=##class(%DynamicArray).%New()
	        //set RESULTArray=##class(%DynamicArray).%New()
            set NameSpaceID=33
        
        	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	
            DO ..Adapter.DSNSet(GetDSN)
            
           
             //
	     /*	 Set SqlName="call JHIPV5_JH503UTIL_RuleTranslation.RuleTranslationUtil_initializationDTRule()"
	     	 
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
	         $$$TRACE(tSC)
		     while tResult.%Next(){
			   //Set name = $REPLACE($E(tResult.%Get("Name"),16,*-1),"""","")
		      // Do RESULT.%Push(name)
		       set FilesName=tResult.%Get("FilesName")
		       set RuleName=tResult.%Get("RuleName")
		       set RuleType=tResult.%Get("Type")
		       set SourceStandard=tResult.%Get("SourceStandard")
		       set SourceStandardMessage=tResult.%Get("SourceStandardMessage")
		       set TargetStandard=tResult.%Get("TargetStandard")
		       set TargetStandardMessage=tResult.%Get("TargetStandardMessage")
		       
		       &sql(insert into JHIPV5_JHREG_DB.RuleTranslationDB (FilesName,RuleName,RuleType,SourceStandard,SourceStandardMessage,TargetStandard,TargetStandardMessage,nameSpaceId) values(:FilesName,:RuleName,:RuleType,:SourceStandard,:SourceStandardMessage,:TargetStandard,:TargetStandardMessage,:NameSpaceID))
	       
	         }*/

	         

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

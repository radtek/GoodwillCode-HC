/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年12月20日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.getXsltBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
    Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(pRequest.pArg.GetAt(1))
		//Set pOutput=##class(Ens.StringResponse).%New()
		Set ID=input.ID
		&sql(select nameSpaceId,RuleName,RuleType into :NameSpaceId,:FilesName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB WHERE ID = :ID)
	 	set FileBody=""
		if (RuleType="XSLT"){
		 Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceId)
	
         DO ..Adapter.DSNSet(GetDSN)
         
         
         Set SqlName="SELECT  ID,FileName,FileType,OperationFileTIME,FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName= '"_FilesName_"'"
		 $$$TRACE(SqlName)
	     Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
	     $$$TRACE(tSC)
		 while tResult.%Next(){
				 $$$TRACE("123")
				 //$$$TRACE(tResult.%Get("NUM"))
			     set FileBody=tResult.%Get("FileBody")
			 $$$TRACE(FileBody)
	     }
         
         
         
       	//&Sql(SELECT FileBody INTO :FileBody FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FilesName)
	    


		}else{
		   set FileBody=""	
			
		}
	  Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	  Set pResponse=##class(Ens.StringResponse).%New()
	 // Set pResponse.StringValue=Result.TResult(FileBody)
	  	Set pResponse.StringValue=Result.Result("200",FileBody,1,"")
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

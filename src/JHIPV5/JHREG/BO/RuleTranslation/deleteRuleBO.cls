/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.deleteRuleBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	 
	     
    Set request =pRequest.pArg.GetAt(1)
    set USE=0
    set UseString="规则"
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(pRequest.pArg.GetAt(1))
	set RuleArray=input.RuleArray
	set iter=RuleArray.%GetIterator()	
	while iter.%GetNext(.key, .value){
	  &sql(select RuleType,RuleName,nameSpaceId,FilesName into :RuleType,:RuleName,:nameSpaceId,:FilesName from  JHIPV5_JHREG_DB.RuleTranslationDB where ID = :value )			
	  //查询DSN
	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(nameSpaceId)

      DO ..Adapter.DSNSet(GetDSN)
      set num=0
      &sql(select Count(1) into num from JHIPV5_JHREG_DB.SubRelationlListDB where RulesTransId=:value)
	     if (num){
		  set USE =1
		   set UseString=UseString_FilesName_","
		 }
		 else{
		   if (RuleType="XSLT"){
		   //删除对应数据库  
		
	       Set SqlName="Delete FROM  JHIPLIB_Util_Save_DB.SaveDB WHERE FileName = '"_RuleName_"'"
	   
		   Set tSC=..Adapter.ExecuteUpdateParmArray(.tResult,SqlName,.a)
		   //&sql(delete FROM  JHIPLIB_Util_Save_DB.SaveDB WHERE FileName = :FilesName)
		   $$$TRACE(tSC)
		
	     }elseif(RuleType="DT"){
	      //调用对应存储过程删除类
	      Set SqlName="call JHIPV5_JH503UTIL_RuleTranslation.RuleTranslationUtil_DeleteRule('"_FilesName_"')"
	      Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)	  
	    }
	  if (tSC){
	   
	    &sql(delete from JHIPV5_JHREG_DB.RuleTranslationDB where ID = :value)
	   }	 
	  }

	  
	  //删除本地总表
	
	}
	 Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
  	Set pResponse=##class(Ens.StringResponse).%New()
  	if (USE=1){
	 
	  	Set pResponse.StringValue=Result.Result("400","",1,$e(UseString,1,*-1)_"正在使用中，请在订阅关系中取消相关订阅再删除")   
	  	}ELSE{
		 
         set pResponse.StringValue=Result.TResult("删除成功") 
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

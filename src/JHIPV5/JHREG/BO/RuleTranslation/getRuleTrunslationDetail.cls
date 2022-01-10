/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.getRuleTrunslationDetail Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

    set NameSpaceId=""
	Set request =pRequest.pArg.GetAt(1)
	set resultArray=##class(%DynamicArray).%New()
	//获取订阅关系表格  
	SET A1=request  //传入json json转object
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(A1)
	set resultArray=##class(%DynamicArray).%New()
	set size=input.size
	set page=input.Page
	set num=(page-1)*size
	set num2=num+size
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(request)
    set sql=""
    $$$TRACE(input.RuleName)
	if (input.NameSpaceId'=""){
	   set sql=sql_"and nameSpaceId = '"_input.NameSpaceId_"'"	
	}	
	if (input.RuleName'=""){
	   set sql=sql_" and RuleName = '"_input.RuleName_"'"	
	}	
	SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total, * FROM JHIPV5_JHREG_DB.RuleTranslationDB WHERE 1=1"_sql_")where %VID<="_num2_" and %VID>"_num_""
    $$$TRACE(myquery)
   set DSN=""
    SET rset=##class(%ResultSet).%New()
    SET qStatus=rset.Prepare(myquery)
    IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    SET sc=rset.Execute()
    set total=0
    WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	      set resultOb.ID=rset.Data("ID")
	     set resultOb.RuleName=rset.Data("RuleName")
	     set resultOb.RuleType=rset.Data("RuleType")
	     set NameSpaceId=rset.Data("nameSpaceId")
	     set resultOb.NameSpaceId=NameSpaceId
	     if (resultOb.RuleType="DT"){
		    //
		    Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceId)
            Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
            
            IF (DSN'=GetDSN){
	            set DSN=GetDSN
            DO ..Adapter.DSNSet(GetDSN)
            }
            set FilesName=rset.Data("FilesName")
            Set SqlName="call JHIPV5_JH503UTIL_RuleTranslation.RuleTranslationUtil_getDTRuleMessageType('"_FilesName_"')"

           Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)

         if tResult.%Next(){
			    // set tsc=tResult.%Get("name")
			    
			    set resultOb.SourceMessage=tResult.%Get("Source")
	            set resultOb.TargetMessage=tResult.%Get("Target") 
	      }
            
		    
		     
		 }else{
		 set resultOb.SourceMessage=rset.Data("SourceStandardMessage")
	     set resultOb.TargetMessage=rset.Data("TargetStandardMessage") 
			 
	     }
	    
	     set SourceStandard=$p(resultOb.SourceMessage,":",1)
	     set TargetStandard=$p(resultOb.TargetMessage,":",1)
	  
	 
	     set sID=""
	     set tID=""
	     &sql(select ID into :sID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID=:NameSpaceId and StandardName=:SourceStandard)
	     &sql(select ID into :tID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID=:NameSpaceId and StandardName=:TargetStandard)
	     //为空时已被删除 重新查询
	     set resultOb.SourceStandardID=sID
	     set resultOb.TargetStandardID=tID
	     set resultOb.SourceStandard=SourceStandard
	     set resultOb.TargetStandard=TargetStandard
	     set resultOb.OperaTime=rset.Data("OperaTime")
	     &sql(select NameSpace into :NameSpace from JHIPV5_JHREG_DB.DomainDB where DomainID =:NameSpaceId)
	     set resultOb.NameSpace=NameSpace
         set total=rset.Data("Total")
	     // set resultOb.transRulesType=rset.Data("RuleType")
	     Do resultArray.%Push(resultOb)
   }
   set re=##class(%DynamicObject).%New()
   set re.rows=resultArray
   set re.total=total
   Set pResponse=##class(Ens.StringResponse).%New()
   	Set pResponse.StringValue=Result.Result("200",re,1,"")
   //Set pResponse.StringValue=Result.TResult(re)
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

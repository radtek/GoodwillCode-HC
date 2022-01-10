/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.bpSubSelect Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{


	Set request =pRequest.pArg.GetAt(1)
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	
	SET A1=request  //传入json json转object

	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(A1)
	set resultArray=##class(%DynamicArray).%New()
	if (input.SubId=""){
	 Set pResponse=##class(Ens.StringResponse).%New()
	     Set pResponse.StringValue=Result.Result("200","[]",1,"") 	
	     Quit $$$OK
	}
	
	
    set myquery="select boId,ifAsyn,RulesTransId from JHIPV5_JHREG_DB.SubRelationlListDB where SubId ="_input.SubId_""
    SET rset=##class(%ResultSet).%New()
    SET qStatus=rset.Prepare(myquery)
    IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    SET sc=rset.Execute()
    WHILE rset.Next() {
	 
	     SET RulesTransId=""
	     set resultOb=##class(%DynamicObject).%New()
	     set resultOb.ifAsyn=rset.Data("ifAsyn")
	     set tempId=rset.Data("boId")
	     &sql(select ID,subscriberName,BusinessPartner,Organization,standard into :ID,:subscriberName,:BusinessPartner,:Organization,:standard from JHIPV5_JHREG_DB_Subscriber.SubscriberDB where ID = :tempId)
	      set resultOb.id=ID
	      set resultOb.Name=subscriberName
	      set resultOb.subSystem=BusinessPartner
          set resultOb.Organization=Organization
	      set resultOb.standard=standard
	      set RulesTransId=rset.Data("RulesTransId")
	      if (RulesTransId){
		      set RuleName=""
		     &sql(select ID,RuleName,RuleType into :ID,:RuleName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB where ID =:RulesTransId) 
		     set resultOb.transRulesId=ID
		     if (RuleName=""){
			   set resultOb.transRules="规则已被删除"
			   set resultOb.transRulesType=""
			    set resultOb.transRulesId="-1"
			    }else{
			 set resultOb.transRules=RuleName	
			 set resultOb.transRulesType=RuleType    
			}
		    
		
		     }else{
		 	set resultOb.transRulesId=0
		    set resultOb.transRules="未使用转换规则"
		    set resultOb.transRulesType="null"
			   
		 }
	     Do resultArray.%Push(resultOb)
     }	
     set re=##class(%DynamicObject).%New()
     set re.options=resultArray
  
	
	  Set pResponse=##class(Ens.StringResponse).%New()
	     Set pResponse.StringValue=Result.Result("200",re,1,"") 
	 // Set pResponse.StringValue=Result.TResult(re)
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

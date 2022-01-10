/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.getRuleTrunslationName Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

    
    
    
    set NameSpaceId=""
	Set request =pRequest.pArg.GetAt(1)
	 set resultArray=##class(%DynamicArray).%New()
	 
	 
	 
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	set input=##class(%DynamicObject).%New()
	
	set input= input.%FromJSON(request)
    


	if (input.NameSpaceId'=""){
	  SET myquery="SELECT * FROM JHIPV5_JHREG_DB.RuleTranslationDB WHERE nameSpaceId = '"_input.NameSpaceId_"'"
		
	}else{
		
	  SET myquery="SELECT * FROM JHIPV5_JHREG_DB.RuleTranslationDB "
    }
 
	SET rset=##class(%ResultSet).%New()
    SET qStatus=rset.Prepare(myquery)
    IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    SET sc=rset.Execute()
    set total=0
    WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	     set resultOb.value=rset.Data("ID")
	     set resultOb.label=rset.Data("RuleName")
	    // set resultOb.transRulesType=rset.Data("RuleType")
	     Do resultArray.%Push(resultOb)
     }
	
	 set re=##class(%DynamicObject).%New()
     set re.options=resultArray
    

	
	Set pResponse=##class(Ens.StringResponse).%New()
	//Set pResponse.StringValue=Result.TResult(re)
	Set pResponse.StringValue=Result.Result("200",re,1,"")
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

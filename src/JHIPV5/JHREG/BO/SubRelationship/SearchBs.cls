/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.SearchBs Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{


	Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(request)
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	//获取订阅关系表格  
     SET myquery="select * from  JHIPV5_JHREG_DB_Theme.ThemeDB  where ID not IN(SELECT bsId AS ID from JHIPV5_JHREG_DB.SupRelation WHERE bsId !='') and NameSpace ='"_input.NameSpace_"'"
     $$$TRACE(myquery)
	SET rset=##class(%ResultSet).%New()
     SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
     set total=0
     SET resultArray=##class(%DynamicArray).%New()
     WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	     set resultOb.id=rset.Data("ID")
	     set resultOb.ThemeName=rset.Data("ThemeName")

	     Do resultArray.%Push(resultOb)
     }	
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue=Result.Result("200",resultArray,1,"") 
	 // Set pResponse.StringValue=Result.TResult(resultArray)
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

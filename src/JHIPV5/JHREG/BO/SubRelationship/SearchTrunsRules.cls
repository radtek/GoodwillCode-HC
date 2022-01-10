/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.SearchTrunsRules Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{




	
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	//获取xslt名 
     SET myquery="select * from JHIPLIB_Util_Save_DB.SaveDB"
	
	
	 SET rset=##class(%ResultSet).%New()
     SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
     set total=0
     SET resultArray=##class(%DynamicArray).%New()
     WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	     
	     set resultOb.TrunsName=rset.Data("FileName")
         set resultOb.Type="xslt"
         Do resultArray.%Push(resultOb)
     }	
     
     
     SET myquery="select * from Ens_Util.LookupTable"
	 SET rset=##class(%ResultSet).%New()
     SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
     set total=0
     SET resultArray=##class(%DynamicArray).%New()
     WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	     
	     set resultOb.TrunsName=rset.Data("TableName")
         set resultOb.Type="dt"
         Do resultArray.%Push(resultOb)
     }
     
     
	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue=Result.TResult(resultArray)
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

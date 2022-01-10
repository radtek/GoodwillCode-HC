/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.SearchBo Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{


	Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(request)
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	//获取订阅关系表格  
	set sql=""
	if (input.Organation'="全部")&&(input.Organation'=""){
		set sql=sql_"and Organization = '"_input.Organation_"'"
	}
	if (input.SubSystem'="全部")&&(input.Organation'=""){
		set sql=sql_"and BusinessPartner = '"_input.SubSystem_"'"	
	}
	
     SET myquery="select * from  JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID not IN (SELECT boId AS ID from JHIPV5_JHREG_DB.SubRelationlListDB where SubId ='"_input.SubId_"' ) and NameSpace ='"_input.nameSpace_"'"_sql
	
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
	     set resultOb.subscriberName=rset.Data("subscriberName")
         set resultOb.Organization=rset.Data("Organization")
          set resultOb.SubSystem=rset.Data("BusinessPartner")
         Do resultArray.%Push(resultOb)
     }	
	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue=Result.Result("200",resultArray,1,"") 
	  //Set pResponse.StringValue=Result.TResult(resultArray)
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

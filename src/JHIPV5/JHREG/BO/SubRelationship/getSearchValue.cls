/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.getSearchValue Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

    //筛选条件值获取接口
	Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(request)
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	//获取搜索条件值

	if (input.Type=1){
	 SET myquery="select nameSpace as Name1  from JHIPV5_JHREG_DB.SupRelation group by nameSpace"	
	}
	elseif (input.Type=2)
	{
     SET myquery="select Category as Name1 from JHIPV5_JHREG_DB.SupRelation group by Category"
	}elseif(input.Type=4){
		 SET myquery="select BusinessPartner as Name1 from JHIPV5_JHREG_DB_Subscriber.SubscriberDB where ID in (select boId from JHIPV5_JHREG_DB.SubRelationlListDB  ) group by BusinessPartner"
		$$$TRACE(myquery)
	}elseif(input.Type=5){
		 SET myquery="select BusinessPartner as Name1 from JHIPV5_JHREG_DB_Theme.ThemeDB where ID in (select bsId from JHIPV5_JHREG_DB.SupRelation ) group by BusinessPartner "
		$$$TRACE(myquery)
	}elseif(input.Type=6){
		set sql1=""
		$$$TRACE(input.searchType)	
		 if (input.searchType="1")&&(input.searchValue'=""){
		
			 	 &sql(select DomainID into :nameSpaceId from JHIPV5_JHREG_DB.DomainDB where NameSpace  = :input.searchValue)
			 set sql1="and nameSpaceId='"_nameSpaceId_"'"
			 }elseif(input.searchType="2")&&(input.searchValue'=""){
			 set sql1="and  Category='"_input.searchValue_"'"
			 }
			 elseif(input.searchType="3")&&(input.searchValue'=""){
				 if (input.searchValue="启用"){set temp=1}else{set temp=0}
			 set sql1="and  openStatus='"_temp_"'"
			 }elseif(input.searchType="5")&&(input.searchValue'=""){
			 set sql1="and  BusinessPartner='"_input.searchValue_"'"
			 }elseif(input.searchType="4")&&(input.searchValue'=""){
			 set sql1="and  BusinessPartner='"_input.searchValue_"'"
			 }
			 if (input.searchType="5"){
				 
				 SET myquery="select ThemeName as Name1 from  JHIPV5_JHREG_DB_Theme.ThemeDB where ID in (select bsId as ID from JHIPV5_JHREG_DB.SupRelation where 1=1)"_sql1
		
				 
				 
				}elseif(input.searchType="4"){
					 SET myquery="select ThemeName as Name1 from  JHIPV5_JHREG_DB_Theme.ThemeDB where ID in (select bsId  from JHIPV5_JHREG_DB.SupRelation where 1=1 and ID in (select SubId from JHIPV5_JHREG_DB.SubRelationlListDB where boId in  (select ID from JHIPV5_JHREG_DB_Subscriber.SubscriberDB where 1=1 "_sql1_")))"
		
				}else{
					
			      SET myquery="select ThemeName as Name1 from  JHIPV5_JHREG_DB_Theme.ThemeDB where ID in (select bsId as ID from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql1_")"
		
					
					}
					
					$$$TRACE(myquery)
		
	}
	
	//编辑页面
	/*elseif(input.Type=7){
		 SET myquery="select Organization as Name1 from  JHIPV5_JHREG_DB_Subscriber.SubscriberDB where ID in (select boId from JHIPV5_JHREG_DB.SubRelationlListDB where SubId = '"_input.SubId_"') group by Organization"
		
	}
	elseif(input.Type=8){
		 SET myquery="select BusinessPartner as Name1 from  JHIPV5_JHREG_DB_Subscriber.SubscriberDB where ID in (select boId from JHIPV5_JHREG_DB.SubRelationlListDB where SubId = '"_input.SubId_"') group by BusinessPartner"
		
	}*/
	//新增编辑页面二级弹框订阅机构订阅系统
	elseif(input.Type=7){
		// &sql(select nameSpace into :nameSpace from JHIPV5_JHREG_DB.SupRelation where ID =:input.SubId)
	     SET myquery="select Organization as Name1 from  JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID not IN (SELECT boId AS ID from JHIPV5_JHREG_DB.SubRelationlListDB where SubId ='"_input.SubId_"' ) and NameSpace ='"_input.nameSpace_"' group by Organization"
	
		
    }
	elseif(input.Type=8){
		// &sql(select nameSpace into :nameSpace from JHIPV5_JHREG_DB.SupRelation where ID =:input.SubId)
	     SET myquery="select BusinessPartner as Name1 from  JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID not IN (SELECT boId AS ID from JHIPV5_JHREG_DB.SubRelationlListDB where SubId ='"_input.SubId_"' ) and NameSpace ='"_input.nameSpace_"' group by BusinessPartner"
	
		
    }
	 SET rset=##class(%ResultSet).%New()
     SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
     set total=0
     SET resultArray=##class(%DynamicArray).%New()
     if (input.Type=7)||(input.Type=8){
	     set resultOb=##class(%DynamicObject).%New()
	    
	     set resultOb.Name="全部"
	     Do resultArray.%Push(resultOb)
	     }
     WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	    
	     set resultOb.Name=rset.Data("Name1")

	     Do resultArray.%Push(resultOb)
	    
     }	
     
     /*if (input.Type=6){
	    set sql1=sql1_"and ifInitialization=1"
	    SET myquery1="select * FROM JHIPV5_JHREG_DB.SupRelation where 1=1"_sql1
	    $$$TRACE(myquery1)
	    SET rset1=##class(%ResultSet).%New()
     SET qStatus1=rset1.Prepare(myquery1)
     IF qStatus1'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc1=rset1.Execute()
	     WHILE rset1.Next() {
		     
		 
	    
	     set NN=rset1.Data("bsId") 
         SET NL=$L(NN,",")
         SET I=1
         FOR I=1:1:NL{
	     set resultOb=##class(%DynamicObject).%New() 
	      set resultOb.Name=$P(rset1.Data("bsId"),",",I)
	      IF (resultOb.Name'=""){
	     Do resultArray.%Push(resultOb)
	      }
	     }
	     //Do resultArray.%Push(resultOb)
		  }
	    

	 }*/
     
     
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

/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.bpSelect Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{


	Set request =pRequest.pArg.GetAt(1)
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	//获取订阅关系表格  
	
	SET A1=request  //传入json json转object

	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(A1)
	 set resultArray=##class(%DynamicArray).%New()
	 set size=input.Size
	 set page=input.Page
	 set num=(page-1)*size
	 set num2=num+size
	 if (input.ThemeName=""){set sql=""}else{set sql="and (bsId in (SELECT ID as bsId from  JHIPV5_JHREG_DB_Theme.ThemeDB where ThemeName = '"_input.ThemeName_"') or bsId like '%"_input.ThemeName_"%')"}
	 if (input.SearchType="1"){
		 if (input.SearchValue=""){
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total, * from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_"  ) where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	     }else{
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where nameSpace ='"_input.SearchValue_"'"_sql_" ) where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	     }
	  
	 }elseif (input.SearchType="2"){  //业务场景  分类 
		if (input.SearchValue=""){
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_" ) where %VID<=Total-"_num_" and %VID>Total-"_num2_""
	    }else{
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where (bsId in(select ID from  JHIPV5_JHREG_DB_Theme.ThemeDB  where Category ='"_input.SearchValue_"'))"_sql_") where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	     } 
		 
	 }
	 elseif (input.SearchType="3"){  //发布状态
	    if (input.SearchValue=""){
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_" ) where %VID<="_num2_" and %VID>"_num_""
	    }else{
		     if (input.SearchValue="启用"){
			    set temp=1
			 }else{
				   set temp=0 
			}
		    SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where openStatus ="_temp_""_sql_") where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	     } 
	}
	 elseif (input.SearchType="4"){  //订阅系统
		 if (input.SearchValue=""){
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_" ) where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	    }else{
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where ID in (select SubId from JHIPV5_JHREG_DB.SubRelationlListDB where boId in(select ID from  JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where BusinessPartner ='"_input.SearchValue_"'))"_sql_") where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	    } 
		 
	 }
	 elseif (input.SearchType="5"){  //发布系统
		if (input.SearchValue=""){
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_" ) where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	    }else{
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where bsId in(select ID from  JHIPV5_JHREG_DB_Theme.ThemeDB  where BusinessPartner ='"_input.SearchValue_"')"_sql_") where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	    } 
		 
	 }
	 elseif (input.SearchType="6"){  //
		if (input.SearchValue=""){
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_" ) where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	    }else{
			 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where subSystem like'%"_input.SearchValue_"%'"_sql_") where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	    }  
	 }else {
		 
		 	 SET myquery="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.SupRelation where 1=1"_sql_" ) where %VID<=Total-"_num_" and %VID>Total-"_num2_" ORDER BY id DESC"
	   
		 
		 }
     SET rset=##class(%ResultSet).%New()
     $$$TRACE(myquery)
     SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
     set total=0
 
     WHILE rset.Next() {
	     set ThemeName=""
	     set resultOb=##class(%DynamicObject).%New()
	     set resultOb.id=rset.Data("ID")
	     set resultOb.Name=rset.Data("Name")
	     set resultOb.boName=rset.Data("boName")
	     set bsId=rset.Data("bsId")
	     set resultOb.Initialization=rset.Data("ifInitialization")
	     if (resultOb.Initialization'=1){
		  &sql(select ThemeName,BusinessPartner,Category into:ThemeName,:BusinessPartner,:Category from JHIPV5_JHREG_DB_Theme.ThemeDB where ID = :bsId)
	     if (ThemeName=""){
		      set resultOb.bsName="主题已被删除"
		      set resultOb.subSystem=""
		       set resultOb.Category=""
		     }else{ set resultOb.bsName=ThemeName
		     set resultOb.pubSystem=BusinessPartner
		      set resultOb.Category=Category
		     } 
		     
		       
		  }else{
			  //调用类去获取？
			 set resultOb.bsName=bsId //先这么写，等主题初始化完成后再考虑修改
			 set resultOb.pubSystem="" //等主题初始化完成再添加或者初始化时加上
			 set resultOb.Category=rset.Data("Category")
			  
		 }

		//通过类调用 查询所有target为目标的BS name及 目标call    
	    set NameSpaceId=rset.Data("nameSpaceId")
	  // Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpaceId)
	     set resultOb.nameSpace=##class(JHIPV5.JHREG.Common.NameSpace).GetNameSpace(NameSpaceId)
	      
	      set resultOb.status=rset.Data("openStatus")

	   
	      
	      //set resultOb.subSystem=rset.Data("subSystem")
	      //修改为通过订户表获取订阅系统，做查重筛选
	      
	      set sub=""
	  SET myquery1="select BusinessPartner from JHIPV5_JHREG_DB_Subscriber.SubscriberDB where ID in(select boId from JHIPV5_JHREG_DB.SubRelationlListDB where SubId='"_rset.Data("ID")_"') group by BusinessPartner"
      SET rset1=##class(%ResultSet).%New()
     SET qStatus1=rset1.Prepare(myquery1)
     IF qStatus1'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus1) QUIT}
     SET sc1=rset1.Execute()
     
       WHILE rset1.Next() {
	       
	       set sub=sub_rset1.%Get("BusinessPartner")_","
	       
	       }
	      set resultOb.subSystem=$e(sub,1,*-1)
	     
	     set total=rset.Data("Total")
	     Do resultArray.%Push(resultOb)
     }	
     set re=##class(%DynamicObject).%New()
     set re.rows=resultArray
     set re.total=total
	//根据不同的请求，拼接ip namespace等去调用不同的存储过程名	
	//
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

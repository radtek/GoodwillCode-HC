/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.SearchNet Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	SET A1=pRequest.pArg.GetAt(1)

	set input=##class(%DynamicObject).%New()

	
	set input= input.%FromJSON(A1)
	set input.type=pRequest.action
   

	////添加
	if (input.type="addSubRelate"){
	
	 &sql(select NameSpace,IpAdderss into :nameSpace, :ipJson from JHIPV5_JHREG_DB.DomainDB where DomainID  = :input.NameSpaceId)
	  
	  set boArray=##class(%DynamicArray).%New()
	  set subSystem=""
	  set boName=""
	  set array=##class(%DynamicArray).%New()
	  set array=input.SubscriberArr
	  if (array.%Size()=0){
		Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"请至少选择一个订户") 
	    Quit $$$OK
		  }
	  set iterBo = input.SubscriberArr.%GetIterator()
	  
	  while iterBo.%GetNext(.key, .value) { 
	   &sql(select BusinessPartner,subscriberName,subscriberCode into :BusinessPartner,:subscriberName,:subscriberCode from JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID  = :value)
       set tempOb= ##class(%DynamicObject).%New()
       //set subscriberCode=$replace(subscriberCode,"_","")
       set tempOb.id=subscriberCode_subscriberName
       set tempOb.status=1
       set RuleName=""
       set RuleType=""
       set tempOb.transRules=""
       set tempOb.transRulesType=""
       //&sql(select RuleName,RuleType into :RuleName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB  where ID  = :value.transRulesID)
       set tempOb.transRules=RuleName
       set tempOb.transRulesType=RuleType
       Do boArray.%Push(tempOb)
	   if ($L(subSystem,BusinessPartner)<2){
	     SET subSystem=subSystem_BusinessPartner_","   
	    }
	   set boName=boName_subscriberName_","
	  }
	  SET THEMEid=input.Themeid
	   
	   &sql(select ThemeCode,ThemeName,BusinessPartner,Category into :ThemeCode, :ThemeName,:BusinessPartner,:Category from JHIPV5_JHREG_DB_Theme.ThemeDB where ID  = :THEMEid)

	 
	 
	  set bpArray=##class(%DynamicObject).%New()
	  set bpArray.type="addSubRelate"
	  //SET ThemeCode=$REPLACE(ThemeCode,"_","")
	  //set bpArray.bsID=$REPLACE("HIPPNew.BPTEST."_ThemeCode_"BP","_","")   //bpclass名
	  set bpArray.bsID="JHIPV5BP.BP"_$TRanslate($ZDT($H,3),"-,:, ")
	  set bpArray.bsName=ThemeCode_ThemeName_"BP"   //根据id获取编码
	  
	  set bpArray.bsName=bpArray.bsName
	  set bpArray.boName=boArray  //根据id获取名称
      set bpArray.Category=Category
      
	  SET bpArray1=bpArray.%ToJSON()
	  Set httprequest=##class(%Net.HttpRequest).%New()
	  Do httprequest.InsertFormData("VALUE",bpArray.%ToJSON())
	  //查询域数据库获取ip 命名空间名
	  set ipNum=$l(ipJson,",")
	
	  set i=0
	/*  for i=1:1:ipNum{
	  set ip=$p(ipJson,",",i) */
	   Try{
	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(input.NameSpaceId)
	   
	  }catch(e){
		SET GetDSN=""
	  }
	  IF (GetDSN=""){
		Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"当前域暂未配置相关DSN") 
	    Quit $$$OK  
		  
	  }
	  DO ..Adapter.DSNSet(GetDSN)
	  /*Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(input.NameSpaceId)
	  DO ..Adapter.DSNSet(GetDSN)*/
	  set temp=bpArray.%ToJSON()
      Set SqlName2="CALL JHIPV5_JH503UTIL_SubRelation.SubRelationUtil_AddSubRelation ('"_bpArray.bsName_"','"_temp_"')"
	 $$$TRACE(SqlName2)
	  Set tSC2=..Adapter.ExecuteQuery(.tResult2,SqlName2)
	  while tResult2.%Next(){
		  set tsc=tResult2.%Get("Status")
		  set response=tResult2.%Get("Value")
	  }
	  if (tsc){
		set Name=ThemeCode_ThemeName_"BP"
		set className=bpArray.bsID //className
		set bsId=input.Themeid //主题的id
	
		
		set boName=$e(boName,1,*-1)
	 	set pubSystem=BusinessPartner  //
	    set subSystem=$e(subSystem,1,*-1)  //
	    set nameSpaceId=input.NameSpaceId  //前端传值
	    //set nameSpace=input.namespace  //前端传值后查询
	    set openStatus=1  //前端传值后查询
	    //SET BOID=$replace($replace(input.SubscriberArr.%ToJSON(),"[",""),"]","")
	    &sql(INSERT INTO JHIPV5_JHREG_DB.SupRelation (Name,className,bsId,boName,pubSystem,subSystem,nameSpaceId,nameSpace,openStatus,Category) VALUES (:Name,:className,:bsId,:boName,:pubSystem,:subSystem,:nameSpaceId,:nameSpace,:openStatus,:Category))	  
	    &sql(select ID into :SubId from JHIPV5_JHREG_DB.SupRelation where Name=:Name  and nameSpaceId=:nameSpaceId) //获取刚才添加数据的ID 
	    set iterBo = input.SubscriberArr.%GetIterator()
	    while iterBo.%GetNext(.key, .value) { 
          &sql(insert into JHIPV5_JHREG_DB.SubRelationlListDB  (SubId,boId,ifAsyn,RulesTransId) values(:SubId,:value,1,''))
	    }
	  }
	  //set return=pHttpResponse.Data.Read()
	  
      if (tsc="1"){
	      &sql(select ID into :ID from JHIPV5_JHREG_DB.SupRelation where Name =:Name and className=:className and nameSpaceId= :nameSpaceId)
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.TResult(ID)
	  }else{
	
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.FResult()
	  }
	
       Quit $$$OK
	}elseif(input.type="editSubRelate"){
      ///编辑
	  set bpArray=##class(%DynamicObject).%New()
	  set bpArray.type="editSubRelate"
	  set bpArray.id=input.SubId
	  
	  set subSystem=""
	  set boName=""
	   set boArray=##class(%DynamicArray).%New()
	    set iterBo = input.SubscriberArr.%GetIterator()
	   set array=##class(%DynamicArray).%New()
	  set array=input.SubscriberArr
	  if (array.%Size()=0){
		Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"请至少订阅一个订户") 
	    Quit $$$OK
		  }
	    while iterBo.%GetNext(.key, .value) { 
	  
	     &sql(select BusinessPartner,subscriberName,subscriberCode into :BusinessPartner,:subscriberName,:subscriberCode from JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID  = :value.id)
        set tempOb= ##class(%DynamicObject).%New()
        //set subscriberCode=$replace(subscriberCode,"_","")
       set tempOb.id=subscriberCode_subscriberName
       set tempOb.status=value.status
       set RuleType=""
       set FilesName=""
       &sql(select FilesName,RuleType into :FilesName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB  where ID  = :value.transRulesID)
       set tempOb.transRules=FilesName
       set tempOb.transRulesType=RuleType
       Do boArray.%Push(tempOb)
       if ($L(subSystem,BusinessPartner)<2){
	     SET subSystem=subSystem_BusinessPartner_","   
	    }
	  
	   set boName=boName_subscriberName_","
	   }
	  
	  set bpArray.boName=boArray
	  ////根据id获取
	  &sql(select bsId,className,nameSpaceid,nameSpace,Name INTO :bsId, :className,:nameSpaceid,:nameSpace,:Name from JHIPV5_JHREG_DB.SupRelation where ID = :input.SubId)
      set bpArray.namespaceid=nameSpaceid
	  set bpArray.namespace=nameSpace  //根据id获取
	  set bpArray.bsID=className  //根据id获取编码
	  set bpArray.bpName=Name
	 // Set httprequest=##class(%Net.HttpRequest).%New()
	 // Do httprequest.InsertFormData("VALUE",bpArray.%ToJSON())
	  &sql(select NameSpace,IpAdderss into :nameSpace, :ipJson from JHIPV5_JHREG_DB.DomainDB where DomainID  = :nameSpaceid)
	  set ipNum=$l(ipJson,",")
	  set i=0
	 /* for i=1:1:ipNum{
	  set ip=$p(ipJson,",",i)
	  */
	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(nameSpaceid)
	  DO ..Adapter.DSNSet(GetDSN)
      set temp=bpArray.%ToJSON()
	  Set SqlName2="CALL JHIPV5_JH503UTIL_SubRelation.SubRelationUtil_EditSubRelation ('"_bpArray.bsName_"','"_temp_"')"
	  $$$TRACE(SqlName2)
	  Set tSC2=..Adapter.ExecuteQuery(.tResult2,SqlName2)
	  $$$TRACE(tSC2)
	  while tResult2.%Next(){
		  set tsc=tResult2.%Get("Status")
		  set response=tResult2.%Get("Value")
	  }
	  if (tsc){
	      set boName=$e(boName,1,*-1)
		//SET BOID=$replace($replace(input.SubscriberArr.%ToJSON(),"[",""),"]","")
		  set subSystem= $e(subSystem,1,*-1) 
	      &sql(update  JHIPV5_JHREG_DB.SupRelation set boName=:boName,subSystem=:subSystem where id = :input.SubId)
	   	 set boidlist=""
		 set iterBo = input.SubscriberArr.%GetIterator()
	     while iterBo.%GetNext(.key, .value) { 
	      set boidlist=boidlist_"'"_value.id_"',"
	     
          &sql(select count(*) into :num from JHIPV5_JHREG_DB.SubRelationlListDB where SubId = :input.SubId and boId =:value.id)

          if (num=0){
	        
	         &sql(insert into JHIPV5_JHREG_DB.SubRelationlListDB (SubId,boId,ifAsyn,RulesTransId) values(:input.SubId,:value.id,:value.status,:value.transRulesID))
	       }
	       else{
		     &sql(update JHIPV5_JHREG_DB.SubRelationlListDB set ifAsyn =:value.status,RulesTransId=:value.transRulesID where SubId =:input.SubId and boId =:value.id)
     
		   }
	   
	     
	     }
	     set boidlist=$e(boidlist,1,*-1)
	     if (boidlist=""){set boidlist="''"}
	     &sql(select count(*) into :num1 from JHIPV5_JHREG_DB.SubRelationlListDB where SubId = :input.SubId AND boId not in (:boidlist) )
       
	     //&sql(delete from JHIPV5_JHREG_DB.SubRelationlListDB where SubId=:input.SubId AND boId not in (:boidlist))
	     
	 set myquery="delete from JHIPV5_JHREG_DB.SubRelationlListDB where SubId='"_input.SubId_"' AND boId not in ("_boidlist_")"  
	 $$$TRACE(myquery) 
	 SET rset=##class(%ResultSet).%New() 
	 SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
	     

	  }
	  set return=tsc
	  if (return="1"){
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.TResult("")
	  }else{
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.FResult()
	  }
	
      Quit $$$OK
	}
	
	elseif(input.type="editRelateTwo"){
      ///二级弹框保存
	  set bpArray=##class(%DynamicObject).%New()
	  set bpArray.type="addRelateTwo"
	  set bpArray.id=input.SubId
	  
	  set subSystem=""
	  set boName=""
	   set boArray=##class(%DynamicArray).%New()
	   
	   
	   	     //查原本订阅的
	    /* set myquery="select * from JHIPV5_JHREG_DB.SubRelationlListDB where SubId='"_input.SubId_"'"  
	      $$$TRACE(myquery) 
	      SET rset=##class(%ResultSet).%New() 
	      SET qStatus=rset.Prepare(myquery)
         IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
         SET sc=rset.Execute()
         while rset.%Next(){
	      set tempid=rset.%Get("boId") 
	      set tempStatus=  rset.%Get("ifAsyn") 
	      set tempRulesTransId=  rset.%Get("RulesTransId")    
	     &sql(select BusinessPartner,subscriberName,subscriberCode into :BusinessPartner,:subscriberName,:subscriberCode from JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID  = :tempid)
        set tempOb= ##class(%DynamicObject).%New()
       set tempOb.id=subscriberCode_subscriberName
       set tempOb.status=tempStatus
       set RuleName=""
       set RuleType=""
       &sql(select RuleName,RuleType into :RuleName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB  where ID  = :tempRulesTransId)
       set tempOb.transRules=RuleName
       set tempOb.transRulesType=RuleType
       Do boArray.%Push(tempOb)
       if ($L(subSystem,BusinessPartner)<2){
	     SET subSystem=subSystem_BusinessPartner_","   
	    }
	  
	    set boName=boName_subscriberName_","  
	         
	   }
	    */
	   
	   set iterBo = input.SubscriberArr.%GetIterator()
	   while iterBo.%GetNext(.key, .value) { //value:id

	     
	     &sql(select BusinessPartner,subscriberName,subscriberCode into :BusinessPartner,:subscriberName,:subscriberCode from JHIPV5_JHREG_DB_Subscriber.SubscriberDB  where ID  = :value)
        set tempOb= ##class(%DynamicObject).%New()
       // set subscriberCode=$replace(subscriberCode,"_","")
       set tempOb.id=subscriberCode_subscriberName
       set tempOb.status=1
       set RuleName=""
       set RuleType=""
       //&sql(select RuleName,RuleType into :RuleName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB  where ID  = :value.transRulesID)
       set tempOb.transRules=""
       set tempOb.transRulesType=""
       Do boArray.%Push(tempOb)
       if ($L(subSystem,BusinessPartner)<2){
	     SET subSystem=subSystem_BusinessPartner_","   
	    }
	  
	   set boName=boName_subscriberName_","
	   }
	 
	  set bpArray.boName=boArray
	  ////根据id获取
	  &sql(select bsId,className,nameSpaceid,nameSpace,Name INTO :bsId, :className,:nameSpaceid,:nameSpace,:Name from JHIPV5_JHREG_DB.SupRelation where ID = :input.SubId)
      set bpArray.namespaceid=nameSpaceid
	  set bpArray.namespace=nameSpace  //根据id获取
	  set bpArray.bsID=className  //根据id获取编码
	  set bpArray.bpName=Name
	 // Set httprequest=##class(%Net.HttpRequest).%New()
	 // Do httprequest.InsertFormData("VALUE",bpArray.%ToJSON())
	  &sql(select NameSpace,IpAdderss into :nameSpace, :ipJson from JHIPV5_JHREG_DB.DomainDB where DomainID  = :nameSpaceid)
	  set ipNum=$l(ipJson,",")
	  set i=0
	 /* for i=1:1:ipNum{
	  set ip=$p(ipJson,",",i)
	  */
	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(nameSpaceid)
	  DO ..Adapter.DSNSet(GetDSN)
      set temp=bpArray.%ToJSON()
	  Set SqlName2="CALL JHIPV5_JH503UTIL_SubRelation.SubRelationUtil_EditSubRelation ('"_bpArray.bsName_"','"_temp_"')"
	   $$$TRACE(SqlName2)
	  Set tSC2=..Adapter.ExecuteQuery(.tResult2,SqlName2)
	  $$$TRACE(tSC2)
	  while tResult2.%Next(){
		  set tsc=tResult2.%Get("Status")
		  set response=tResult2.%Get("Value")
	  }
	  if (tsc){
	      set boName=$e(boName,1,*-1)
		//SET BOID=$replace($replace(input.SubscriberArr.%ToJSON(),"[",""),"]","")
		  set subSystem= $e(subSystem,1,*-1) 
	      &sql(update  JHIPV5_JHREG_DB.SupRelation set boName=:boName,subSystem=:subSystem where id = :input.SubId)
	   	 set boidlist=""
		 set iterBo = input.SubscriberArr.%GetIterator()
	     while iterBo.%GetNext(.key, .value) { 
	      set boidlist=boidlist_"'"_value_"',"
	     
          &sql(select count(*) into :num from JHIPV5_JHREG_DB.SubRelationlListDB where SubId = :input.SubId and boId =:value)

          if (num=0){
	        
	         &sql(insert into JHIPV5_JHREG_DB.SubRelationlListDB (SubId,boId,ifAsyn,RulesTransId) values(:input.SubId,:value,1,''))
	       }
	       else{
		     &sql(update JHIPV5_JHREG_DB.SubRelationlListDB set ifAsyn =1,RulesTransId='' where SubId =:input.SubId and boId =:value)
     
		   }
	   
	     
	     }
	     set boidlist=$e(boidlist,1,*-1)
	     if (boidlist=""){set boidlist="''"}
	     &sql(select count(*) into :num1 from JHIPV5_JHREG_DB.SubRelationlListDB where SubId = :input.SubId AND boId not in (:boidlist) )
       
	     //&sql(delete from JHIPV5_JHREG_DB.SubRelationlListDB where SubId=:input.SubId AND boId not in (:boidlist))
	     
	 set myquery="delete from JHIPV5_JHREG_DB.SubRelationlListDB where SubId='"_input.SubId_"' AND boId not in ("_boidlist_")"  
	
	 SET rset=##class(%ResultSet).%New() 
	 SET qStatus=rset.Prepare(myquery)
     IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
     SET sc=rset.Execute()
	     

	  }
	  set return=tsc
	  if (return="1"){
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.TResult("")
	  }else{
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.FResult()
	  }
	
      Quit $$$OK
	}
	
	
	
	elseif(input.type="deleteSubRelate"){
		
		set fresult=1
	  set bpArray=##class(%DynamicObject).%New()
	  set iter = input.SubIdArr.%GetIterator()
	  set idlist=""
      while iter.%GetNext(.key, .value) { 
      //pushid
        set idlist=idlist_value_","
      }
      set idlist=$e(idlist,1,*-1)
      SET myquery="select nameSpaceId from JHIPV5_JHREG_DB.SupRelation  where ID  in("_idlist_") group by nameSpaceId"
        $$$TRACE(myquery)
	  SET rset=##class(%ResultSet).%New()
      SET qStatus=rset.Prepare(myquery)
      IF qStatus'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
      SET sc=rset.Execute()
      WHILE rset.Next() {
	   
	     set resultar=##class(%DynamicArray).%New()
	     set ID=rset.Data("nameSpaceId")
	     SET myquery2="select Name from JHIPV5_JHREG_DB.SupRelation  where nameSpaceId ='"_ID_"' AND ID in("_idlist_")"
	     $$$TRACE(myquery2)
         SET rset2=##class(%ResultSet).%New()
         SET qStatus2=rset2.Prepare(myquery2)
         IF qStatus2'=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus2) QUIT}
         SET sc2=rset2.Execute()
         WHILE rset2.Next() {
	        Do resultar.%Push(rset2.Data("Name"))
	     }
	     set resultArray=##class(%DynamicArray).%New()
         set bpArray=##class(%DynamicObject).%New()
	     set bpArray.type="deleteSubRelate"
	     set bpArray.bsName=resultar   //根据id获取编码
	     set temp=##class(%DynamicArray).%New()
	     set bpArray.boName=temp

	     //Set httprequest=##class(%Net.HttpRequest).%New()
	     //Do httprequest.InsertFormData("VALUE",bpArray.%ToJSON())
	     //set re= httprequest.Get("http://10.10.10.33:9988/")
		&sql(select NameSpace,IpAdderss,DomainID into :nameSpace, :ipJson,:namespaceid from JHIPV5_JHREG_DB.DomainDB where DomainID  = :ID)
	
	  set ipNum=$l(ipJson,",")
	  set i=0
	   	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(namespaceid)
	
           DO ..Adapter.DSNSet(GetDSN)

	     	  set temp=bpArray.%ToJSON()
	     	 Set SqlName2="CALL JHIPV5_JH503UTIL_SubRelation.SubRelationUtil_DeleteSubRelation ('"_bpArray.bsName.%ToJSON()_"','"_temp_"')"
	         $$$TRACE(SqlName2)
	         Set tSC2=..Adapter.ExecuteQuery(.tResult2,SqlName2)
		     while tResult2.%Next(){
			     set tsc=tResult2.%Get("Status")
			     set response=tResult2.%Get("Value")
	         }
	     
	     
	     if (tsc="1"){
	          set iter = input.SubIdArr.%GetIterator()
	          
	          while iter.%GetNext(.key, .value) { 
	        
            &sql(DELETE FROM JHIPV5_JHREG_DB.SupRelation WHERE ID = :value and nameSpaceId = :namespaceid )	 
            &sql(delete from JHIPV5_JHREG_DB.SubRelationlListDB where SubId=:value)
	    
            }
	      }else{
	         set fresult=0
	      }
           

      //}	
      //set return=pHttpResponse.Data.Read()
	  
      }
      if (fresult="1"){
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.TResult("")
	  }else{
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"删除失败")	 
	  }
      Quit $$$OK
	}elseif(input.type="StopOrOpenSubRelate"){

	  set bpArray=##class(%DynamicObject).%New()
	  &sql(select Name,nameSpaceid INTO :Name,:nameSpaceid from JHIPV5_JHREG_DB.SupRelation where ID = :input.SubId)
      set bpArray.type="StopOrOpenSubRelate"
	  set bpArray.id=input.SubId
	  set bpArray.status=input.Status
	  set bpArray.bpName=Name
	  //Set httprequest=##class(%Net.HttpRequest).%New()
	  //Do httprequest.InsertFormData("VALUE",bpArray.%ToJSON())
	  &sql(select NameSpace,IpAdderss into :nameSpace, :ipJson from JHIPV5_JHREG_DB.DomainDB where DomainID  = :nameSpaceid)
	  set ipNum=$l(ipJson,",")
	  set i=0
	  /*for i=1:1:ipNum{
	  set ip=$p(ipJson,",",i)*/
	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(nameSpaceid)
	  DO ..Adapter.DSNSet(GetDSN)
	  
	  //set re= httprequest.Post("http://"_ip_":52773/JHREG"_nameSpace_"/BP/"_bpArray.%ToJSON())

      //Set httpResponse=##class(%Net.HttpResponse).%New()
	  //Set pHttpResponse=httprequest.HttpResponse
	  
	  	     set temp=bpArray.%ToJSON()
	     	 Set SqlName2="CALL JHIPV5_JH503UTIL_SubRelation.SubRelationUtil_StartOrStopSubRelation ('','"_temp_"')"
	     	$$$TRACE(SqlName2)
	         Set tSC2=..Adapter.ExecuteQuery(.tResult2,SqlName2)
	       
		     while tResult2.%Next(){
			     set tsc=tResult2.%Get("Status")
			     set response=tResult2.%Get("Value")
			 
	         }
	  
	  if (tsc){
	     &sql(update  JHIPV5_JHREG_DB.SupRelation set openStatus=:input.Status where id = :bpArray.id)	  
       }
	
	  if (tsc="1"){
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.TResult("")
	  }else{
	    Set pResponse=##class(Ens.StringResponse).%New()
	     Set pResponse.StringValue=Result.FResult()
	  }
	  //}
      Quit $$$OK
	}
}

}

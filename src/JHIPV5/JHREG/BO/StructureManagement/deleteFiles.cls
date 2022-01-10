/// Classname 
/// Summary   jhipv5 文件删除
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.deleteFiles Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	     SET ERRORNUM=0
           set Allnum=0
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	SET A1     =pRequest.pArg.GetAt(1)
	set request=##class(%DynamicArray).%New()
	set request=request.%FromJSON(A1)
	Set req=##class(%DynamicArray).%New()
	
	set iter   =request.ID.%GetIterator()
	
	while iter.%GetNext(.key, .value) {
		$$$TRACE(value)
		&sql(select FileName,FileType into:FileName,:FileType  from JHIPV5_JHREG_DB.StructureManagementFilesDB where ID = :value)
        //&sql(delete from JHIPV5_JHREG_DB.StructureManagementFilesDB where ID = :value)
		$$$TRACE(FileType)
		
		set reqOb=##class(%DynamicObject).%New()
		set reqOb.Name=FileName
		set reqOb.Type=FileType
		Do req.%Push(reqOb)

	   //set tsc=$$$FileDelete(url_"")
	  //set tsc='$zu(140,5,value)
	

		  
    }
    	set queryStr  ="select * from JHIPV5_JHREG_DB.DomainDB group by IpAdderss"
		Set statement = ##class(%SQL.Statement).%New()
		Set qStatus   = statement.%Prepare(queryStr)
		Set rset      = statement.%Execute()
		set ipJson=""
	    while rset.%Next(){	
	        set length=$l(ipJson,rset.%Get("IpAdderss"))
	        if (length<2){
		      Set ipJson  = ipJson_rset.%Get("IpAdderss")_","
		     }
		   
	     }
	     set i=1
	    set ll=$l(ipJson,",")
	     $$$TRACE(ipJson)
	    for i=1:1:ll{
		 	    set temp=$p(ipJson,",",i)
		  if (temp'=""){
		
			  $$$TRACE(temp)
			  &sql(select DomainID into :DomainID from JHIPV5_JHREG_DB.DomainDB where  IpAdderss like :temp)
			  //设置DSN
			
			  TRY {
			    Set GetDSN= ^Ens.LookupTable("DSNTABLE",temp)
			  }CATCH{
				  Set GetDSN =""
				  
				}
		
			   if (GetDSN'=""){
				    set Allnum=Allnum+1
			   DO ..Adapter.DSNSet(GetDSN)  
			   //删除对应服务器的文件
			    Set tQuery="call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_deleteFiles('"_req.%ToJSON()_"')"
			    $$$TRACE(tQuery)
			    set tsc=..Adapter.ExecuteQuery(.A,tQuery)
			    $$$TRACE(tsc)
			    if (tsc'=1){
				    set ERRORNUM=ERRORNUM+1
				      
				    }
			   
			    
			   }
		    
		    
		    }
	    }
    
	
    	 if (ERRORNUM'=Allnum){
	    set iter   =request.ID.%GetIterator()
	    while iter.%GetNext(.key, .value) {
		 &sql(delete from JHIPV5_JHREG_DB.StructureManagementFilesDB where ID = :value)
	    }
	     set pResponse=##class(Ens.StringResponse).%New()
         set pResponse.StringValue=Result.TResult("删除成功")  
	   }else{
		 set pResponse=##class(Ens.StringResponse).%New()
         set pResponse.StringValue=Result.FResult() 
	   }
   
   Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}

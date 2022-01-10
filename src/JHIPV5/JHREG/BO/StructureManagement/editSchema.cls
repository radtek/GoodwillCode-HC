/// Classname 
/// Summary   jhipv5 结构管理删除
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.editSchema Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
 
        Set Result         =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	    set request        =##class(%DynamicArray).%New()
	    set request        =request.%FromJSON(pRequest.pArg.GetAt(1))
	    set ID             =request.ID
	       //判断是否为标准
		    set standard=""
		    &sql(select standard into :standard from JHIPV5_JHREG_DB.StructureManagement where ID =:ID)
		    if (standard'=""){
			    Set pResponse.StringValue=Result.Result(400,"",1,"该标准为标准Schema，不可删除")
		        Quit $$$OK  
			    
			 }
	    //set newStandardName=request.StandardName  //标准名
        set newimportStatus=request.StandardStatus
	    set FileID=request.FileID
	    set time=$zdt($H,3)	
	    if (FileID'=""){
		&sql(select FileName,FileType into :FileName,:FileType from  JHIPV5_JHREG_DB.StructureManagementFilesDB where ID = :FileID)
	    set newimportName  =FileName  //选择的FileName
	    set newimportType  =FileType
	    &sql(select StandardName,FileName,StandardType,NameSpaceID into :StandardName,:FileName,:StandardType,:NameSpaceID FROM JHIPV5_JHREG_DB.StructureManagement WHERE ID = :ID )
	    
	      //先进行重复判断
	     if (newimportType'=2){
		       SET templ   =$L(newimportName,".")
               SET temp   =$P(newimportName,".",1,templ-1)
		      &sql(select count(1),StandardName,ID into :num2,:StandardName2,:ID from JHIPV5_JHREG_DB.StructureManagement where FileName=:temp and NameSpaceId=:NameSpaceID)
	         // &sql(select count(1),StandardName,ID into :num2,:StandardName2,:ID from JHIPV5_JHREG_DB.StructureManagement where FileName=:temp )
	     
	         if (num2){
		       
		       if (request.ID)&&(request.ID=ID){
			     //若为编辑Schema导入同个文件
			  }else{
			   Set pResponse=##class(Ens.StringResponse).%New()
		       Set pResponse.StringValue=Result.Result("400","",1,"该文件已被标准"_StandardName2_"导入，请重新选择")   
		       Quit 1	  
		      }
		     
		   }
		     
		  }else{
			  
		    set importname ="/usr/workspace/hl7_2/"_newimportName
	        set tsc2=##class(EnsLib.HL7.SchemaXML).GetImportCategory(newimportName)
			&sql(select count(1),ID into :num,:ID  from JHIPV5_JHREG_DB.StructureManagement where FileName = :tsc2 and StandardType = 2)
	         if (num'=0){
		  
		     if (request.ID)&&(request.ID=ID){
			     //若为编辑Schema导入同个文件
			  }else{
			     Set pResponse=##class(Ens.StringResponse).%New()
	             Set pResponse.StringValue=Result.Result("400","",1,"同名标准已被导入,请重新选择。")  
	             Quit 1  
		      }
		 
	        }  
			  
		}
	    
	    
	    
	    	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	
            DO ..Adapter.DSNSet(GetDSN)
	    
	  
	    //先导入新的
	    //set tsc            =##class(JHIPV5.JHREG.BO.StructureManagement.importXml).addSchema(request,.response)
	    
	       	 Set SqlName="call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_AddStructureManager('"_newimportName_"','"_newimportType_"')"
	     	  $$$TRACE(SqlName)
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
		     while tResult.%Next(){
			     set tsc=tResult.%Get("Status")
			     set response=tResult.%Get("Value")
	         }
	    
	    if (tsc){
		  //删除旧的
		  if (FileName'=response)&&(newimportType'=StandardType){ //如果同名同类型就不删除

		     Set SqlName="call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_DeleteStructureManager('"_FileName_"','"_StandardType_"')"
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
		     while tResult.%Next(){
			     set tsc=tResult.%Get("Status")
			     set response=tResult.%Get("Value")
	         }
		  
		  
		     set tsc=##class(JHIPV5.JHREG.BO.StructureManagement.deleteXml).deleteSchema(request,.response1)
	   	  }
		
		  //更新表
	      &sql(update JHIPV5_JHREG_DB.StructureManagement set StandardName =:response,FileName=:response,StandardType=:newimportType,openStatus=:newimportStatus,ManagerTime=:time WHERE ID = :ID)  
		  Set pResponse=##class(Ens.StringResponse).%New()
	      Set pResponse.StringValue=Result.TResult("更新成功")   
		}else{
		  Set pResponse=##class(Ens.StringResponse).%New()
	      Set pResponse.StringValue=Result.Result("400","",1,response)  
	    }

		    
		 }else{
		  set time=$zdt($H,3)	 
		  &sql(update JHIPV5_JHREG_DB.StructureManagement set openStatus=:newimportStatus,ManagerTime=:time WHERE ID = :ID)  
		 
	      Set pResponse=##class(Ens.StringResponse).%New()
	      Set pResponse.StringValue=Result.TResult("更新成功")   
	
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

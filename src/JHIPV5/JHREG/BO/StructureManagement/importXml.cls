/// Classname 
/// Summary   jhipv5 结构管理导入
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.importXml Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	      //导入
	     
	     Set Result      =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	     set request     =##class(%DynamicArray).%New()
	     set request     =request.%FromJSON(pRequest.pArg.GetAt(1))
	     
	     //set StandardName=request.StandardName  
         set importStatus=request.StandardStatus
	     set FileID=request.FileID
	     set NameSpaceID=request.NameSpaceID
	     &sql(select FileName,FileType,ipAdress into :FileName,:FileType,:ipAdress from  JHIPV5_JHREG_DB.StructureManagementFilesDB where ID = :FileID)
	     if ($l(ipAdress,NameSpaceID)<2){
		     
		    Set pResponse=##class(Ens.StringResponse).%New()
	        Set pResponse.StringValue=Result.Result("400","",1,"当前服务器没有该文件，请重新上传文件。")    
		     Quit $$$OK
		     }
	   
	     set importName  =FileName  //选择的FileName
	     set importType  =FileType
	     //先进行重复判断
	     if (importType'=2){
		       SET templ   =$L(importName,".")
               SET temp   =$P(importName,".",1,templ-1)
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
			  
		    set importname ="/usr/workspace/hl7_2/"_importName
	        set tsc2=##class(EnsLib.HL7.SchemaXML).GetImportCategory(importname)
			&sql(select count(1),ID into :num,:ID  from JHIPV5_JHREG_DB.StructureManagement where FileName = :tsc2 and StandardType = 2 and NameSpaceId=:NameSpaceID)
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
	     
	     
	     //set tsc = ..addSchema(request,.response)
	     //调用对应域的存储过程
	     
	        //set NameSpaceId=input.NameSpaceId
   
             Try{
	  Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	   
	  }catch(e){
		SET GetDSN=""
	  }
	  
	    IF (GetDSN=""){
		Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"当前域暂未配置相关DSN") 
	    Quit $$$OK  
		  
	  }
	  
        	//Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	
            DO ..Adapter.DSNSet(GetDSN)
            
            
            
             $$$TRACE(GetDSN)
	     	 Set SqlName="call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_AddStructureManager('"_importName_"','"_importType_"')"
	     	  $$$TRACE(SqlName)
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
		     while tResult.%Next(){
			     set tsc=tResult.%Get("Status")
			     set response=tResult.%Get("Value")
	         }
	     //set tsc = ..addSchema(request,.response)
	     set time=$zdt($H,3)
	     $$$TRACE("wwwww"_response)
	      //DO ..Adapter.Disconnect()
         if (tsc=1){  
	      &sql(insert into JHIPV5_JHREG_DB.StructureManagement (StandardName,FileName,StandardType,openStatus,ManagerTime,NameSpaceID)values(:response,:response,:importType,:importStatus,:time,:request.NameSpaceID))
	     Set pResponse=##class(Ens.StringResponse).%New()
	     Set pResponse.StringValue=Result.TResult("创建成功")  
	     
	    }else{
		  Set pResponse=##class(Ens.StringResponse).%New()
	      Set pResponse.StringValue=Result.Result("400","",1,response)    
		     
		}
		//Do tResult.Close()
		
		//KILL tResult
		// set tsc= ..Adapter.Disconnect()
		 //$$$TRACE(tsc)
       Quit $$$OK
}

ClassMethod addSchema(Schema As %Library.DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	     &sql(select FileName,FileType into :FileName,:FileType from  JHIPV5_JHREG_DB.StructureManagementFilesDB where ID = :Schema.FileID)
	     $$$TRACE(FileName)
	     set importName  =FileName  //选择的FileName
	     set importType  =FileType

		 if (importType'=2){
			 
		   SET templ   =$L(FileName,".")
           SET temp   =$P(FileName,".",1,templ-1)
           //
           
	       &sql(select count(1),StandardName,ID into :num2,:StandardName2,:ID from JHIPV5_JHREG_DB.StructureManagement where FileName=:temp)
	       
	       if (num2){
		       
		     if (Schema.ID)&&(Schema.ID=ID){
			     //若为编辑Schema导入同个文件
			  }else{
			   Set pResponse=##class(Ens.StringResponse).%New()
		       Set pResponse.StringValue="该文件已被标准"_StandardName2_"导入，请重新选择或者修改文件名。" 
		       Quit 0	  
		      }
		     
		   }  
			 
		   if (importType=1){ set importname ="/usr/workspace/xml/"_importName}	
		   elseif(importType=3){set importname ="/usr/workspace/hl7_3/"_importNam}
		   elseif(importType=4){set importname ="/usr/workspace/hl7_fhir/"_importNam}
		   set tsc        =##class(EnsPortal.EDI.XML.SchemaMain).ImportInBackground(importname)
		   $$$TRACE("TSC:"_tsc)
		   
	       set Status     =##class(EnsPortal.EDI.XML.SchemaMain).GetImportStatus()
	       while ($L(Status,"running|/usr/workspace")>1){
		      set Status     =##class(EnsPortal.EDI.XML.SchemaMain).GetImportStatus() 
		       
		   }
	       $$$TRACE(Status) 
           if ($L(Status,"unable to open primary document entit")>1){
	        SET Status   ="缺少"_$P($P(Status,"unable to open primary document entity '",2),"' at line",1)
	        Set pResponse=##class(Ens.StringResponse).%New()
	        Set pResponse.StringValue=Status
	        Quit 0
	      }
	      else{
		   set time     =$h
	       Set pResponse=##class(Ens.StringResponse).%New()
	       SET pCategoryl   =$L(importName,".")
           SET pCategory   =$P(importName,".",1,pCategoryl-1)
	       Set pResponse.StringValue=pCategory
	       Quit $$$OK
		  } 
	   }elseif (importType=2){	 //hl7_V2
	   set importname ="/usr/workspace/hl7_2/"_importName
	    set tsc2=##class(EnsLib.HL7.SchemaXML).GetImportCategory(importname)
	    //判断是否已经导入
	   &sql(select count(1),ID into :num,:ID  from JHIPV5_JHREG_DB.StructureManagement where FileName = :tsc2 and StandardType = 2)
	   if (num'=0){
		  
		     if (Schema.ID)&&(Schema.ID=ID){
			     //若为编辑Schema导入同个文件
			  }else{
			     Set pResponse=##class(Ens.StringResponse).%New()
	             Set pResponse.StringValue="同名标准已被导入,请重新选择。"  
	             Quit 0	  
		      }
		 
	   }
	   Set tSC=##class(EnsLib.HL7.SchemaXML).Import(importname,.tCatImported)
	   if (tSC){
		  if (tCatImported'=""){
			  $$$TRACE(tCatImported)
			  set time     =$h
	          Set pResponse=##class(Ens.StringResponse).%New()
	          Set pResponse.StringValue=tCatImported 
	           Quit $$$OK
		   }else{
			  Set pResponse=##class(Ens.StringResponse).%New()
	          Set pResponse.StringValue="导入错误文件"_tCatImported  
	           Quit 0
			   
		   } 
	   }else{
		      Set pResponse=##class(Ens.StringResponse).%New()
		      
	          Set pResponse.StringValue="导入失败"
	           Quit 0  
	        }	 
	 }
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

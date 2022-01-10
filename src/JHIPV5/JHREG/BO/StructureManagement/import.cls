/// Classname 
/// Summary   jhipv5 上传文件
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.import Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As %CSP.BinaryStream, Output pResponse As Ens.StringResponse) As %Status
{
	      //上传文件至服务器
	      //
	  

           Do pRequest.CopyFrom(pRequest)
           set ipAdress=""
	       Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
		  SET ERROR=""
		  //$$$TRACE(pRequest.Read())
	
           SET ERRORNUM=0
           set Allnum=0

		 //上传文件至服务器
	    //查询有多少服务器
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
		    //$$$TRACE(a(2).Read())
		   
		   
		    set temp=$p(ipJson,",",i)
		  if (temp'=""){
			  
			  $$$TRACE(temp)
			  //&sql(select DomainID into :DomainID from JHIPV5_JHREG_DB.DomainDB where  IpAdderss like :temp)
			  //设置DSN
			
			  TRY {
				   Set GetDSN= ^Ens.LookupTable("DSNTABLE",temp)
			     //Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(DomainID)
			  }CATCH{
				  Set GetDSN =""
				  
				}
		
			   if (GetDSN'=""){
				    set ipAdress=ipAdress_temp_","
			   DO ..Adapter.DSNSet(GetDSN)
			   //$$$TRACE("IF"_..Adapter.Connected)
			   set Allnum=Allnum+1
	          set t1=##class(%CSP.BinaryStream).%New()
              Do t1.CopyFrom(pRequest)
              set type=t1.GetAttribute("type")
              SET NAME=t1.FileName
              
                SET WW=t1
                  
	           Set tQuery="{call JHIPV5_JH503UTIL_StructureManagement.StructureManagemenUtil_importFiles(?,?,?,?)"
              Set tSC = ..Adapter.ExecuteProcedure(.tRTs,.tOutParms,tQuery,"iiio",t1,type,NAME,.a)
              
             
              $$$TRACE(tSC)
              if (tSC){
	            if (tOutParms.GetAt(1)="上传成功"){
		        }else{
			        set ERROR=ERROR_temp_tOutParms.GetAt(1)_","
			        set ERRORNUM=ERRORNUM+1
			    }
		   
		   
		      
		       }else{
			     set ERRORNUM=ERRORNUM+1
			     set ERROR=ERROR_temp
			    
			   }   
			}
	       }  
	  
		    Do ..Adapter.Disconnect()
		 }
	   if (ERRORNUM'=Allnum){
		   &sql(select Count(1) into num from  JHIPV5_JHREG_DB.StructureManagementFilesDB where FileName=:NAME and FileType=:type )
		   if (num=0){
			 &sql(insert into JHIPV5_JHREG_DB.StructureManagementFilesDB (FileName,FileType,ipAdress) values(:NAME,:type,:ipAdress))   
			}
		  
	   }
	 
	      
	       Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	       $$$TRACE(ERROR)
	       if (ERROR'=""){
		     
		       Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
               Set pResponse=##class(Ens.StringResponse).%New()
           
    	       Set pResponse.StringValue=Result.Result(400,"",1,"操作失败")
	           //Set pResponse.StringValue=Result.TResult(ERROR)   
		       
		       }ELSE{  
			      Set pResponse=##class(Ens.StringResponse).%New()
    	       Set pResponse.StringValue=Result.Result(200,"",1,"上传成功") 
			}
	     
	         
		
	     

       //set tsc=##class(EnsPortal.EDI.XML.SchemaMain).ImportInBackground("")
      // set Status=##class(EnsPortal.EDI.XML.SchemaMain).GetImportStatus() //是否导入成功  还需要什么文件
      
   
       Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="%CSP.BinaryStream"> 
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}
